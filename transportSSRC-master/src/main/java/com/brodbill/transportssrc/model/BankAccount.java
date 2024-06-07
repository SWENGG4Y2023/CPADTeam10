package com.brodbill.transportssrc.model;

import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Data
@NoArgsConstructor
public class BankAccount {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @NotNull(message = "Account number should not be null")
    @Column(unique = true)
    private Long AccountNumber;

    private String BankName;

    private String AccountType;

    private String IFSCCode;

    private String BeneficiaryName;
}
