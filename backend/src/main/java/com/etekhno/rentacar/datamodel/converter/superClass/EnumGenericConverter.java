package com.etekhno.rentacar.datamodel.converter.superClass;

import com.etekhno.rentacar.common.exceptions.JPAConverterException;
import com.etekhno.rentacar.datamodel.enums.superClass.EnumInterface;
import jakarta.persistence.AttributeConverter;

import java.util.EnumSet;
import java.util.Objects;

public abstract class EnumGenericConverter<E extends Enum<E>> implements AttributeConverter<E, Integer> {

    private Class<E> currentEnum;

    public EnumGenericConverter(Class<E> e) {
        currentEnum = e;
    }

    @Override
    public Integer convertToDatabaseColumn(E eenum) {
        if(Objects.isNull(eenum))
            return null;
        if(EnumInterface.class.isAssignableFrom(eenum.getClass()))
            return ((EnumInterface)eenum).getValue();

        throw new JPAConverterException(null, JPAConverterException.Error.IllegalEnumArgumentError,String.format("Attribute %s is unknown", eenum));
    }

    @Override
    public E convertToEntityAttribute(Integer i) {
        if(Objects.isNull(i))
            return null;

        try {
            for (E e : EnumSet.allOf(currentEnum)) {
                if(((EnumInterface)e).getValue().equals(i))
                    return e;
            }
        }catch (Exception e) {
            throw new JPAConverterException(e, JPAConverterException.Error.IllegalEnumArgumentError, String.format("Attribute %s is unknown", i.toString()));
        }
        throw new JPAConverterException(null, JPAConverterException.Error.IllegalEnumArgumentError, String.format("Attribute %s is unknown", i.toString()));
    }

}
