<%@page import="files.dao.FilesDAO"%>
<%@page import="files.bean.FilesDTO"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="community.dao.CommunityDAO"%>
<%@page import="java.util.List"%>
<%@page import="community.bean.CommunityDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	// DB
	CommunityDAO communityDAO = new CommunityDAO();
	List<CommunityDTO> list = communityDAO.communityList();
	// JSON
	String rt = null;
	int total = list.size();		// 전체 조회된 데이터 수
	// 조회된 데이터 수로 성공/실패 판단
	if(total > 0) {
		rt = "OK";
	} else {
		rt = "FAIL";
	}

	// json객체 생성
	JSONObject json = new JSONObject();
	json.put("rt", rt);
	json.put("total", total);
	// json 배열 만들기 : 넘어오는 값이 있어야만이 생성(total이 0보다 커야지)
	if(total>0) {
		JSONArray item = new JSONArray();
		for(int i =0; i<list.size(); i++) {
			CommunityDTO communityDTO = list.get(i);
			// 파일이름 얻어오기
			FilesDAO filesDAO = new FilesDAO();
			String filename = filesDAO.checkFiles(communityDTO.getSeq());
			String fileURL = "";
			if(filename != null) {
				fileURL = "http://192.168.0.44:8080/miniboard/storage" + "/" + filename;
			}
			
			JSONObject temp = new JSONObject();
			temp.put("seq", communityDTO.getSeq());
			temp.put("user_name", communityDTO.getUser_name());
			temp.put("user_pwd", communityDTO.getUser_pwd());
			temp.put("email", communityDTO.getEmail());
			temp.put("subject", communityDTO.getSubject());
			temp.put("content", communityDTO.getContent());
			temp.put("reg_date", communityDTO.getReg_date());
			temp.put("edit_date", communityDTO.getEdit_date());
			temp.put("filename",fileURL);
			// json 배열에 추가
			item.put(i, temp);
		}
		// json 객체에 배열 추가
		json.put("item", item);
	}
	// 응답
	out.println(json);
	System.out.println(json);
%>
