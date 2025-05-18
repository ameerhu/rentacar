package com.etekhno.rentacar.datamodel.enums;

import com.etekhno.rentacar.datamodel.enums.superClass.EnumInterface;

public enum BookingStatus implements EnumInterface {
    PENDING(0),
    CONFIRMED(1),
    CHECKOUT(2),
    COMPLETED(3),
    OVERDUE(4),
    CANCELLED(5);

    BookingStatus(int l) {
        value = l;
    }

    @Override
    public Integer getValue() {
        return value;
    }
    Integer value;
}
