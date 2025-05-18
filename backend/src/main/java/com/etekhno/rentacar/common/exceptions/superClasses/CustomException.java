package com.etekhno.rentacar.common.exceptions.superClasses;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpStatus;

import java.util.HashMap;

public class CustomException extends RuntimeException {

    String errorGroup;
    String errorCode;
    String errorMessage;
    Exception exception;
    HttpStatus httpStatus;
    String debugMsg;

    public ErrorDTO getErrorDTO() {
        return new ErrorDTO(errorGroup, errorCode, errorMessage, debugMsg, httpStatus);
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class ErrorDTO {
        String errorGroup;
        String errorCode;
        String errorMessage;
        String debugMessage;
        HttpStatus httpStatus;

        public String toJson() {
            HashMap map = new HashMap();
            map.put("errorGroup", errorGroup);
            map.put("errorCode", errorCode);
            map.put("errorMsg", errorMessage);
            map.put("debugMsg", debugMessage);
            map.put("httpStatus", httpStatus);
            return map.toString();
        }
    }

    public CustomException(Exception e, HttpStatus httpStatus, String errorGroup, CustomError error, String debugMsg) {
        this.errorCode = error.getErrorCode();
        this.errorMessage = error.getErrorMessage();
        this.errorGroup = errorGroup;
        this.httpStatus = httpStatus;
        this.debugMsg = debugMsg;
        this.exception = e;
    }

    public CustomException(Exception e, HttpStatus httpStatus, CustomError error, String debugMsg) {
        this(e, httpStatus, null, error, debugMsg);
    }

    public CustomException(Exception e, CustomError error, String debugMsg) {
        this(e, HttpStatus.BAD_REQUEST, error, debugMsg);
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }
}
