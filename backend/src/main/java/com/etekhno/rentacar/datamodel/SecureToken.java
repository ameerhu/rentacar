package com.etekhno.rentacar.datamodel;

import com.etekhno.rentacar.common.utils.DateHelper;
import com.etekhno.rentacar.datamodel.converter.EmailTypeConverter;
import com.etekhno.rentacar.datamodel.enums.EmailType;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.GenericGenerator;

import java.util.Date;

@Entity
@Getter
@Setter
public class SecureToken {
    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid",strategy = "uuid2")
    private String id;
    private String token;
    private Date timestamp;
    private Date expireAt;
    private String userId;
    private boolean isExpired;
    @Convert(converter = EmailTypeConverter.class)
    private EmailType emailType;

    public boolean isExpired() {
        return getExpireAt().before(DateHelper.getCurrentDate());
    }
}
