package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.AuthenticationException;
import com.etekhno.rentacar.common.exceptions.FileHandlingException;
import com.etekhno.rentacar.common.exceptions.UserAccountException;
import com.etekhno.rentacar.common.utils.UserInfoUtils;
import com.etekhno.rentacar.config.ConfigProperties;
import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.datamodel.SecureToken;
import com.etekhno.rentacar.datamodel.enums.EmailType;
import com.etekhno.rentacar.datamodel.repo.PartyRepo;
import com.etekhno.rentacar.datamodel.repo.SecureTokenRepo;
import com.etekhno.rentacar.datamodel.repo.UserCredentialRepo;
import com.etekhno.rentacar.domain.CustomerDTO;
import com.etekhno.rentacar.domain.UserDTO;
import com.etekhno.rentacar.domain.UserDTOExt;
import com.etekhno.rentacar.domain.inbound.RegisterDTOIn;
import com.etekhno.rentacar.domain.inbound.UserContactDTOIn;
import com.etekhno.rentacar.domain.pojo.email.AccountVerificationEmail;
import com.etekhno.rentacar.services.IEmailService;
import com.etekhno.rentacar.services.ISecureTokenService;
import com.etekhno.rentacar.services.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import static com.etekhno.rentacar.common.utils.LocaleUtils.validateAndGetLocale;
import static com.etekhno.rentacar.common.utils.TimezoneUtils.validateAndGetZoneId;

@Service
public class UserServiceImpl implements IUserService {

    @Autowired
    PartyRepo partyRepo;
    @Autowired
    UserCredentialRepo userCredentialRepo;
    @Autowired
    ISecureTokenService secureTokenService;
    @Autowired
    IEmailService emailService;
    @Autowired
    ConfigProperties configProperties;
    @Autowired
    SecureTokenRepo secureTokenRepo;

    @Override
    public Party createUser(RegisterDTOIn registerDTOIn, HttpServletRequest request) {
        Party newUser = new Party();
        newUser.setFirstName(registerDTOIn.getFirstName());
        newUser.setLastName(registerDTOIn.getLastName());
        newUser.setEmail(registerDTOIn.getEmail());
        newUser.setGender(registerDTOIn.getGender());
        newUser.setPhoneNumber(registerDTOIn.getPhoneNumber());
        newUser.setCnic(registerDTOIn.getCnic());
        if (request != null) {
            newUser.setTimezone(validateAndGetZoneId(request.getHeader("timezone")));
            newUser.setLocale(validateAndGetLocale(request.getHeader("locale")));
        }
        return partyRepo.save(newUser);
    }

    @Override
    public Party updateUser(String customerId, RegisterDTOIn registerDTOIn) {
        Party user = partyRepo.findById(customerId).orElseThrow(() ->
                new UserAccountException(null, UserAccountException.Error.UserNotFoundError, "Customer Not Exist"));
        user.setFirstName(registerDTOIn.getFirstName());
        user.setLastName(registerDTOIn.getLastName());
        user.setEmail(registerDTOIn.getEmail());
        user.setGender(registerDTOIn.getGender());
        user.setPhoneNumber(registerDTOIn.getPhoneNumber());
        user.setCnic(registerDTOIn.getCnic());
        return partyRepo.save(user);
    }

    @Override
    public void deleteCustomer(String customerId) {
        partyRepo.deleteById(customerId);
    }

    @Override
    public UserDTO findUserDTOByEmail(String email) {
        UserDTO userDTO = userCredentialRepo.findUserDTOByEmail(email);
        if (Objects.isNull(userDTO))
            throw new UserAccountException(null, UserAccountException.Error.UserAccountNotVerifiedError, null);
        return userDTO;
    }

    @Override
    public UserDTOExt findUserDTOExtByEmail(String email) {
        UserDTOExt userDTOExt = userCredentialRepo.findUserDTOExtByEmail(email);
        if (Objects.isNull(userDTOExt))
            throw new UserAccountException(null, UserAccountException.Error.UserAccountNotVerifiedError, null);
        return userDTOExt;
    }

    public List<CustomerDTO> findCustomerDTOsByCnic(String cnic) {
        return partyRepo.findCustomerDTOsByCnic(cnic);
    }

    public List<CustomerDTO> findCustomerDTOs() {
        return partyRepo.findCustomerDTOs();
    }

    public void validateTokenAndUserExpiry(Optional<SecureToken> secureToken, Optional<Party> userOp) {
        if (secureToken.isEmpty())
            throw new AuthenticationException(null, AuthenticationException.Error.ValidationTokenNotFoundError, null);

        if (secureToken.get().isExpired())
            throw new AuthenticationException(null, AuthenticationException.Error.ValidationTokenExpiredError, null);

        if (userOp.isEmpty())
            throw new UserAccountException(null, UserAccountException.Error.UserNotFoundError, null);
    }

    @Override
    public boolean verifyUserAccount(String token, String email) {
        Optional<SecureToken> secureToken = secureTokenRepo.findByToken(token);
        Optional<Party> userOp = partyRepo.findByEmail(email);
        validateTokenAndUserExpiry(secureToken, userOp);

        SecureToken st = secureToken.get();
        Party user = userOp.get();

        if (Objects.equals(st.getUserId(), user.getId())) {
            if (!Objects.equals(user.getAccountVerified(), true)) {
                user.setAccountVerified(true);
                partyRepo.save(user);
            }
            return true;
        }
        return false;
    }

    @Async
    @Override
    public void sendRegistrationConfirmationEmail(Party user) {
        SecureToken secureToken = secureTokenService.getSecureToken(user.getId(), EmailType.AccountVerificationEmail);
        AccountVerificationEmail emailContext = new AccountVerificationEmail(configProperties.getBaseURL(), configProperties.getSenderEmail(),
                configProperties.getSupportEmail(), secureToken.getToken(), user);
        String subject = String.format("[%s] Verify your email", configProperties.getEmailSubjectPrefix());
        emailContext.init(subject, "verification-email-template.html");
        emailContext.updateEmailContent();

        Object message = emailService.getMimeMessage(emailContext);
        emailService.sendEmail(message);
    }

    @Override
    public void saveProfilePicture(MultipartFile file, String id) {
        byte[] fileData;
        try {
            fileData = file.getInputStream().readAllBytes();
        } catch (IOException e) {
            throw new FileHandlingException(e, FileHandlingException.Error.PictureNotReadable, "Profile picture failed to read.");
        }

        Optional<Party> user = partyRepo.findById(id);
        if (user.isEmpty())
            throw new UserAccountException(null, UserAccountException.Error.UserNotFoundError, "User id doesn't found");
        Party user1 = user.get();
        user1.setProfilePicture(fileData);
        partyRepo.save(user1);
    }

    @Override
    @Transactional
    public void updateUserContactInformation(UserContactDTOIn userContactDTOIn) {
        Party user = partyRepo.findByEmail(UserInfoUtils.getUserEmail()).get();
        user.setPhoneNumber(userContactDTOIn.getPhoneNumber());
        partyRepo.save(user);
    }
}
