package com.etekhno.rentacar.controller;

import com.etekhno.rentacar.RequestHelper;
import org.springframework.http.HttpStatus;

import static org.junit.jupiter.api.Assertions.assertNotNull;

public class ApiTestHelper {

    private final RequestHelper requestHelper;

    public ApiTestHelper(RequestHelper requestHelper) {
        this.requestHelper = requestHelper;
    }

    public <T> void testCreate(String url, T dto, HttpStatus expectedStatus, Class<?> responseClass) {
        requestHelper.postApi(url, dto);
        requestHelper.withHttpStatus(expectedStatus);
        Object response = requestHelper.getResponseDTO(responseClass);
        assertNotNull(response);
        //smjh nhi aa rha k aasert kese krun yahan
    }

    public <T> void testUpdate(String url, T dto, HttpStatus expectedStatus) {
        requestHelper.putApi(url, dto);
        requestHelper.withHttpStatus(expectedStatus);
    }
    public <T> void testGet(String url, T expectedDto, HttpStatus expectedStatus) {
        requestHelper.getApi(url, expectedDto);
        requestHelper.withHttpStatus(expectedStatus);

    }

    public void testDelete(String url, HttpStatus expectedStatus) {
        requestHelper.deleteApi(url, null);
        requestHelper.withHttpStatus(expectedStatus);
    }
}
