package com.etekhno.rentacar.common.utils;

import java.time.ZoneId;

public class TimezoneUtils {
    public static String validateAndGetZoneId(String id) {
        try {
            ZoneId.of(id);
        } catch(Exception ex) {
            return null;
        }
        return id;
    }
}
