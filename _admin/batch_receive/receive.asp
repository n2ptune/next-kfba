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

' ���� ���� ���� ����
If excelFile <> "" Then
  If FILE_CHECK_EXT(excelFile) = True Then
    ' Ȯ���� üũ
    If FILE_CHECK_EXT_RETURN(excelFile) <> "xlsx" AND FILE_CHECK_EXT_RETURN(excelFile) <> "xls" Then
      DeleteFile savePath, excelFile
      Response.Write "<p>���� ������ �ƴմϴ�.</p>" 
      Response.Write "<p><strong>���� Ȯ���ڴ� ������ 'xlsx', 'xls'�̿��� �մϴ�.</strong></p>"
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
  Response.Write "���� �˻� ���� ������ �����ϴ�."
  Response.End
End If

<!-- �̹��� ���� ���� ���� -->
For i = 1 To UPLOAD__FORM("imageFile").Count
  If UPLOAD__FORM("imageFile")(i) <> "" Then
    If FILE_CHECK_EXT(UPLOAD__FORM("imageFile")) = True Then
      If FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "png" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "bmp" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "jpg" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "jpeg" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "gif" Then
        Call DeleteFile(savePath, UPLOAD__FORM("imageFile")(i))
        Response.Write "<p>���� Ȯ���ڿ� ������ �ֽ��ϴ�.</p>" 
        Response.Write "<p><strong>���� Ȯ���� ���� Ÿ�� : 'png', 'bmp', 'jpg', 'jpeg', 'gif'</strong></p>"
        Response.End
      End If
      If UPLOAD__FORM.MaxFileLen >= UPLOAD__FORM("imageFile")(i).FileLen Then
        <!-- �̹��� ���� ���� -->
        UPLOAD__FORM("imageFile")(i).SaveAs savePath & UPLOAD__FORM("imageFile")(i)
        Response.Write UPLOAD__FORM("imageFile")(i) & " ���� ���� �Ϸ�<br/>"
      Else
        <!-- �뷮 �ʰ� ó�� -->
        With Response
        .Write "<script language='javascript' type='text/javascript'>"
        .Write "alert('���� �뷮 �ʰ�! (���� : 10MB)');"
        .Write "history.go(-1);"
        .Write "</script>"
        .End
        End with
      End If
    Else
      <!-- Ȯ���� ���� ó�� -->
      With Response
      .Write "<script language='javascript' type='text/javascript'>"
      .Write "alert('���� Ȯ���� ����');"
      .Write "history.go(-1);"
      .Write "</script>"
      .End
      End with
    End If
  Else
    <!-- ���� ó�� -->
    Response.Write "�� �� ���� ����"
    Response.End
  End If
Next

Response.Redirect "excel_push.asp?fns=" & excelFile
Response.End
%>