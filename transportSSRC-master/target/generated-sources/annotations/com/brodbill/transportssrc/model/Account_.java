package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.AccountRole;
import java.time.ZonedDateTime;
import javax.annotation.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Account.class)
public abstract class Account_ {

	public static volatile SingularAttribute<Account, String> password;
	public static volatile SingularAttribute<Account, String> phone;
	public static volatile ListAttribute<Account, AccountRole> roles;
	public static volatile SingularAttribute<Account, String> name;
	public static volatile SingularAttribute<Account, ZonedDateTime> createdTime;
	public static volatile SingularAttribute<Account, Integer> id;
	public static volatile SingularAttribute<Account, Boolean> isActive;
	public static volatile SingularAttribute<Account, String> email;

	public static final String PASSWORD = "password";
	public static final String PHONE = "phone";
	public static final String ROLES = "roles";
	public static final String NAME = "name";
	public static final String CREATED_TIME = "createdTime";
	public static final String ID = "id";
	public static final String IS_ACTIVE = "isActive";
	public static final String EMAIL = "email";

}

