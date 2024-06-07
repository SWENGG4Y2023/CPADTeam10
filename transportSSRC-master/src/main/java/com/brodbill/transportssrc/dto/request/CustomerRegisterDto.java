package com.brodbill.transportssrc.dto.request;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CustomerRegisterDto {
    private String name;
    private String address;
    private String phone;
    private String email;
    private String gstNumber;
    private String panNumber;
    private String customerType;
    private Long bankAccountNumber;
    private String bankAccountType;
    private String beneficiaryName;
    private String bankName;
    private String bankBranch;
    private String bankIfsc;
}
