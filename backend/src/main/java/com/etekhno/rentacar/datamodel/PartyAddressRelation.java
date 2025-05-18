package com.etekhno.rentacar.datamodel;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PartyAddressRelation extends BasicAuditingEntity {
    @Id
    private String partyId;
    private String addressId;
}
