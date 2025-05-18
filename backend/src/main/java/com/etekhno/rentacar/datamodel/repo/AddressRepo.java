package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.constants.RACConstant;
import com.etekhno.rentacar.datamodel.Address;
import com.etekhno.rentacar.domain.AddressDTO;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface AddressRepo extends CrudRepository<Address, String> {
    @Query("select new " + RACConstant.DOMAIN_PACKAGE + ".AddressDTO(a.id, a.city, a.street, a.state, a.postalCode, a.country)" +
            " from PartyAddressRelation uar left join Address a on uar.addressId = a.id where uar.partyId = (:userId)")
    AddressDTO findAddressDTOByUserId(@Param("userId") String userId);

    Optional<Address> findByCityAndCountryAndStreetAndStateAndPostalCode(String city, String country,
                                                                         String street, String state, int PostalCode);
}
