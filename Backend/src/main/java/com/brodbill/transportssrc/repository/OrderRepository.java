package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Orders;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository  extends JpaRepository<Orders, Integer> {}
