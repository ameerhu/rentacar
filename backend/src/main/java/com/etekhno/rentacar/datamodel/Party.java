package com.etekhno.rentacar.datamodel;

import com.etekhno.rentacar.datamodel.converter.GenderConverter;
import com.etekhno.rentacar.datamodel.enums.Gender;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.GenericGenerator;

import java.util.Date;

@Setter
@Getter
@Entity
@NoArgsConstructor
public class Party extends BasicAuditingEntity{
    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid2")
    String id;
    String firstName;
    String lastName;
    String cnic;
    String email;
    @Convert(converter = GenderConverter.class)
    Gender gender;
    Boolean deleted;
    Boolean locked = false;
    Date lockedTime;
    Boolean accountVerified;
    byte[] profilePicture;
    String phoneNumber;
    String timezone;
    String locale;
}
