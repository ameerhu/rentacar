package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.EntityNotFoundException;
import com.etekhno.rentacar.datamodel.Party;
import com.etekhno.rentacar.datamodel.Vehicle;
import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import com.etekhno.rentacar.datamodel.repo.PartyRepo;
import com.etekhno.rentacar.datamodel.repo.VehicleRepo;
import com.etekhno.rentacar.domain.VehicleDTO;
import com.etekhno.rentacar.domain.VehicleDTOExt;
import com.etekhno.rentacar.domain.inbound.VehicleDTOIn;
import com.etekhno.rentacar.services.IVehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VehicleServiceImpl implements IVehicleService {

    @Autowired
    private VehicleRepo vehicleRepo;
    @Autowired
    private PartyRepo partyRepo;

    public VehicleDTO addVehicle(VehicleDTOIn vehicleDTOIn) {
        Party party = partyRepo.findById(vehicleDTOIn.getOwnerId())
                .orElseThrow(() ->
                        new EntityNotFoundException(null, EntityNotFoundException.Error.CustomerNotFoundError, "Owner Not Found")
                );

        Vehicle vehicle = new Vehicle();
        vehicle.setCompany(vehicleDTOIn.getCompany());
        vehicle.setModel(vehicleDTOIn.getModel());
        vehicle.setType(vehicleDTOIn.getType());
        vehicle.setLicensePlate(vehicleDTOIn.getLicensePlate());
        vehicle.setNumber(vehicleDTOIn.getNumber());
        vehicle.setOwnerId(vehicleDTOIn.getOwnerId());
        vehicle.setPricePerDay(vehicleDTOIn.getPricePerDay());
        vehicle = vehicleRepo.save(vehicle);

        return new VehicleDTO(vehicle.getId(), vehicle.getCompany(), vehicle.getModel(), vehicle.getType(),
                vehicle.getLicensePlate(), vehicle.getNumber(), vehicle.getStatus(), vehicle.getOwnerId(), vehicle.getPricePerDay());
    }

    public List<VehicleDTOExt> getAllVehicles() {
        return vehicleRepo.findVehicleDTOs();
    }

    public VehicleDTO getVehicleById(String vehicleId) {
        return vehicleRepo.findVehicleDTOById(vehicleId)
                .orElseThrow(() -> new EntityNotFoundException(null, EntityNotFoundException.Error.VehicleNotFoundError, "Vehicle not found"));
    }

    public VehicleDTO updateVehicle(String vehicleId, VehicleDTOIn updatedVehicle) {
        Party party = partyRepo.findById(updatedVehicle.getOwnerId())
                .orElseThrow(() ->
                        new EntityNotFoundException(null, EntityNotFoundException.Error.CustomerNotFoundError, "Owner Not Found")
                );
        Vehicle vehicle = vehicleRepo.findById(vehicleId)
                .orElseThrow(() ->
                        new EntityNotFoundException(null, EntityNotFoundException.Error.VehicleNotFoundError, "Vehicle not found"));

        vehicle.setId(vehicleId);
        vehicle.setModel(updatedVehicle.getModel());
        vehicle.setCompany(updatedVehicle.getCompany());
        vehicle.setNumber(updatedVehicle.getNumber());
        vehicle.setLicensePlate(updatedVehicle.getLicensePlate());
        vehicle.setPricePerDay(updatedVehicle.getPricePerDay());
        vehicle.setStatus(updatedVehicle.getStatus());
        vehicle.setType(updatedVehicle.getType());
        vehicle.setOwnerId(updatedVehicle.getOwnerId());
        vehicle = vehicleRepo.save(vehicle);

        return new VehicleDTO(vehicle.getId(), vehicle.getCompany(), vehicle.getModel(), vehicle.getType(),
                vehicle.getLicensePlate(), vehicle.getNumber(), vehicle.getStatus(), vehicle.getOwnerId(), vehicle.getPricePerDay());
    }

    public void deleteVehicle(String vehicleId) {
        if (!vehicleRepo.existsById(vehicleId)) {
            throw new EntityNotFoundException(EntityNotFoundException.Error.VehicleNotFoundError, "Vehicle not found");
        }
        vehicleRepo.deleteById(vehicleId);
    }

    public List<VehicleDTO> getVehiclesByStatus(VehicleStatus status) {
        return vehicleRepo.findVehicleDTOsByStatus(status);
    }

    public List<VehicleDTO> getVehiclesByPartyId(String partyId) {
        return vehicleRepo.findVehicleDTOsByPartyId(partyId);
    }
}
