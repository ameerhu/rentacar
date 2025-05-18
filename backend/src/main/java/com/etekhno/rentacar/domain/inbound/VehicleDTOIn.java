package com.etekhno.rentacar.domain.inbound;

import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class VehicleDTOIn {
    private String company;
    private String model;
    private String type;
    private String licensePlate;
    private String number;
    private VehicleStatus status = VehicleStatus.AVAILABLE;
    private String ownerId;
    private Double pricePerDay;
}
