<!-- #include file ="../../_lib/template.class.asp" -->
<!-- #include file ="../../_lib/common.asp" -->
<!-- #include file ="../_lib/common.asp" -->

<%
' ���ø� ����
Dim ntpl
Set ntpl = new SkyTemplate

' ���ø� ��� ����
ntpl.setTplDir( ADMIN_ROOT_DIR & TPL_DIR_FOLDER )
ntpl.setFile "HEADER", "_inc/header.html"
ntpl.setFile "MAIN", "batch_receive/index.html"

' ���ø� ���
ntpl.tplParse()
ntpl.tplPrint()
%>