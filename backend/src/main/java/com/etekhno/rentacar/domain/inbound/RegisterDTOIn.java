package com.etekhno.rentacar.domain.inbound;

import com.etekhno.rentacar.datamodel.enums.Gender;
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
public class RegisterDTOIn {
    @NotNull
    @NotBlank
    private String firstName;
    @NotNull
    @NotBlank
    private String lastName;
    @Email
    @NotNull
    @NotBlank
    private String email;
    private String cnic;
    @NotBlank
    @NotNull
    private String phoneNumber;
    @NotNull
    private Gender gender;
    @NotBlank
    @NotNull
    @Pattern(regexp = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\\S+$).{8,20}$",
            message = "should have 8 characters, contain at least one small and capital letter and special symbol")
    private String password;
}
