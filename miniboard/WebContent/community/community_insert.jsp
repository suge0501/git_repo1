<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="files.dao.FilesDAO"%>
<%@page import="files.bean.FilesDTO"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="org.json.JSONObject"%>
<%@page import="community.dao.CommunityDAO"%>
<%@page import="community.bean.CommunityDTO"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 데이터(클라이언트로 넘어온 데이터)
	request.setCharacterEncoding("UTF-8");	// post방식일 때, 한글 처리
	// 실제 폴더 위치
	String dir = request.getServletContext().getRealPath("/storage");
	// 요청처리 객체
	MultipartRequest multi = new MultipartRequest(request,dir,5*1024*1024,"UTF-8", new DefaultFileRenamePolicy()); // ,폴더 경로, 최대파일크기,중복저장(이름바꿔서)	
	String user_name = multi.getParameter("user_name");
	String user_pwd = multi.getParameter("user_pwd");
	String email = multi.getParameter("email");
	String subject = multi.getParameter("subject");
	String content = multi.getParameter("content");
	// DB
	CommunityDTO communityDTO = new CommunityDTO();
	communityDTO.setUser_name(user_name);
	communityDTO.setUser_pwd(user_pwd);
	communityDTO.setEmail(email);
	communityDTO.setSubject(subject);
	communityDTO.setContent(content);
	
	CommunityDAO communityDAO = new CommunityDAO();
	int result = communityDAO.communityWrite(communityDTO);
	// JSON으로 결과값 반환
	String rt = null;
	int community_seq = 0;
	if(result > 0) {
		rt = "OK";
	} else {
		rt = "FAIL";
	}
	// Community 저장이 성공한 경우에 파일 관련 정보 저장
	if(rt.equals("OK")) {
		// 전송되어온 파일 이름
		String originname = multi.getOriginalFileName("photo");
		// storage 폴더에 저장된 파일이름
		String filename = multi.getFilesystemName("photo");
		// 저장된 파일의 환장자를 원본이름에서 추출
		int lastIndex = originname.lastIndexOf(".");
		String filetype = originname.substring(lastIndex + 1);
		// 파일의 크기
		File file = multi.getFile("photo");
		int filesize = 0;
		if(file != null) filesize = (int)file.length();
		// DTO에 저장
		FilesDTO filesDTO = new FilesDTO();
		filesDTO.setDir(dir);
		filesDTO.setOriginname(originname);
		filesDTO.setFilename(filename);
		filesDTO.setFiletype(filetype);
		filesDTO.setFilesize(filesize);
		// DB
		FilesDAO filesDAO = new FilesDAO();
		// 방금 저장된 Cmmunity테이블의 seq값 얻어오기
		community_seq = filesDAO.getCommunityFirstSeq();	
		filesDTO.setCommunity_seq(community_seq);
		int result2 = filesDAO.filesWrite(filesDTO);
		
		if(result2 > 0) {
			rt = "OK";
		} else {
			rt = "FAIL";
		}
		
	}
	// JSON 객체 생성
	JSONObject json = new JSONObject();		//	{} : 객체 생성 직후에는 텅 빈 {}만 만들어 진 것임
	json.put("rt", rt);						// {"rt" : "OK"} 또는 {"rt" : "FAIL"}
	json.put("seq", community_seq);
	out.println(json);
	
	System.out.println(json);
%>    
