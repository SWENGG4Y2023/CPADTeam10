package com.brodbill.transportssrc.model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Vehicle.class)
public abstract class Vehicle_ {

	public static volatile SingularAttribute<Vehicle, String> vehicleCapacity;
	public static volatile SingularAttribute<Vehicle, String> vehicleRegistrationDate;
	public static volatile SingularAttribute<Vehicle, String> vehicleNumber;
	public static volatile SingularAttribute<Vehicle, String> vehicleModel;
	public static volatile SingularAttribute<Vehicle, Integer> id;
	public static volatile SingularAttribute<Vehicle, String> vehicleType;

	public static final String VEHICLE_CAPACITY = "vehicleCapacity";
	public static final String VEHICLE_REGISTRATION_DATE = "vehicleRegistrationDate";
	public static final String VEHICLE_NUMBER = "vehicleNumber";
	public static final String VEHICLE_MODEL = "vehicleModel";
	public static final String ID = "id";
	public static final String VEHICLE_TYPE = "vehicleType";

}

