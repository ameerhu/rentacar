package com.etekhno.rentacar.services;

import com.etekhno.rentacar.domain.UserDTO;
import com.etekhno.rentacar.domain.inbound.LoginDTOIn;
import com.etekhno.rentacar.domain.inbound.RegisterDTOIn;
import com.etekhno.rentacar.domain.inbound.ResetPasswordDTOIn;
import jakarta.servlet.http.HttpServletRequest;

public interface IAuthService {
    UserDTO login(LoginDTOIn loginDTOIn);

    void forgetPassword(String email);
    UserDTO changePassword(String email, String OTP, ResetPasswordDTOIn resetPasswordDTOIn);
    UserDTO registerUser(RegisterDTOIn registerDTOIn, HttpServletRequest httpServletRequest);
}
