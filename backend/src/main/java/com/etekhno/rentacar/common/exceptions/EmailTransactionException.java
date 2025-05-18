package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class EmailTransactionException extends CustomException {

    private static String errorGroup = "E008";

    public static enum Error implements CustomError {

        MailersendEmailTransactionError("E00800","Mailersend failed to send email");

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

    public EmailTransactionException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.BAD_REQUEST, errorGroup, error, debugMsg);
    }
}
