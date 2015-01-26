package org.xu.swan.util;

import java.util.Date;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;

public class SendMailHelper {
	private Logger logger = Logger.getLogger(this.getClass());
	
	
	public SenderInfo getSenderInfo(){
		return new SenderInfo();
	}
	
	public SimpleMailSender getSimpleMailSender(){
		return new SimpleMailSender();
	} 
	
	public static boolean send(String text, String subject, String toAddress){
		//return true;
		
		SendMailHelper sendMailHelper=new SendMailHelper();
		
		SenderInfo senderInfo=sendMailHelper.getSenderInfo();
		
		senderInfo.setMailServerHost("smtp.qq.com");	//"inmarsoft.com"
//		senderInfo.setMailServerPort("25");
//		senderInfo.setMailServerHost("localhost");
		senderInfo.setMailServerPort("587");
//		
		senderInfo.setValidate(true);
		senderInfo.setUserName("350789317@qq.com");  
		senderInfo.setPassword("tki8705");
//		senderInfo.setUserName("icloudsalon@gmail.com");  
//		senderInfo.setPassword("daiby2004");
//
		senderInfo.setFromAdress("350789317@qq.com"); //noreply@isalon2you-soft.com
//		senderInfo.setFromAdress("icloudsalon@gmail.com");
		
		senderInfo.setToAdress(toAddress);
//		senderInfo.setToAdress("cantorfan@yeah.net");
		
		senderInfo.setSubject(subject);
		senderInfo.setContent(text);
		
		SimpleMailSender sms=sendMailHelper.getSimpleMailSender();
		boolean result = sms.sendTxtMail(senderInfo);
		return result;
		
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

