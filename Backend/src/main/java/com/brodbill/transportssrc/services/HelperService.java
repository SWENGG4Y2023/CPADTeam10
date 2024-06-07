package com.brodbill.transportssrc.services;

import com.brodbill.transportssrc.dto.request.AdminRegisterDto;
import com.brodbill.transportssrc.model.Account;
import com.brodbill.transportssrc.model.Admin;
import com.brodbill.transportssrc.model.consts.AccountRole;
import com.brodbill.transportssrc.repository.AccountRepository;
import com.brodbill.transportssrc.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HelperService {

    @Autowired
    AccountRepository accountRepository;
    @Autowired
    AdminRepository adminRepository;
    @Autowired
    PasswordEncoder passwordEncoder;
    public Boolean createAdmin(AdminRegisterDto adminRegisterDto) {
        Admin admin = new Admin();
        Account account = new Account();
        account.setName(adminRegisterDto.getName());
        account.setEmail(adminRegisterDto.getEmail());
        account.setPassword(passwordEncoder.encode(adminRegisterDto.getPassword()));
        account.setPhone(adminRegisterDto.getPhone());
        account.setRoles(List.of(AccountRole.ROLE_ADMIN));
        account.setIsActive(true);
        accountRepository.save(account);
        admin.setAccount(account);
        adminRepository.save(admin);
        return true;
    }
}
