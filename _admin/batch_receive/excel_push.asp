<!-- #include file = "../../_lib/common.asp" -->
<!-- #include file = "../../_lib/uploadUtil.asp" -->

<%
Dim fileName : fileName = Request.QueryString("fns")
Dim basePath : basePath = Server.MapPath("/" & "upload")
Dim openPath : openPath = basePath & "\excel/"
Dim photoPath : photoPath = basePath & "\appMember/"

Dim excelFile : excelFile = openPath & fileName

Set excelDB = Server.CreateObject("ADODB.Connection")
Set oRs = Server.CreateObject("ADODB.RecordSet")
Set UPLOAD__FORM = Server.CreateObject("DEXT.FileUpload")
UPLOAD__FORM.DefaultPath = openPath

connectString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&excelFile&"; Extended Properties=""Excel 12.0;HDR=YES;IMEX=1;""" 
excelDB.Open connectString

sQuery = "SELECT * FROM [Sheet1$]"
oRs.Open sQuery,excelDB ,1
If Not(oRs.Eof Or oRs.Bof) then
	arrTmp = oRs.GetRows()
End if
oRs.Close
excelDB.Close

if IsArray(arrTmp) then
  for i = 0 To UBound(arrTmp, 2)
  <!-- 첫 열이 숫자가 아닐 시, 두번째 열이 빈칸이 아닐 시 -->
  if isNumeric(arrTmp(0, i)) = True And Not arrTmp(1, i) = "" then
    '0 : 순번
    '1 : 성명
    '2 : 패스워드
    '3 : 생년월일
    '4 : 연락처
    '5 : 이메일
    '6 : 우편번호
    '7 : 상세주소
    '8 : 성별
    '9 : 영문 첫번째
    '10: 영문 두번째
    Dim userName : userName = arrTmp(1, i)
    Dim userPassWord : userPassWord = arrTmp(2, i)
    Dim userBirthDay : userBirthDay = arrTmp(3, i)
    Dim userPhoneNumber : userPhoneNumber = arrTmp(4, i)
    Dim userEmail : userEmail = arrTmp(5, i)
    Dim userZipCode : userZipCode = arrTmp(6, i)
    Dim userAddress : userAddress = arrTmp(7, i)
    Dim userGender : userGender = arrTmp(8, i)
    Dim userEnameFirst : userEnameFirst = arrTmp(9, i)
    Dim userEnameSecond : userEnameSecond = arrTmp(10, i)

    Dim userPhoneFirst : userPhoneFirst = Split(userPhoneNumber, "-")(0)
    Dim userPhoneSecond : userPhoneSecond = Split(userPhoneNumber, "-")(1)
    Dim userPhoneThird : userPhoneThird = Split(userPhoneNumber, "-")(2)

    ' 이미지 파일 읽기
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    Dim userImageFileName
    
    If fso.FileExists(openPath & userName & ".png") Then
      ' png
      userImageFileName = userName & ".png"
    ElseIf fso.FileExists(openPath & userName & ".bmp") Then
      ' bmp
      userImageFileName = userName & ".bmp"
    ElseIf fso.FileExists(openPath & userName & ".jpg") Then
      ' jpg
      userImageFileName = userName & ".jpg"
    ElseIf fso.FileExists(openPath & userName & ".jpeg") Then
      ' jpeg
      userImageFileName = userName & ".jpeg"
    ElseIf fso.FileExists(openPath & userName & ".gif") Then
      ' gif
      userImageFileName = userName & ".gif"
    End If

    Set fso = Nothing

    ' 파일 업로드
    Dim oldUserImageFileName : oldUserImageFileName = userImageFileName
    userImageFileName = DextFileUpload(userImageFileName, photoPath, 0)

    Response.Write userImageFileName & "<br/>"

    ' 엑셀 파일 읽고난 뒤 엑셀 파일 지우기
    ' 이미지 파일 읽고 appMember 폴더에 옮기기
    Call DeleteFileNotPath(excelFile)
    Call DeleteFile(openPath, oldUserImageFileName)

    With Response
      .Write "이름 : " & userName & "<br>"
      .Write "패스워드 : " & userPassWord & "<br>"
      .Write "생년월일 : " & userBirthDay & "<br>"
      .Write "연락처 : " & userPhoneNumber & "<br>"
      .Write "이메일 : " & userEmail & "<br>"
      .Write "우편번호 : " & userZipCode & "<br>"
      .Write "상세주소 : " & userAddress & "<br>"
      .Write "성별 : " & userGender & "<br>"
      .Write "영문 첫번째 : " & userEnameFirst & "<br>"
      .Write "영문 두번째 : " & userEnameSecond & "<br>"
      .Write "폰 앞 : " & userPhoneFirst & "<br>"
      .Write "폰 중간 : " & userPhoneSecond & "<br>"
      .Write "폰 뒤 : " & userPhoneThird & "<br>"
      .Write "이미지 파일 : " & userImageFileName & "<br>"
    End With
  End if
  Next
End if

Response.End
' 파일 삭제 테스트
'DeleteFile basePath, fileName
'
'Response.Write basePath & fileName
'Response.End
%>