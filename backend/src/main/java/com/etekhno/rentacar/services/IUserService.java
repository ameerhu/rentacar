package com.etekhno.rentacar.services;

import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.datamodel.SecureToken;
import com.etekhno.rentacar.domain.CustomerDTO;
import com.etekhno.rentacar.domain.UserDTO;
import com.etekhno.rentacar.domain.UserDTOExt;
import com.etekhno.rentacar.domain.inbound.RegisterDTOIn;
import com.etekhno.rentacar.domain.inbound.UserContactDTOIn;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

public interface IUserService {

    Party createUser(RegisterDTOIn registerDTOIn, HttpServletRequest request);

    Party updateUser(String customerId, RegisterDTOIn registerDTOIn);

    void deleteCustomer(String customerId);

    UserDTO findUserDTOByEmail(String email);

    UserDTOExt findUserDTOExtByEmail(String email);

    List<CustomerDTO> findCustomerDTOsByCnic(String cnic);

    List<CustomerDTO> findCustomerDTOs();

    boolean verifyUserAccount(String token, String email);

    void validateTokenAndUserExpiry(Optional<SecureToken> secureToken, Optional<Party> userOp);

    void sendRegistrationConfirmationEmail(Party user);

    void saveProfilePicture(MultipartFile file, String id);

    void updateUserContactInformation(UserContactDTOIn userContactDTOIn);
}

