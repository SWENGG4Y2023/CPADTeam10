package com.brodbill.transportssrc.model;

import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Data
@NoArgsConstructor
public class Vehicle {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @NotNull(message = "Vehicle number should not be null")
    @Column(unique = true)
    private String vehicleNumber;

    private String vehicleType;

    private String vehicleModel;

    private String vehicleCapacity;

    private String vehicleRegistrationDate;
}
