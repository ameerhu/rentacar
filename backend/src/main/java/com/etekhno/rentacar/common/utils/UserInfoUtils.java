package com.etekhno.rentacar.common.utils;

import com.etekhno.rentacar.config.security.RACToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class UserInfoUtils {
    public static String getUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = ((RACToken) authentication).getUserId();
        return userId;
    }

    public static String getUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userEmail = (String) ((RACToken) authentication).getPrincipal();
        return userEmail;
    }
}
