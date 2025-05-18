package com.etekhno.rentacar.datamodel;

import com.etekhno.rentacar.datamodel.enums.BookingStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;

@Entity
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Booking extends BasicAuditingEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    private String vehicleId;
    private String customerId;

    private Date rentalStartDate;
    private Date rentalEndDate;
    private BigDecimal totalAmount;
    private BigDecimal amountPaid = BigDecimal.ZERO;
    private BigDecimal remainingBalance;
    private BookingStatus status = BookingStatus.PENDING;

    @PrePersist
    private void initializeRemainingBalance() {
        if (totalAmount != null) {
            this.remainingBalance = totalAmount.subtract(amountPaid);
        }
    }
}
