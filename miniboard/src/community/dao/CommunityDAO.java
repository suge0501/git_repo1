package community.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import community.bean.CommunityDTO;

public class CommunityDAO {
	String driver = "oracle.jdbc.driver.OracleDriver";
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String username = "jspexam";
	String password = "m1234";
	
	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs;
	
	public CommunityDAO() {
		try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	public Connection getConnection() {
		try {
			conn = DriverManager.getConnection(url,username,password);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}
	public void close() {
		try {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	// DB에 입력내용 저장
	public int communityWrite(CommunityDTO communityDTO) {
		int result = 0;
		String sql = "insert into community values"
		+ "(seq_comm.nextval, ?, ?, ?, ?, ?, sysdate, sysdate)";
		conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, communityDTO.getUser_name());
			pstmt.setString(2, communityDTO.getUser_pwd());
			pstmt.setString(3, communityDTO.getEmail());
			pstmt.setString(4, communityDTO.getSubject());
			pstmt.setString(5, communityDTO.getContent());
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
	// DB 데이터 삭제
	public int communityDelete(int seq, String user_pwd) {
		int result = 0;
		String sql = "delete from community where seq=? and user_pwd=?";
		conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, seq);
			pstmt.setString(2, user_pwd);
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
	// DB 데이터 수정
	public int communityModify(CommunityDTO communityDTO) {
		int result = 0;
		String sql = "update community set user_name =?," + 
				"  email =?, subject =?, content =?,edit_date = sysdate where seq=? and user_pwd=?";
		conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, communityDTO.getUser_name());
			pstmt.setString(2, communityDTO.getEmail());
			pstmt.setString(3, communityDTO.getSubject());
			pstmt.setString(4, communityDTO.getContent());
			pstmt.setInt(5, communityDTO.getSeq());
			pstmt.setString(6, communityDTO.getUser_pwd());
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return result;
	}
	// DB 데이터 전체 검색
	public List<CommunityDTO> communityList() {
		List<CommunityDTO> list = new ArrayList<CommunityDTO>();
		String sql = "select * from community order by seq desc";
		conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				CommunityDTO communityDTO = new CommunityDTO();
				communityDTO.setSeq(rs.getInt("seq"));
				communityDTO.setUser_name(rs.getString("user_name"));
				communityDTO.setUser_pwd(rs.getString("user_pwd"));
				communityDTO.setEmail(rs.getString("email"));
				communityDTO.setSubject(rs.getString("subject"));
				communityDTO.setContent(rs.getString("content"));
				communityDTO.setReg_date(rs.getString("reg_date"));
				communityDTO.setEdit_date(rs.getString("edit_date"));
				list.add(communityDTO);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}
	// DB 상세항목
	public CommunityDTO communitySelect(int seq) {
		CommunityDTO communityDTO = null;
		String sql = "select * from community where seq=?";
		conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, seq);
			rs = pstmt. executeQuery();
			if(rs.next()) {
				communityDTO = new CommunityDTO();
				communityDTO.setSeq(rs.getInt("seq"));
				communityDTO.setUser_name(rs.getString("user_name"));
				communityDTO.setUser_pwd(rs.getString("user_pwd"));
				communityDTO.setEmail(rs.getString("email"));
				communityDTO.setSubject(rs.getString("subject"));
				communityDTO.setContent(rs.getString("content"));
				communityDTO.setReg_date(rs.getString("reg_date"));
				communityDTO.setEdit_date(rs.getString("edit_date"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return communityDTO;
	}
}













