package com.brodbill.transportssrc.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
public class DriverExpensesRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @OneToOne
    private Driver driver;

    @CreationTimestamp
    private ZonedDateTime createdTime;

    @ElementCollection
    private List<String> paymentRecordData = new ArrayList<>();
}
