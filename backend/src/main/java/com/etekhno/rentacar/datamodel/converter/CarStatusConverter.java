package com.etekhno.rentacar.datamodel.converter;

import com.etekhno.rentacar.datamodel.converter.superClass.EnumGenericConverter;
import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import jakarta.persistence.Converter;

@Converter
public class CarStatusConverter extends EnumGenericConverter<VehicleStatus> {
    public CarStatusConverter() {
        super(VehicleStatus.class);
    }
}
