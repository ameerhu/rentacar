package com.etekhno.rentacar.domain;

import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import com.etekhno.rentacar.domain.inbound.VehicleDTOIn;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
public class VehicleDTO extends VehicleDTOIn {
    private String id;

    public VehicleDTO(String id, String company, String model, String type, String licensePlate,
                      String number, VehicleStatus status, String ownerId, Double pricePerDay) {
        super(company, model, type, licensePlate, number, status, ownerId, pricePerDay);
        this.id = id;
    }
}
