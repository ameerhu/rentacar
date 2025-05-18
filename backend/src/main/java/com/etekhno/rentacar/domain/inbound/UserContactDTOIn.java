package com.etekhno.rentacar.domain.inbound;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserContactDTOIn {

    @NotEmpty(message = "LinkedIn profile URL cannot be empty")
    @Pattern(regexp = "^(https?:\\/\\/)?(www\\.)?linkedin\\.com\\/.*$", message = "Invalid LinkedIn URL")
    @Size(max = 255)
    private String linkedin;

    @NotEmpty(message = "GitHub profile URL cannot be empty")
    @Pattern(regexp = "^(https?:\\/\\/)?(www\\.)?github\\.com\\/.*$", message = "Invalid GitHub URL")
    @Size(max = 255)
    private String github;

    @NotEmpty(message = "Gitlab profile URL cannot be empty")
    @Pattern(regexp = "^(https?:\\/\\/)?(www\\.)?gitlab\\.com\\/.*$", message = "Invalid GitLab URL")
    @Size(max = 255)
    private String gitlab;

    @Pattern(regexp = "^(https?:\\/\\/)?(www\\.)?[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)+.*$", message = "Invalid website URL")
    @Size(max = 255)
    private String website;


    @NotNull
    @NotBlank
    @Pattern(regexp = "^\\+?[0-9. ()-]{10,15}$", message = "Invalid phone number")
    @Size(max = 15)
    private String phoneNumber;
}
