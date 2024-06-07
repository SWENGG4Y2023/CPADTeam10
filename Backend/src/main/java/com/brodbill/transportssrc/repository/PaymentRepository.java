package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository  extends JpaRepository<Payment, Integer> {}
