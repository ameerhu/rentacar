package com.etekhno.rentacar.datamodel;

import com.etekhno.rentacar.datamodel.enums.PaymentStatus;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;

@Entity
@Setter
@Getter
@NoArgsConstructor
public class Payment extends BasicAuditingEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    private String customerId;
    private BigDecimal totalAmount;
    private BigDecimal overpaidAmount = BigDecimal.ZERO;
    private String paymentMethod;
    private Date paymentDate;
    private PaymentStatus paymentStatus;
}
