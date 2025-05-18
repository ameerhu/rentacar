package com.etekhno.rentacar.datamodel.enums;

import com.etekhno.rentacar.datamodel.enums.superClass.EnumInterface;

public enum Month implements EnumInterface {
    January(1),
    February(2),
    March(3),
    April(4),
    May(5),
    June(6),
    July(7),
    August(8),
    September(9),
    October(10),
    November(11),
    December(12);


    Month(int m){
        month = m;
    }

    @Override
    public Integer getValue() {
        return month;
    }
    Integer month;

}
