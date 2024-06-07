package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.PaymentMethod;
import com.brodbill.transportssrc.model.consts.PaymentStatus;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Data
@NoArgsConstructor
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    @Column(unique = true)
    private String referenceNumber;

    private PaymentMethod paymentMethod;

    private PaymentStatus paymentStatus;

    private ZonedDateTime paymentDate;

    private String paymentAmount;
}
