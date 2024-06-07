package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.TripStatus;
import com.brodbill.transportssrc.model.consts.TripType;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
public class Trip {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private ZonedDateTime startTime;

    private ZonedDateTime endTime;

    private String startLocation;

    private String endLocation;

    @OneToOne
    private Driver driver;

    @OneToOne
    private Vehicle vehicle;

    @OneToOne
    private Orders order;

    @OneToMany
    private List<DriverExpensesRecord> driverExpensesRecordList = new ArrayList<>();

    private TripType tripType;

    private Double tripExpenses;

    private Double tripRevenue;

    private TripStatus tripStatus;

    private String tripNotes;

}
