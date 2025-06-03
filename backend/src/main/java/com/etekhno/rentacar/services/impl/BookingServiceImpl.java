package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.EntityNotFoundException;
import com.etekhno.rentacar.common.exceptions.ValidationException;
import com.etekhno.rentacar.datamodel.Booking;
import com.etekhno.rentacar.datamodel.Payment;
import com.etekhno.rentacar.datamodel.PaymentAllocation;
import com.etekhno.rentacar.datamodel.enums.BookingStatus;
import com.etekhno.rentacar.datamodel.repo.BookingRepo;
import com.etekhno.rentacar.datamodel.repo.PaymentAllocationRepo;
import com.etekhno.rentacar.datamodel.repo.PaymentRepo;
import com.etekhno.rentacar.domain.BookingDTO;
import com.etekhno.rentacar.domain.BookingDTOExt;
import com.etekhno.rentacar.domain.PendingPaymentDTO;
import com.etekhno.rentacar.domain.inbound.BookingDTOIn;
import com.etekhno.rentacar.services.IBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class BookingServiceImpl implements IBookingService {

    @Autowired
    private BookingRepo bookingRepo;

    @Autowired
    private PaymentRepo paymentRepo;

    @Autowired
    private PaymentAllocationRepo paymentAllocationRepo;


    public BookingDTO createBooking(BookingDTOIn bDTOIn) {
        Booking booking = new Booking(null, bDTOIn.getVehicleId(), bDTOIn.getCustomerId(),
                bDTOIn.getRentalStartDate(), bDTOIn.getRentalEndDate(), bDTOIn.getTotalAmount(),
                bDTOIn.getAmountPaid(), bDTOIn.getRemainingBalance(), bDTOIn.getStatus());
        booking = bookingRepo.save(booking);

        return new BookingDTO(booking.getId(), booking.getVehicleId(), booking.getCustomerId(),
                booking.getRentalStartDate(), booking.getRentalEndDate(), booking.getTotalAmount(),
                booking.getAmountPaid(), booking.getRemainingBalance(), booking.getStatus());
    }

    // Update booking details
    public BookingDTO updateBooking(String bookingId, BookingDTOIn updatedBooking) {
        Booking booking = bookingRepo.findById(bookingId)
                .orElseThrow(() -> new EntityNotFoundException(EntityNotFoundException.Error.BookingNotFoundError, "Booking not found"));

        booking.setTotalAmount(updatedBooking.getTotalAmount());
        booking.setRentalStartDate(updatedBooking.getRentalStartDate());
        booking.setRentalEndDate(updatedBooking.getRentalEndDate());
        booking.setStatus(updatedBooking.getStatus());
        booking.setAmountPaid(updatedBooking.getAmountPaid());
        booking.setRemainingBalance(updatedBooking.getRemainingBalance());

        booking = bookingRepo.save(booking);

        return new BookingDTO(booking.getId(), booking.getVehicleId(), booking.getCustomerId(),
                booking.getRentalStartDate(), booking.getRentalEndDate(), booking.getTotalAmount(),
                booking.getAmountPaid(), booking.getRemainingBalance(), booking.getStatus());
    }

    public void allocatePayment(String paymentId) {
        Payment payment = paymentRepo.findById(paymentId)
                .orElseThrow(() -> new EntityNotFoundException(EntityNotFoundException.Error.PaymentNotFoundError, "Payment not found"));

        if (payment.getTotalAmount().compareTo(BigDecimal.ZERO) == 0) {
            throw new ValidationException(ValidationException.Error.PaymentAmountInvalidError, "Invalid payment amount.");
        }

        List<Booking> bookings = bookingRepo.findByCustomerIdAndStatus(payment.getCustomerId(), BookingStatus.PENDING);

        if (bookings.isEmpty()) {
            throw new EntityNotFoundException(EntityNotFoundException.Error.PendingBookingNotFoundError, "No pending bookings for this customer.");
        }

        BigDecimal remainingAmountToAllocate = payment.getTotalAmount();

        for (Booking booking : bookings) {
            if (remainingAmountToAllocate.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal amountToAllocate = booking.getRemainingBalance();

                // Record the allocation in PaymentAllocation table
                PaymentAllocation allocation = new PaymentAllocation();
                allocation.setPaymentId(payment.getId());
                allocation.setBookingId(booking.getId());

                if (remainingAmountToAllocate.compareTo(amountToAllocate) >= 0) {
                    // Fully allocate the booking's remaining balance
                    booking.setAmountPaid(booking.getAmountPaid().add(amountToAllocate));
                    booking.setRemainingBalance(BigDecimal.ZERO);
                    booking.setStatus(BookingStatus.COMPLETED);
                    remainingAmountToAllocate = remainingAmountToAllocate.subtract(amountToAllocate);
                    allocation.setAllocatedAmount(amountToAllocate);
                } else {
                    // Partially allocate the remaining balance
                    booking.setAmountPaid(booking.getAmountPaid().add(remainingAmountToAllocate));
                    booking.setRemainingBalance(booking.getRemainingBalance().subtract(remainingAmountToAllocate));
                    allocation.setAllocatedAmount(remainingAmountToAllocate);
                    remainingAmountToAllocate = BigDecimal.ZERO;
                }
                paymentAllocationRepo.save(allocation);
            }
        }

        // If any remaining balance from payment is left unallocated, it becomes overpaid
        if (remainingAmountToAllocate.compareTo(BigDecimal.ZERO) > 0) {
            payment.setOverpaidAmount(remainingAmountToAllocate);
        }

        paymentRepo.save(payment);
        bookingRepo.saveAll(bookings);
    }

    @Override
    public List<BookingDTO> getBookingDTOsByCustomerId(String customerId) {
        return bookingRepo.findBookingDTOsByCustomerId(customerId);
    }

    @Override
    public List<PendingPaymentDTO> getAllPendingPayments() {
        return bookingRepo.findAllPendingPayments();
    }

    @Override
    public List<BookingDTO> getBookingDTOs() {
        return bookingRepo.findBookingDTOs();
    }

    @Override
    public List<BookingDTOExt> getBookingDTOExtList() {
        return bookingRepo.findBookingDTOExtList();
    }
}
