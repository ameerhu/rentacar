package com.etekhno.rentacar.services;

import com.google.zxing.WriterException;

import java.io.IOException;

public interface IQRCodeService {
    byte[] generate(String resumeId) throws WriterException, IOException;
}
