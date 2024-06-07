package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountRepository extends JpaRepository<Account, Integer> {
    Account findByEmail(String email);
}
