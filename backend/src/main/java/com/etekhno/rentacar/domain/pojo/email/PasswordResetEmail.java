package com.etekhno.rentacar.domain.pojo.email;

import com.etekhno.rentacar.common.exceptions.FileHandlingException;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import com.etekhno.rentacar.datamodel.Party;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;

@Getter
@Setter
public class PasswordResetEmail extends BaseAbstractEmailContext<Party> {
    private String OTPExpiryTime;

    public PasswordResetEmail(String baseURL, String senderEmail, String supportEmail, int OTPExpiryTime, String token, Party user) {
        super(baseURL, senderEmail, supportEmail, token, user);
        this.OTPExpiryTime = String.valueOf(OTPExpiryTime);
    }

    @Override
    public String updateEmailContent() {
        String emailTemp = super.updateEmailContent();
        emailTemp = emailTemp.replace("{{forget-password-link}}", getLink());
        emailTemp = emailTemp.replace("{{otp}}", getToken());
        emailTemp = emailTemp.replace("{{rentacar.otp_expiry_mints}}", getOTPExpiryTime());
        setEmailText(emailTemp);
        return emailTemp;
    }

    @Override
    public CustomException getException(IOException ioe) {
        return new FileHandlingException(ioe, FileHandlingException.Error.EmailTemplateNotFoundError,
                " Password Reset template not found");
    }

    @Override
    public String generateLink() {
        return buildForgetPasswordUrl();
    }

    private String buildForgetPasswordUrl(){
        return UriComponentsBuilder.fromHttpUrl(getBaseURL())
                .path("/auth/updatePassword")
                .queryParam("otp", getToken())
                .queryParam("email", getTo())
                .toUriString();
    }
}
