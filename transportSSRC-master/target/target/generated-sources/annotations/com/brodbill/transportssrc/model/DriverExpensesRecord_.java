package com.brodbill.transportssrc.model;

import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(DriverExpensesRecord.class)
public abstract class DriverExpensesRecord_ {

	public static volatile SingularAttribute<DriverExpensesRecord, Driver> driver;
	public static volatile ListAttribute<DriverExpensesRecord, String> paymentRecordData;
	public static volatile SingularAttribute<DriverExpensesRecord, ZonedDateTime> createdTime;
	public static volatile SingularAttribute<DriverExpensesRecord, Integer> id;

	public static final String DRIVER = "driver";
	public static final String PAYMENT_RECORD_DATA = "paymentRecordData";
	public static final String CREATED_TIME = "createdTime";
	public static final String ID = "id";

}

