package com.etekhno.rentacar.datamodel;

import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@Entity
@NoArgsConstructor
public class Vehicle extends BasicAuditingEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    private String company;
    private String model;
    private String type;
    private String number;
    private String licensePlate;
    private VehicleStatus status = VehicleStatus.AVAILABLE;
    private String ownerId;
    private Double pricePerDay;
}
