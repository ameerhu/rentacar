package com.etekhno.rentacar.config.security;

import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

@Setter
@Getter
public class MyUserDetails extends User {

    private String userId;
    private int loginAttempt;

    public MyUserDetails(String userId, int loginAttempt, String username, String password, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
        this.userId = userId;
        this.loginAttempt = loginAttempt;
    }

    public MyUserDetails(String userId, int loginAttempt, String username, String password, boolean enabled, boolean accountNonExpired, boolean credentialsNonExpired, boolean accountNonLocked, Collection<? extends GrantedAuthority> authorities) {
        super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
        this.userId = userId;
        this.loginAttempt = loginAttempt;
    }

}
