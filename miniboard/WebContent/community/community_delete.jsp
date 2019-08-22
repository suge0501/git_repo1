<%@page import="files.dao.FilesDAO"%>
<%@page import="org.json.JSONObject"%>
<%@page import="community.dao.CommunityDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	// 데이터
	String str_seq = request.getParameter("seq");
	//int seq = Integer.parseInt(request.getParameter("seq")); null값 방지,,
	String user_pwd = request.getParameter("user_pwd");
	int seq = 0;
	if(str_seq != null){
		if (!str_seq.trim().equals("") && str_seq.matches("^[0-9]*$")) {
			seq = Integer.parseInt(str_seq);
		}
	}
	// 실제 폴더위치
	String dir = request.getServletContext().getRealPath("/storage");
	// DB
	CommunityDAO communityDAO = new CommunityDAO();
	int result = communityDAO.communityDelete(seq, user_pwd);
	// JSON으로 결과값 반환
		String rt = null;
		if(result > 0) {
			rt = "OK";
		} else {
			rt = "FAIL";
		}
	// 게시판 글을 지운 후에 파일 삭제
	if(rt.equals("OK")) {
		FilesDAO filesDAO = new FilesDAO();
		// 파일이 있는지 검사해서, 있으면 파일이름 얻어오기
		String filename = filesDAO.checkFiles(seq);
		int result2 = 0;
		// 파일이 있으면 삭제
		if(filename != null) {
			String filePath = dir + "//" + filename;
			result2 = filesDAO.filesDelete(seq, filePath);
			if(result2 > 0) {
				rt = "OK";	// 파일까지 지워야만 OK
			} else {
				rt = "FAIL";
			}
		}
	}
	// JSON 
	JSONObject json = new JSONObject();
	json.put("rt",rt);
	out.println(json);
	System.out.println(json);
	
	
%>    
