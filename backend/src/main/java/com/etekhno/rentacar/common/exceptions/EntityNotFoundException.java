package com.etekhno.rentacar.common.exceptions;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import org.springframework.http.HttpStatus;

public class EntityNotFoundException extends CustomException {
    private static String errorGroup = "E003";

    public static enum Error implements CustomError {

        CustomerNotFoundError("E00300", "Customer Entity Not Found "),
        VehicleNotFoundError("E00301", "Vehicle Entity Not Found "),
        BookingNotFoundError("E00302", "Booking Entity Not Found"),
        PaymentNotFoundError("E00303", "Payment Entity Not Found"),
        AddressEntityNotFoundError("E00304", "Address Entity Not Found"),
        UserAddressRelationError("E00305", "User Address Relation Entity Not Found"),
        ProjectEntityNotFoundError("E00306", "Project Entity Not Found"),
        AwardEntityNotFoundError("E00307", "Award Entity Not Found"),
        PendingBookingNotFoundError("E00308", "Pending Booking Not Found");

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

    public EntityNotFoundException(Exception e, CustomError error, String debugMsg) {
        super(e, HttpStatus.BAD_REQUEST, errorGroup, error, debugMsg);
    }

    public EntityNotFoundException(CustomError error, String debugMsg) {
        super(null, HttpStatus.BAD_REQUEST, errorGroup, error, debugMsg);
    }
}
