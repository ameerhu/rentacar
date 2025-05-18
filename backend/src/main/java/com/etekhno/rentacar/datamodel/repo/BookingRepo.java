package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.constants.RACConstant;
import com.etekhno.rentacar.datamodel.Booking;
import com.etekhno.rentacar.datamodel.enums.BookingStatus;
import com.etekhno.rentacar.domain.BookingDTO;
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
}
