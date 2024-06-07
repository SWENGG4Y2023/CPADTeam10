package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.OrderStatus;
import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Orders.class)
public abstract class Orders_ {

	public static volatile SingularAttribute<Orders, Double> amountDue;
	public static volatile SingularAttribute<Orders, String> orderType;
	public static volatile SingularAttribute<Orders, String> referenceNumber;
	public static volatile SingularAttribute<Orders, OrderStatus> orderStatus;
	public static volatile SingularAttribute<Orders, Double> orderPrice;
	public static volatile SingularAttribute<Orders, Integer> id;
	public static volatile SingularAttribute<Orders, String> poaUpload;
	public static volatile SingularAttribute<Orders, ZonedDateTime> orderReceivedTime;
	public static volatile SingularAttribute<Orders, String> orderDescription;
	public static volatile SingularAttribute<Orders, Customer> customer;
	public static volatile SingularAttribute<Orders, Double> amountReceived;
	public static volatile ListAttribute<Orders, Payment> paymentList;

	public static final String AMOUNT_DUE = "amountDue";
	public static final String ORDER_TYPE = "orderType";
	public static final String REFERENCE_NUMBER = "referenceNumber";
	public static final String ORDER_STATUS = "orderStatus";
	public static final String ORDER_PRICE = "orderPrice";
	public static final String ID = "id";
	public static final String POA_UPLOAD = "poaUpload";
	public static final String ORDER_RECEIVED_TIME = "orderReceivedTime";
	public static final String ORDER_DESCRIPTION = "orderDescription";
	public static final String CUSTOMER = "customer";
	public static final String AMOUNT_RECEIVED = "amountReceived";
	public static final String PAYMENT_LIST = "paymentList";

}

