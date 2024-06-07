package com.brodbill.transportssrc.dto.request;

import com.brodbill.transportssrc.model.consts.AccountRole;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class AccountUpdateDto {
    private String name;
    private String email;
    private String phone;
    private List<AccountRole> roles;
}
