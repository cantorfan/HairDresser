package org.xu.swan.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.apache.log4j.Logger;

public class SendMailHelper{
	private Logger logger = Logger.getLogger(this.getClass());
	
	/*
	 * 	mail.smtp.host=smtp.163.com
	 	fromAddress=tuxmingg@163.com
		
		mail.run=false
		
		mail.smtp.starttls.enable=true
		mail.smtp.user=tuxmingg@163.com
		mail.smtp.password=8705429316
		mail.smtp.auth=true
		
		mail.smtp.port=25
	 */
	private static Properties props = null;
	
	public SendMailHelper(){
		if(props==null){
			try {
				props = new Properties();
				String path = SendMailHelper.class.getResource("/").getPath()+"email.config.properties";
				logger.error("email.config.properties path: "+path);
				InputStream in = new BufferedInputStream(new FileInputStream(path));
				props.load(in);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				e.printStackTrace();
			}
		}

	}
	
	public static boolean isMailActive(){
		SendMailHelper helper = new SendMailHelper();
		if(Boolean.parseBoolean(props.getProperty("mail.run"))==false){
			return false;
		}
		return true;
	}
	
	public static boolean send(String text, String subject, String toAddress){
		SendMailHelper helper = new SendMailHelper();
		MyAuthenticator authenticator=null;
		
		if(Boolean.parseBoolean(props.getProperty("mail.run"))==false){
			return false;
		}
		
		if(Boolean.parseBoolean(props.getProperty("mail.smtp.auth"))){
			authenticator=helper.getMyAuthenticator(props.getProperty("mail.smtp.user"), 
					props.getProperty("mail.smtp.password"));
		}
		Session session=Session.getDefaultInstance(props, authenticator);
		Message message=new MimeMessage(session);
		try {
			Address from=new InternetAddress(props.getProperty("fromAddress"));
			message.setFrom(from);
			Address to=new InternetAddress(toAddress);
			message.setRecipient(Message.RecipientType.TO, to);
			message.setSubject(subject);
			message.setHeader("X-Mailer", "JavaMail");
			message.setSentDate(new Date());
			message.setText(text);
			Transport.send(message); 
			return true;
			
		} catch (AddressException e) {
			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public static boolean sendHTMLMail(String text, String subject, String toAddress){
		SendMailHelper helper = new SendMailHelper();
		
		if(Boolean.parseBoolean(props.getProperty("mail.run"))==false){
			return false;
		}
		
		MyAuthenticator authenticator=null;
		if(Boolean.parseBoolean(props.getProperty("mail.smtp.auth"))){
			authenticator=helper.getMyAuthenticator(props.getProperty("mail.smtp.user"), 
					props.getProperty("mail.smtp.password"));
		}
		
		Session session=Session.getDefaultInstance(props, authenticator);
		try {
			Address from=new InternetAddress(props.getProperty("fromAddress"));
			Address to=new InternetAddress(toAddress);
			
			Message message=new MimeMessage(session);
			message.setFrom(from);
			message.setRecipient(Message.RecipientType.TO, to);
			message.setSentDate(new Date());
			
			message.setSubject(subject);
			Multipart mp = new MimeMultipart("related");
			BodyPart bodyPart = new MimeBodyPart();
			bodyPart.setDataHandler(new DataHandler(text, "text/html;charset=utf-8"));
			mp.addBodyPart(bodyPart); 
			message.setContent(mp);
	        Transport.send(message);
			return true;
			
		} catch (AddressException e) {
			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public static boolean sendAttatchment(String text, String subject, String toAddress, File attachment) {
		SendMailHelper helper = new SendMailHelper();
		
		if(Boolean.parseBoolean(props.getProperty("mail.run"))==false){
			return false;
		}
		
		MyAuthenticator authenticator=null;
		if(Boolean.parseBoolean(props.getProperty("mail.smtp.auth"))){
			authenticator=helper.getMyAuthenticator(props.getProperty("mail.smtp.user"), 
					props.getProperty("mail.smtp.password"));
		}
		
		Session session=Session.getDefaultInstance(props,authenticator);
		try {
			Address from=new InternetAddress(props.getProperty("fromAddress"));
			Address to=new InternetAddress(toAddress);
			
			Message message=new MimeMessage(session);
			message.setSubject(subject);
			
			message.setFrom(from);
			message.setRecipient(Message.RecipientType.TO, to);
			message.setSentDate(new Date());
			
			// 向multipart对象中添加邮件的各个部分内容，包括文本内容和附件
            Multipart multipart = new MimeMultipart();
            // 添加邮件正文
            BodyPart contentPart = new MimeBodyPart();
            contentPart.setContent(text, "text/plain");
            multipart.addBodyPart(contentPart);
            
            // 添加附件的内容
            if (attachment != null) {
                BodyPart attachmentBodyPart = new MimeBodyPart();
                DataSource source = new FileDataSource(attachment);
                attachmentBodyPart.setDataHandler(new DataHandler(source));
                
                // 网上流传的解决文件名乱码的方法，其实用MimeUtility.encodeWord就可以很方便的搞定
                // 这里很重要，通过下面的Base64编码的转换可以保证你的中文附件标题名在发送时不会变成乱码
                //sun.misc.BASE64Encoder enc = new sun.misc.BASE64Encoder();
                //messageBodyPart.setFileName("=?GBK?B?" + enc.encode(attachment.getName().getBytes()) + "?=");
                
                //MimeUtility.encodeWord可以避免文件名乱码
                attachmentBodyPart.setFileName(MimeUtility.encodeWord(attachment.getName()));
                multipart.addBodyPart(attachmentBodyPart);
            }
            
            // 将multipart对象放到message中
            message.setContent(multipart);
            // 保存邮件
            message.saveChanges();
            
	        Transport.send(message);
			return true;
			
		} catch (AddressException e) {
			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public MyAuthenticator getMyAuthenticator(String userName,String password){
		return new MyAuthenticator(userName, password);
	}
	private class MyAuthenticator extends Authenticator{
		String userName=null;
		String password=null;
		
		public MyAuthenticator(){}
		
		public MyAuthenticator(String userName,String password){
			this.userName=userName;
			this.password=password;
		}
		protected PasswordAuthentication getPasswordAuthentication(){  
	        return new PasswordAuthentication(userName, password);  
	    }
	}
	
}