package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.CustomerType;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Data
@NoArgsConstructor
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private String name;

    private String address;

    private String phone;

    private String email;

    @Column(unique = true)
    private String gstNumber;

    private String panNumber;

    @Enumerated(EnumType.STRING)
    private CustomerType customerType;

    @OneToOne
    private BankAccount bankAccount;
}
