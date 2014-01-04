package org.xu.swan.util;

import org.xu.swan.bean.User;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

public class ActionUtil {
    public static final int PAGE_ITEMS = 50;    
    public static final String PAGE = "page";
    public static final String NUMPAGE = "pageNum";
    public static final String EMPTY = "";

    public static final String ACTION = "action";

    public static final String ACT_ADD = "add";
    public static final String ACT_EDIT = "edit";
    public static final String ACT_DEL = "delete";
    public static final String ACT_LIST = "list";
    public static final String ACT_UPLOAD = "upload";
    public static final String ACT_HIST = "hist";
    public static final String ACT_TIME = "time";

    public static User getUser(HttpServletRequest req){
        try{
            if(req != null){
                HttpSession sess = req.getSession(true);
                return (User)sess.getAttribute("user");
            }
        }catch(Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }
}
