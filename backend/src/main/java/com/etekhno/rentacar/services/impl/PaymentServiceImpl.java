package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.EntityNotFoundException;
import com.etekhno.rentacar.common.exceptions.ValidationException;
import com.etekhno.rentacar.common.utils.DateHelper;
import com.etekhno.rentacar.datamodel.Payment;
import com.etekhno.rentacar.datamodel.enums.PaymentStatus;
import com.etekhno.rentacar.datamodel.repo.PaymentRepo;
import com.etekhno.rentacar.domain.PaymentDTO;
import com.etekhno.rentacar.domain.inbound.PaymentDTOIn;
import com.etekhno.rentacar.services.IBookingService;
import com.etekhno.rentacar.services.IPaymentService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PaymentServiceImpl implements IPaymentService {

    @Autowired
    private PaymentRepo paymentRepo;

    @Autowired
    private IBookingService bookingService;

    @Transactional
    public PaymentDTO processPayment(PaymentDTOIn paymentDTOIn) {
        Payment payment = new Payment();
        payment.setCustomerId(paymentDTOIn.getCustomerId());
        payment.setPaymentDate(DateHelper.getCurrentDate());
        payment.setTotalAmount(paymentDTOIn.getTotalAmount());
        payment.setPaymentMethod(paymentDTOIn.getPaymentMethod());
        payment.setPaymentStatus(PaymentStatus.UNALLOCATED);
        payment = paymentRepo.save(payment);

        processPayment(payment.getId());

        return new PaymentDTO(payment.getId(), payment.getCustomerId(), payment.getTotalAmount(),
                payment.getPaymentMethod(), payment.getOverpaidAmount(), payment.getPaymentDate(), payment.getPaymentStatus());
    }

    @Transactional
    public void processPayment(String paymentId) {
        Payment payment = paymentRepo.findById(paymentId)
                .orElseThrow(() -> new EntityNotFoundException(EntityNotFoundException.Error.PaymentNotFoundError, "Payment not found"));

        if (payment.getPaymentStatus() == PaymentStatus.COMPLETED) {
            throw new ValidationException(ValidationException.Error.PaymentAlreadyProceedError,
                    "Payment has already been distributed over the booking.");
        }

        // Allocate the payment to bookings
        bookingService.allocatePayment(paymentId);

        // Update the payment status to COMPLETED
        payment.setPaymentStatus(PaymentStatus.COMPLETED);
        paymentRepo.save(payment);
    }

    @Override
    public List<PaymentDTO> getAllPayments() {
        return paymentRepo.findAllPayments();
    }
}
