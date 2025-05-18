package com.etekhno.rentacar.controller;

import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SecurityRequirements
@RequestMapping("/config")
@RestController
public class ConfigController {

    @GetMapping("/health")
    public String getHealth() {
        return "<div style='margin:auto; width:60%; border:3px solid #73AD21; padding:10px; text-align:center;'>" +
                " <h1>Congratulation</h1> <h3>Etekhno</h3> from <h4><i>Rent A Car</i></h4>" +
                "</div>";
    }

}
