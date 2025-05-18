package com.etekhno.rentacar.services;

import com.etekhno.rentacar.domain.pojo.email.AbstractContext;

public interface IEmailService {
    Object getMimeMessage(AbstractContext abstractContext);
    void sendEmail(Object message);
}
