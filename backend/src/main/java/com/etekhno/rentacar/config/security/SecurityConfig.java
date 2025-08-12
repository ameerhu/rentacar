package com.etekhno.rentacar.config.security;

import com.etekhno.rentacar.config.CustomAccessDeniedHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
public class SecurityConfig {

    @Autowired
    JwtTokenAuthenticationFilter jwtTokenAuthenticationFilter;
    @Autowired
    MyUserDetailsService userDetailsService;
    @Autowired
    RACAuthenticationEntryPoint RACAuthenticationEntryPoint;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        String racPermitList[] = {"/config/**", "/auth/**", "/sse/**"};
        String swaggerPermitList[] = {"/v3/api-docs/**", "/swagger-resources/**"};
        String[] staticResources = {"/*.js", "/*.css", "/*.html", "/assets/**", "/favicon.png", "/manifest.json"};

        http.csrf(c -> c.disable())
                .httpBasic(h -> h.disable());

        http.sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        http.authorizeHttpRequests(req -> {
            req.requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                    .requestMatchers(racPermitList).permitAll()
                    .requestMatchers(swaggerPermitList).permitAll()
                    .requestMatchers(staticResources).permitAll()
                    .anyRequest().authenticated();
        });

        http.userDetailsService(userDetailsService);
        http.addFilterBefore(jwtTokenAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        http.exceptionHandling(eh -> eh.authenticationEntryPoint(RACAuthenticationEntryPoint));
        http.exceptionHandling(ah -> ah.accessDeniedHandler(accessDeniedHandler()));

        return http.build();
    }

    @Bean
    public AuthenticationManager securityAuthenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return new CustomAccessDeniedHandler();
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
