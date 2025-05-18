package com.etekhno.rentacar.domain.pojo.email;

import com.etekhno.rentacar.common.exceptions.FileHandlingException;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import com.etekhno.rentacar.datamodel.Party;

import java.io.IOException;

public class PasswordUpdateSuccessEmail extends BaseAbstractEmailContext<Party> {

    public PasswordUpdateSuccessEmail(String baseURL, String senderEmail, String supportEmail, Party user) {
        super(baseURL, senderEmail, supportEmail, user);
    }

    @Override
    public String updateEmailContent() {
        String emailTemp = super.updateEmailContent();
        setEmailText(emailTemp);
        return emailTemp;
    }

    @Override
    public CustomException getException(IOException ioe) {
        return new FileHandlingException(ioe, FileHandlingException.Error.EmailTemplateNotFoundError,
                " Password Update Successful template not found");
    }

    @Override
    public String generateLink() {
        return null;
    }
}
