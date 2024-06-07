package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VehicleRepository  extends JpaRepository<Vehicle, Integer> {
    Vehicle findByVehicleNumber(String vehicleNumber);
}
