package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class JPAConverterException extends CustomException {
    private static String errorGroup = "E005";

    public static enum Error implements CustomError{
        IllegalEnumArgumentError("E00500","Unknown Enum Argument ");
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
    public JPAConverterException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.NOT_FOUND, errorGroup, error, debugMsg);
    }



}
