package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Account;
import com.brodbill.transportssrc.model.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminRepository extends JpaRepository<Admin, Integer> {
    Admin findByAccountEmail(String email);

    Admin findByAccount(Account account);
}

