package com.etekhno.rentacar.datamodel;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Setter
@Getter
@NoArgsConstructor
public class UserCredential extends BasicAuditingEntity {
    @Id
    String partyId;
    int loginAttempt;
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    String password;
}
