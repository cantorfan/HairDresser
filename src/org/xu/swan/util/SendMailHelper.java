package org.xu.swan.util;

import java.io.File;
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

public class SendMailHelper {
	private SenderInfo info;
	private Logger logger = Logger.getLogger(this.getClass());
	private static String username = "tuxmingg@163.com";
	private static String password = "8705429316";
	private static String servHost = "smtp.163.com";
	private static String fromAddress = "tuxmingg@163.com";
	
	public SenderInfo getSenderInfo(){
		if(info==null)
			info = new SenderInfo();
		return info;
	}
	
	public SimpleMailSender getSimpleMailSender(){
		return new SimpleMailSender();
	} 
	
	public static boolean send(String text, String subject, String toAddress){
		SendMailHelper helper = getInstance();
		
		SenderInfo senderInfo=helper.getSenderInfo();
		senderInfo.setToAdress(toAddress);
		
		senderInfo.setSubject(subject);
		senderInfo.setContent(text);
		
		SimpleMailSender sms=helper.getSimpleMailSender();
		boolean result = sms.sendTxtMail(senderInfo);
		
		return result;
	}
	
	public static boolean sendHTML(String text, String subject, String toAddress) {
		SendMailHelper helper = getInstance();
		SenderInfo senderInfo=helper.getSenderInfo();
		
		senderInfo.setToAdress(toAddress);
		senderInfo.setSubject(subject);
		senderInfo.setContent(text);
		
		SimpleMailSender sms=helper.getSimpleMailSender();
		boolean result = sms.sendHTMLMail(senderInfo);
		return result;
	}
	
	public static boolean sendAttatchment(String text, String subject, String toAddress, File file) {
		SendMailHelper helper = getInstance();
		SenderInfo senderInfo=helper.getSenderInfo();
		
		senderInfo.setToAdress(toAddress);
		senderInfo.setSubject(subject);
		senderInfo.setContent(text);
		
		SimpleMailSender sms=helper.getSimpleMailSender();
		boolean result = sms.sendAttachmentMail(senderInfo, file);
		return result;
	}
	
	public static SendMailHelper getInstance(){
		SendMailHelper sendMailHelper=new SendMailHelper();
		
		SenderInfo senderInfo=sendMailHelper.getSenderInfo();
		
		senderInfo.setMailServerHost(servHost);
		senderInfo.setValidate(true);
		senderInfo.setUserName(username);  
		senderInfo.setPassword(password);
		senderInfo.setFromAdress(fromAddress);
		
		return sendMailHelper;
	}
	
	public class SimpleMailSender{
		public boolean sendTxtMail(SenderInfo mailInfo){
			Properties p=mailInfo.getProperties();
			MyAuthenticator authenticator=null;
			if(mailInfo.validate){
				authenticator=new MyAuthenticator(mailInfo.getUserName(),mailInfo.getPassword());
			}
			Session session=Session.getDefaultInstance(p,authenticator);
			Message message=new MimeMessage(session);
			try {
				Address from=new InternetAddress(mailInfo.getFromAdress());
				message.setFrom(from);
				Address to=new InternetAddress(mailInfo.getToAdress());
				message.setRecipient(Message.RecipientType.TO, to);
				message.setSubject(mailInfo.getSubject());
				message.setHeader("X-Mailer", "JavaMail");
				message.setSentDate(new Date());
				message.setText(mailInfo.getContent());
				Transport.send(message); 
				return true;
				
			} catch (AddressException e) {
				e.printStackTrace();
			} catch (MessagingException e) {
				e.printStackTrace();
			}
			return false;
		}
		
		public boolean sendHTMLMail(SenderInfo mailInfo){
			Properties p=mailInfo.getProperties();
			MyAuthenticator authenticator=null;
			if(mailInfo.validate){
				authenticator=new MyAuthenticator(mailInfo.getUserName(),mailInfo.getPassword());
			}
			Session session=Session.getDefaultInstance(p,authenticator);
			try {
				Address from=new InternetAddress(mailInfo.getFromAdress());
				Address to=new InternetAddress(mailInfo.getToAdress());
				
				Message message=new MimeMessage(session);
				message.setFrom(from);
				message.setRecipient(Message.RecipientType.TO, to);
				message.setSentDate(new Date());
				
				message.setSubject(mailInfo.getSubject());
				Multipart mp = new MimeMultipart("related");
				BodyPart bodyPart = new MimeBodyPart();
				bodyPart.setDataHandler(new DataHandler(mailInfo.getContent(), "text/html;charset=utf-8"));
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
		
		public boolean sendAttachmentMail(SenderInfo mailInfo, File attachment){
			Properties p=mailInfo.getProperties();
			MyAuthenticator authenticator=null;
			if(mailInfo.validate){
				authenticator=new MyAuthenticator(mailInfo.getUserName(),mailInfo.getPassword());
			}
			Session session=Session.getDefaultInstance(p,authenticator);
			try {
				Address from=new InternetAddress(mailInfo.getFromAdress());
				Address to=new InternetAddress(mailInfo.getToAdress());
				
				Message message=new MimeMessage(session);
				message.setSubject(mailInfo.getSubject());
				
				message.setFrom(from);
				message.setRecipient(Message.RecipientType.TO, to);
				message.setSentDate(new Date());
				
				// 向multipart对象中添加邮件的各个部分内容，包括文本内容和附件
	            Multipart multipart = new MimeMultipart();
	            // 添加邮件正文
	            BodyPart contentPart = new MimeBodyPart();
	            contentPart.setContent(mailInfo.getContent(), "text/html;charset=UTF-8");
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
	
	public class SenderInfo{
		private String mailServerHost;
		private String mailServerPort="25";
		private String fromAdress;
		private String toAdress;
		private String userName;
		private String password;
		private boolean validate=false;
		private String subject;
		private String content;
		private String[] attachFileNames;
		
		public SenderInfo(){}
		
		public Properties getProperties(){
			Properties p=new Properties();
			p.put("mail.smtp.host", this.mailServerHost);
			p.put("mail.smtp.starttls.enable", "true");  
		    p.put("mail.smtp.user", fromAdress);  
		    p.put("mail.smtp.password", password);  
		    p.put("mail.smtp.port", this.mailServerPort);
			p.put("mail.smtp.auth", validate?"true":"false");
			return p;
		}
		
		public String getMailServerHost() {
			return mailServerHost;
		}
		public String getMailServerPort() {
			return mailServerPort;
		}
		public String getFromAdress() {
			return fromAdress;
		}
		public String getToAdress() {
			return toAdress;
		}
		public String getUserName() {
			return userName;
		}
		public String getPassword() {
			return password;
		}
		public boolean isValidate() {
			return validate;
		}
		public String getSubject() {
			return subject;
		}
		public String getContent() {
			return content;
		}
		public String[] getAttachFileNames() {
			return attachFileNames;
		}
		public void setMailServerHost(String mailServerHost) {
			this.mailServerHost = mailServerHost;
		}
		public void setMailServerPort(String mailServerPort) {
			this.mailServerPort = mailServerPort;
		}
		public void setFromAdress(String fromAdress) {
			this.fromAdress = fromAdress;
		}
		public void setToAdress(String toAdress) {
			this.toAdress = toAdress;
		}
		public void setUserName(String userName) {
			this.userName = userName;
		}
		public void setPassword(String password) {
			this.password = password;
		}
		public void setValidate(boolean validate) {
			this.validate = validate;
		}
		public void setSubject(String subject) {
			this.subject = subject;
		}
		public void setContent(String content) {
			this.content = content;
		}
		public void setAttachFileNames(String[] attachFileNames) {
			this.attachFileNames = attachFileNames;
		}
	}

}

