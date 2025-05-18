package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class ServerException extends CustomException {

    private static String errorGroup = "E011";

    public static enum Error implements CustomError{
        InternalServerError("E01100", "Internal server error");
        private String message;
        private String errorCode;

         Error(String errorCode, String message){
            this.message = message;
            this.errorCode = errorCode;
        }

        @Override
        public String getErrorMessage() {
            return message;
        }

        @Override
        public String getErrorCode() {
            return errorCode;
        }
    }
    public ServerException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.INTERNAL_SERVER_ERROR, errorGroup, error, debugMsg);
    }
}
