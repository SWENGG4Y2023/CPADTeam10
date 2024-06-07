package com.brodbill.transportssrc.dto.request;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AdminRegisterDto {
    private String name;
    private String email;
    private String password;
    private String phone;
}
