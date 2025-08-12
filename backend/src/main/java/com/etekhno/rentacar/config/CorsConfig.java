package com.etekhno.rentacar.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("http://localhost:3000", "http://localhost:8080", "*") // Allow frontend
                        .allowedMethods("GET", "POST", "PUT", "DELETE")
                        .allowedHeaders("*")
                        .allowCredentials(false);
            }

            @Override
            public void addResourceHandlers(ResourceHandlerRegistry registry) {
                registry
                        .addResourceHandler("/**")
                        .addResourceLocations("classpath:/static/");
            }

            @Override
            public void configureViewResolvers(ViewResolverRegistry registry) {
                registry.enableContentNegotiation();
            }
        };
    }
}
