package com.etekhno.rentacar.common.utils;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class DateHelper {

    public static Date getCurrentDate() {
        return GregorianCalendar.getInstance().getTime();
    }

    public static Date getDateFromMS(Long milliseconds) {
        Calendar calendar = GregorianCalendar.getInstance();
        calendar.setTimeInMillis(milliseconds);
        return calendar.getTime();
    }

    public static Date addHoursInCurrentDate(Integer hours) {
        Long hoursInMS = (long)hours * 60 * 60 * 1000;
        Calendar calendar = GregorianCalendar.getInstance();
        calendar.setTimeInMillis(calendar.getTimeInMillis() + hoursInMS );
        return calendar.getTime();
    }

    public static Date addHoursInDate(Date date, Integer hours) {
        return addHoursInDate(date, (long) hours);
    }

    public static Date addHoursInDate(Date date, Long hours) {
        Long hoursInMS = hours * 60 * 60 * 1000;
        Calendar calendar = GregorianCalendar.getInstance();
        calendar.setTime(date);
        calendar.setTimeInMillis(calendar.getTimeInMillis() + hoursInMS );
        return calendar.getTime();
    }

    public static Date addMinutesInCurrentDate(Integer mints) {
        Long mintsInMS = (long)mints * 60 * 1000;
        Calendar calendar = GregorianCalendar.getInstance();
        calendar.setTimeInMillis(calendar.getTimeInMillis() + mintsInMS );
        return calendar.getTime();
    }

}
