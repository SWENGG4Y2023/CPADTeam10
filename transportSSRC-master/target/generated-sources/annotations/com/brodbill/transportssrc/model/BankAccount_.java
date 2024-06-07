package com.brodbill.transportssrc.model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value = "org.hibernate.jpamodelgen.JPAMetaModelEntityProcessor")
@StaticMetamodel(BankAccount.class)
public abstract class BankAccount_ {

	public static volatile SingularAttribute<BankAccount, String> BankName;
	public static volatile SingularAttribute<BankAccount, String> IFSCCode;
	public static volatile SingularAttribute<BankAccount, String> BeneficiaryName;
	public static volatile SingularAttribute<BankAccount, Integer> id;
	public static volatile SingularAttribute<BankAccount, String> AccountType;
	public static volatile SingularAttribute<BankAccount, Long> AccountNumber;

	public static final String BANK_NAME = "BankName";
	public static final String I_FS_CCODE = "IFSCCode";
	public static final String BENEFICIARY_NAME = "BeneficiaryName";
	public static final String ID = "id";
	public static final String ACCOUNT_TYPE = "AccountType";
	public static final String ACCOUNT_NUMBER = "AccountNumber";

}

