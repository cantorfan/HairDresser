package org.xu.swan.util;

import java.util.regex.Pattern;

public final class SwanGuid {

    private static int counter = 0;
    private byte[] guts;
    private static byte shiftab[] = {0, 4, 8, 12, 16, 20, 24, 28};

    /* The Constructor */
    public SwanGuid() {
        guts = nextSwanGuid();
    }

    public static byte[] nextSwanGuid() {
        try {
            counter++;
            long time = System.currentTimeMillis();

            byte[] guid = new byte[8];
            time += counter;
            longToBytes(time, guid, 0);

            return guid;
        }
        catch (Exception e) {
            return null;
        }
    }

    /* method for comparing two Guid objects
    I have had no use for this method, so I never bothered to write it.
    */
    public boolean equals(Object obj) {
        return true;
    }

    /* method returns the hash value
     I have had no use for this method, so I never bothered to write it.
    */
    public int hashCode() {
        return 0;
    }

    /*
      Convert this Guid to a  string.
    */
    public String toString() {
        String str = Long.toHexString(bytesToLong(guts, 0));
        return str.toLowerCase();//return str.toUpperCase();
    }

    public static long bytesToLong(byte[] ba, int offset) throws IllegalArgumentException {
        if (ba == null)
            throw new IllegalArgumentException();

        long i = 0;
        for (int j = 0; j < 8; j++)
            i |= ((long) ba[offset + 7 - j] << shiftab[j]) & (0xFFL << shiftab[j]);

        return i;
    }

    public static void longToBytes(long i, byte[] ba, int offset) throws IllegalArgumentException {
        if (ba == null)
            throw new IllegalArgumentException();

        for (int j = 0; j < 8; j++)
            ba[offset + j] = (byte) ((i >>> shiftab[7 - j]) & 0xFF);
    }

    public static boolean isSwanGuid(String guid){
        if(guid==null || guid.trim().equals(""))
            return false;

        return (Pattern.compile("(\\w|-){9}").matcher(guid.trim()).matches());
    }

    public static void main(String[] args){
        for(int i=0; i<5000; i++){
            SwanGuid sg = new SwanGuid();
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(sg.toString());
        }
    }
}
