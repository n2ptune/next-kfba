  If isNumeric(arrTmp(0, i)) = True And Not arrTmp(1, i) = "" then
      For j=0 To 7
        If j = 4 Or j = 6 Then
          j = j + 1
        End If
        'Response.write "[" & j & "] " & arrTmp(j, i) & "/"

        ' 배열에 넣기
        arraySelector = j
        If arraySelector = 4 Or arraySelector = 6 Then
          arraySelector = arraySelector - 1
        End If

        '0  : 순번
        '1  : 이름
        '2  : 수검번호
        '3  : 핸드폰번호
        '5  : 점수
        '7  : 결/불/합 여부
        tmpArray(arraySelector) = arrTmp(j, i)

        Response.write tmpArray(arraySelector) & " / "
      Next
    Response.write " - <p style='color: red; font-weight: bold'>처리완료</p>"

    call dbopen()
      SET objRs	= Server.CreateObject("ADODB.RecordSet")
	    SET objCmd	= Server.CreateObject("ADODB.Command")

      '' 일괄 접수 처리할 때 쓰면 좋을 듯
      '' 엑셀에서 내용을 배열에 담아 SQL 쿼리를 날려줌
      'SQL = "INSERT INTO [dbo].[SP_TEST_TABLES]" &_
      '      "(Idx, Name, AppNumber, PhoneNumber, Score, State)" &_
      '      "VALUES (" &_
      '      ""  & tmpArray(0) &_
      '      "," & "'" & tmpArray(1) & "'" &_
      '      "," & tmpArray(2) &_
      '      "," & "'" & tmpArray(3) & "'" &_
      '      "," & tmpArray(5) &_
      '     "," & "'" & tmpArray(7) & "'" & ")"

      ' State 문자열을 데이터베이스에 넣기 위해 변환
      Select Case tmpArray(7)
        Case "합격"
          tmpArray(7) = 10
        Case "불합격"
          tmpArray(7) = 3
        Case "결시"
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