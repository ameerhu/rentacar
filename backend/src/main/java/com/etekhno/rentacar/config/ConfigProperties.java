package com.etekhno.rentacar.config;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@Getter
public class ConfigProperties {

    @Value("${rentacar.jwt_secret}")
    private String jwtSecret;

    @Value("${rentacar.jwt_issuer}")
    private String jwtIssuer;

    @Value("${rentacar.base-url}")
    private String baseURL;

    @Value("${spring.mail.username}")
    private String emailUser;

    @Value("${mail.sender.name}")
    private String senderName;

    @Value("${mail.sender.email}")
    private String senderEmail;

    @Value("${mail.mailersend.api.key}")
    private String mailersendApiKey;

    @Value("${rentacar.max-login-attempt}")
    private int maxLoginAttempt;

    @Value("${rentacar.opt-expiry-mints:10}")
    private int otpExpiryMints;

    @Value("${rentacar.support-email}")
    private String supportEmail;

    @Value("${rentacar.email-subject-prefix}")
    private String emailSubjectPrefix;

    @Value("${rentacar.qrcode-size:200}")
    private Integer qrCodeSize;

    @Value("${rentacar.block-duration-hours}")
    private Long blockDurationHours;

    @Value("${rentacar.max-user-awards}")
    private Integer noOfAwards;
}
