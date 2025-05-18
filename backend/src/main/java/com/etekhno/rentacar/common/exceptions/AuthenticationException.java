package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class AuthenticationException extends CustomException {

    private static String errorGroup = "E002";

    public static enum Error implements CustomError {

        InvalidTokenError("E00200", "Auth Token Not Validate"),
        InvalidCredentialError("E00201", "Invalid Username or Password"),
        NoAuthenticationInfoError("E00202", "Auth Token Not Found"),
        ValidationTokenExpiredError("E00203", "Token already expired or used"),
        ValidationTokenNotFoundError("E00204", "Email Verification Token Not Found"),
        UserAccountLockedError("E00205","User's account has been locked");

        private String code;
        private String message;

        Error(String code, String message) {
            this.code = code;
            this.message = message;
        }

        @Override
        public String getErrorMessage() {
            return message;
        }

        @Override
        public String getErrorCode() {
            return code;
        }
    }

    public AuthenticationException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.UNAUTHORIZED, errorGroup, error, debugMsg);
    }

}
