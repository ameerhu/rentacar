package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.datamodel.SecureToken;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface SecureTokenRepo extends CrudRepository<SecureToken, String> {
    Optional<SecureToken> findByToken(String token);
}
