package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.common.exceptions.*;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.tomcat.util.http.fileupload.impl.FileSizeLimitExceededException;
import org.springframework.dao.DataAccessException;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.Objects;

@ControllerAdvice
public class ExceptionHandlerAdvice {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<CustomException.ErrorDTO> handleException(HttpServletRequest request, Exception e) {
        CustomException ce = new ServerException(e, ServerException.Error.InternalServerError, null);
        e.printStackTrace();

        return ResponseEntity
                .status(ce.getHttpStatus())
                .contentType(MediaType.APPLICATION_JSON)
                .body(ce.getErrorDTO());
    }

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<CustomException.ErrorDTO> handleCustomException(HttpServletRequest request, CustomException ce) {

        return ResponseEntity
                .status(ce.getHttpStatus())
                .contentType(MediaType.APPLICATION_JSON)
                .body(ce.getErrorDTO());
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<CustomException.ErrorDTO> handleAuthenticationException(HttpServletRequest request, AuthenticationException ae) {

        if(Objects.nonNull(ae.getCause()) && CustomException.class.isAssignableFrom(ae.getCause().getClass()))
            return handleCustomException(request, (CustomException) ae.getCause());

        CustomException ce = new com.etekhno.rentacar.common.exceptions.AuthenticationException
                (ae, com.etekhno.rentacar.common.exceptions.AuthenticationException.Error.InvalidCredentialError, null);

        if (LockedException.class.isAssignableFrom(ae.getClass()))
            ce = new com.etekhno.rentacar.common.exceptions.AuthenticationException
                (ae, com.etekhno.rentacar.common.exceptions.AuthenticationException.Error.UserAccountLockedError, ae.getMessage());

        return ResponseEntity
                .status(ce.getHttpStatus())
                .contentType(MediaType.APPLICATION_JSON)
                .body(ce.getErrorDTO());
    }

    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<CustomException.ErrorDTO> handleDataAccessException(HttpServletRequest request, DataAccessException dae) {

        CustomException ce = new DatabaseAccessException(dae, DatabaseAccessException.Error.DatabaseAccessError, null);
        dae.printStackTrace();

        return ResponseEntity
                .status(ce.getHttpStatus())
                .contentType(MediaType.APPLICATION_JSON)
                .body(ce.getErrorDTO());
    }

    @ExceptionHandler(FileSizeLimitExceededException.class)
    public ResponseEntity<CustomException.ErrorDTO> handleFileException(HttpServletRequest request, FileSizeLimitExceededException fe) {

        CustomException ce = new com.etekhno.rentacar.common.exceptions.FileHandlingException
                (fe,  FileHandlingException.Error.FileSizeExceeded, null);

        return ResponseEntity
                .status(ce.getHttpStatus())
                .contentType(MediaType.APPLICATION_JSON)
                .body(ce.getErrorDTO());
    }


    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<CustomException.ErrorDTO> handleHttpMsgNotReadableException(HttpServletRequest request, HttpMessageNotReadableException ae) {

        if(Objects.nonNull(ae.getCause()) && InvalidFormatException.class.isAssignableFrom(ae.getCause().getClass())) {
            InvalidFormatException ife = (InvalidFormatException) ae.getCause();
            ValidationException ve = new ValidationException(ife, ValidationException.Error.ConstraintViolationError, getDebugMsg(ife));
            return handleCustomException(request, ve);
        }

        ValidationException ve = new ValidationException(ae, ValidationException.Error.DTOValidationError, ae.getClass().getSimpleName());

        return  ResponseEntity
                .status(ve.getHttpStatus())
                .contentType(MediaType.APPLICATION_JSON)
                .body(ve.getErrorDTO());
    }
    @ExceptionHandler({NoHandlerFoundException.class, HttpRequestMethodNotSupportedException.class})
  public ResponseEntity<CustomException.ErrorDTO> HandleMethodOrHandlerNotFoundException(ServletException nhfe) {
      CustomException ce = new com.etekhno.rentacar.common.exceptions.ResourceNotFoundException
              (nhfe,  ResourceNotFoundException.Error.PathNotFoundError, null);

      return ResponseEntity
              .status(ce.getHttpStatus())
              .contentType(MediaType.APPLICATION_JSON)
              .body(ce.getErrorDTO());
  }

    private static String getDebugMsg(InvalidFormatException ife) {
        return String.format("%s.%s %s",
                ife.getPath() == null || ife.getPath().size() == 0 ? null : ife.getPath().get(0).getFrom().getClass().getSimpleName(),
                ife.getTargetType().getSimpleName(),
                ife.getOriginalMessage()
                        .replace(ife.getTargetType().getName(), ife.getTargetType().getSimpleName())
                        .replace("\"",""));
    }
}
