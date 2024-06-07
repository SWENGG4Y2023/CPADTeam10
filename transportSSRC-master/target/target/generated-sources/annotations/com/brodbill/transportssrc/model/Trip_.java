package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.TripStatus;
import com.brodbill.transportssrc.model.consts.TripType;
import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Trip.class)
public abstract class Trip_ {

	public static volatile ListAttribute<Trip, DriverExpensesRecord> driverExpensesRecordList;
	public static volatile SingularAttribute<Trip, Double> tripExpenses;
	public static volatile SingularAttribute<Trip, Double> tripRevenue;
	public static volatile SingularAttribute<Trip, String> tripNotes;
	public static volatile SingularAttribute<Trip, Vehicle> vehicle;
	public static volatile SingularAttribute<Trip, TripType> tripType;
	public static volatile SingularAttribute<Trip, String> startLocation;
	public static volatile SingularAttribute<Trip, Driver> driver;
	public static volatile SingularAttribute<Trip, ZonedDateTime> startTime;
	public static volatile SingularAttribute<Trip, Integer> id;
	public static volatile SingularAttribute<Trip, ZonedDateTime> endTime;
	public static volatile SingularAttribute<Trip, String> endLocation;
	public static volatile SingularAttribute<Trip, Orders> order;
	public static volatile SingularAttribute<Trip, TripStatus> tripStatus;

	public static final String DRIVER_EXPENSES_RECORD_LIST = "driverExpensesRecordList";
	public static final String TRIP_EXPENSES = "tripExpenses";
	public static final String TRIP_REVENUE = "tripRevenue";
	public static final String TRIP_NOTES = "tripNotes";
	public static final String VEHICLE = "vehicle";
	public static final String TRIP_TYPE = "tripType";
	public static final String START_LOCATION = "startLocation";
	public static final String DRIVER = "driver";
	public static final String START_TIME = "startTime";
	public static final String ID = "id";
	public static final String END_TIME = "endTime";
	public static final String END_LOCATION = "endLocation";
	public static final String ORDER = "order";
	public static final String TRIP_STATUS = "tripStatus";

}

