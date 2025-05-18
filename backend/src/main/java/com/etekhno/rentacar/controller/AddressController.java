package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.services.IAddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class AddressController {
    @Autowired
    IAddressService addressService;
}
