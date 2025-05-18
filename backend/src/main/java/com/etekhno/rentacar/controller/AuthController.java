package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.common.exceptions.AuthenticationException;
import com.etekhno.rentacar.controller.util.RACDTOInValidator;
import com.etekhno.rentacar.domain.UserDTO;
import com.etekhno.rentacar.domain.inbound.LoginDTOIn;
import com.etekhno.rentacar.domain.inbound.RegisterDTOIn;
import com.etekhno.rentacar.domain.inbound.ResetPasswordDTOIn;
import com.etekhno.rentacar.services.IAuthService;
import com.etekhno.rentacar.services.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@SecurityRequirements
public class AuthController {

    @Autowired
    IAuthService authService;

    @Autowired
    IUserService userService;

    @PostMapping("/login")
    @Operation(summary = "This method will allow users to login only if they have created their accounts before.")
    public UserDTO login(@Valid @RequestBody LoginDTOIn loginDTOIn, BindingResult result) {
        RACDTOInValidator.validate(result);
        return authService.login(loginDTOIn);
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "This method is used to create new users or for signup purpose.")
    public UserDTO register(@Valid @RequestBody RegisterDTOIn registerDTOIn,
                            BindingResult result, HttpServletRequest httpServletRequest) {
        RACDTOInValidator.validate(result);
        return authService.registerUser(registerDTOIn, httpServletRequest);
    }

    @GetMapping("/verify")
    @Operation(summary = "This api will be used to verify the user email address.")
    public UserDTO Verify(@RequestParam String token, @RequestParam String email) {
        if (userService.verifyUserAccount(token, email))
            return userService.findUserDTOByEmail(email);

        throw new AuthenticationException(null, AuthenticationException.Error.InvalidTokenError, null);
    }

    @GetMapping("/forgetPassword")
    public void forgetUserPassword(@RequestParam("email") String email) {
        authService.forgetPassword(email);
    }

    @Operation(summary = "This api is used to create new password for particular user ")
    @GetMapping("/updatePassword")
    public UserDTO updatePassword(@RequestParam("email") String email,
                                  @RequestParam("otp") String OTP,
                                  @RequestBody ResetPasswordDTOIn resetPasswordDTOIn) {
        return authService.changePassword(email, OTP, resetPasswordDTOIn);
    }

}
