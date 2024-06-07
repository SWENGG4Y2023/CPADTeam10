package com.brodbill.transportssrc.model;

import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Accountant.class)
public abstract class Accountant_ {

	public static volatile SingularAttribute<Accountant, BankAccount> bankAccount;
	public static volatile SingularAttribute<Accountant, ZonedDateTime> createdTime;
	public static volatile SingularAttribute<Accountant, Integer> id;
	public static volatile SingularAttribute<Accountant, Account> account;

	public static final String BANK_ACCOUNT = "bankAccount";
	public static final String CREATED_TIME = "createdTime";
	public static final String ID = "id";
	public static final String ACCOUNT = "account";

}

