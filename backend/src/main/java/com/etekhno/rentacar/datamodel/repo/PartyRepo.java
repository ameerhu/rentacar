package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.constants.RACConstant;
import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.domain.CustomerDTO;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PartyRepo extends CrudRepository<Party, String> {
    Optional<Party> findByEmail(String email);

    Optional<Party> findById(String id);

    Optional<Party> findByCnic(String cnic);

    Optional<Party> findByEmailOrCnic(String email, String cnic);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".CustomerDTO(u.id, u.firstName, u.lastName, u.email," +
            " u.timezone, u.locale, u.phoneNumber, u.cnic) from Party u where u.cnic like (:cnic)")
    List<CustomerDTO> findCustomerDTOsByCnic(@Param("cnic") String cnic);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".CustomerDTO(u.id, u.firstName, u.lastName, u.email," +
            " u.timezone, u.locale, u.phoneNumber, u.cnic) from Party u")
    List<CustomerDTO> findCustomerDTOs();
}
