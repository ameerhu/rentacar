package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class AuthorizationException extends CustomException {
    private static String errorGroup = "E007";

    public static enum Error implements CustomError{
        UnauthorizedUserError("E00700","User is not authorized.");
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

    public AuthorizationException(Exception e,CustomError error,String debugMsg){
        super(e, HttpStatus.FORBIDDEN, errorGroup, error, debugMsg);
    }
}
