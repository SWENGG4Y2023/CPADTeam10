package com.brodbill.transportssrc.services;

import com.brodbill.transportssrc.model.Account;
import com.brodbill.transportssrc.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.Principal;

@Service
public class AccountService {
    @Autowired
    AccountRepository accountRepository;

    public Account getAccountDetails(Principal principal) {
        return accountRepository.findByEmail(principal.getName());
    }

    public Boolean isAccountEnabled(Principal principal) {
        return accountRepository.findByEmail(principal.getName()).getIsActive();
    }
}
