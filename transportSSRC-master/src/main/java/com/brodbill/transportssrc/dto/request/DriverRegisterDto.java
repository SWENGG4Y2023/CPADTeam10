package com.brodbill.transportssrc.dto.request;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.ZonedDateTime;

@Data
@NoArgsConstructor
public class DriverRegisterDto {
    private String name;
    private String email;
    private String password;
    private String phone;
    private String licenseNumber;
    private String licenseType;
    private ZonedDateTime licenseExpiryDate;
    private ZonedDateTime licenseIssueDate;
    private String bankName;
    private Long bankAccountNumber;
    private String bankAccountType;
    private String bankIFSCCode;
    private String bankBeneficiaryName;
}
