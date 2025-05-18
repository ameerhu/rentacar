package com.etekhno.rentacar;

import com.etekhno.rentacar.config.ConfigProperties;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public abstract class AbstractIntegrationTest {

    @Autowired
    WebApplicationContext wac;
    @Autowired
    ConfigProperties config;
    @Autowired
    protected RequestHelper requestHelper;
    @Autowired
    protected DatabaseCleanup databaseCleanup;

    protected MockMvc mockMvc;
    protected String baseURL;

//    @BeforeAll
    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).apply(springSecurity()).build();
        requestHelper.mockMvc = mockMvc;
        baseURL = config.getBaseURL();
    }

    @AfterEach
//    @AfterAll
    void cleanUp() {
        mockMvc = null;
        baseURL = null;
        databaseCleanup.truncateTables();
    }

    public String getBaseURL() {
        return baseURL;
    }
}
