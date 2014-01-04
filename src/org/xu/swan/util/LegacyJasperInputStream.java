package org.xu.swan.util;


import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class LegacyJasperInputStream extends FilterInputStream
{
    /**
     * @param is        The InputStream with the modern XSD based Jasper design
     */
    public LegacyJasperInputStream(final InputStream is) {
        super( convertToLegacyFormat(is) );
    }

    private static InputStream convertToLegacyFormat(final InputStream is){
        Document document = convertInputStreamToDOM( is );
        document.getDocumentElement().removeAttribute("xmlns");
        document.getDocumentElement().removeAttribute("xmlns:xsi");
        document.getDocumentElement().removeAttribute("xsi:schemaLocation");
        return convertStringToInputStream( addDocTypeAndConvertDOMToString(document) );
    }


    private static Document convertInputStreamToDOM(final InputStream is){
        Document document = null;
        BufferedInputStream bis = new BufferedInputStream(is);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = null;

        try {
            builder = factory.newDocumentBuilder();
        }
        catch (ParserConfigurationException ex) {
            //LoggerFactory.getLogger(LegacyJasperInputStream.class).error(ex.getMessage(), ex);
        }

        try {
            document = builder.parse(bis);
        } catch (SAXException ex) {
            //LoggerFactory.getLogger(LegacyJasperInputStream.class).error(ex.getMessage(), ex);
        } catch (IOException ex) {
            //LoggerFactory.getLogger(LegacyJasperInputStream.class).error(ex.getMessage(), ex);
        }

        return document;
    }

    private static String addDocTypeAndConvertDOMToString(final Document document){

        TransformerFactory transfac = TransformerFactory.newInstance();
        Transformer trans = null;
        try {
            trans = transfac.newTransformer();
        } catch (TransformerConfigurationException ex) {
            //LoggerFactory.getLogger(LegacyJasperInputStream.class).error(ex.getMessage(), ex);
        }

        trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        trans.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "//JasperReports//DTD Report Design//EN");
        trans.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "http://jasperreports.sourceforge.net/dtds/jasperreport.dtd");

        StringWriter sw = new StringWriter();
        StreamResult result = new StreamResult(sw);
        DOMSource source = new DOMSource(document);
        try {
            trans.transform(source, result);
        } catch (TransformerException ex) {
            //LoggerFactory.getLogger(LegacyJasperInputStream.class).error(ex.getMessage(), ex);
        }

        return sw.toString();
    }

    private static InputStream convertStringToInputStream(final String template){
        InputStream is = null;
        try {
            is = new ByteArrayInputStream(template.getBytes("UTF-8"));
        } catch (UnsupportedEncodingException ex) {
           //LoggerFactory.getLogger(LegacyJasperInputStream.class).debug(ex.getMessage(), ex);
        }
        return is;
    }
}

