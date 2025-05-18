package com.etekhno.rentacar.domain.inbound;

import com.etekhno.rentacar.datamodel.enums.Gender;
import com.etekhno.rentacar.domain.UserDTOExt;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CustomerDTOIn extends UserDTOExt {
    String cnic;
    Gender gender;
    public CustomerDTOIn(String id, String firstName, String lastName, String email, String timezone,
                       String locale, String phoneNumber, String cnic) {
        super(id, firstName, lastName, email, timezone, locale, phoneNumber);
        this.cnic = cnic;
    }
}
