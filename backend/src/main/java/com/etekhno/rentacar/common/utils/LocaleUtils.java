package com.etekhno.rentacar.common.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class LocaleUtils {
    static List locales = new ArrayList<Locale>();
    public static String validateAndGetLocale(String locale) {
        if(locales.isEmpty())
            locales = List.of(Locale.getAvailableLocales());

        return locales.stream().anyMatch(l -> l.toString().equals(locale)) ? locale : null;
    }

}
