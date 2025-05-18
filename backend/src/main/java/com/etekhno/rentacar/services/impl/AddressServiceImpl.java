package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.EntityNotFoundException;
import com.etekhno.rentacar.datamodel.Address;
import com.etekhno.rentacar.datamodel.PartyAddressRelation;
import com.etekhno.rentacar.datamodel.repo.AddressRepo;
import com.etekhno.rentacar.datamodel.repo.UserAddressRelationRepo;
import com.etekhno.rentacar.domain.AddressDTO;
import com.etekhno.rentacar.domain.inbound.AddressDTOIn;
import com.etekhno.rentacar.services.IAddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

import static com.etekhno.rentacar.common.utils.UserInfoUtils.getUserId;
@Service
public class AddressServiceImpl implements IAddressService {
    @Autowired
    AddressRepo addressRepo;
    @Autowired
    UserAddressRelationRepo userAddressRelationRepo;

      @Override
    public AddressDTO getAddressDTOByUserId(String userId) {
          return addressRepo.findAddressDTOByUserId(userId);
    }
    @Override
    public void deleteUserAddressRelation(String addressId) {
        Optional<PartyAddressRelation> userAR = userAddressRelationRepo.findByPartyIdAndAddressId(getUserId(), addressId);
        if (userAR.isEmpty()){
            throw new EntityNotFoundException(null,EntityNotFoundException.Error.UserAddressRelationError,
                    "User Address Relation Not Exist");
        }
        userAddressRelationRepo.delete(userAR.get());
    }

    @Override
    public AddressDTO addAndUpdateAddress(AddressDTOIn addressDTOIn, String userId) {
        Optional<Address> retrieveAddress = addressRepo.findByCityAndCountryAndStreetAndStateAndPostalCode(addressDTOIn.getCity(),
                addressDTOIn.getCountry(), addressDTOIn.getStreet(), addressDTOIn.getState(), addressDTOIn.getPostalCode());
        Address address = new Address();

        if(retrieveAddress.isEmpty()) {
            address.setCity(addressDTOIn.getCity());
            address.setCountry(addressDTOIn.getCountry());
            address.setStreet(addressDTOIn.getStreet());
            address.setState(addressDTOIn.getState());
            address.setPostalCode(addressDTOIn.getPostalCode());
            address = addressRepo.save(address);
        } else {
            address = retrieveAddress.get();
        }

        AddressDTO addressDTO = new AddressDTO();
        addressDTO.setId(address.getId());
        addressDTO.setCity(address.getCity());
        addressDTO.setCountry(address.getCountry());
        addressDTO.setStreet(address.getStreet());
        addressDTO.setState(address.getState());
        addressDTO.setPostalCode(address.getPostalCode());

        Optional<PartyAddressRelation> retrievedUAR = userAddressRelationRepo.findByPartyId(userId);
        PartyAddressRelation userAddressRelation = new PartyAddressRelation();
        if(retrievedUAR.isEmpty()) {
            userAddressRelation.setAddressId(address.getId());
            userAddressRelation.setPartyId(userId);
        } else {
            userAddressRelation = retrievedUAR.get();
            userAddressRelation.setAddressId(address.getId());
        }
        userAddressRelationRepo.save(userAddressRelation);
        return addressDTO;
    }
}
