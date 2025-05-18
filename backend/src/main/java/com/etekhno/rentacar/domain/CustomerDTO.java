package com.etekhno.rentacar.domain;

import com.etekhno.rentacar.domain.inbound.CustomerDTOIn;

public class CustomerDTO extends CustomerDTOIn {
    public CustomerDTO(String id, String firstName, String lastName, String email, String timezone,
                       String locale, String phoneNumber, String cnic) {
        super(id, firstName, lastName, email, timezone, locale, phoneNumber, cnic);
    }
}
