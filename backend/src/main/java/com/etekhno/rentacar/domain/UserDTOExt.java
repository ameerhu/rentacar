package com.etekhno.rentacar.domain;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserDTOExt extends UserDTO {

    private String phoneNumber;

    public UserDTOExt( String id, String firstName, String lastName, String email, String timezone,
                       String locale, String phoneNumber) {
        super(id, firstName, lastName, email, timezone, locale);
        this.phoneNumber = phoneNumber;

    }
}
