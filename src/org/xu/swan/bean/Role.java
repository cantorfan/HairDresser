package org.xu.swan.bean;

import java.util.HashMap;

public class Role {
    public final static String S_ADMIN = "Administrator";
    public final static String S_RECEP = "Receptionist ( Schedule & Checkout Only)";
    public final static String S_EMP = "Schedule (Edit Only Schedule)";
    public final static String S_VIEW = "View Schedule ( Can’t Edit)";
    public final static String S_SHD_CHK = "Schedule & Checkout (View Both)";

    public final static int R_ADMIN = 1001;
    public final static int R_RECEP = 2001;
    public final static int R_EMP = 3001;
    public final static int R_VIEW = 4001;
    public final static int R_SHD_CHK  = 5001;

    public final static HashMap ROLES = new HashMap();
    static{
        ROLES.put("1001",S_ADMIN);
        ROLES.put("2001",S_RECEP);
        ROLES.put("3001",S_EMP);
        ROLES.put("4001",S_VIEW);
        ROLES.put("5001",S_SHD_CHK);
    }
}
