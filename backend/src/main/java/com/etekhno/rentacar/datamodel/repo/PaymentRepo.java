package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.constants.RACConstant;
import com.etekhno.rentacar.datamodel.Payment;
import com.etekhno.rentacar.domain.PaymentDTO;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PaymentRepo extends CrudRepository<Payment, String> {
    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".PaymentDTO(p.id, p.customerId, p.totalAmount," +
            "p.paymentMethod, p.overpaidAmount, p.paymentDate, p.paymentStatus) from Payment p")
    List<PaymentDTO> findAllPayments();

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".PaymentDTO(p.id, p.customerId, p.totalAmount," +
            "p.paymentMethod, p.overpaidAmount, p.paymentDate, p.paymentStatus) " +
            "from Payment p where p.customerId = :customerId")
    List<PaymentDTO> findAllPaymentsByCustomerId(@Param("customerId") String customerId);
}
