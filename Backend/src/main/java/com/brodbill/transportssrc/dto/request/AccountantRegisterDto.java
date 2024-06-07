package com.brodbill.transportssrc.dto.request;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AccountantRegisterDto {
    private String name;
    private String email;
    private String password;
    private String phone;
    private String bankName;
    private Long bankAccountNumber;
    private String bankAccountType;
    private String bankIFSCCode;
    private String bankBeneficiaryName;
}
