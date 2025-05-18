package com.etekhno.rentacar.domain;

import com.etekhno.rentacar.datamodel.enums.PaymentStatus;
import com.etekhno.rentacar.domain.inbound.PaymentDTOIn;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;

@Setter
@Getter
@NoArgsConstructor
public class PaymentDTO extends PaymentDTOIn {
    private String id;
    private BigDecimal overpaidAmount = BigDecimal.ZERO;
    private Date paymentDate;
    private PaymentStatus paymentStatus;

    public PaymentDTO(String id, String customerId, BigDecimal totalAmount, String paymentMethod,
                      BigDecimal overpaidAmount, Date paymentDate, PaymentStatus paymentStatus) {
        super(customerId, totalAmount, paymentMethod);
        this.id = id;
        this.overpaidAmount = overpaidAmount;
        this.paymentDate = paymentDate;
        this.paymentStatus = paymentStatus;
    }
}
