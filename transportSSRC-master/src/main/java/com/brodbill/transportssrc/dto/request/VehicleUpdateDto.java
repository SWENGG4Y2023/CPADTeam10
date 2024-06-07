package com.brodbill.transportssrc.dto.request;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class VehicleUpdateDto {
    private String vehicleNumber;
    private String vehicleType;
    private String vehicleModel;
    private String vehicleCapacity;
    private String vehicleRegistrationDate;
}
