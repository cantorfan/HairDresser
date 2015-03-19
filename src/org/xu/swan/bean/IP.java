package org.xu.swan.bean;

public class IP {
	private String IP;
	private boolean checked;
	
	public IP(){}
	public IP(String ip, boolean checked){this.IP=ip; this.checked=checked;}
	
	public String getIP() {
		return IP;
	}
	public void setIP(String iP) {
		IP = iP;
	}
	public boolean isChecked() {
		return checked;
	}
	public void setChecked(boolean checked) {
		this.checked = checked;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((IP == null) ? 0 : IP.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		IP other = (IP) obj;
		if (IP == null) {
			if (other.IP != null)
				return false;
		} else if (!IP.equals(other.IP))
			return false;
		return true;
	}
	
	
	
}
