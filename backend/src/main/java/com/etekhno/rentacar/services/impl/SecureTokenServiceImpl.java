package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.utils.DateHelper;
import com.etekhno.rentacar.config.ConfigProperties;
import com.etekhno.rentacar.datamodel.SecureToken;
import com.etekhno.rentacar.datamodel.enums.EmailType;
import com.etekhno.rentacar.datamodel.repo.SecureTokenRepo;
import com.etekhno.rentacar.services.ISecureTokenService;
import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.keygen.BytesKeyGenerator;
import org.springframework.security.crypto.keygen.KeyGenerators;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.Date;

@Service
public class SecureTokenServiceImpl implements ISecureTokenService {
    private static final BytesKeyGenerator DEFAULT_TOKEN_GENERATOR = KeyGenerators.secureRandom(15);
    private static final Integer MIN = 100000;
    private static final Integer MAX = 999999;

    @Autowired
    SecureTokenRepo secureTokenRepo;
    @Autowired
    ConfigProperties configProperties;

    @Override
    public SecureToken getSecureToken(String userId, EmailType emailType) {
        // this is a sample, you can adapt as per your security need
        String tokenValue = Base64.encodeBase64URLSafeString(DEFAULT_TOKEN_GENERATOR.generateKey());
        return createSecureToken(userId, emailType, tokenValue,DateHelper.addHoursInCurrentDate(1));
    }
    @Override
    public SecureToken getIntegerOTP(String userId, EmailType emailType) {
        String OTP = String.valueOf(MIN + new SecureRandom().nextInt(MAX - MIN));
        return createSecureToken(userId, emailType, OTP, DateHelper.addMinutesInCurrentDate(configProperties.getOtpExpiryMints()));
    }

    private SecureToken createSecureToken(String userId, EmailType emailType, String OTP, Date time) {
        SecureToken secureToken = new SecureToken();
        secureToken.setToken(OTP);
        secureToken.setTimestamp(DateHelper.getCurrentDate());
        secureToken.setExpireAt(time);
        secureToken.setUserId(userId);
        secureToken.setEmailType(emailType);
        secureToken = secureTokenRepo.save(secureToken);
        return secureToken;
    }
}
