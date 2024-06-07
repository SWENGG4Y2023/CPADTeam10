package com.brodbill.transportssrc.controller;

import com.brodbill.transportssrc.services.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/account")
@CrossOrigin
public class AccountController {

    @Autowired
    AccountService accountService;

    @GetMapping("/getAccountDetails")
    public ResponseEntity<?> getAccountDetails(Principal principal) throws Exception {
        return new ResponseEntity<>(accountService.getAccountDetails(principal), HttpStatus.OK);
    }

    @GetMapping("/isAccountEnabled")
    public ResponseEntity<?> isAccountEnabled(Principal principal) throws Exception {
        return new ResponseEntity<>(accountService.isAccountEnabled(principal), HttpStatus.OK);
    }

}
