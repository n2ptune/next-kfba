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
  <!-- ù ���� ���ڰ� �ƴ� ��, �ι�° ���� ��ĭ�� �ƴ� �� -->
  if isNumeric(arrTmp(0, i)) = True And Not arrTmp(1, i) = "" then
    '0 : ����
    '1 : ����
    '2 : �н�����
    '3 : �������
    '4 : ����ó
    '5 : �̸���
    '6 : �����ȣ
    '7 : ���ּ�
    '8 : ����
    '9 : ���� ù��°
    '10: ���� �ι�°
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

    ' �̹��� ���� �б�
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

    ' ���� ���ε�
    Dim oldUserImageFileName : oldUserImageFileName = userImageFileName
    userImageFileName = DextFileUpload(userImageFileName, photoPath, 0)

    Response.Write userImageFileName & "<br/>"

    ' ���� ���� �а� �� ���� ���� �����
    ' �̹��� ���� �а� appMember ������ �ű��
    Call DeleteFileNotPath(excelFile)
    Call DeleteFile(openPath, oldUserImageFileName)

    With Response
      .Write "�̸� : " & userName & "<br>"
      .Write "�н����� : " & userPassWord & "<br>"
      .Write "������� : " & userBirthDay & "<br>"
      .Write "����ó : " & userPhoneNumber & "<br>"
      .Write "�̸��� : " & userEmail & "<br>"
      .Write "�����ȣ : " & userZipCode & "<br>"
      .Write "���ּ� : " & userAddress & "<br>"
      .Write "���� : " & userGender & "<br>"
      .Write "���� ù��° : " & userEnameFirst & "<br>"
      .Write "���� �ι�° : " & userEnameSecond & "<br>"
      .Write "�� �� : " & userPhoneFirst & "<br>"
      .Write "�� �߰� : " & userPhoneSecond & "<br>"
      .Write "�� �� : " & userPhoneThird & "<br>"
      .Write "�̹��� ���� : " & userImageFileName & "<br>"
    End With
  End if
  Next
End if

Response.End
' ���� ���� �׽�Ʈ
'DeleteFile basePath, fileName
'
'Response.Write basePath & fileName
'Response.End
%>