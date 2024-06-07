package com.brodbill.transportssrc.controller;

import com.brodbill.transportssrc.dto.request.*;
import com.brodbill.transportssrc.services.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin")
@CrossOrigin
public class AdminController {

    @Autowired
    AdminService adminService;

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllUsers")
    public ResponseEntity<?> getAllUsers() throws Exception {
        return new ResponseEntity<>(adminService.getAllUsers(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllAdmins")
    public ResponseEntity<?> getAllAdmins() throws Exception {
        return new ResponseEntity<>(adminService.getAllAdmins(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllDrivers")
    public ResponseEntity<?> getAllDrivers() throws Exception {
        return new ResponseEntity<>(adminService.getAllDrivers(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllAccountants")
    public ResponseEntity<?> getAllAccountants() throws Exception {
        return new ResponseEntity<>(adminService.getAllAccountants(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllCustomers")
    public ResponseEntity<?> getAllCustomers() throws Exception {
        return new ResponseEntity<>(adminService.getAllCustomers(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllVehicles")
    public ResponseEntity<?> getAllVehicles() throws Exception {
        return new ResponseEntity<>(adminService.getAllVehicles(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllOrders")
    public ResponseEntity<?> getAllOrders() throws Exception {
        return new ResponseEntity<>(adminService.getAllOrders(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @GetMapping("/getAllTrips")
    public ResponseEntity<?> getAllTrips() throws Exception {
        return new ResponseEntity<>(adminService.getAllTrips(), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PostMapping("/changeAccountStatus")
    public ResponseEntity<?> changeAccountStatus(String email, Boolean isEnabled) throws Exception {
        return new ResponseEntity<>(adminService.changeAccountStatus(email, isEnabled), HttpStatus.OK);
    }
    @Secured("ROLE_ADMIN")
    @PutMapping("/updateAccount")
    public ResponseEntity<?> updateAccount(@RequestBody AccountUpdateDto accountUpdateDto) throws Exception {
        return new ResponseEntity<>(adminService.updateAccount(accountUpdateDto), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @DeleteMapping("/deleteUserAccount")
    public ResponseEntity<?> deleteUserAccount(String email) throws Exception {
        return new ResponseEntity<>(adminService.deleteUserAccount(email), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PutMapping("/changeAccountPassword")
    public ResponseEntity<?> changeAccountPassword(@RequestBody AccountPasswordUpdateDto accountPasswordUpdateDto) throws Exception {
        return new ResponseEntity<>(adminService.changeAccountPassword(accountPasswordUpdateDto), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PostMapping("/createAdmin")
    public ResponseEntity<?> createAdmin(@RequestBody AdminRegisterDto adminRegisterDto) throws Exception {
        return new ResponseEntity<>(adminService.createAdmin(adminRegisterDto), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PostMapping("/createDriver")
    public ResponseEntity<?> createDriver(@RequestBody DriverRegisterDto driverRegisterDto) throws Exception {
        return new ResponseEntity<>(adminService.createDriver(driverRegisterDto), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PostMapping("/createAccountant")
    public ResponseEntity<?> createAccountant(@RequestBody AccountantRegisterDto accountantRegisterDto) throws Exception {
        return new ResponseEntity<>(adminService.createAccountant(accountantRegisterDto), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PostMapping("/createVehicle")
    public ResponseEntity<?> createVehicle(@RequestBody VehicleRegisterDto vehicleRegisterDto) throws Exception {
        return new ResponseEntity<>(adminService.createVehicle(vehicleRegisterDto), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PutMapping("/updateVehicle")
    public ResponseEntity<?> updateVehicle(@RequestBody VehicleUpdateDto vehicleUpdateDto) throws Exception {
        return new ResponseEntity<>(adminService.updateVehicle(vehicleUpdateDto), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @DeleteMapping("/deleteVehicle")
    public ResponseEntity<?> deleteVehicle(String vehicleNumber) throws Exception {
        return new ResponseEntity<>(adminService.deleteVehicle(vehicleNumber), HttpStatus.OK);
    }

    @Secured("ROLE_ADMIN")
    @PostMapping("/createCustomer")
    public ResponseEntity<?> createCustomer(@RequestBody CustomerRegisterDto customerRegisterDto) throws Exception {
        return new ResponseEntity<>(adminService.createCustomer(customerRegisterDto), HttpStatus.OK);
    }
}
