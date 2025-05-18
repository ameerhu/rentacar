package com.etekhno.rentacar.datamodel.converter;

import com.etekhno.rentacar.datamodel.converter.superClass.EnumGenericConverter;
import com.etekhno.rentacar.datamodel.enums.Month;
import jakarta.persistence.Converter;

@Converter
public class MonthConverter extends EnumGenericConverter<Month> {
    public MonthConverter(){
        super(Month.class);
    }
}
