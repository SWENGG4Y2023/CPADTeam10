package com.brodbill.transportssrc.model;

import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Admin.class)
public abstract class Admin_ {

	public static volatile SingularAttribute<Admin, ZonedDateTime> createdTime;
	public static volatile SingularAttribute<Admin, Integer> id;
	public static volatile SingularAttribute<Admin, Account> account;

	public static final String CREATED_TIME = "createdTime";
	public static final String ID = "id";
	public static final String ACCOUNT = "account";

}

