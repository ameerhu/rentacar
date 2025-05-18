package com.etekhno.rentacar.services;

import com.etekhno.rentacar.domain.PaymentDTO;
import com.etekhno.rentacar.domain.inbound.PaymentDTOIn;

import java.util.List;

public interface IPaymentService {
    PaymentDTO processPayment(PaymentDTOIn paymentDTOIn);

    void processPayment(String paymentId);

    List<PaymentDTO> getAllPayments();
}
