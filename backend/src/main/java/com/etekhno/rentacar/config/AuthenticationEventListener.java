package com.etekhno.rentacar.config;

import com.etekhno.rentacar.common.exceptions.AuthenticationException;
import com.etekhno.rentacar.config.security.MyUserDetails;
import com.etekhno.rentacar.config.security.RACToken;
import com.etekhno.rentacar.datamodel.repo.UserCredentialRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.event.AuthenticationFailureBadCredentialsEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationEventListener {

    @Autowired
    UserCredentialRepo userCredentialRepo;
    @Autowired
    ConfigProperties configProperties;

    @EventListener
    public void authenticationFailed(AuthenticationFailureBadCredentialsEvent event) {
        if (event.getAuthentication() instanceof RACToken rat) {
            String email = (String) rat.getPrincipal();
            userCredentialRepo.blockUser(email, configProperties.getMaxLoginAttempt());
            //rat.getLoginAttempt will be increased by 1 because it contains old value
            // whereas userRepo.blockUser already increased loginAttempt in db
            if (rat.getLoginAttempt() + 1 >= configProperties.getMaxLoginAttempt()) {
                throw new AuthenticationException(null, AuthenticationException.Error.UserAccountLockedError,
                        "User has reached maximum wrong login attempts. Please try it out after 24 hours.");
            }
        }
    }

    @EventListener
    public void authenticationListener(AuthenticationSuccessEvent event) {
        if (event.getAuthentication().getPrincipal() instanceof MyUserDetails mud)
            if (mud.getLoginAttempt() > 0)
                userCredentialRepo.resetAttemptForUser(mud.getUsername());
    }

}