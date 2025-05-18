package com.etekhno.rentacar.config.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;

@Configuration
public class SwaggerSecurityConfig {

    @Autowired
    PasswordEncoder passwordEncoder;
    @Autowired
    AccessDeniedHandler accessDeniedHandler;

    @Bean
    @Order(1)
    public SecurityFilterChain swaggerFilterChain(HttpSecurity http) throws Exception {
        String swaggerPermitList[] = {"/v3/api-docs/**", "/swagger-resources/**"};

        http.csrf(c->c.disable()).cors(cor->cor.disable());
        http.sessionManagement(s->s.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        http.securityMatcher("/swagger-ui/**")
                .authorizeHttpRequests(req ->
                req.requestMatchers(swaggerPermitList).permitAll()
                .anyRequest().authenticated());

        http.userDetailsService(userDetailsService());

        http.exceptionHandling(e -> e.accessDeniedHandler(accessDeniedHandler));
        http.httpBasic(Customizer.withDefaults());
        return http.build();
    }

    public InMemoryUserDetailsManager userDetailsService() {
        UserDetails user = User
                .withUsername("developer")
                .password(passwordEncoder.encode("fin3st1@d3v"))
                .authorities("ROLE_DEVELOPER")
                .build();
        return new InMemoryUserDetailsManager(user);
    }

}
