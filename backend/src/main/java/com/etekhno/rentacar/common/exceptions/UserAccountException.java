package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class UserAccountException extends CustomException {

    private static String errorGroup = "E001";

    public static enum Error implements CustomError {

        UserNotFoundError("E00100", "User Not Found"),
        UserAccountNotVerifiedError("E00101", "Account Not Verified."),
        UserAlreadyExistError("E00102", "User Already Exist ");

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

    public UserAccountException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.BAD_REQUEST, errorGroup, error, debugMsg);
    }

}
