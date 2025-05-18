package com.etekhno.rentacar.datamodel.converter;

import com.etekhno.rentacar.datamodel.converter.superClass.EnumGenericConverter;
import com.etekhno.rentacar.datamodel.enums.EmailType;
import jakarta.persistence.Converter;
@Converter
public class EmailTypeConverter extends EnumGenericConverter<EmailType> {

    public EmailTypeConverter() {
        super(EmailType.class);
    }
}
