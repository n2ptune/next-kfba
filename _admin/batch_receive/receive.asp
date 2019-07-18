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

' 엑셀 파일 서버 저장
If excelFile <> "" Then
  If FILE_CHECK_EXT(excelFile) = True Then
    ' 확장자 체크
    If FILE_CHECK_EXT_RETURN(excelFile) <> "xlsx" AND FILE_CHECK_EXT_RETURN(excelFile) <> "xls" Then
      DeleteFile savePath, excelFile
      Response.Write "<p>엑셀 파일이 아닙니다.</p>" 
      Response.Write "<p><strong>파일 확장자는 무조건 'xlsx', 'xls'이여야 합니다.</strong></p>"
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
  Response.Write "파일 검색 오류 파일이 없습니다."
  Response.End
End If

<!-- 이미지 파일 서버 저장 -->
For i = 1 To UPLOAD__FORM("imageFile").Count
  If UPLOAD__FORM("imageFile")(i) <> "" Then
    If FILE_CHECK_EXT(UPLOAD__FORM("imageFile")) = True Then
      If FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "png" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "bmp" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "jpg" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "jpeg" AND _
        FILE_CHECK_EXT_RETURN(UPLOAD__FORM("imageFile")(i)) <> "gif" Then
        Call DeleteFile(savePath, UPLOAD__FORM("imageFile")(i))
        Response.Write "<p>사진 확장자에 오류가 있습니다.</p>" 
        Response.Write "<p><strong>사진 확장자 지원 타입 : 'png', 'bmp', 'jpg', 'jpeg', 'gif'</strong></p>"
        Response.End
      End If
      If UPLOAD__FORM.MaxFileLen >= UPLOAD__FORM("imageFile")(i).FileLen Then
        <!-- 이미지 파일 쓰기 -->
        UPLOAD__FORM("imageFile")(i).SaveAs savePath & UPLOAD__FORM("imageFile")(i)
        Response.Write UPLOAD__FORM("imageFile")(i) & " 파일 저장 완료<br/>"
      Else
        <!-- 용량 초과 처리 -->
        With Response
        .Write "<script language='javascript' type='text/javascript'>"
        .Write "alert('파일 용량 초과! (제한 : 10MB)');"
        .Write "history.go(-1);"
        .Write "</script>"
        .End
        End with
      End If
    Else
      <!-- 확장자 오류 처리 -->
      With Response
      .Write "<script language='javascript' type='text/javascript'>"
      .Write "alert('파일 확장자 오류');"
      .Write "history.go(-1);"
      .Write "</script>"
      .End
      End with
    End If
  Else
    <!-- 오류 처리 -->
    Response.Write "알 수 없는 오류"
    Response.End
  End If
Next

Response.Redirect "excel_push.asp?fns=" & excelFile
Response.End
%>