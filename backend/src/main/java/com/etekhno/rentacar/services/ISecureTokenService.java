package com.etekhno.rentacar.services;

import com.etekhno.rentacar.datamodel.SecureToken;
import com.etekhno.rentacar.datamodel.enums.EmailType;

public interface ISecureTokenService {
    SecureToken getSecureToken(String userId, EmailType emailType);
    SecureToken getIntegerOTP(String userId, EmailType emailType);
}
