package com.etekhno.rentacar.domain;

import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VehicleDTOExt extends VehicleDTO {
    private String ownerName;

    public VehicleDTOExt(String id, String company, String model, String type, String licensePlate,
                         String number, VehicleStatus status, String ownerId, String ownerName, Double pricePerDay) {
        super(id, company, model, type, licensePlate, number, status, ownerId, pricePerDay);
        this.ownerName = ownerName;
    }
}
