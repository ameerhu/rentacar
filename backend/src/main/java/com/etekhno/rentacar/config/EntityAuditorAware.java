package com.etekhno.rentacar.config;

import com.etekhno.rentacar.config.security.RACToken;
import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;

public class EntityAuditorAware implements AuditorAware<String> {

    @Override
    public Optional<String> getCurrentAuditor() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && RACToken.class.isAssignableFrom(auth.getClass())) {
            return Optional.of(((RACToken) auth).getUserId());
        }
        return Optional.of("self-service");
    }
}
