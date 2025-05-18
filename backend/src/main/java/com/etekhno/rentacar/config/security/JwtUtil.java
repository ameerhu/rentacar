package com.etekhno.rentacar.config.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.etekhno.rentacar.common.utils.DateHelper;
import com.etekhno.rentacar.config.ConfigProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtUtil {

    @Autowired
    ConfigProperties configProperties;

    public String generateJwtToken(String email, String pswd) {
        return JWT.create()
                .withSubject("user")
                .withClaim("email", email)
                .withIssuedAt(new Date())
                .withExpiresAt(DateHelper.addHoursInCurrentDate(1))
                .withIssuer(configProperties.getJwtIssuer())
                .sign(Algorithm.HMAC256(configProperties.getJwtSecret()));
    }

    public String validateTokenAndReturnClaimer(String token) {
        JWTVerifier verifier = JWT.require(Algorithm.HMAC256(configProperties.getJwtSecret()))
                .withSubject("user")
                .withIssuer(configProperties.getJwtIssuer())
                .build();

        DecodedJWT jwt = verifier.verify(token);
        return jwt.getClaim("email").asString();
    }
}
