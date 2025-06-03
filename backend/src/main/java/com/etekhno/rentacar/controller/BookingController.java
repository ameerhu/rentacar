package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.domain.BookingDTO;
import com.etekhno.rentacar.domain.BookingDTOExt;
import com.etekhno.rentacar.domain.inbound.BookingDTOIn;
import com.etekhno.rentacar.services.IBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("bookings")
public class BookingController {

    @Autowired
    private IBookingService bookingService;

    // Create a new booking
    @PostMapping
    public BookingDTO createBooking(@RequestBody BookingDTOIn bookingDTOIn) {
        return bookingService.createBooking(bookingDTOIn);
    }

    @GetMapping
    public List<BookingDTOExt> getBookingDTOExtList() {
        return bookingService.getBookingDTOExtList();
    }

    // Update an existing booking
    @PutMapping("/{id}")
    public BookingDTO updateBooking(@PathVariable String id, @RequestBody BookingDTOIn bookingDTOIn) {
        return bookingService.updateBooking(id, bookingDTOIn);
    }
}
