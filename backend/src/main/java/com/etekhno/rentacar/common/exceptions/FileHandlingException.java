package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;

public class FileHandlingException extends CustomException {
    private static String errorGroup = "E006";

    public static enum Error implements CustomError{
        PictureNotReadable("E00600","Profile picture failed to upload "),
        FileFormatNotSupported("E00601","Profile picture must be in jpeg/png/gif format"),
        FileSizeExceeded("E00602","File size has exceeded maximum limit of 500KB"),
        EmailTemplateNotFoundError("E00603", "Email template  not found at specified location"),
        FileNotFoundError("E00604", "File not found at specified location");

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

    public FileHandlingException(Exception e, CustomError error, String debugMsg) {
        super(e, error, debugMsg);
    }
}
