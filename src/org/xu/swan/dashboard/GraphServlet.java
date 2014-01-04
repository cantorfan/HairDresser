package org.xu.swan.dashboard;

import org.xu.swan.bean.Appointment;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;

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
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Set;
import java.util.ArrayList;
import java.util.Calendar;

public class GraphServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RenderedImage rendImage = null;
        try {
            rendImage = myCreateImage(request);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("image/png");
        ImageIO.write(rendImage, "png", response.getOutputStream());
    }

    // Returns a generated image.
    private RenderedImage myCreateImage(HttpServletRequest request) throws IOException, FontFormatException {
        int color = 0;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date from = null;
        Date to = null;
        try {
            from = new Date(sdf.parse(request.getParameter("from")).getTime());
            to = new Date(sdf.parse(request.getParameter("to")).getTime());
        } catch (ParseException e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }

        // Create a buffered image in which to draw
        int width = 600;
        int height = 400;
        BufferedImage bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_4BYTE_ABGR);

        // Create a graphics contents on the buffered image
        Graphics2D g2d = bufferedImage.createGraphics();


        // Draw graphics
        g2d.setColor(new Color(color));
        // for antialiasing text
        g2d.setRenderingHint( RenderingHints.KEY_TEXT_ANTIALIASING,
                            RenderingHints.VALUE_TEXT_ANTIALIAS_ON );

        InputStream is = getClass().getResourceAsStream("/org/xu/swan/dashboard/ZeroTwos.ttf");
        FontRenderContext frc = g2d.getFontRenderContext();
        Font font = Font.createFont(Font.TRUETYPE_FONT, is);

        Font myFont = font.deriveFont(12.0f);
        g2d.setFont(myFont);

        // load data
        ArrayList data = Appointment.getChartData(from, to);
        
        // get max value
        long maxValue = 0;
        if(data.size() > 0){
            for(int i = 0; i < data.size(); i++){
                long val = ((ChartData)data.get(i)).getCount();
                if(val > maxValue)
                    maxValue = val;
            }
            if(maxValue == 0)
                maxValue = 1;
        }else
            maxValue = 100;
        float pixelsPerPoint = (height-100.0f) / (float)maxValue;

        // draw axis values
        final int countY = 6;
        long stepDateTitle = (to.getTime() - from.getTime()) / countY;
        g2d.setColor(Color.LIGHT_GRAY);
        for(int i = 0; i <= countY; i++){
            Date c = new Date(from.getTime() + stepDateTitle * i);
            int w = (int)myFont.getStringBounds(sdf.format(c), frc).getBounds2D().getWidth();
            g2d.drawString(sdf.format(c), 50 + i*85 - w/2, height-20);
            g2d.drawLine(50 + i*85, height-47,  50 + i*85, 0);
        }

        final int countX = 10;
        int stepValue = (height-100) / countX;
        g2d.setColor(Color.LIGHT_GRAY);
        for(int i = 0; i <= countX; i++){
            String c = Float.toString((int)((float)maxValue/(float)countX * (float)i * 10) / 10.0f);
            int w = (int)myFont.getStringBounds(c, frc).getBounds2D().getWidth();
            g2d.drawString(c, 20 - w/2, height-50 - stepValue * i + 3);
            g2d.drawLine(47, height-50 - stepValue * i, width, height-50 - stepValue * i);
        }
        // draw chart
        g2d.setColor(Color.RED);
        if(data.size() > 0){
            int offset = (int)(
                            (float)(((ChartData)data.get(0)).getDate().getTime() - from.getTime()) /
                            (float)(to.getTime() - from.getTime())
                            * countY * 85
                    );
            for(int i = 0; i < data.size() - 1; i++){
                ChartData cd1 = (ChartData)data.get(i);
                ChartData cd2 = (ChartData)data.get(i+1);
                int step = (int)(
                                (float)(cd2.getDate().getTime() - cd1.getDate().getTime()) /
                                (float)(to.getTime() - from.getTime())
                                * countY * 85
                        );
                int c1 = cd1.getCount();
                int c2 = cd2.getCount();
                g2d.drawLine(
                        50 + offset, (int)(height - 50 - c1*pixelsPerPoint),
                        50 + offset + step, (int)(height - 50 - c2*pixelsPerPoint)
                        );
                offset += step;
            }
        }

        g2d.setColor(Color.BLACK);
        g2d.drawLine(50, 0, 50, height - 50);
        g2d.drawLine(50, height - 50, width, height - 50);

        // Graphics context no longer needed so dispose it
        g2d.dispose();

        return bufferedImage;
    }
}
