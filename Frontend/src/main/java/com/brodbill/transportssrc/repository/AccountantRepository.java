package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Account;
import com.brodbill.transportssrc.model.Accountant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountantRepository extends JpaRepository<Accountant, Integer> {
    Accountant findByAccountEmail(String email);

    Accountant findByAccount(Account account);
}
