package org.xu.swan.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.SQLException;


public class ByteArray {
    public static byte[] toByteArray(Blob fromImageBlob) {
        if (fromImageBlob != null) {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            try {
                return toByteArrayImpl(fromImageBlob, baos);
            } catch (Exception e) {
            }
        }
        return null;
    }

    public static byte[] toByteArrayImpl(Blob fromImageBlob, ByteArrayOutputStream baos) throws SQLException, IOException {
        byte buf[] = new byte[4000];
        int dataSize;
        InputStream is;
        if (fromImageBlob != null)
            is = fromImageBlob.getBinaryStream();
        else
            return null;
        try {
            while ((dataSize = is.read(buf)) != -1) {
                baos.write(buf, 0, dataSize);
            }
        } finally {
            if (is != null) {
                is.close();
            }
        }
        return baos.toByteArray();
    }
}
