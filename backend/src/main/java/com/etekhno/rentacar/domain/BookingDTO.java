package com.etekhno.rentacar.domain;

import com.etekhno.rentacar.datamodel.enums.BookingStatus;
import com.etekhno.rentacar.domain.inbound.BookingDTOIn;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class BookingDTO extends BookingDTOIn {
    private String id;
    public BookingDTO(String id, String vehicleId, String customerId, Date rentalStartDate, Date rentalEndDate,
                      BigDecimal totalAmount, BigDecimal amountPaid, BigDecimal remainingBalance, BookingStatus status) {
        super(vehicleId, customerId, rentalStartDate, rentalEndDate, totalAmount, amountPaid, remainingBalance, status);
        this.id = id;
    }
}
