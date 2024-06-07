package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.PaymentMethod;
import com.brodbill.transportssrc.model.consts.PaymentStatus;
import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Payment.class)
public abstract class Payment_ {

	public static volatile SingularAttribute<Payment, String> referenceNumber;
	public static volatile SingularAttribute<Payment, PaymentMethod> paymentMethod;
	public static volatile SingularAttribute<Payment, Integer> id;
	public static volatile SingularAttribute<Payment, ZonedDateTime> paymentDate;
	public static volatile SingularAttribute<Payment, String> paymentAmount;
	public static volatile SingularAttribute<Payment, PaymentStatus> paymentStatus;

	public static final String REFERENCE_NUMBER = "referenceNumber";
	public static final String PAYMENT_METHOD = "paymentMethod";
	public static final String ID = "id";
	public static final String PAYMENT_DATE = "paymentDate";
	public static final String PAYMENT_AMOUNT = "paymentAmount";
	public static final String PAYMENT_STATUS = "paymentStatus";

}

