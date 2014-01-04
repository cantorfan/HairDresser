package org.xu.swan.util;

import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.parser.ParserDelegator;
import java.io.IOException;
import java.io.Reader;

public class Html2Text extends HTMLEditorKit.ParserCallback {
       StringBuffer s;

       public Html2Text() {
       }

       public void parse(Reader in) throws IOException {
           s = new StringBuffer();
           ParserDelegator delegator = new ParserDelegator();
           delegator.parse(in, this, Boolean.TRUE);
       }

       public void handleText(char[] text, int pews) {
           s.append(text);
       }

       public String getText() {
           return s.toString();
       }
   }
