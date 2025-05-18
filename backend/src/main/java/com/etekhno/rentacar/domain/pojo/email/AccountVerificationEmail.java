package com.etekhno.rentacar.domain.pojo.email;

import com.etekhno.rentacar.common.exceptions.FileHandlingException;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import com.etekhno.rentacar.datamodel.Party;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;


public class AccountVerificationEmail extends BaseAbstractEmailContext<Party> {

    public AccountVerificationEmail(String baseURL, String senderEmail, String supportEmail, String token, Party user) {
        super(baseURL, senderEmail, supportEmail, token, user);
    }

    /*
    For a time being, the template is specific to Verification email.
        Enhance the code and put into context.
        Thus, the template will be load based on context
        i.e. verification template for verification, reset password template for reset password.
        shifted the template
    */
    @Override
    public String updateEmailContent() {
        String emailTemp = super.updateEmailContent();
        emailTemp = emailTemp.replace("{{verification-link}}", getLink());
        setEmailText(emailTemp);
        return emailTemp;
    }

    @Override
    public CustomException getException(IOException ioe) {
        return new FileHandlingException(ioe, FileHandlingException.Error.EmailTemplateNotFoundError,
                " Account Verification template not found");
    }

    @Override
    public String generateLink() {
        return buildVerificationUrl();
    }

    private String buildVerificationUrl(){
        return UriComponentsBuilder.fromHttpUrl(getBaseURL())
                .path("/auth/verify")
                .queryParam("token", getToken())
                .queryParam("email", getTo()).toUriString();
    }

}
