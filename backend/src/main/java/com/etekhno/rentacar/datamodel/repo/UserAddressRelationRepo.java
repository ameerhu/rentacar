package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.datamodel.PartyAddressRelation;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface UserAddressRelationRepo extends CrudRepository<PartyAddressRelation, String> {
    Optional<PartyAddressRelation> findByPartyIdAndAddressId(String partyId, String addressId);
    Optional<PartyAddressRelation> findByPartyId(String partyId);
}
