package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.datamodel.PaymentAllocation;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface PaymentAllocationRepo extends CrudRepository<PaymentAllocation, String> {
    List<PaymentAllocation> findByPaymentId(String paymentId);
    List<PaymentAllocation> findByBookingId(String bookingId);
}
