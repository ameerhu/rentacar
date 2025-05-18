package com.etekhno.rentacar.services;

import com.etekhno.rentacar.domain.AddressDTO;
import com.etekhno.rentacar.domain.inbound.AddressDTOIn;

public interface IAddressService {
    AddressDTO getAddressDTOByUserId(String userId);
    void deleteUserAddressRelation(String addressId);
    AddressDTO addAndUpdateAddress(AddressDTOIn addressDTOIn, String userId);
}

