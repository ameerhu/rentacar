package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class DatabaseAccessException extends CustomException {
    private static String errorGroup = "E009";

    public static enum Error implements CustomError{
        DatabaseAccessError("E00900"," Database Access Error ");
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
    public DatabaseAccessException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.INTERNAL_SERVER_ERROR, errorGroup, error, debugMsg);
    }

}
