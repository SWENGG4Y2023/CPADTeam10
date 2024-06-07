package com.brodbill.transportssrc.security.service;

import com.brodbill.transportssrc.model.Account;
import com.brodbill.transportssrc.repository.AccountRepository;
import com.brodbill.transportssrc.security.model.SecurityUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class SecurityUserDetailsService implements UserDetailsService {

    @Autowired
    AccountRepository accountRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<Account> accountOptional = Optional.ofNullable(accountRepository.findByEmail(username));
        accountOptional.orElseThrow(() -> new UsernameNotFoundException("No User Found"));
        return accountOptional.map(SecurityUserDetails::new).get();
    }
}
