/**
 * 
 */
package org.xu.swan.util;

/**
 * @author Administrator
 *
 */
public class ParseUtil {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	
	public static int parseInt(String s)
	{
		
		if(s == null || s.trim().length() == 0)
			return 0;
		else
			return Integer.parseInt(s.trim());
	}

}
