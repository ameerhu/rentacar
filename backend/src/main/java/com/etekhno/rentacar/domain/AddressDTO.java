package com.etekhno.rentacar.domain;

import com.etekhno.rentacar.domain.inbound.AddressDTOIn;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AddressDTO extends AddressDTOIn {
    String id;
    public AddressDTO(String id, String city, String street, String state, int postalCode, String country ){
        super(city, street, state, postalCode, country);
        this.id = id;
    }
}
