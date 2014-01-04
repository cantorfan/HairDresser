package org.xu.swan.util;

import org.xu.swan.bean.Location;

import java.util.*;

public class TimeZoneUtils {

    static Map<String,Integer> timeZoneDict = null;
    static String salonTimeZone = null;

    private static Map<String,Integer> getZones(){
       
        if (timeZoneDict == null){
            timeZoneDict = new HashMap<String,Integer>();
            timeZoneDict.put("GMT-12:00",-720);
            timeZoneDict.put("GMT-11:00",-660);
            timeZoneDict.put("GMT-10:30",-630);
            timeZoneDict.put("GMT-10:00",-600);
            timeZoneDict.put("GMT-09:30",-570);
            timeZoneDict.put("GMT-09:00",-540);
            timeZoneDict.put("GMT-08:30",-510);
            timeZoneDict.put("GMT-08:00",-480);
            timeZoneDict.put("GMT-07:00",-420);
            timeZoneDict.put("GMT-06:00",-360);
            timeZoneDict.put("GMT-05:00",-300);
            timeZoneDict.put("GMT-04:30",-270);
            timeZoneDict.put("GMT-04:00",-240);
            timeZoneDict.put("GMT-03:45",-225);
            timeZoneDict.put("GMT-03:30",-210);
            timeZoneDict.put("GMT-03:00",-180);
            timeZoneDict.put("GMT-02:00",-120);
            timeZoneDict.put("GMT-01:00",-60);
            timeZoneDict.put("GMT+00:00",0);
            timeZoneDict.put("GMT+01:00",60);
            timeZoneDict.put("GMT+02:00",120);
            timeZoneDict.put("GMT+03:00",180);
            timeZoneDict.put("GMT+04:00",240);
            timeZoneDict.put("GMT+04:30",270);
            timeZoneDict.put("GMT+05:00",300);
            timeZoneDict.put("GMT+05:30",330);
            timeZoneDict.put("GMT+05:45",345);
            timeZoneDict.put("GMT+06:00",360);
            timeZoneDict.put("GMT+06:30",390);
            timeZoneDict.put("GMT+07:00",420);
            timeZoneDict.put("GMT+08:00",480);
            timeZoneDict.put("GMT+08:45",525);
            timeZoneDict.put("GMT+09:00",540);
            timeZoneDict.put("GMT+09:30",570);
            timeZoneDict.put("GMT+10:00",600);
            timeZoneDict.put("GMT+11:00",660);
            timeZoneDict.put("GMT+11:30",690);
            timeZoneDict.put("GMT+12:00",720);
            timeZoneDict.put("GMT+12:45",765);
            timeZoneDict.put("GMT+13:00",780);
            timeZoneDict.put("GMT+14:00",840);
        }
        return timeZoneDict;
    }
    
    public static String getSalonTimezone() {
        if (salonTimeZone == null){
            salonTimeZone = Location.getTimezoneForLocation(1);
        }
        return salonTimeZone;
    }

    //todo refreshSalonTimeZone  изменить  salonTimeZone когда изменились настройки
    
    public static String getLocalTimeZone(){
        return "GMT+09:00";
    }

    public static int GetOffsetInMinutes(){
        Map<String,Integer> tZoneDict = getZones();
        String timezone = getSalonTimezone();
        int offset = tZoneDict.get(timezone);
        return offset;
    }

    public static int GetOffsetInMinutes(String timezone){
        Map<String,Integer> tZoneDict = getZones();
        int offset = tZoneDict.get(timezone);
        return offset;
    }

    public static Date getSalonTime(Date dbDate){
      
        int offsetMinutes = GetOffsetInMinutes() - GetOffsetInMinutes(getLocalTimeZone());
   
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(dbDate);
        calendar.add(Calendar.MINUTE, offsetMinutes);
        
        return calendar.getTime();
    }


    public static Date getDbTime(Date salonDate){

        int offsetMinutes = GetOffsetInMinutes() - GetOffsetInMinutes(getLocalTimeZone());

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(salonDate);
        calendar.add(Calendar.MINUTE, -offsetMinutes);

        return calendar.getTime();
    }


    public static Date getCurrentSalonTime(){

        int offsetMinutes = GetOffsetInMinutes() - GetOffsetInMinutes(getLocalTimeZone());

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, -offsetMinutes);

        return calendar.getTime();
    }


    public static Date getCurrentDbTime(){

        Calendar calendar = Calendar.getInstance();
        return calendar.getTime();
    }
}
