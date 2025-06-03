package com.etekhno.rentacar.domain;

import com.etekhno.rentacar.datamodel.enums.BookingStatus;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;

@Setter
@Getter
public class BookingDTOExt extends BookingDTO {
    private String vehicleName;
    private String customerName;

    public BookingDTOExt(String id, String vehicleId, String vehicleName, String customerId, String customerName, Date rentalStartDate, Date rentalEndDate,
                         BigDecimal totalAmount, BigDecimal amountPaid, BigDecimal remainingBalance, BookingStatus status) {
        super(id, vehicleId, customerId, rentalStartDate, rentalEndDate, totalAmount, amountPaid, remainingBalance, status);
        this.vehicleName = vehicleName;
        this.customerName = customerName;
    }
}
