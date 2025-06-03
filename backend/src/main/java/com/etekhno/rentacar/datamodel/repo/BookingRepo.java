package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.constants.RACConstant;
import com.etekhno.rentacar.datamodel.Booking;
import com.etekhno.rentacar.datamodel.enums.BookingStatus;
import com.etekhno.rentacar.domain.BookingDTO;
import com.etekhno.rentacar.domain.BookingDTOExt;
import com.etekhno.rentacar.domain.PendingPaymentDTO;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BookingRepo extends CrudRepository<Booking, String> {
    List<Booking> findByCustomerIdAndStatus(String customerId, BookingStatus status);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".BookingDTO(b.id, b.vehicleId, b.customerId, " +
            " b.rentalStartDate, b.rentalEndDate, b.totalAmount, b.amountPaid, b.remainingBalance," +
            " b.status) from Booking b where b.customerId = (:customerId)")
    List<BookingDTO> findBookingDTOsByCustomerId(@Param("customerId") String customerId);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".BookingDTO(b.id, b.vehicleId, b.customerId, " +
            " b.rentalStartDate, b.rentalEndDate, b.totalAmount, b.amountPaid, b.remainingBalance," +
            " b.status) from Booking b")
    List<BookingDTO> findBookingDTOs();

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".BookingDTOExt(b.id, b.vehicleId, v.company, b.customerId, " +
            "c.firstName, b.rentalStartDate, b.rentalEndDate, b.totalAmount, b.amountPaid, b.remainingBalance, b.status)" +
            " from Booking b " +
            " left join Vehicle v on v.id = b.vehicleId" +
            " left join Party c on c.id = b.customerId")
    List<BookingDTOExt> findBookingDTOExtList();

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".PendingPaymentDTO(b.customerId, p.cnic, p.firstName, sum(b.remainingBalance) )" +
            " from Booking b " +
            " left join Party p on p.id = b.customerId" +
            " group by(b.customerId, p.cnic, p.firstName)" +
            " having sum(b.remainingBalance) > 0 " +
            " order by sum(b.remainingBalance) desc")
    List<PendingPaymentDTO> findAllPendingPayments();
}
