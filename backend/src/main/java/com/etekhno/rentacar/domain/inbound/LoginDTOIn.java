package com.etekhno.rentacar.domain.inbound;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

public class LoginDTOIn {
    @Email
    /*@NotNull
    @NotBlank*/
    private String email;
    /*@NotNull
    @NotBlank*/
    private String cnic;

    @NotNull
    @NotBlank
    @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\\S+$).{8,20}$" ,
            message = "should have 8 characters, contain at least one small and capital letter and special symbol")
    private String password;
}
