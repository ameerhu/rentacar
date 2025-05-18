package com.etekhno.rentacar.services.impl;


import com.etekhno.rentacar.common.exceptions.ValidationException;
import com.etekhno.rentacar.domain.pojo.email.AbstractContext;
import com.etekhno.rentacar.services.IEmailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;

@Service
@Profile("Temp")
public class EmailServiceImpl implements IEmailService {

    @Autowired
    private JavaMailSender emailSender;

    @Override
    public Object getMimeMessage(AbstractContext abstractContext) {
        MimeMessage message = emailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = null;

        if(abstractContext.getEmailText() == null || abstractContext.getEmailText().isBlank())
            throw new ValidationException(null, ValidationException.Error.EmailBodyNullError, "Email Text should not be null");

        try {
            mimeMessageHelper = new MimeMessageHelper(message,
                    MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
                    StandardCharsets.UTF_8.name());
            mimeMessageHelper.setTo(abstractContext.getTo());
            mimeMessageHelper.setSubject(abstractContext.getSubject());
            mimeMessageHelper.setFrom(abstractContext.getFrom());
            mimeMessageHelper.setText(abstractContext.getEmailText(), true);
        } catch (MessagingException e) {
            e.printStackTrace();
        }

        return message;
    }

    public void sendEmail(Object message) {
        emailSender.send((MimeMessage) message);
    }

}
