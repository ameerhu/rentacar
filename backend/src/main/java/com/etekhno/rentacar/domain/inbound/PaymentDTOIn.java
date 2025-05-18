package com.etekhno.rentacar.domain.inbound;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PaymentDTOIn {
    private String customerId;
    private BigDecimal totalAmount;
    private String paymentMethod;
}
