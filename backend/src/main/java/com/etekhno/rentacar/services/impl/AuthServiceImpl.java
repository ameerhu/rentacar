package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.UserAccountException;
import com.etekhno.rentacar.common.exceptions.ValidationException;
import com.etekhno.rentacar.config.ConfigProperties;
import com.etekhno.rentacar.config.security.JwtUtil;
import com.etekhno.rentacar.config.security.RACToken;
import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.datamodel.SecureToken;
import com.etekhno.rentacar.datamodel.UserCredential;
import com.etekhno.rentacar.datamodel.enums.EmailType;
import com.etekhno.rentacar.datamodel.repo.PartyRepo;
import com.etekhno.rentacar.datamodel.repo.SecureTokenRepo;
import com.etekhno.rentacar.datamodel.repo.UserCredentialRepo;
import com.etekhno.rentacar.domain.UserDTO;
import com.etekhno.rentacar.domain.inbound.LoginDTOIn;
import com.etekhno.rentacar.domain.inbound.RegisterDTOIn;
import com.etekhno.rentacar.domain.inbound.ResetPasswordDTOIn;
import com.etekhno.rentacar.domain.pojo.email.PasswordResetEmail;
import com.etekhno.rentacar.domain.pojo.email.PasswordUpdateSuccessEmail;
import com.etekhno.rentacar.services.IAuthService;
import com.etekhno.rentacar.services.IEmailService;
import com.etekhno.rentacar.services.ISecureTokenService;
import com.etekhno.rentacar.services.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Objects;
import java.util.Optional;

@Service
public class AuthServiceImpl implements IAuthService {
    @Autowired
    private AuthenticationManager authManager;
    @Autowired
    private PartyRepo partyRepo;
    @Autowired
    private UserCredentialRepo userCredentialRepo;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    PasswordEncoder passwordEncoder;
    @Autowired
    IUserService userService;
    @Autowired
    ConfigProperties configProperties;
    @Autowired
    ISecureTokenService secureTokenService;
    @Autowired
    IEmailService emailService;
    @Autowired
    SecureTokenRepo secureTokenRepo;

    @Override
    public UserDTO login(LoginDTOIn loginDTOIn) {
        String userId = loginDTOIn.getCnic() == null ? loginDTOIn.getEmail() : loginDTOIn.getCnic();
        UserAccountException unf = new UserAccountException(null, UserAccountException.Error.UserNotFoundError, "User is not properly registered.");
        Party user = partyRepo.findByEmailOrCnic(userId, userId).orElseThrow(() -> unf);

        if (!Objects.equals(user.getAccountVerified(), true)) {
            userService.sendRegistrationConfirmationEmail(user);
            throw new UserAccountException(null, UserAccountException.Error.UserAccountNotVerifiedError, null);
        }

        UserCredential userCredential = userCredentialRepo.findById(user.getId()).orElseThrow(() -> unf);
        RACToken authToken =
                new RACToken(user.getId(), userCredential.getLoginAttempt(), user.getEmail(), loginDTOIn.getPassword());
        authManager.authenticate(authToken);

        UserDTO userDTO = mapUserIntoUserDTO(user);
        userDTO.setToken(jwtUtil.generateJwtToken(loginDTOIn.getCnic() == null ? loginDTOIn.getEmail() : loginDTOIn.getCnic(), loginDTOIn.getPassword()));
        return userDTO;
    }

    @Override
    public UserDTO registerUser(RegisterDTOIn registerDTOIn, HttpServletRequest httpServletRequest) {
        validatePassword(registerDTOIn);
        String email = registerDTOIn.getEmail();
        Optional<Party> user = partyRepo.findByEmail(email);

        if (user.isPresent()) {
            if (Objects.equals(user.get().getAccountVerified(), true)) {
                throw new UserAccountException(null, UserAccountException.Error.UserAlreadyExistError,
                        "The provided email is already registered.");
            } else {
                userService.sendRegistrationConfirmationEmail(user.get());
                throw new UserAccountException(null, UserAccountException.Error.UserAccountNotVerifiedError,
                        "Please verify your account.");
            }
        }

        Party newUser = userService.createUser(registerDTOIn, httpServletRequest);


        registerDTOIn.setPassword(passwordEncoder.encode(registerDTOIn.getPassword()));
        saveOrUpdateUserCredential(new UserCredential(), newUser.getId(), 0, registerDTOIn.getPassword());

        UserDTO userDTO = userCredentialRepo.findUserDTOByEmail(registerDTOIn.getEmail());
        userDTO.setToken(jwtUtil.generateJwtToken(registerDTOIn.getEmail(), registerDTOIn.getPassword()));
        userDTO.setTimezone(newUser.getTimezone());
        userDTO.setLocale(newUser.getLocale());

        userService.sendRegistrationConfirmationEmail(newUser);
        return userDTO;
    }

    @Override
    public void forgetPassword(String email) {
        Party user = partyRepo.findByEmail(email)
                .orElseThrow(() ->
                        new UserAccountException(null, UserAccountException.Error.UserNotFoundError, "Email doesn't exist"));

        sendForgetPasswordEmail(user);
    }

    @Async
    public void sendForgetPasswordEmail(Party user) {
        SecureToken secureToken = secureTokenService.getIntegerOTP(user.getId(), EmailType.ForgetPasswordEmail);
        PasswordResetEmail emailContext = new PasswordResetEmail(configProperties.getBaseURL(), configProperties.getSenderEmail(),
                configProperties.getSupportEmail(), configProperties.getOtpExpiryMints(), secureToken.getToken(), user);
        String subject = String.format("[%s] Reset your Password", configProperties.getEmailSubjectPrefix());
        emailContext.init(subject, "reset-password-email-template.html");
        emailContext.updateEmailContent();

        Object message = emailService.getMimeMessage(emailContext);
        emailService.sendEmail(message);
    }

    @Override
    public UserDTO changePassword(String email, String OTP, ResetPasswordDTOIn resetPasswordDTOIn) {
        if (!resetPasswordDTOIn.getPassword().equals(resetPasswordDTOIn.getRepeatPassword())) {
            throw new ValidationException(null, ValidationException.Error.PasswordMismatchError,
                    "Password and repeat password should match");
        }

        Optional<SecureToken> secureToken = secureTokenRepo.findByToken(OTP);
        Optional<Party> userOp = partyRepo.findByEmail(email);
        userService.validateTokenAndUserExpiry(secureToken, userOp);
        Party user = userOp.get();
        RegisterDTOIn rDTOIn = new RegisterDTOIn(user.getFirstName(), user.getLastName(), email, user.getCnic(), user.getPhoneNumber(), user.getGender(), resetPasswordDTOIn.getPassword());
        this.validatePassword(rDTOIn);

        UserCredential userCredential = userCredentialRepo.findById(user.getId()).orElse(new UserCredential());
        saveOrUpdateUserCredential(userCredential, user.getId(), 0, passwordEncoder.encode(resetPasswordDTOIn.getPassword()));

        sendPasswordSuccessfulUpdateEmail(user);
        return userCredentialRepo.findUserDTOByEmail(email);
    }

    @Async
    public void sendPasswordSuccessfulUpdateEmail(Party user) {
        PasswordUpdateSuccessEmail emailContext = new PasswordUpdateSuccessEmail(configProperties.getBaseURL(),
                configProperties.getSenderEmail(), configProperties.getSupportEmail(), user);
        String subject = String.format("[%s] Reset Password Success Email", configProperties.getEmailSubjectPrefix());
        emailContext.init(subject, "reset-password-successful-email-template.html");
        emailContext.updateEmailContent();

        Object message = emailService.getMimeMessage(emailContext);
        emailService.sendEmail(message);
    }

    private UserCredential saveOrUpdateUserCredential(UserCredential userCredential, String partyId, int loginAttempt, String password) {
        userCredential.setPartyId(partyId);
        userCredential.setPassword(password);
        userCredential.setLoginAttempt(loginAttempt);
        return userCredentialRepo.save(userCredential);
    }

    private UserDTO mapUserIntoUserDTO(Party user) {
        UserDTO userDTO = new UserDTO();
        userDTO.setId(user.getId());
        userDTO.setEmail(user.getEmail());
        userDTO.setFirstName(user.getFirstName());
        userDTO.setLastName(user.getLastName());
        return userDTO;
    }

    private void validatePassword(RegisterDTOIn registerDTOIn) {
        String str = registerDTOIn.getEmail();
        String email = str.split("@")[0];
        if (email.length() <= 3) {
            if (registerDTOIn.getPassword().toLowerCase().contains(email.toLowerCase())) {
                throw new ValidationException(null, ValidationException.Error.PasswordContainsPartialEmailError,
                        "Password shouldn't contain any part of user's email");
            }
        }
        for (int i = 0; i < email.length(); i++) {
            if (i + 4 < email.length()) {
                String splitEmail = email.substring(i, i + 4);
                if (registerDTOIn.getPassword().toLowerCase().contains(splitEmail.toLowerCase())) {
                    throw new ValidationException(null, ValidationException.Error.PasswordContainsPartialEmailError,
                            "Password shouldn't contain any part of user's email");
                }
            }
        }

        if (registerDTOIn.getPassword().toLowerCase().contains(registerDTOIn.getFirstName().toLowerCase())) {
            throw new ValidationException(null, ValidationException.Error.PasswordNotAllowedError,
                    "Password shouldn't contain user's first or last name");
        } else if (registerDTOIn.getPassword().toLowerCase().contains(registerDTOIn.getLastName().toLowerCase())) {
            throw new ValidationException(null, ValidationException.Error.PasswordNotAllowedError,
                    "Password shouldn't contain user's first or last name");
        } else if (registerDTOIn.getPassword().toLowerCase().contains(str.toLowerCase())) {
            throw new ValidationException(null, ValidationException.Error.InvalidPasswordError,
                    "Password shouldn't contain user's email");
        }
    }

}