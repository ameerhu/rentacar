package com.etekhno.rentacar.datamodel.enums;

import com.etekhno.rentacar.datamodel.enums.superClass.EnumInterface;

public enum PaymentStatus implements EnumInterface {
    UNALLOCATED(1),
    COMPLETED(2),
    FAILED(3);

    PaymentStatus(int t) {
        type = t;
    }

    @Override
    public Integer getValue() {
        return type;
    }
    int type;
}
