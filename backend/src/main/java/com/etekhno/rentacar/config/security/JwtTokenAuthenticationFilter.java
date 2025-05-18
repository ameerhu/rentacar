package com.etekhno.rentacar.config.security;

import com.auth0.jwt.exceptions.JWTVerificationException;
import com.etekhno.rentacar.common.exceptions.AuthenticationException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtTokenAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    JwtUtil jwtUtil;
    @Autowired
    MyUserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && !authHeader.isBlank() && authHeader.startsWith("Bearer ")) {
            String jwt = authHeader.substring(7);
            if (jwt == null || jwt.isBlank()) {
                throw new AuthenticationException(null, AuthenticationException.Error.NoAuthenticationInfoError, "Invalid JWT Token");
            } else {
                try {
                    String email = jwtUtil.validateTokenAndReturnClaimer(jwt);
                    MyUserDetails userDetails = userDetailsService.loadUserByUsername(email);
                    RACToken authToken =
                            new RACToken(userDetails.getUserId(), userDetails.getLoginAttempt(), email, userDetails.getPassword(), userDetails.getAuthorities());

                    if (SecurityContextHolder.getContext().getAuthentication() == null) {
                        SecurityContextHolder.getContext().setAuthentication(authToken);
                    }
                } catch (JWTVerificationException exc) {
                    throw new AuthenticationException(exc, AuthenticationException.Error.InvalidTokenError, "Invalid JWT Token");
                }
            }
        }

        filterChain.doFilter(request, response);
    }
}
