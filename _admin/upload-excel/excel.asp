<!-- #include file = "../../_lib/common.asp" -->

<%
' �ʱ� �迭 ����
Dim tmpArray(4)

' ���� �̸� ��������
Dim basePath : basePath = Server.MapPath("/" & "upload")
Dim openPath : openPath = basePath & "\excel/"
Dim fileName : fileName = Request.QueryString("fns")

Dim excelFile : excelFile = openPath & fileName

Set xlDb = Server.CreateObject("ADODB.Connection")  
Set oRs = Server.CreateObject("ADODB.RecordSet")  
 
'FileName = Server.MapPath("excel/test.xlsx")
connectString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&excelFile&"; Extended Properties=""Excel 12.0;HDR=YES;IMEX=1;""" 
xlDb.Open connectString
 
sQuery = "SELECT * FROM [Sheet1$]"
oRs.Open sQuery,xlDb ,1
If Not(oRs.Eof Or oRs.Bof) then
	arrTmp = oRs.GetRows()
End if
oRs.Close
xlDb.Close
 
IF IsArray(arrTmp) Then
	For i=0 To UBound(arrTmp, 2)
  If isNumeric(arrTmp(0, i)) = True And Not arrTmp(1, i) = "" then
    ' 2 : ���˹�ȣ
    ' 3 : ����ó
    ' 4 : ����
    ' 5 : ��/��/�� ����
    Dim number : number = arrTmp(2, i)
    Dim phoneNumber : phoneNumber = arrTmp(3, i)
    Dim score : score = arrTmp(4, i)
    Dim state : state = arrTmp(5, i)
    
    Select Case state
      Case "�հ�":
        tmpArray(3) = 10
      Case "���հ�":
        tmpArray(3) = 3
      Case "���":
        tmpArray(3) = 4
    End Select

    ' @array : tmpArray
    ' (0)    : ���˹�ȣ
    ' (1)    : ����
    ' (2)    : �ڵ��� ��ȣ (Full)
    ' (3)    : ��/��/�� ���� (Number)

    tmpArray(0) = number
    tmpArray(1) = score
    tmpArray(2) = phoneNumber

    phoneNumberSize = Len(tmpArray(2))

    If phoneNumberSize = 0 Or isNull(phoneNumberSize) Or phoneNumberSize > 14 Then
      With Response
        .Write "����ó ���� �о�� �� �����ϴ�. ���Ŀ� �°� �ۼ����ּ���."
        .End
      End With
    End If
    
    phoneSplit = Split(tmpArray(2), "-")

    ' �� ��ȣ
    phoneFront = Trim(phoneSplit(0))
    ' �߰� ��ȣ
    phoneMid = Trim(phoneSplit(1))
    ' �� ��ȣ
    phoneBack = Trim(phoneSplit(2))

    Response.Write arrTmp(1, i) & " -<strong> " & state & ", " & tmpArray(2) & " <span style='color: blue;'>ó���Ϸ�</span></strong><br/>"

    call dbopen()
      SET objRs	= Server.CreateObject("ADODB.RecordSet")
	    SET objCmd	= Server.CreateObject("ADODB.Command")

      'SQL = "UPDATE dbo.TEST_APP_TABLES " &_
      '      "SET STATE = " & tmpArray(3) & ", " &_
      '      "SCORE = " & tmpArray(1) & "(" &_
      '      "SELECT u.UserIdx, u.Snumber, p.UserIdx " &_
      '      "FROM dbo.TEST_APP_TABLES as u, dbo.SP_USER_MEMBER as p " &_
      '      "WHERE u.Snumber = '" & tmpArray(0) & "' " &_
      '      "AND p.UserIdx = u.UserIdx " &_
      '      "AND p.UserHphone1 = '" & phoneFront & "' " &_
      '      "AND p.UserHphone2 = '" & phoneMid & "' " &_
      '      "AND p.UserHphone3 = '" & phoneBack & "');"

      SQL = "UPDATE dbo.SP_PROGRAM_APP " &_
            "SET State = '" & tmpArray(3) & "', " &_
            "Score = '" & tmpArray(1) & "' " &_
            "FROM dbo.SP_PROGRAM_APP as t JOIN dbo.SP_USER_MEMBER as m ON t.UserIdx = m.UserIdx " &_
            "WHERE m.UserHphone1 = '" & phoneFront & "' AND m.UserHphone2 = '" & phoneMid & "' AND m.UserHphone3 = '" & phoneBack & "' AND Snumber = '" & tmpArray(0) & "'"

      call cmdopen()
      with objCmd
        .CommandText = SQL
        set objRs = .Execute
      End with
      call cmdclose()
      set objRs = Nothing
    call dbclose()
  End If
	Next
End If

Call DeleteFileNotPath(excelFile)
%>