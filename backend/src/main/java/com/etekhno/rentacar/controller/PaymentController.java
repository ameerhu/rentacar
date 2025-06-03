package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.domain.PaymentDTO;
import com.etekhno.rentacar.domain.PendingPaymentDTO;
import com.etekhno.rentacar.domain.inbound.PaymentDTOIn;
import com.etekhno.rentacar.services.IPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("payments")
public class PaymentController {

    @Autowired
    private IPaymentService paymentService;

    @GetMapping
    public List<PaymentDTO> getAllPayments() {
        return paymentService.getAllPayments();
    }

    @GetMapping("/pending")
    public List<PendingPaymentDTO> getAllPendingPayments() {
        return paymentService.getAllPendingPayments();
    }

    @PostMapping
    public PaymentDTO createPayment(@RequestBody PaymentDTOIn paymentDTOIn) {
        return paymentService.processPayment(paymentDTOIn);
    }

    @PostMapping("/{paymentId}/allocate")
    public void allocatePayment(@PathVariable String paymentId) {
        paymentService.processPayment(paymentId);
    }
}
