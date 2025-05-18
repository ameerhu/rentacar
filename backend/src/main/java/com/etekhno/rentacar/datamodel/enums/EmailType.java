package com.etekhno.rentacar.datamodel.enums;

import com.etekhno.rentacar.datamodel.enums.superClass.EnumInterface;

public enum EmailType implements EnumInterface {
    AccountVerificationEmail(0),
    ForgetPasswordEmail(1),
    PasswordResetEmail(2);
    EmailType(int v){
        value = v;
    }

    @Override
    public Integer getValue() {
        return value;
    }

    int value;
}
