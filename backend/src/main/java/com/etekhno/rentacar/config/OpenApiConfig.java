package com.etekhno.rentacar.config;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import io.swagger.v3.core.converter.AnnotatedType;
import io.swagger.v3.core.converter.ModelConverters;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.media.Content;
import io.swagger.v3.oas.models.media.MediaType;
import io.swagger.v3.oas.models.responses.ApiResponse;
import io.swagger.v3.oas.models.responses.ApiResponses;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springdoc.core.customizers.OpenApiCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;

import java.util.Arrays;
import java.util.List;

@Configuration
public class OpenApiConfig {
    private List<String> publicController = Arrays.asList("/auth/**", "/config/**");

    private Content content = new Content()
            .addMediaType("application/json", new MediaType().schema(ModelConverters.getInstance()
                    .resolveAsResolvedSchema(new AnnotatedType(CustomException.ErrorDTO.class)).schema));

    private SecurityRequirement getSecurityRequirement() {
        return new SecurityRequirement().addList("JWT-Token");
    }

    private SecurityScheme getSecurityScheme() {
        return new SecurityScheme().scheme("bearer").type(SecurityScheme.Type.HTTP).bearerFormat("JWT");
    }

    private Info getInfo() {
        return new Info()
                .title("Rent A Car")
                .description("Rent A Car Restful Apis")
                .version("1.0")
                .termsOfService("Terms of service")
                .contact(new Contact().email("info@finestresume.com").url("www.finestresume.com").name("Usman Saeed"))
                .license(new License().name("Apache License Version 2.0").url("www.finestresume.com"));
    }

    @Bean
    public OpenAPI getOpenAPI() {
        return new OpenAPI()
                .info(getInfo())
                .schemaRequirement("JWT-Token", getSecurityScheme())
                .security(List.of(getSecurityRequirement()));
    }

    @Bean
    public OpenApiCustomizer openApiCustomizer() {
        return openApi -> openApi.getPaths().entrySet()
                .forEach(path -> {
                    path.getValue().readOperations().forEach(operation -> {
                        addApiResponse(operation.getResponses(), HttpStatus.BAD_REQUEST);
                        addApiResponse(operation.getResponses(), HttpStatus.NOT_FOUND);
                        addApiResponse(operation.getResponses(), HttpStatus.INTERNAL_SERVER_ERROR);

                        if (!isAPIOrControllerPublic(path.getKey()))
                            addApiResponse(operation.getResponses(), HttpStatus.UNAUTHORIZED);
                    });
                });
    }

    private ApiResponses addApiResponse(ApiResponses apiResponses, HttpStatus httpStatus) {
        ApiResponse apiResponse = new ApiResponse().description(httpStatus.getReasonPhrase()).content(content);
        return apiResponses.addApiResponse(String.valueOf(httpStatus.value()), apiResponse);
    }

    private Boolean isAPIOrControllerPublic(String path) {
        return publicController.stream().anyMatch(pc -> pc.endsWith("**")
                ? path.startsWith(pc.replace("**", ""))
                : path.equals(pc));
    }

}