package com.etekhno.rentacar.domain.inbound;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AddressDTOIn {
    @NotNull
    @NotBlank
    String city;
    @NotNull
    @NotBlank
    String street;
    @NotNull
    @NotBlank
    String state;
    @NotNull
    int postalCode;
    @NotNull
    @NotBlank
    String country;
}
