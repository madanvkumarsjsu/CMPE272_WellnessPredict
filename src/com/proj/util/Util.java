package com.proj.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import com.proj.pojo.State;


public class Util {


	public ArrayList<State> getStates(){
		ArrayList<State> alStates = new ArrayList<State>();
		Connection conn = connectToDatabase();
		Statement stmt = null;
		State stateObj = null;
		String sqlQuery = "SELECT * FROM CMPE272DB.states";
		try {
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sqlQuery);
			while(rs.next()){
				stateObj = new State();
				Integer iStateID = rs.getInt("stateid");
				String strStateName = rs.getString("states");
				stateObj.setiStateId(iStateID);
				stateObj.setStrStateName(strStateName.toUpperCase());
				alStates.add(stateObj);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally{
			try{
			stmt.close();
			conn.close();
			}
			catch(Exception ex){
				ex.printStackTrace();
			}
		}

		return alStates;

	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	public static Connection connectToDatabase(){
		Connection connect = null;
		if(connect == null){
			try {
				Class.forName("com.mysql.jdbc.Driver");// loading MySQL driver
				connect = DriverManager.getConnection("jdbc:mysql://cmpe272.cn1huhw7fmgm.us-west-1.rds.amazonaws.com:3306/CMPE272DB?user=root&password=rootcmpe");
				//Set up connection with DB, username, password
			} catch (Exception e) {
				System.out.println("Exception in Login::"+e.getMessage());
				e.printStackTrace();
			}
		}
		return connect;
	}

}
