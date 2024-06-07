package com.brodbill.transportssrc.controller;

import com.brodbill.transportssrc.dto.request.AdminRegisterDto;
import com.brodbill.transportssrc.services.HelperService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/helper")
@CrossOrigin
public class HelperController {

    @Autowired
    HelperService helperService;

    @PostMapping("/createAdmin")
    public ResponseEntity<?> createAdmin(@RequestBody AdminRegisterDto adminRegisterDto) throws Exception {
        return new ResponseEntity<>(helperService.createAdmin(adminRegisterDto), HttpStatus.OK);
    }


}
