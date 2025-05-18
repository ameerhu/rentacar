package com.etekhno.rentacar.domain.inbound;

import com.etekhno.rentacar.datamodel.enums.BookingStatus;
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
public class BookingDTOIn {
    private String vehicleId;
    private String customerId;
    private Date rentalStartDate;
    private Date rentalEndDate;
    private BigDecimal totalAmount;
    private BigDecimal amountPaid = BigDecimal.ZERO;
    private BigDecimal remainingBalance;
    private BookingStatus status = BookingStatus.PENDING;
}
