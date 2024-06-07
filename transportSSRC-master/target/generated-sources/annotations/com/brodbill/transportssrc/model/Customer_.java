package com.brodbill.transportssrc.model;

import com.brodbill.transportssrc.model.consts.CustomerType;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(Customer.class)
public abstract class Customer_ {

	public static volatile SingularAttribute<Customer, BankAccount> bankAccount;
	public static volatile SingularAttribute<Customer, String> gstNumber;
	public static volatile SingularAttribute<Customer, CustomerType> customerType;
	public static volatile SingularAttribute<Customer, String> address;
	public static volatile SingularAttribute<Customer, String> phone;
	public static volatile SingularAttribute<Customer, String> name;
	public static volatile SingularAttribute<Customer, Integer> id;
	public static volatile SingularAttribute<Customer, String> panNumber;
	public static volatile SingularAttribute<Customer, String> email;

	public static final String BANK_ACCOUNT = "bankAccount";
	public static final String GST_NUMBER = "gstNumber";
	public static final String CUSTOMER_TYPE = "customerType";
	public static final String ADDRESS = "address";
	public static final String PHONE = "phone";
	public static final String NAME = "name";
	public static final String ID = "id";
	public static final String PAN_NUMBER = "panNumber";
	public static final String EMAIL = "email";

}

