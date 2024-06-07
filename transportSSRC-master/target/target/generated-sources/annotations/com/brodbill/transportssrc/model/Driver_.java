package com.brodbill.transportssrc.model;

import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Driver.class)
public abstract class Driver_ {

	public static volatile SingularAttribute<Driver, BankAccount> bankAccount;
	public static volatile SingularAttribute<Driver, String> licenseType;
	public static volatile SingularAttribute<Driver, ZonedDateTime> licenseIssueDate;
	public static volatile SingularAttribute<Driver, ZonedDateTime> licenseExpiryDate;
	public static volatile SingularAttribute<Driver, ZonedDateTime> createdTime;
	public static volatile SingularAttribute<Driver, String> licenseNumber;
	public static volatile SingularAttribute<Driver, Integer> id;
	public static volatile SingularAttribute<Driver, Account> account;

	public static final String BANK_ACCOUNT = "bankAccount";
	public static final String LICENSE_TYPE = "licenseType";
	public static final String LICENSE_ISSUE_DATE = "licenseIssueDate";
	public static final String LICENSE_EXPIRY_DATE = "licenseExpiryDate";
	public static final String CREATED_TIME = "createdTime";
	public static final String LICENSE_NUMBER = "licenseNumber";
	public static final String ID = "id";
	public static final String ACCOUNT = "account";

}

