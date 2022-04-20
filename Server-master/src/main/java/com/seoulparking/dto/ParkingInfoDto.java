package com.seoulparking.dto;

import java.util.List;

import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Data;

@Data
@Document(collection="parking_lot")  
public class ParkingInfoDto {
	
	private String pname;
	private String addr1;  
	private String addr2;
	private String total;
	private String avail;
	private List<String> rate;
	private List<String> time;
	private List<Double> location;
}

