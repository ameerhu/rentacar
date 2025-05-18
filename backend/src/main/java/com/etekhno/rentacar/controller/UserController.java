package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.common.exceptions.FileHandlingException;
import com.etekhno.rentacar.common.utils.UserInfoUtils;
import com.etekhno.rentacar.config.security.RACToken;
import com.etekhno.rentacar.controller.util.RACDTOInValidator;
import com.etekhno.rentacar.domain.AddressDTO;
import com.etekhno.rentacar.domain.UserDTOExt;
import com.etekhno.rentacar.domain.inbound.AddressDTOIn;
import com.etekhno.rentacar.domain.inbound.UserContactDTOIn;
import com.etekhno.rentacar.services.IAddressService;
import com.etekhno.rentacar.services.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private IUserService userService;
    @Autowired
    IAddressService addressService;

    @GetMapping("/currentUser")
    @Operation(summary = "This method is used to find current User Details.")
    UserDTOExt findCurrentUser() {
        String currentUserEmail = SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString();
        return userService.findUserDTOExtByEmail(currentUserEmail);
    }

    @PutMapping("/currentUser/profile")
    @Operation(summary = "This api is used to update user's contact information")
    public void updateContactInformation(@RequestBody @Valid UserContactDTOIn userContactDTOIn, BindingResult result) {
        RACDTOInValidator.validate(result);
        userService.updateUserContactInformation(userContactDTOIn);
    }

    @ResponseStatus(HttpStatus.NO_CONTENT)
    @PutMapping("/currentUser/profilePicture")
    @Operation(summary = "This method is used to upload user profile picture")
    public void uploadUserProfilePic(@RequestParam("file") MultipartFile file) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = ((RACToken) authentication).getUserId();

        if (file.getContentType().endsWith("jpeg")
                || file.getContentType().endsWith("png")
                || file.getContentType().endsWith("gif")) {
            userService.saveProfilePicture(file, userId);
            return;
        }

        throw new FileHandlingException(null, FileHandlingException.Error.FileFormatNotSupported, "Profile picture failed to read.");
    }

    @PostMapping("/currentUser/address")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "This api is used to add address for particular user")
    public AddressDTO addAddress(@RequestBody @Valid AddressDTOIn addressDTOIn, BindingResult result) {
        RACDTOInValidator.validate(result);
        return addressService.addAndUpdateAddress(addressDTOIn, UserInfoUtils.getUserId());
    }

    @PutMapping("/currentUser/address")
    @ResponseStatus(HttpStatus.OK)
    @Operation(summary = "This api is used to update address for particular user")
    public AddressDTO updateAddress(@RequestBody AddressDTOIn addressDTOIn) {
        return addressService.addAndUpdateAddress(addressDTOIn, UserInfoUtils.getUserId());
    }

    @DeleteMapping("/currentUser/address/{addressId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @Operation(summary = "This api is used to delete address for particular user")
    public void deleteUserAddressRelation(@PathVariable("addressId") String addressId) {
        addressService.deleteUserAddressRelation(addressId);
    }

    @Operation(summary = "This api is used to get list of address for particular user ")
    @GetMapping("/currentUser/address")
    public AddressDTO getAddress() {
        return addressService.getAddressDTOByUserId(UserInfoUtils.getUserId());
    }
}