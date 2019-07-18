<!-- #include file ="../../_lib/template.class.asp" -->
<!-- #include file ="../../_lib/common.asp" -->
<!-- #include file ="../_lib/common.asp" -->

<%
' 템플릿 선언
Dim ntpl
Set ntpl = new SkyTemplate

' 템플릿 경로 설정
ntpl.setTplDir( ADMIN_ROOT_DIR & TPL_DIR_FOLDER )
ntpl.setFile "HEADER", "_inc/header.html"
ntpl.setFile "MAIN", "batch_receive/index.html"

' 템플릿 출력
ntpl.tplParse()
ntpl.tplPrint()
%>