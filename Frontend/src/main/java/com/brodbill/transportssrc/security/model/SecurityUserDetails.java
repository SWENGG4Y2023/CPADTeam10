package com.brodbill.transportssrc.security.model;

import com.brodbill.transportssrc.model.Account;
import com.brodbill.transportssrc.model.consts.AccountRole;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class SecurityUserDetails implements UserDetails {
    private String username;
    private String password;
    private Boolean active;
    private List<GrantedAuthority> authorityList;

    public SecurityUserDetails(Account account) {
        this.username = account.getEmail();
        this.password = account.getPassword();
        this.active = account.getIsActive();
        List<AccountRole> accountRoles = account.getRoles();
        this.authorityList = new ArrayList<>();
        for (AccountRole role : accountRoles) {
            authorityList.add(new SimpleGrantedAuthority(role.toString()));
        }
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorityList;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return active;
    }

    @Override
    public boolean isAccountNonLocked() {
        return active;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return active;
    }

    @Override
    public boolean isEnabled() {
        return active;
    }
}
