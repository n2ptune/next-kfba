  If isNumeric(arrTmp(0, i)) = True And Not arrTmp(1, i) = "" then
      For j=0 To 7
        If j = 4 Or j = 6 Then
          j = j + 1
        End If
        'Response.write "[" & j & "] " & arrTmp(j, i) & "/"

        ' �迭�� �ֱ�
        arraySelector = j
        If arraySelector = 4 Or arraySelector = 6 Then
          arraySelector = arraySelector - 1
        End If

        '0  : ����
        '1  : �̸�
        '2  : ���˹�ȣ
        '3  : �ڵ�����ȣ
        '5  : ����
        '7  : ��/��/�� ����
        tmpArray(arraySelector) = arrTmp(j, i)

        Response.write tmpArray(arraySelector) & " / "
      Next
    Response.write " - <p style='color: red; font-weight: bold'>ó���Ϸ�</p>"

    call dbopen()
      SET objRs	= Server.CreateObject("ADODB.RecordSet")
	    SET objCmd	= Server.CreateObject("ADODB.Command")

      '' �ϰ� ���� ó���� �� ���� ���� ��
      '' �������� ������ �迭�� ��� SQL ������ ������
      'SQL = "INSERT INTO [dbo].[SP_TEST_TABLES]" &_
      '      "(Idx, Name, AppNumber, PhoneNumber, Score, State)" &_
      '      "VALUES (" &_
      '      ""  & tmpArray(0) &_
      '      "," & "'" & tmpArray(1) & "'" &_
      '      "," & tmpArray(2) &_
      '      "," & "'" & tmpArray(3) & "'" &_
      '      "," & tmpArray(5) &_
      '     "," & "'" & tmpArray(7) & "'" & ")"

      ' State ���ڿ��� �����ͺ��̽��� �ֱ� ���� ��ȯ
      Select Case tmpArray(7)
        Case "�հ�"
          tmpArray(7) = 10
        Case "���հ�"
          tmpArray(7) = 3
        Case "���"
          tmpArray(7) = 4
      End Select
      
      SQL = "UPDATE dbo.SP_PROGRAM_APP " &_
            "SET State = " & "'" & tmpArray(7) & "'" & ", " &_
            "Score = " & "'" & tmpArray(5) & "'" & " " &_
            "WHERE Snumber = " & "'" & tmpArray(2) & "'"

      'Response.Write SQL & "<br/>"

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