package com.brodbill.transportssrc.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Data
@NoArgsConstructor
public class Driver {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @Column(unique = true)
    private String licenseNumber;

    private String licenseType;

    private ZonedDateTime licenseExpiryDate;

    private ZonedDateTime licenseIssueDate;

    @OneToOne
    private Account account;

    @OneToOne
    private BankAccount bankAccount;

    @CreationTimestamp
    private ZonedDateTime createdTime;
}
