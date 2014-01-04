package org.xu.swan.util;

import java.util.Date;
import java.util.Calendar;
import java.util.TimeZone;
import java.util.Locale;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.sql.Time;

public final class DateUtil {
    public final static String FULL_DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
    public final static String DATE_FORMAT1 = "yyyy/M/d";
    public final static String DATE_FORMAT2 = "yyyy-M-d";
    public final static String TIME_FORMAT = "H:mm:ss";

    public static Date getDate(){
        return Calendar.getInstance(TimeZone.getDefault()).getTime();
    }

    public static java.sql.Date getSqlDate(){
        return new java.sql.Date(getDate().getTime());
    }

    public static String getDateTime() {
        SimpleDateFormat sdf = new SimpleDateFormat(FULL_DATE_FORMAT);
        Calendar now = Calendar.getInstance(TimeZone.getDefault());
        return sdf.format(now.getTime());
    }

    public static String formatDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat(FULL_DATE_FORMAT);
        return sdf.format(date);
    }

    public static String formatYmd(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT1);
        return sdf.format(date);
    }

    public static String formatTime(Time time) {
        SimpleDateFormat sdf = new SimpleDateFormat(TIME_FORMAT);
        return sdf.format(time);
    }

    public static Date parseDate(String date){
        try{
            date = date.trim().replace('-','/');
            date = date.replaceAll("/0","/");
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT1);
            return sdf.parse(date);
        }catch(ParseException pe){
            return null;
        }catch(NullPointerException npe){
            return null;
        }
    }

    public static java.sql.Date parseSqlDate(String date){
        try{
            date = date.trim().replace('-','/');
            date = date.replaceAll("/0","/");
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT1);
            return toSqlDate(sdf.parse(date));
        }catch(ParseException pe){
            return null;
        }catch(NullPointerException npe){
            return null;
        }
    }

    public static java.sql.Date toSqlDate(Date date){
        return new java.sql.Date(date.getTime());
    }

    public static int getHour(Time t){
        SimpleDateFormat sdf = new SimpleDateFormat("H");
        return Integer.parseInt(sdf.format(t));
    }

    public static int getMinute(Time t){
        SimpleDateFormat sdf = new SimpleDateFormat("m");
        return Integer.parseInt(sdf.format(t));
    }

    public static int getSecond(Time t){
        SimpleDateFormat sdf = new SimpleDateFormat("s");
        return Integer.parseInt(sdf.format(t));
    }

    public static Time parseSqlTime(String time){
        try{
            SimpleDateFormat sdf = new SimpleDateFormat(TIME_FORMAT);
            return toSqlTime(sdf.parse(time));    
        }catch(ParseException pe){
            return null;
        }catch(NullPointerException npe){
            return null;
        }
    }

    public static Time toSqlTime(Date date){
        return new java.sql.Time(date.getTime());
    }

    public static int getDayOfWeek(Date date){
        //F - Day of week in month - Number - 2
        //E -	Day in week 	- Text - Tuesday; Tue
        SimpleDateFormat sdf = new SimpleDateFormat("EEE", Locale.US);
        String day = sdf.format(date);
        if(day.startsWith("Mon")) return 1;
        else if(day.startsWith("Tue")) return 2;
        else if(day.startsWith("Wed")) return 3;
        else if(day.startsWith("Thu")) return 4;
        else if(day.startsWith("Fri")) return 5;
        else if(day.startsWith("Sat")) return 6;
        else if(day.startsWith("Sun")) return 7;
        else return 0;
    }
}
