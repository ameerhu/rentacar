package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.EmailTransactionException;
import com.etekhno.rentacar.common.exceptions.ValidationException;
import com.etekhno.rentacar.config.ConfigProperties;
import com.etekhno.rentacar.domain.pojo.email.AbstractContext;
import com.etekhno.rentacar.services.IEmailService;
import com.mailersend.sdk.MailerSend;
import com.mailersend.sdk.MailerSendResponse;
import com.mailersend.sdk.emails.Email;
import com.mailersend.sdk.exceptions.MailerSendException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MailersendEmailServiceImpl implements IEmailService {

    @Autowired
    ConfigProperties configProperties;

    @Override
    public Object getMimeMessage(AbstractContext abstractContext) {
        Email email = new Email();
        email.setFrom(configProperties.getSenderName(), configProperties.getSenderEmail());
        email.addRecipient(abstractContext.getDisplayName(), abstractContext.getTo());
        email.setSubject(abstractContext.getSubject());

        if(abstractContext.getEmailText() == null || abstractContext.getEmailText().isBlank())
            throw new ValidationException(null, ValidationException.Error.EmailBodyNullError, "Email Text should not be null");

        email.setHtml(abstractContext.getEmailText());
        return email;
    }

    @Override
    public void sendEmail(Object message) {
        MailerSend ms = new MailerSend();
        ms.setToken(configProperties.getMailersendApiKey());
        MailerSendResponse msr = null;
        try {
            msr = ms.emails().send((Email) message);
            System.out.println("The messageId : " + msr.messageId);
        } catch (MailerSendException e) {
            throw new EmailTransactionException(e, EmailTransactionException.Error.MailersendEmailTransactionError,
                    String.format("Failed to transfer messageId: %s", msr.messageId));
        }
    }
}
