package com.etekhno.rentacar.datamodel;


import jakarta.persistence.PrePersist;

public class BasicAuditingEntityListener {

    @PrePersist
    private void beforePersist(){}
}
