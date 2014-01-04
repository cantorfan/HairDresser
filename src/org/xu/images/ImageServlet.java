package org.xu.images;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.imageio.ImageIO;
import java.io.*;
import java.awt.image.RenderedImage;
import java.awt.image.BufferedImage;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.font.FontRenderContext;
import java.awt.font.TextLayout;
import java.net.URI;

public class ImageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RenderedImage rendImage = null;
        try {
            String t = request.getParameter("t");
            if(t.length() == 0)
                return;
            int c = Integer.parseInt(request.getParameter("c"), 16);
            float fs = Float.parseFloat(request.getParameter("fs"));
            int width = 0;//request.getParameter("w").length() > 0 ? Integer.parseInt(request.getParameter("w")) : 0;
            rendImage = myCreateImage(t, c, fs, width);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("image/png");
        ImageIO.write(rendImage, "png", response.getOutputStream());
    }

    // Returns a generated image.
    private RenderedImage myCreateImage(String text, int color, float fontsize, int width) throws IOException, FontFormatException {

        // Create a buffered image in which to draw
        BufferedImage bufferedImage = new BufferedImage((int)fontsize*text.length(), (int)(fontsize*1.2), BufferedImage.TYPE_4BYTE_ABGR);

        // Create a graphics contents on the buffered image
        Graphics2D g2d = bufferedImage.createGraphics();


        // Draw graphics
        g2d.setColor(new Color(color));
           // for antialiasing text
        g2d.setRenderingHint( RenderingHints.KEY_TEXT_ANTIALIASING,
                            RenderingHints.VALUE_TEXT_ANTIALIAS_ON );

        InputStream is = getClass().getResourceAsStream("/org/xu/images/ZeroTwos.ttf");

        FontRenderContext frc = g2d.getFontRenderContext();
        
//        File f = new File("D:\\work\\MA-HairDresser\\trunk\\sources\\design\\css\\ZeroTwos.ttf");
        
        Font font = Font.createFont(Font.TRUETYPE_FONT, is);

        Font myFont = font.deriveFont(fontsize);


        g2d.setFont(myFont);
        g2d.drawString(text, 0, (int)fontsize);

        // Graphics context no longer needed so dispose it
        g2d.dispose();
        
        if(width == 0)
            return bufferedImage.getSubimage(0,0,(int)myFont.getStringBounds(text, frc).getBounds2D().getWidth(),(int)(fontsize*1.2));
        
        return bufferedImage.getSubimage(0,0,width,(int)(fontsize*1.2));
    }
}
