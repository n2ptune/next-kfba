<!--#include file="../../_lib/uploadUtil.asp"-->
<!--#include file="../../_lib/pront.common.asp"-->
<!--#include file="../../_lib/common.asp"-->

<%
' 저장 경로
Dim basePath : basePath = Server.MapPath("/" & "upload")
Dim savePath : savePath = basepath & "\excel/"

' 파일 전송 폼
Set UPLOAD__FORM = Server.CreateObject("DEXT.FileUpload")
UPLOAD__FORM.AutoMakeFolder = True
UPLOAD__FORM.DefaultPath = savePath
' 파일 크기 제한(10MB)
UPLOAD__FORM.MaxFileLen = 10 * 1024 * 1024

' 값 불러오기
Dim excelFile : excelFile = UPLOAD__FORM("excelFile")

If excelFile <> "" Then
  If FILE_CHECK_EXT(excelFile) = True Then
    ' 확장자 체크
    If FILE_CHECK_EXT_RETURN(excelFile) <> "xlsx" AND FILE_CHECK_EXT_RETURN(excelFile) <> "xls" Then
      DeleteFile savePath, excelFile
      Response.Write "<p>엑셀 파일이 아닙니다.</p>" 
      Response.Write "<p><strong>파일 확장자는 무조건 'xlsx'이여야 합니다.</strong></p>"
      Response.End
    End If
    ' 크기 체크
    If UPLOAD__FORM.MaxFileLen >= UPLOAD__FORM("excelFile").FileLen Then
      excelFile = DextFileUpload("excelFile", savePath, 0)
    Else
      With Response
        .Write "<script language='javascript' type='text/javascript'>"
        .Write "alert('파일 용량 초과! (제한 : 10MB)');"
        .Write "history.go(-1);"
        .Write "</script>"
        .End
      End with
    End If
  Else
    With Response
      .Write "<script language='javascript' type='text/javascript'>"
      .Write "alert('파일 확장자 오류');"
      .Write "history.go(-1);"
      .Write "</script>"
      .End
    End with
  End If
Else
  Response.Write "오류"
  Response.End
End If

Response.Redirect "excel.asp?fns=" & excelFile
Response.End
%>