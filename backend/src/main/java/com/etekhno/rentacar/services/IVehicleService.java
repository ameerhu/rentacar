package com.etekhno.rentacar.services;

import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import com.etekhno.rentacar.domain.VehicleDTO;
import com.etekhno.rentacar.domain.VehicleDTOExt;
import com.etekhno.rentacar.domain.inbound.VehicleDTOIn;

import java.util.List;

public interface IVehicleService {
    VehicleDTO addVehicle(VehicleDTOIn vehicleDTOIn);

    List<VehicleDTOExt> getAllVehicles();

    VehicleDTO getVehicleById(String vehicleId);

    VehicleDTO updateVehicle(String vehicleId, VehicleDTOIn updatedVehicle);

    void deleteVehicle(String vehicleId);

    List<VehicleDTO> getVehiclesByStatus(VehicleStatus status);

    List<VehicleDTO> getVehiclesByPartyId(String partyId);
}
