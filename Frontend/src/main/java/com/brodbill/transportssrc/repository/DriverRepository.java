package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Account;
import com.brodbill.transportssrc.model.Driver;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DriverRepository extends JpaRepository<Driver, Integer> {
    Driver findByAccountEmail(String email);

    Driver findByAccount(Account account);
}
