package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import com.etekhno.rentacar.domain.VehicleDTO;
import com.etekhno.rentacar.domain.VehicleDTOExt;
import com.etekhno.rentacar.domain.inbound.VehicleDTOIn;
import com.etekhno.rentacar.services.IVehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("vehicles")
public class VehicleController {
    @Autowired
    private IVehicleService vehicleService;

    @PostMapping
    public VehicleDTO addVehicle(@RequestBody VehicleDTOIn vehicleDTOIn) {
        return vehicleService.addVehicle(vehicleDTOIn);
    }

    @GetMapping
    public List<VehicleDTOExt> getAllVehicles() {
        return vehicleService.getAllVehicles();
    }

    @GetMapping("/{id}")
    public VehicleDTO getVehicleById(@PathVariable String id) {
        return vehicleService.getVehicleById(id);
    }

    @PutMapping("/{id}")
    public VehicleDTO updateVehicle(@PathVariable String id, @RequestBody VehicleDTOIn vehicleDTOIn) {
        return vehicleService.updateVehicle(id, vehicleDTOIn);
    }

    @DeleteMapping("/{id}")
    public void deleteVehicle(@PathVariable String id) {
        vehicleService.deleteVehicle(id);
    }

    @GetMapping("/status/{status}")
    public List<VehicleDTO> getVehiclesByStatus(@PathVariable VehicleStatus status) {
        return vehicleService.getVehiclesByStatus(status);
    }
}
