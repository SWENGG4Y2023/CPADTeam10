package com.brodbill.transportssrc.dto.request;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AccountPasswordUpdateDto {
    private String email;
    private String oldPassword;
    private String newPassword;
}
