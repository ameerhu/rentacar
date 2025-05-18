package com.etekhno.rentacar.datamodel.repo;

import com.etekhno.rentacar.constants.RACConstant;
import com.etekhno.rentacar.datamodel.Vehicle;
import com.etekhno.rentacar.datamodel.enums.VehicleStatus;
import com.etekhno.rentacar.domain.VehicleDTO;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface VehicleRepo extends CrudRepository<Vehicle, String> {

    List<Vehicle> findByStatus(VehicleStatus status);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".VehicleDTO(v.id, v.company, v.model, v.type, v.licensePlate," +
            " v.number, v.status, v.ownerId, v.pricePerDay) from Vehicle v")
    List<VehicleDTO> findVehicleDTOs();

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".VehicleDTO(v.id, v.company, v.model, v.type, v.licensePlate," +
            " v.number, v.status, v.ownerId, v.pricePerDay) from Vehicle v where v.id = (:id)")
    Optional<VehicleDTO> findVehicleDTOById(String id);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".VehicleDTO(v.id, v.company, v.model, v.type, v.licensePlate," +
            " v.number, v.status, v.ownerId, v.pricePerDay) from Vehicle v where v.status = (:status)")
    List<VehicleDTO> findVehicleDTOsByStatus(@Param("status") VehicleStatus status);

    @Query("Select new " + RACConstant.DOMAIN_PACKAGE + ".VehicleDTO(v.id, v.company, v.model, v.type, v.licensePlate," +
            " v.number, v.status, v.ownerId, v.pricePerDay) from Vehicle v where v.ownerId = (:ownerId)")
    List<VehicleDTO> findVehicleDTOsByPartyId(@Param("ownerId") String ownerId);
}
