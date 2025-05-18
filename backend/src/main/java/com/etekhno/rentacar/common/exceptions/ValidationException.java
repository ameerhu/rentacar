package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class ValidationException extends CustomException {
    private static String errorGroup = "E004";

    public static enum Error implements CustomError{
        DTOValidationError("E00400","Input DTO Not Valid"),
        ConstraintViolationError("E00401","Input Constraint Violation"),
        PasswordNotAllowedError("E00402","Password shouldn't contain user's first or last name"),
        InvalidPasswordError("E00403","Password shouldn't contain user's email"),
        PathVariableOrDTOIdNotMatchError("E00404", "PathVariable or DTO id not match"),
        EmailBodyNullError("E00405", "Email text/body should not be null"),
        PasswordContainsPartialEmailError("E00406", "Password shouldn't contain any part of user's email"),
        PasswordMismatchError("E00407","Password and repeat password should be identical"),
        PaymentAlreadyProceedError("E00408", "Payment already allocated over booking.");

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

    public ValidationException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.BAD_REQUEST, errorGroup, error, debugMsg);
    }

    public ValidationException(CustomError error, String debugMsg) {
        super(null, HttpStatus.BAD_REQUEST, errorGroup, error, debugMsg);
    }
}
