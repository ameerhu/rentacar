package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.constants.RACConstant;
import com.etekhno.rentacar.datamodel.UserCredential;
import com.etekhno.rentacar.domain.UserDTO;
import com.etekhno.rentacar.domain.UserDTOExt;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface UserCredentialRepo extends CrudRepository<UserCredential, String> {
    Optional<UserCredential> findById(String userid);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".UserDTO(u.id, u.firstName, u.lastName, u.email, u.timezone," +
            " u.locale) from Party u where u.email = (:email)")
    UserDTO findUserDTOByEmail(@Param("email") String email);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".UserDTOExt(u.id, u.firstName, u.lastName, u.email, u.timezone, " +
            "u.locale, u.phoneNumber) from Party u where u.email = (:email)")
    UserDTOExt findUserDTOExtByEmail(@Param("email") String email);

    @Transactional
    @Modifying
    @Query("UPDATE UserCredential uc JOIN Party u ON u.id = uc.partyId set uc.loginAttempt = uc.loginAttempt + 1, " +
            "u.locked = CASE WHEN uc.loginAttempt >= (:maxLoginAttempt) THEN true ELSE u.locked END, " +
            "u.lockedTime = CASE WHEN uc.loginAttempt >= (:maxLoginAttempt) THEN now() ELSE u.lockedTime END " +
            "where u.email = (:email)")
    void blockUser(String email, int maxLoginAttempt);

    @Transactional
    @Modifying
    @Query("UPDATE UserCredential uc JOIN Party p ON p.id = uc.partyId " +
            " set uc.loginAttempt = 0, p.locked = false where p.email = (:email)")
    void resetAttemptForUser(String email);
}
