package com.brodbill.transportssrc.repository;

import com.brodbill.transportssrc.model.Trip;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TripRepository  extends JpaRepository<Trip, Integer> {}
