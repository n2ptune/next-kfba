<!-- #include file = "../_lib/header.asp" -->
<!-- #include file = "../_lib/template.class.asp" -->
<!-- #include file = "_lib/common.asp" -->
<link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR&display=swap" rel="stylesheet">
<%
If session("Admin_Id") <> "" Then 
	'response.redirect "member/adminCheck.asp"
End If

dim ntpl
set ntpl = new SkyTemplate

Dim GoUrl : GoUrl = Request.QueryString("GoUrl")

ntpl.setTplDir( ADMIN_ROOT_DIR & TPL_DIR_FOLDER )
ntpl.setFile "MAIN", "member/login.html"

ntpl.tplAssign array(   _
	 array("imgDir", "_skin/login/" ) _
	,array("GoUrl", GoUrl ) _
	,array("action", "member/loginProc.asp") _
), ""

'// 예제에서 { 마크 사용을 위한 것
ntpl.tplAssign "m", "{"

ntpl.tplParse()  '// 설정한 템플릿 파일처리
ntpl.tplPrint()  '// 출력

set ntpl = nothing
%>