package com.etekhno.rentacar.config.security;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

public class RACToken extends UsernamePasswordAuthenticationToken {

    private String userId;
    private int loginAttempt;

    public RACToken(String userId, int loginAttempt, Object principal, Object credentials) {
        super(principal, credentials);
        this.userId = userId;
        this.loginAttempt = loginAttempt;
    }

    public RACToken(String userId, int loginAttempt, Object principal, Object credentials, Collection<? extends GrantedAuthority> authorities) {
        super(principal, credentials, authorities);
        this.userId = userId;
        this.loginAttempt = loginAttempt;
    }

    public String getUserId() {
        return userId;
    }

    public int getLoginAttempt() {
        return loginAttempt;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}
