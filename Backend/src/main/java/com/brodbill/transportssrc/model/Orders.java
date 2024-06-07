package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.OrderStatus;
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
public class Orders {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private Double orderPrice;

    @OneToOne
    private Customer customer;

    private OrderStatus orderStatus;

    @CreationTimestamp
    private ZonedDateTime orderReceivedTime;

    private Double amountReceived;

    private Double amountDue;

    private String orderType;

    private String orderDescription;

    @Column(unique = true)
    private String referenceNumber;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Payment> paymentList = new ArrayList<>();

    private String poaUpload;
}
