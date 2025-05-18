package com.etekhno.rentacar.datamodel.converter;

import com.etekhno.rentacar.datamodel.converter.superClass.EnumGenericConverter;
import com.etekhno.rentacar.datamodel.enums.BookingStatus;
import jakarta.persistence.Converter;

@Converter
public class BookingStatusConverter extends EnumGenericConverter<BookingStatus> {
    public BookingStatusConverter() {
        super(BookingStatus.class);
    }
}
