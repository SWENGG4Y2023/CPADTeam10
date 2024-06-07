package com.brodbill.transportssrc.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Data
@NoArgsConstructor
public class Accountant {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @OneToOne
    private Account account;

    @CreationTimestamp
    private ZonedDateTime createdTime;

    @OneToOne
    private BankAccount bankAccount;
}
