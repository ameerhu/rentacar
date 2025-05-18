package com.etekhno.rentacar.domain.pojo.email;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import com.etekhno.rentacar.datamodel.Party;
import lombok.Getter;
import lombok.Setter;
import org.springframework.util.ResourceUtils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@Setter
@Getter
public abstract class BaseAbstractEmailContext<T> extends AbstractContext {
    private String token;
    private String baseURL;

    BaseAbstractEmailContext(String baseURL, String senderEmail, String supportEmail, Party user) {
        this(baseURL, senderEmail, supportEmail, null, user);
    }

    BaseAbstractEmailContext(String baseURL, String senderEmail, String supportEmail, String token, Party user) {
        setBaseURL(baseURL);
        setFrom(senderEmail);
        setToken(token);
        setSupportEmail(supportEmail);
        setTo(user.getEmail());
        setDisplayName(user.getFirstName());
    }

    /**
     * @Param fileName
     * The method will load the email template from resources
     * */
    public String loadEmailTemplate(String fileName) throws IOException {
        File file = ResourceUtils.getFile(String.format("classpath:template/%s",fileName));
        String content = new String(Files.readAllBytes(file.toPath()));
        return content;
    }

    public String loadEmailTemplateOrThrowException() {
        try {
            return loadEmailTemplate(getTemplateLocation());
        } catch (IOException e) {
            throw getException(e);
        }
    }

    public void init(String emailSubject, String templateLocation) {
        setSubject(emailSubject);
        setTemplateLocation(templateLocation);
        setLink(generateLink());
    }

    public String updateEmailContent() {
        String emailTemp = loadEmailTemplateOrThrowException();
        emailTemp = emailTemp.replace("{{recipient-name}}", getDisplayName());
        return emailTemp.replace("{{support-email}}", getSupportEmail());
    }

    public abstract CustomException getException(IOException ioe);
    public abstract String generateLink();
}
