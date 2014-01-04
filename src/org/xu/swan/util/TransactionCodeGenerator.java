package org.xu.swan.util;

public class TransactionCodeGenerator {
    private static int counter = 0;
    private static byte shiftab[] = {0, 4, 8, 12, 16, 20, 24, 28};

    /* The Constructor */
    public TransactionCodeGenerator() {
    }

    private static byte[] nextSwanGuid() {
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

    public static String next() {
        return Long.toHexString(bytesToLong(nextSwanGuid(), 0)).toLowerCase();
    }

    private static long bytesToLong(byte[] ba, int offset) throws IllegalArgumentException {
        if (ba == null)
            throw new IllegalArgumentException();

        long i = 0;
        for (int j = 0; j < 8; j++)
            i |= ((long) ba[offset + 7 - j] << shiftab[j]) & (0xFFL << shiftab[j]);

        return i;
    }

    private static void longToBytes(long i, byte[] ba, int offset) throws IllegalArgumentException {
        if (ba == null)
            throw new IllegalArgumentException();

        for (int j = 0; j < 8; j++)
            ba[offset + j] = (byte) ((i >>> shiftab[7 - j]) & 0xFF);
    }
}
