package com.etekhno.rentacar.services.impl;

import com.etekhno.rentacar.common.exceptions.EntityNotFoundException;
import com.etekhno.rentacar.config.ConfigProperties;
import com.etekhno.rentacar.datamodel.UserCredential;
import com.etekhno.rentacar.services.IQRCodeService;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Optional;

@Service
public class QRCodeServiceImpl implements IQRCodeService {
    @Autowired
    private ConfigProperties configProperties;

    @Override
    public byte[] generate(String resumeId) throws WriterException, IOException {
        Optional<UserCredential> opResume = Optional.empty();
//        = resumeRepo.findById(resumeId);
        if (opResume.isEmpty())
            throw new EntityNotFoundException(null, EntityNotFoundException.Error.CustomerNotFoundError,
                    "Resume id doesn't exist");

        String pngdata = "";
//        pngdata= opResume.get().getBarCodeImage();

        if (pngdata == null) {
            String url = configProperties.getBaseURL();
            url = String.format("%s%s%s", url, "/my-resumes/", resumeId);

            QRCodeWriter qw = new QRCodeWriter();
            int size = configProperties.getQrCodeSize();
            BitMatrix bm = qw.encode(url, BarcodeFormat.QR_CODE, size, size);
            ByteArrayOutputStream bs = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(bm, "PNG", bs);
            pngdata = Base64.getEncoder().encodeToString(bs.toByteArray());
//            opResume.get().setBarCodeImage(pngdata);
//            resumeRepo.save(opResume.get());
        }

        return Base64.getDecoder().decode(pngdata);
    }
}
