package org.xu.swan.util;



public class ResourcesManager {
    private String VALIDATOR = "*";
    private String REQMESSAGE = "Fields marked with * are required.";
    private String REQERROR = "* You must fill in all of the fields marked in red correctly.";
    private String REDIRECTMSG = "Your session is closed!";
    private String PERMISSIONMSG = "Your do not have permission to view this Page.";

    public String getVALIDATOR() {
        return VALIDATOR;
    }

    public String getREQMESSAGE() {
        return REQMESSAGE;
    }

    public String getREQERROR() {
        return REQERROR;
    }

    public String getREDIRECTMSG() {
        return REDIRECTMSG;
    }

    public String getPERMISSIONMSG() {
        return PERMISSIONMSG;
    }

    //    public static String getResource(String name){
//        try{
//            if(!name.equals("")){
//            }
//        }catch(Exception e) {
//            System.out.println(e.getMessage());
//        }
//        return null;
//    }
}