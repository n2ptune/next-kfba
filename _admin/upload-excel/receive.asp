<!--#include file="../../_lib/uploadUtil.asp"-->
<!--#include file="../../_lib/pront.common.asp"-->
<!--#include file="../../_lib/common.asp"-->

<%
' ���� ���
Dim basePath : basePath = Server.MapPath("/" & "upload")
Dim savePath : savePath = basepath & "\excel/"

' ���� ���� ��
Set UPLOAD__FORM = Server.CreateObject("DEXT.FileUpload")
UPLOAD__FORM.AutoMakeFolder = True
UPLOAD__FORM.DefaultPath = savePath
' ���� ũ�� ����(10MB)
UPLOAD__FORM.MaxFileLen = 10 * 1024 * 1024

' �� �ҷ�����
Dim excelFile : excelFile = UPLOAD__FORM("excelFile")

If excelFile <> "" Then
  If FILE_CHECK_EXT(excelFile) = True Then
    ' Ȯ���� üũ
    If FILE_CHECK_EXT_RETURN(excelFile) <> "xlsx" AND FILE_CHECK_EXT_RETURN(excelFile) <> "xls" Then
      DeleteFile savePath, excelFile
      Response.Write "<p>���� ������ �ƴմϴ�.</p>" 
      Response.Write "<p><strong>���� Ȯ���ڴ� ������ 'xlsx'�̿��� �մϴ�.</strong></p>"
      Response.End
    End If
    ' ũ�� üũ
    If UPLOAD__FORM.MaxFileLen >= UPLOAD__FORM("excelFile").FileLen Then
      excelFile = DextFileUpload("excelFile", savePath, 0)
    Else
      With Response
        .Write "<script language='javascript' type='text/javascript'>"
        .Write "alert('���� �뷮 �ʰ�! (���� : 10MB)');"
        .Write "history.go(-1);"
        .Write "</script>"
        .End
      End with
    End If
  Else
    With Response
      .Write "<script language='javascript' type='text/javascript'>"
      .Write "alert('���� Ȯ���� ����');"
      .Write "history.go(-1);"
      .Write "</script>"
      .End
    End with
  End If
Else
  Response.Write "����"
  Response.End
End If

Response.Redirect "excel.asp?fns=" & excelFile
Response.End
%>