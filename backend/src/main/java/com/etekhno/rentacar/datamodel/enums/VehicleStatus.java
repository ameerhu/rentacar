package com.etekhno.rentacar.datamodel.enums;

import com.etekhno.rentacar.datamodel.enums.superClass.EnumInterface;

public enum VehicleStatus implements EnumInterface {
    AVAILABLE(1),
    BOOKED(2),
    OUTOFSERVICE(3),
    UNAVAILABLE(4);

    VehicleStatus(int t) {
        type = t;
    }

    @Override
    public Integer getValue() {
        return type;
    }
    int type;
}
