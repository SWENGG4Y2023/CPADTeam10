package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.BankAccount;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BankAccountRepository extends JpaRepository<BankAccount, Integer> {}
