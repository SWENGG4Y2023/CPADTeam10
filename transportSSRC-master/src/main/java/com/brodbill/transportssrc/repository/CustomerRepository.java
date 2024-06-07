package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerRepository  extends JpaRepository<Customer, Integer> {}
