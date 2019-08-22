<%@page import="org.json.JSONObject"%>
<%@page import="community.dao.CommunityDAO"%>
<%@page import="community.bean.CommunityDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 데이터
	request.setCharacterEncoding("UTF-8");
	String user_name = request.getParameter("user_name");
	String email = request.getParameter("email");
	String subject = request.getParameter("subject");
	String content = request.getParameter("content");
	String str_seq = request.getParameter("seq");
	String user_pwd = request.getParameter("user_pwd");
	int seq = 0;
	if (str_seq != null && str_seq.matches("^[0-9]*$")) {
		seq = Integer.parseInt(str_seq);
	}
	CommunityDTO communityDTO = new CommunityDTO();
	communityDTO.setUser_name(user_name);
	communityDTO.setEmail(email);
	communityDTO.setSubject(subject);
	communityDTO.setContent(content);
	communityDTO.setSeq(seq);
	communityDTO.setUser_pwd(user_pwd);
	
	CommunityDAO communityDAO = new CommunityDAO();
	int result = communityDAO.communityModify(communityDTO);
	// DB
	String rt = null;
	if(result > 0) {
		rt = "OK";
	} else {
		rt = "FAIL";
	}
	// JSON 변환
	JSONObject json = new JSONObject();
	json.put("rt", rt);
	out.println(json);
	
	System.out.println(json);
%>
