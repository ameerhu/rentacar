package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.AbstractIntegrationTest;
import com.etekhno.rentacar.DataHelper;
import com.etekhno.rentacar.common.exceptions.ValidationException;
import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.datamodel.enums.Gender;
import com.etekhno.rentacar.datamodel.repo.UserCredentialRepo;
import com.etekhno.rentacar.domain.UserDTO;
import com.etekhno.rentacar.domain.inbound.LoginDTOIn;
import com.etekhno.rentacar.domain.inbound.RegisterDTOIn;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithMockUser;

@WithMockUser("test@finestresume.com")
public class AuthControllerTest extends AbstractIntegrationTest {
    @Autowired
    UserCredentialRepo userCredentialRepo;
    @Autowired
    PasswordEncoder passwordEncoder;
    @Autowired
    DataHelper dataHelper;

    @Test
    void testRegisterUserThrowsValidationErrorWhenPasswordContainsFirstName() {
        RegisterDTOIn registerDTOIn = getRegisterDTO("Pass", "Last", "finestResume@gmail.com", "PassDev1@");
        requestHelper.postApi("/auth/register", registerDTOIn).withHttpStatus(HttpStatus.BAD_REQUEST);
        requestHelper.withErrorCode(ValidationException.Error.PasswordNotAllowedError);
    }

    @Test
    void testRegisterUserThrowsValidationErrorWhenPasswordContainsPartialEmail() {
        RegisterDTOIn registerDTOIn = getRegisterDTO("finestResume@gmail.com", "FinestDev1@");
        requestHelper.postApi("/auth/register", registerDTOIn).withHttpStatus(HttpStatus.BAD_REQUEST);
        requestHelper.withErrorCode(ValidationException.Error.PasswordContainsPartialEmailError);
    }

    @Test
    void testRegisterUserSuccessful() {
        RegisterDTOIn registerDTOIn = getRegisterDTO("finestResume@gmail.com", "OurDev1@");
        requestHelper.postApi("/auth/register", registerDTOIn).withHttpStatus(HttpStatus.CREATED);
        UserDTO userDTO = requestHelper.getResponseDTO(UserDTO.class);
        Assertions.assertNotNull(userDTO);
        Assertions.assertEquals(registerDTOIn.getEmail(), userDTO.getEmail());
    }

    @Test
    void testLoginUserSuccessfully() {
        Party newUser = dataHelper.createUser("finestResume@gmail.com", passwordEncoder.encode("OurDev1@"), true);
        LoginDTOIn loginDTOIn = getLoginDTO("finestResume@gmail.com", "OurDev1@");
        requestHelper.postApi("/auth/login", loginDTOIn);
        UserDTO userDTO = requestHelper.getResponseDTO(UserDTO.class);
        Assertions.assertNotNull(userDTO);
        Assertions.assertEquals(newUser.getEmail(), userDTO.getEmail());
    }

    private RegisterDTOIn getRegisterDTO(String email, String password) {
        return getRegisterDTO("Finest", "Resume", email, password);
    }

    private RegisterDTOIn getRegisterDTO(String fName, String lName, String email, String password) {
        RegisterDTOIn registerDTOIn = new RegisterDTOIn();
        registerDTOIn.setEmail(email);
        registerDTOIn.setPassword(password);
        registerDTOIn.setGender(Gender.Male);
        registerDTOIn.setPhoneNumber("0578173978");
        registerDTOIn.setFirstName(fName == null ? "Finest" : fName);
        registerDTOIn.setLastName(lName == null? "Resume" : lName);
        return registerDTOIn;
    }
    private LoginDTOIn getLoginDTO(String email, String password) {
        LoginDTOIn loginDTOIn = new LoginDTOIn();
        loginDTOIn.setEmail(email);
        loginDTOIn.setPassword(password);
        return loginDTOIn;
    }
}
