package com.etekhno.rentacar.services;

import com.etekhno.rentacar.domain.BookingDTO;
import com.etekhno.rentacar.domain.BookingDTOExt;
import com.etekhno.rentacar.domain.PendingPaymentDTO;
import com.etekhno.rentacar.domain.inbound.BookingDTOIn;

import java.util.List;

public interface IBookingService {
    void allocatePayment(String paymentId);

    BookingDTO createBooking(BookingDTOIn bDTOIn);

    BookingDTO updateBooking(String bookingId, BookingDTOIn updatedBooking);

    List<BookingDTO> getBookingDTOs();

    List<BookingDTOExt> getBookingDTOExtList();

    List<BookingDTO> getBookingDTOsByCustomerId(String customerId);

    List<PendingPaymentDTO> getAllPendingPayments();
}
