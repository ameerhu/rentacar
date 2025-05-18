package com.etekhno.rentacar.domain.pojo.email;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public abstract class AbstractContext {
    private String from;
    private String to;
    private String subject;
    private String link;
    private String attachment;
    private String fromDisplayName;
    private String emailLanguage;
    private String displayName;
    private String templateLocation;
    private String emailText;
    private String supportEmail;
    private Map<String, Object> context;
}
