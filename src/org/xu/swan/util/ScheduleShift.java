package org.xu.swan.util;

/**
 * Created by IntelliJ IDEA.
 * User: swatch
 * Date: Nov 11, 2008
 * Time: 12:20:23 PM
 * To change this template use File | Settings | File Templates.
 */
public class ScheduleShift {

    public static int getShift(int empOrder, String browser) {
        int shift = 0;
        if (browser.equals("Microsoft Internet Explorer")) {
            switch (empOrder){
                case 1:
                    shift = empOrder-1;
                    break;
                case 3:
                    shift = empOrder-2;
                    break;
                case 4:
                   shift = empOrder-2;
                   break;
                case 5:
                case 6:
                   shift = empOrder-1;
                   break;
                case 7:
                   shift = empOrder;
                   break;
                default:
                  shift = 0;
            }
        }else{
             switch (empOrder){
                case 7:
                   shift = 3;
                   break;
                case 6:
                   shift = 1;
                   break;
                default:
                  shift = 0;
        }
        }
        return shift;        
    }
}
