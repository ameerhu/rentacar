package com.etekhno.rentacar.controller.util;

import com.etekhno.rentacar.common.exceptions.ValidationException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class RACDTOInValidator {
    public static void validate(BindingResult result) {
        if(result.hasErrors())
            throw new ValidationException(null, ValidationException.Error.ConstraintViolationError, getDebugMsg(result));
    }

    private static String getDebugMsg(BindingResult result) {
        List<FieldError> errors = result.getFieldErrors(result.getFieldError().getField());

        Optional<FieldError> fe = errors.stream().filter(e -> Arrays.stream(e.getCodes())
                .anyMatch(c->c.equalsIgnoreCase("NotNull"))).findAny();
        if(fe.isPresent())
            return String.format("%s.%s %s", result.getObjectName(), fe.get().getField(), fe.get().getDefaultMessage());

        fe = errors.stream().filter(e -> Arrays.stream(e.getCodes())
                .anyMatch(c->c.equalsIgnoreCase("NotEmpty"))).findAny();
        if(fe.isPresent())
            return String.format("%s.%s %s", result.getObjectName(), fe.get().getField(), fe.get().getDefaultMessage());

        return String.format("%s.%s %s", result.getObjectName(),
                result.getFieldError().getField(), result.getFieldError().getDefaultMessage());
    }
}
