package com.etekhno.rentacar.datamodel.enums;

import com.etekhno.rentacar.datamodel.enums.superClass.EnumInterface;

public enum Gender implements EnumInterface {

    Male(0),
    Female(1);

    Gender(int v) {
        value = v;
    }

    @Override
    public Integer getValue() {
        return value;
    }
    Integer value;
}
