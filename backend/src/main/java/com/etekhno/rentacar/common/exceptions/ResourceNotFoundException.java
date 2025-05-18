package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class ResourceNotFoundException extends CustomException {
    private static String errorCode = "E010";

    public static enum Error implements CustomError{
        PathNotFoundError("E01000","Resource not found for the requested URL");

        private String message;
        private String code;
        Error(String message, String code){
            this.message = message;
            this.code = code;
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

    public ResourceNotFoundException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.NOT_FOUND, errorCode, error, debugMsg);
    }
}
