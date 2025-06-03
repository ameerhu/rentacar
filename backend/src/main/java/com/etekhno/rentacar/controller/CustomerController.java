package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.controller.util.RACDTOInValidator;
import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.domain.*;
import com.etekhno.rentacar.domain.inbound.AddressDTOIn;
import com.etekhno.rentacar.domain.inbound.CustomerDTOIn;
import com.etekhno.rentacar.domain.inbound.RegisterDTOIn;
import com.etekhno.rentacar.services.*;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("customers")
public class CustomerController {

    @Autowired
    IUserService userService;
    @Autowired
    IAddressService addressService;
    @Autowired
    IVehicleService vehicleService;
    @Autowired
    IBookingService bookingService;
    @Autowired
    IPaymentService paymentService;

    @PostMapping("/{customerId}/address")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "This api is used to add address for particular user")
    public AddressDTO addAddress(@PathVariable("customerId") String customerId,
                                 @RequestBody @Valid AddressDTOIn addressDTOIn, BindingResult result) {
        RACDTOInValidator.validate(result);
        return addressService.addAndUpdateAddress(addressDTOIn, customerId);
    }

    @PutMapping("/{customerId}/address")
    @ResponseStatus(HttpStatus.OK)
    @Operation(summary = "This api is used to update address for particular user")
    public AddressDTO updateAddress(@PathVariable("customerId") String customerId, @RequestBody AddressDTOIn addressDTOIn) {
        return addressService.addAndUpdateAddress(addressDTOIn, customerId);
    }

    @GetMapping("/{ownerId}/vehicles")
    @ResponseStatus(HttpStatus.OK)
    @Operation(summary = "This api is used to update address for particular user")
    public List<VehicleDTO> getVehicleDTOsByOwner(@PathVariable("ownerId") String ownerId) {
        return vehicleService.getVehiclesByPartyId(ownerId);
    }

    @GetMapping("/{customerId}/bookings")
    @ResponseStatus(HttpStatus.OK)
    @Operation(summary = "This api is used to update address for particular user")
    public List<BookingDTO> getBookingDTOsByCustomer(@PathVariable("customerId") String customerId) {
        return bookingService.getBookingDTOsByCustomerId(customerId);
    }

    @GetMapping("/{customerId}/payments")
    @ResponseStatus(HttpStatus.OK)
    @Operation(summary = "This api is used to update address for particular user")
    public List<PaymentDTO> getPaymentDTOsByCustomer(@PathVariable("customerId") String customerId) {
        return paymentService.getCustomerPayments(customerId);
    }

    @GetMapping("{cnic}")
    public List<CustomerDTO> getCustomerByCnic(@PathVariable String cnic) {
        return userService.findCustomerDTOsByCnic(cnic);
    }

    @PostMapping
    public CustomerDTO createCustomer(@RequestBody CustomerDTOIn customerDTOIn) {
        RegisterDTOIn r = new RegisterDTOIn(customerDTOIn.getFirstName(), customerDTOIn.getLastName(), customerDTOIn.getEmail(),
                customerDTOIn.getCnic(), customerDTOIn.getPhoneNumber(), customerDTOIn.getGender(), null);
        Party party = userService.createUser(r, null);
        return new CustomerDTO(party.getId(), party.getFirstName(), party.getLastName(), party.getEmail(),
                party.getTimezone(), party.getLocale(), party.getPhoneNumber(), party.getCnic());
    }

    @PutMapping("/{customerId}")
    public CustomerDTO updateCustomer(@PathVariable String customerId, @RequestBody CustomerDTOIn customerDTOIn) {
        RegisterDTOIn r = new RegisterDTOIn(customerDTOIn.getFirstName(), customerDTOIn.getLastName(), customerDTOIn.getEmail(),
                customerDTOIn.getCnic(), customerDTOIn.getPhoneNumber(), customerDTOIn.getGender(), null);
        Party party = userService.updateUser(customerId, r);
        return new CustomerDTO(party.getId(), party.getFirstName(), party.getLastName(), party.getEmail(),
                party.getTimezone(), party.getLocale(), party.getPhoneNumber(), party.getCnic());
    }

    @DeleteMapping("/{customerId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteCustomer(@PathVariable String customerId) {
        userService.deleteCustomer(customerId);
    }

    @GetMapping
    public List<CustomerDTO> getCustomerDTOs() {
        return userService.findCustomerDTOs();
    }

    @Operation(summary = "This api is used to get list of address for particular user ")
    @GetMapping("/{customerId}/address")
    public AddressDTO getAddress(@PathVariable String customerId) {
        return addressService.getAddressDTOByUserId(customerId);
    }
}
