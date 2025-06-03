package com.etekhno.rentacar.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PendingPaymentDTO {
    String customerId;
    String customerCNIC;
    String customerName;
    BigDecimal remainingBalance;
}
