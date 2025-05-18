package com.etekhno.rentacar.datamodel.converter;

import com.etekhno.rentacar.datamodel.converter.superClass.EnumGenericConverter;
import com.etekhno.rentacar.datamodel.enums.Gender;
import jakarta.persistence.Converter;

@Converter
public class GenderConverter extends EnumGenericConverter<Gender> {
    public GenderConverter() {
        super(Gender.class);
    }
}
