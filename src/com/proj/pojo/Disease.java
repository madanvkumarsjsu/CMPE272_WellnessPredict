package com.proj.pojo;
public class Disease {

	private String diseaseName;
	private int occurance;
	
	public Disease(String diseaseName, Integer occurance){
		this.diseaseName = diseaseName;
		this.occurance = occurance;
	}
	public String getDiseaseName() {
		return diseaseName;
	}
	public void setDiseaseName(String diseaseName) {
		this.diseaseName = diseaseName;
	}
	public int getOccurance() {
		return occurance;
	}
	public void setOccurance(Integer occurance) {
		this.occurance = occurance;
	}
	
	public String toJSON(){
		 return new StringBuffer("[\'").append(this.diseaseName).append("\',").append(this.occurance).append("]").toString();

	}
	
}
