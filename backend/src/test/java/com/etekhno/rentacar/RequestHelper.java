package com.etekhno.rentacar;

import com.etekhno.rentacar.common.exceptions.superClasses.CustomError;
import com.etekhno.rentacar.common.exceptions.superClasses.CustomException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;

@Component
@ActiveProfiles("test")
public class RequestHelper {

    final String CONTEXT_PATH = "/api/v1";
    MockMvc mockMvc;
    MvcResult mvcResult;
    ObjectMapper om = new ObjectMapper();

    RequestHelper() {
        om.configure(SerializationFeature.WRAP_ROOT_VALUE, false);
        om.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }
    public <T> RequestHelper postApi(String url, T data) {
        try {
            String requestJson=om.writeValueAsString(data);

            mvcResult = mockMvc.perform(post("/api/v1" + url)
                    .contextPath(CONTEXT_PATH)
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(requestJson))
                    .andReturn();
        } catch (Exception e) {
            throw new RuntimeException(String.format("%s Api exception", url), e);
        }
        return this;
    }
    public <T> RequestHelper putApi(String url, T data) {
        try {
            String requestJson=om.writeValueAsString(data);

            mvcResult = mockMvc.perform(put("/api/v1" + url)
                            .contextPath(CONTEXT_PATH)
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(requestJson))
                    .andReturn();
        } catch (Exception e) {
            throw new RuntimeException(String.format("%s Api exception", url), e);
        }
        return this;
    }
    public <T> RequestHelper getApi(String url, T data) {
        try {
            String requestJson=om.writeValueAsString(data);

            mvcResult = mockMvc.perform(get("/api/v1" + url)
                            .contextPath(CONTEXT_PATH)
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(requestJson))
                    .andReturn();
        } catch (Exception e) {
            throw new RuntimeException(String.format("%s Api exception", url), e);
        }
        return this;
    }
    public <T> RequestHelper deleteApi(String url, T data) {
        try {
            String requestJson=om.writeValueAsString(data);

            mvcResult = mockMvc.perform(delete("/api/v1" + url)
                            .contextPath(CONTEXT_PATH)
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(requestJson))
                    .andReturn();
        } catch (Exception e) {
            throw new RuntimeException(String.format("%s Api exception", url), e);
        }
        return this;
    }

    public MvcResult getMvcResult() {
        return mvcResult;
    }

    public RequestHelper withHttpStatus(HttpStatus status) {
        assertEquals(status.value(), mvcResult.getResponse().getStatus());
        return this;
    }

    public RequestHelper withErrorCode(CustomError ce) {
        if(CustomException.class.isAssignableFrom(mvcResult.getResolvedException().getClass())) {
            CustomException actualCE = (CustomException) mvcResult.getResolvedException();
            assertEquals(ce.getErrorCode(), actualCE.getErrorDTO().getErrorCode());
            return this;
        }
        throw new RuntimeException(mvcResult.getResolvedException());
    }

    public <T> T getResponseDTO(Class<T> type) {
        try {
            return om.readValue(mvcResult.getResponse().getContentAsByteArray(), type);
        } catch (IOException e) {
            throw new RuntimeException("JSON to POJO", e);
        }
    }
}
