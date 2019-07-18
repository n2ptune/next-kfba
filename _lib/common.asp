<!--METADATA TYPE="typelib" NAME=" ADODB Type Library" UUID="00000205-0000-0010-8000-00AA006D2EA4" -->
<!--#include file="../security/hide.asp"-->
<%
Const FRONT_ROOT_DIR = "/"
Const ADMIN_ROOT_DIR = "/_admin/"
Const INTRA_ROOT_DIR = "/_intranet/"

Const SITE_NAME = "[한국외식식음료협협회]"
Const SEND_MAIL_MAIL = "<kfba@kfba.smileh.co.kr>"
Const SEND_MAIL_BOTTOM_INFO = "본 메일은 회원님께서 수신 가능 메일 주소로 설정한 e-mail 주소로 발송된 것으로 발신전용이며 관련 문의는 고객센터를 이용해주시기 바랍니다."
Const SEND_MAIL_BOTTOM_COPY = "상호: 한국외식음료협회   대표: 임영철   주소: 서울특별시 금천구 가산동 543-1번지 대성 디-폴리스 지식산업센터 B동 2003호   사업자등록번호: 119-86-68711<br>개인정보취급담당자: 김영웅   통신판매번호: 제2013-서울구로-1104호   고객센터: 02-861-9411~3   이메일: kfba0319@naver.com"

Dim objConn,objRs,objCmd
Dim g_uip   : g_uip   = Request.ServerVariables("REMOTE_ADDR")
Dim g_host  : g_host  = "http://" & Request.ServerVariables("SERVER_NAME")
Dim g_url   : g_url   = Request.ServerVariables("PATH_INFO")
Dim ref_url : ref_url = Request.ServerVariables("HTTP_REFERER")
Dim g_query_string : g_query_string = Request.ServerVariables ("QUERY_STRING")

'------------------------------------------------------------------------------------
' UpLoad base path
'------------------------------------------------------------------------------------
Dim UPLOAD_BASE_PATH   : UPLOAD_BASE_PATH = server.mapPath(FRONT_ROOT_DIR & "upload")
'------------------------------------------------------------------------------------
' DB Open/Close
'------------------------------------------------------------------------------------
Sub dbopen()
	Set objConn = Server.CreateObject("ADODB.Connection")
	objConn.ConnectionString = CONN_STRING
	objConn.CommandTimeOut = 30
	objConn.Open
End Sub

Sub dbclose()
	If IsObject(objConn) Then
		objConn.close() : Set objConn = Nothing
	End If
End Sub

'------------------------------------------------------------------------------------
' DB Open/Close
'------------------------------------------------------------------------------------
Sub cmdopen()
	SET objCmd	= Server.CreateObject("ADODB.Command")
	with objCmd
		.ActiveConnection  = objConn
		.prepared          = true
		.CommandType       = adCmdText
	End with
End Sub

Sub cmdclose()
	If IsObject(objCmd) Then Set objCmd = Nothing
End Sub
'------------------------------------------------------------------------------------
' RS 레코드셋의 필드 Index 변수를 만든다.예) FI_fieldName = 1   FI는 prefix.
'------------------------------------------------------------------------------------
Sub setFieldIndex(rs, prefix)
	Dim fld
	Dim i : i = 0
	
	for each fld in rs.fields
		Execute(prefix & "_" & fld.name & "=" & i)
		i = i + 1
	next
End Sub
'------------------------------------------------------------------------------------
' RS 레코드셋의 필드 Index 변수를 만든다. 예) FV_fieldName   FV는 prefix.
'------------------------------------------------------------------------------------
Sub setFieldValue(rs, prefix)
	Dim fld
	Dim i : i = 0
	
	' 무조건 변수 선언.
	for each fld in rs.fields
		Execute(prefix & "_" & fld.name & "=""""")
	next
	
	if NOT(rs.EOF) then
		for each fld in rs.fields
			Execute(prefix & "_" & fld.name & "=""" & Replace(Replace(fld.value&"","""",""""""),vbcrlf,""" & vbcrlf & """) & """" )
		next
	end if
End Sub
'----------------------------------------------------------------------------------------------
' FORM 값 데이타들을 화면에 출력한다.
'----------------------------------------------------------------------------------------------
Sub showFormData()
	Dim item
	For Each item in Request.Form
		  Response.write "<BR>" & item & "..." & Request.Form(item).count & "..." & Request.Form(item)
	Next
End Sub
'------------------------------------------------------------------------------------
' 캐쉬 설정.
'------------------------------------------------------------------------------------
Sub Expires()
	Response.Buffer = true
	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1 
	Response.AddHeader "pragma","no-cache" 
	Response.AddHeader "cache-control","private" 
	'Response.CacheControl = "no-cache"
End Sub

'------------------------------------------------------------------------------------
' "IF...ELSE...END IF"문.
'------------------------------------------------------------------------------------
Function IIF(Expression, TruePart, FalsePart)
	If Expression Then 
		IIF = TruePart
	Else
		IIF = FalsePart
	End If
End Function
'------------------------------------------------------------------------------------
' 업로드 관련 변수.
'------------------------------------------------------------------------------------
Dim UPLOAD__FORM
'------------------------------------------------------------------------------------
' 업로드 관련인지 판단.
'------------------------------------------------------------------------------------
Function isMultipart()
	isMultipart = IIF(InStr(request.serverVariables("HTTP_CONTENT_TYPE"),"multipart/form-data")=1, True, False)
End Function

'----------------------------------------------------------------------------------------------
''메세지를 화면에 Alert 창으로 출력한다.
'----------------------------------------------------------------------------------------------
Sub msgbox(pMsg, pBack)
	response.write "<script Language='JavaScript'>"
	response.write "	alert('" & toJS(pMsg) & "');"
	if (pBack=vbTrue) then response.write "	history.back();"
	response.write "</script>"
	if (pBack=vbTrue) then response.end
End Sub

'----------------------------------------------------------------------------------------------
''일반문자를 특수문자로 바꾼다.
'----------------------------------------------------------------------------------------------
Function toJS(pStr)
	Dim str : str= replace(replace(replace(pStr,"\","\\"), "'","\'"), vbCrLf,"\n")
	toJS = str
End Function

'----------------------------------------------------------------------------------------------
''배열로부터 옵션 목록 만들기.
'----------------------------------------------------------------------------------------------
Function makeOption(arrList, cntList, codeIndex, nameIndex, default)
	Dim str, i
	for i = 0 to cntList
		str = str & "<option " & IIF( Trim(arrList(codeIndex, i)) = Trim(default) ,"selected='selected'","") & " value='" & Trim(arrList(codeIndex, i)) & "'>" & Trim(arrList(nameIndex, i)) & "</option>"
	next
	
	makeOption = "<option value=''> 선 택 </option>" & str
End Function

'==============================================================================================
''왼쪽 문자열 채우기
'==============================================================================================
Function lpad(baseStr, fillStr, iSize)
	Dim tmpString	: tmpString = CStr(baseStr)
	Dim tLoop
	
	' 만약 채울 문자열이 빈 데이타이면 그냥 빠져나감.
	if (fillStr="" OR iSize < 1) then
		lpad = baseStr
		EXIT FUNCTION
	end if
	
	DO WHILE LEN(tmpString) < iSize
		tmpString = fillStr & tmpString
	LOOP

	lpad = RIGHT(tmpString, iSize)
End Function

'==============================================================================================
''오른쪽 문자열 채우기
'==============================================================================================
Function rpad(baseStr, fillStr, iSize)
	Dim tmpString	: tmpString = CStr(baseStr)
	Dim tLoop
	
	' 만약 채울 문자열이 빈 데이타이면 그냥 빠져나감.
	if (fillStr="" OR iSize < 1) then
		rpad = baseStr
		EXIT FUNCTION
	end if
	
	DO WHILE LEN(tmpString) < iSize
		tmpString = tmpString & fillStr
	LOOP

	rpad = LEFT(tmpString, iSize)
End Function

'==============================================================================================
''Request 받기 초기값 설정
'==============================================================================================
Function RequestSet(ByVal itemName , method , Default )
	Dim tmpString
	
	If UCase(method) = "POST" Then
		tmpString = Request.Form(itemName)
		tmpString = IIF( IsNull(tmpString) Or tmpString="" , Default ,  IIF( isNumeric(Default) , IIF(IsNumeric(tmpString),tmpString,0) , Trim(tmpString) )  )
	Else
		tmpString = Request.QueryString(itemName)
		tmpString = IIF( IsNull(tmpString) Or tmpString="" , Default , IIF( isNumeric(Default) , IIF(IsNumeric(tmpString),tmpString,0) , Trim(tmpString) )  )
	End If

	RequestSet = tmpString
End Function

'----------------------------------------------------------------------------------------------
''날짜 형태로 변환(맞지 않으면 원래대로).
'----------------------------------------------------------------------------------------------
Function toDateFormat(pStr)
	Dim arr : arr = split(pStr, ", ")
	Dim str	: str = pStr
	if (UBound(arr)=4) then 
		if arr(0)<>"" and arr(1)<>"" and arr(2)<>"" and arr(3)<>"" and arr(4)<>"" then
			str = lpad(arr(0), "0", 4) & "-" & lpad(arr(1), "0", 2) & "-" & lpad(arr(2), "0", 2) & " " & lpad(arr(3), "0", 2) & ":" & lpad(arr(4), "0", 2)
		elseif arr(0)<>"" and arr(1)<>"" and arr(2)<>"" then
			str = lpad(arr(0), "0", 4) & "-" & lpad(arr(1), "0", 2) & "-" & lpad(arr(2), "0", 2)
		else
			str = ""
		end if
	elseif (UBound(arr)=2) then 
		if arr(0)<>"" and arr(1)<>"" and arr(2)<>"" then
			str = lpad(arr(0), "0", 4) & "-" & lpad(arr(1), "0", 2) & "-" & lpad(arr(2), "0", 2)
		else
			str = ""
		end if
	else
		str = ""
	end if
	
	toDateFormat = str
End Function


 '------------------------HtmlTagRemover -- HTML 테그 제거 함수 -------by Andy---------
 ' 파라미터 설명 : (처리할문자열, 자를길이)
 ' cutlen = 0 일경우 전체 문자열
 '---------------------------------------------------------------------------------------
 function HtmlTagRemover(content, cutlen)
  j=1
  tmpb=2
  length = len(content)
  htmlRemovedContent = content

  Do while length > 0
   k = mid(htmlRemovedContent,j,1)

   if k="<" then
    tmpb = 0
   elseif k = ">" then
    tmpb = 1
   end if

   if tmpb = 0 then
    htmlRemovedContent = left(htmlRemovedContent,j-1) & mid(htmlRemovedContent,j+1)
   elseif tmpb = 1 then
    htmlRemovedContent = left(htmlRemovedContent,j-1) & mid(htmlRemovedContent,j+1)
    tmpb = 2
   else
    j=j+1
   end if
 
   length = length -1
  Loop

  if cutlen <> 0 then
'---------------------------------
' 문자열 한글 영문 숫자 길이변환
'---------------------------------
  dim intPos, chrTemp, strCut, intLength
    '문자열 길이 초기화
    intLength = 0
    intPos = 1

    '문자열 길이만큼 돈다
    do while ( intPos <= Len( htmlRemovedContent ))

       '문자열을 한문자씩 비교한다
        chrTemp = ASC(Mid( htmlRemovedContent, intPos, 1))

        if chrTemp < 0 then '음수값(-)이 나오면 한글임
          strCut = strCut & Mid( htmlRemovedContent, intPos, 1 ) 
          intLength = intLength + 2  '한글일 경우 문자열 길이를 2를 더한다 
        else
          strCut = strCut & Mid( htmlRemovedContent, intPos, 1 )            
          intLength = intLength + 1  '한글이 아닌경우 문자열 길이를 1을 더한다
        end If

        if intLength >= cutlen  then
           exit do
        end if

        intPos = intPos + 1
  
    Loop
   
	
    htmlRemovedContent = strCut
    if intLength >= cutlen  then
		htmlRemovedContent = htmlRemovedContent &".."
	end if
  end if

  HtmlTagRemover = htmlRemovedContent

 end Function
'----------------------------------------------------------------------------------------------
' 이미지 리사이징
'----------------------------------------------------------------------------------------------
Function img_resize(savePath,Images,WmaxSize,HmaxSize)
	If Images <> "" Then 
		thumbnail_fg = 0
		path = savePath & Images
		Oldsize = Split(imgFileSizeChk(path),"/")
		If ubound(Oldsize) > -1 Then 
			
			'섬네일
			th_path = savePath & "s_" & Images
			th_Oldsize = Split(imgFileSizeChk(th_path),"/")

			If ubound(th_Oldsize) > -1 Then
				If th_Oldsize(0) >= WmaxSize Or th_Oldsize(1) >= HmaxSize Then 
					thumbnail_fg = 1
				End If
			End If

			If thumbnail_fg = 0 Then 
				NewSize = Split(resizeImg(Oldsize(0),Oldsize(1),WmaxSize,HmaxSize),"/")
				img_resize = "<img src=" & savePath & Images & " width="&NewSize(0)&" height="&NewSize(1)&">"
			Else
				NewSize = Split(resizeImg(th_Oldsize(0),th_Oldsize(1),WmaxSize,HmaxSize),"/")
				img_resize = "<img src=" & savePath & "s_" & Images & " width="&NewSize(0)&" height="&NewSize(1)&">"
			End If
		Else
			img_resize = "<img width="&WmaxSize&" height="&HmaxSize&" alt='NO IMAGE'>"
		End If
		
	End If
End Function

'----------------------------------------------------------------------------------------------
' 이미지 사이즈 리턴
'----------------------------------------------------------------------------------------------
Function imgFileSizeChk(path)'fso를 이용한 이미지 사이즈 리턴
On Error Resume Next 
' Dim objFSO,obj,imgWidth,imgHeight,imgSize
' path = Server.MapPath("/") & path

' Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
'  IF objFSO.FileExists(path) THEN
'   Set obj = LoadPicture(path)
'    imgWidth = CLng(int(obj.Width) * 24 / 635)
'    imgHeight = CLng(int(obj.Height) * 24 / 635)  
'   Set obj = Nothing
'   imgSize = imgWidth &"/"& imgHeight '사용자 입맛에맞게 리턴형식지정

'   If Err.Number > 0 Then
'	imgSize = ""
'   End If 
'  Else 
'   imgSize = ""
'  END If  
' Set objFSO = Nothing

' imgFileSizeChk = imgSize
	If path <> "" Then 
		path = Server.MapPath("/") & path
		Dim Image
		Set Image = new ImageClass
		With Image
			   .LoadFilePath( path )
			   .ImageRead
			   iType = .ImageType
			   iWidth = .Width
			   iHeight = .Height
		End With
		Set Imaeg = Nothing 
		imgFileSizeChk = iWidth &"/"& iHeight

		If Err.Number > 0 Then
			imgFileSizeChk = ""
		End If
	Else
		imgFileSizeChk = ""
	End If
	
End Function


 '----------------------------------------------------------------------------------------------
' 가로/세로 사이즈를 기준으로 이미지 리사이즈 업로드 / 게시판 리스트
'----------------------------------------------------------------------------------------------
Function resizeImg(w,h,WmaxSize,HmaxSize)
 
 Dim imgWidth,imgHeight,imgSize,ratio,b1,b2
 ratio = 1

 If w > h Then 
  b1 = WmaxSize/HmaxSize
  b2 = w/h
  If b1 <= b2 Then
   If CLng(WmaxSize) < CLng(w) Then 
    ratio = WmaxSize/w
   End If  
  Else 
   If CLng(h) > CLng(HmaxSize) Then 
    ratio = HmaxSize/h
   End If 
  End If
 Else 
  b1 = HmaxSize/WmaxSize

   If(w > 0) then 
	  b2 = h/w
	  If b1 <= b2 Then
	   If CLng(HmaxSize) < CLng(h) Then 
		ratio = HmaxSize/h
	   End If  
	  Else 
	   If CLng(w) > CLng(WmaxSize) Then 
		ratio = WmaxSize/w
	   End If 
	  End If
	Else
		ratio = 0
	End if
 End If

 imgWidth = CLng(ratio*w)
 imgHeight = CLng(ratio*h)
 imgSize = imgWidth &"/"& imgHeight '사용자 입맛에맞게 리턴형식지정

 resizeImg = imgSize

End Function


'----------------------------------------------------------------------------------------------
' 문자열 64비트 디코드
'----------------------------------------------------------------------------------------------
function Base64decode(ByVal asContents)
Const sBASE_64_CHARACTERS = _
           "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" 
           Dim lsResult
           Dim lnPosition
           Dim lsGroup64, lsGroupBinary
           Dim Char1, Char2, Char3, Char4
           Dim Byte1, Byte2, Byte3
           if Len(asContents) Mod 4 > 0 _
          Then asContents = asContents & String(4 - (Len(asContents) Mod 4), " ")
           lsResult = ""

           For lnPosition = 1 To Len(asContents) Step 4
                   lsGroupBinary = ""
                   lsGroup64 = Mid(asContents, lnPosition, 4)
                   Char1 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 1, 1)) - 1
                   Char2 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 2, 1)) - 1
                   Char3 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 3, 1)) - 1
                   Char4 = INSTR(sBASE_64_CHARACTERS, Mid(lsGroup64, 4, 1)) - 1
                   Byte1 = Chr(((Char2 And 48) \ 16) Or (Char1 * 4) And &HFF)
                   Byte2 = lsGroupBinary & Chr(((Char3 And 60) \ 4) Or (Char2 * 16) And &HFF)
                   Byte3 = Chr((((Char3 And 3) * 64) And &HFF) Or (Char4 And 63))
                   lsGroupBinary = Byte1 & Byte2 & Byte3

                   lsResult = lsResult + lsGroupBinary
           Next
Base64decode = lsResult
End Function

'----------------------------------------------------------------------------------------------
' 문자열 64비트 인코딩
'----------------------------------------------------------------------------------------------
function Base64encode(ByVal asContents)
Const sBASE_64_CHARACTERS = _
           "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" 
        Dim lnPosition
        Dim lsResult
        Dim Char1
        Dim Char2
        Dim Char3
        Dim Char4
        Dim Byte1
        Dim Byte2
        Dim Byte3
        Dim SaveBits1
        Dim SaveBits2
        Dim lsGroupBinary
        Dim lsGroup64

        if Len(asContents) Mod 3 > 0 Then _
        asContents = asContents & String(3 - (Len(asContents) Mod 3), " ")
        lsResult = ""

        For lnPosition = 1 To Len(asContents) Step 3
               lsGroup64 = ""
               lsGroupBinary = Mid(asContents, lnPosition, 3)

               Byte1 = Asc(Mid(lsGroupBinary, 1, 1)): SaveBits1 = Byte1 And 3
               Byte2 = Asc(Mid(lsGroupBinary, 2, 1)): SaveBits2 = Byte2 And 15
               Byte3 = Asc(Mid(lsGroupBinary, 3, 1))

               Char1 = Mid(sBASE_64_CHARACTERS, ((Byte1 And 252) \ 4) + 1, 1)
               Char2 = Mid(sBASE_64_CHARACTERS, (((Byte2 And 240) \ 16) Or _
               (SaveBits1 * 16) And &HFF) + 1, 1)
               Char3 = Mid(sBASE_64_CHARACTERS, (((Byte3 And 192) \ 64) Or _
               (SaveBits2 * 4) And &HFF) + 1, 1)
               Char4 = Mid(sBASE_64_CHARACTERS, (Byte3 And 63) + 1, 1)
               lsGroup64 = Char1 & Char2 & Char3 & Char4

               lsResult = lsResult + lsGroup64
         Next

         Base64encode = lsResult
End Function

'----------------------------------------------------------------------------------------------
' 스크립트 방지
'----------------------------------------------------------------------------------------------
Function TagEncode(ByVal Contans)
	Dim temp
	temp = replace(Contans,"&","&amp;")
	temp = replace(temp,"/","&#47;")
	temp = replace(temp,"""","&quot;")
	temp = replace(temp,"'","&#39;")
	temp = replace(temp,"<","&lt;")
	temp = replace(temp,">","&gt;")
	temp = Replace(temp,VbCrlf,"<br>")
	TagEncode = temp
End Function 

'----------------------------------------------------------------------------------------------
' 스크립트 복구
'----------------------------------------------------------------------------------------------
Function TagDecode(ByVal Contans)
	Dim temp
	temp = replace(Contans,"&#47;","/")
	temp = replace(temp,"&quot;","""")
	temp = replace(temp,"&#39;","'")
	temp = replace(temp,"&lt;","<")
	temp = replace(temp,"&gt;",">")
	temp = Replace(LCase(temp),"<br>",VbCrlf)
	temp = replace(temp,"&amp;","&")
	TagDecode = temp
End Function 

'----------------------------------------------------------------------------------------------
' 파일확장자 체크
'----------------------------------------------------------------------------------------------
Function FILE_CHECK_EXT(ByVal filePath)
	Dim fileExt,temp
	fileExt = LCase(Mid(filePath, InStrRev(filePath, ".") + 1))
	If fileExt = "asp" Or fileExt = "php" Or fileExt = "jsp" Or fileExt = "html" Or fileExt = "htm" Or fileExt = "js" Then 
		temp = false
	Else
		temp = true
	End If
	FILE_CHECK_EXT = temp
End Function 

'----------------------------------------------------------------------------------------------
' 파일확장자 리턴
'----------------------------------------------------------------------------------------------
Function FILE_CHECK_EXT_RETURN(ByVal filePath)
	Dim fileExt,temp
	fileExt = LCase(Mid(filePath, InStrRev(filePath, ".") + 1))
	FILE_CHECK_EXT_RETURN = fileExt
End Function 

'----------------------------------------------------------------------------------------------
' 문자 * 가리기
'----------------------------------------------------------------------------------------------
Function StrLenBlind(ByVal str,ByVal length)
	Dim Strlen,StrTemp,StrTemp2
	Strlen = Len(str)
	StrTemp = Mid(str,1,length)
	For i=0 To Strlen - length -1
		StrTemp2 = StrTemp2 & "*"
	Next
	StrTemp = StrTemp & StrTemp2
	StrLenBlind = StrTemp

End function

'------------------------------------------------------------------------------------
' 페이징
'------------------------------------------------------------------------------------
Function printPageList(pTotCount, pPageNo, pRows, url)
	if pTotCount = 0 then 
		printPageList = "<span class='bold'>1</span>"	: Exit Function
	end if
	
	' 하단에 보여줄 페이지 건수...
	Dim tPrintCount, tPageCount, tCurRange, tCount, tPageNo
	Dim tmpStr
	
	tPrintCount = 10
	tPageCount = Fix((pTotCount + (pRows-1)) / pRows)
	tCurRange  = FIX((pPageNo-1) / tPrintCount)* tPrintCount

	tCount = 1
	tPageNo = 0
	
	' 두단계 앞으로....
	tmpStr = ""
	if ( tCurRange > 0) then
		tmpStr = tmpStr & vbCrLf & "<a href='" & replace(url,"__PAGE__","1") & "'><span style='font-size:8px;'><b><<</b></span></a> "
	else
		tmpStr = tmpStr & vbCrLf & "<span style='font-size:8px;'><b><<</b></span> "
	end if
	
	' 한단계 앞으로....
	if ( tCurRange > 0) then
		tmpStr = tmpStr & vbCrLf & "<a href='" & replace(url,"__PAGE__",(tCurRange-tPrintCount+1)) & "'><span style='font-size:8px;'><b><</b></span></a> "
	else
		tmpStr = tmpStr & vbCrLf & "<span style='font-size:8px;'><b><</b></span> "
	end if

	while (tCount <= tPrintCount AND (tCurRange+tCount) <= tPageCount )
		tPageNo = tCurRange+tCount

		if (tPageNo = int(pPageNo))	then
			tmpStr = tmpStr & vbCrLf & "<b>" & tPageNo & "</b> "
		else
			tmpStr = tmpStr & vbCrLf & "<a href='" & replace(url,"__PAGE__",tPageNo) & "'>" & tPageNo & "</a> "
		end if
		
		tCount = tCount + 1
	wend
	
	' 한단계 뒤로....
	if ( FIX((tPageCount-1)/tPrintCount) > FIX(tCurRange/tPrintCount) )	then
		tmpStr = tmpStr & vbCrLf & "<a href='" & replace(url,"__PAGE__",(tCurRange+tPrintCount+1)) & "' class='next'><span style='font-size:8px;'><b>></b></span></a> "
	else
		tmpStr = tmpStr & vbCrLf & "<span style='font-size:8px;'><b>></b></span> "
	end if
	
	' 두단계 뒤로....
	if ( FIX((tPageCount-1)/tPrintCount) > FIX(tCurRange/tPrintCount) )	then
		tmpStr = tmpStr & vbCrLf & "<a href='" & replace(url,"__PAGE__",tPageCount) & "' class='last'><span style='font-size:8px;'><b>>></b></span></a> "
	else
		tmpStr = tmpStr & vbCrLf & "<span style='font-size:8px;'><b>>></b></span> "
	end if
	
	printPageList = tmpStr
	
End Function


'** ---------------------------------------------------------------------------
' 함 수 명 : MailSend(strSubject, strBody, strTo, strFrom)
' 인    자 : 1. strSubject	: 메일 제목
'            2. strBody		: 메일 내용
'            3. strTo		: 받는 사람 메일 주소
'            4. strFrom		: 보내는 사람 메일 주소
' 목    적 : 메일 발송
' 플 로 우 :
' 검    수 :
' 생 성 일 :
' 수    정 :
'** ---------------------------------------------------------------------------
function MailSend(strSubject, strBody, strTo, strFrom, attachPath)

	dim result
	Dim objConfig, objSendMail, Flds

	on error resume Next
	
	Const cdoSendUsingMethod		= "http://schemas.microsoft.com/cdo/configuration/sendusing" 
	Const cdoSendUsingPort			= 2 
	Const cdoSMTPServer				= "http://schemas.microsoft.com/cdo/configuration/smtpserver" 
	Const cdoSMTPServerPort			= "http://schemas.microsoft.com/cdo/configuration/smtpserverport"
	Const cdoSMTPConnectionTimeout	= "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout" 
	Const cdoSMTPAccountName		= "http://schemas.microsoft.com/cdo/configuration/smtpaccountname" 
	Const cdoSMTPAuthenticate		= "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate" 
	Const cdoBasic					= 1 
	Const cdoSendUserName			= "http://schemas.microsoft.com/cdo/configuration/sendusername" 
	Const cdoSendPassword			= "http://schemas.microsoft.com/cdo/configuration/sendpassword" 


	' SMTP Configuration 
	set objConfig = createobject("CDO.Configuration") 
	Set Flds = objConfig.Fields 
	With Flds 
		.Item(cdoSendUsingMethod) = cdoSendUsingPort 
		.Item(cdoSMTPServer) = "mail-002.smileh.co.kr" 
		.Item(cdoSMTPServerPort) = 25 
		.Item(cdoSMTPAuthenticate) = cdoBasic 
		.Item(cdoSendUserName) = "kfba@kfba.smileh.co.kr"
		.Item(cdoSendPassword) = "kfba2580"
		.Update
	End With 
	'이미지 경로 일괄 변경.
	strBody = replace(strBody, FRONT_ROOT_DIR & "_skin/mail/images/", g_host & "/_skin/mail/images/")
	
	Set objSendMail			= Server.CreateObject("CDO.Message")
	With objSendMail 
		.BodyPart.Charset = "ks_c_5601-1987" 
		.Configuration = objConfig 
		'''.MimeFormatted = false 
		.From		= strFrom
		.To			= strTo
		.Subject	= strSubject
		.HTMLBody	= strBody
		if LEN(attachPath)>0 then
			.AddAttachment attachPath
		end if

		.fields.update 
		
		.Send
	End With
	Set objSendMail = Nothing

	if err.number <> 0 then
		result = replace(replace(replace(err.description,vbCrLf,""),vbCr,""),vbLf,"")
	else
		result = ""
	end if

	MailSend = result

end function

'** ---------------------------------------------------------------------------
' 함 수 명 : ReadFile(strFileName)
' 인  자 : 1. strFileName : 파일명
' 목    적 : 파일 업로드 후 결과 리턴
' 플 로 우 :
' 검    수 :
' 생 성 일 : 
' 수    정 :
'** ---------------------------------------------------------------------------
function ReadFile(strFileName)
	Dim strTemp, objFS, objFL
	Set objFS = CreateObject("Scripting.FileSystemObject")

	Set objFL = objFS.OpenTextFile( strFileName )
	Do While Not objFL.AtEndOfStream
		strTemp = strTemp & objFL.ReadLine
		strTemp = strTemp & vbCrLf
	Loop
	objFL.Close	: Set objFS = Nothing
	ReadFile = strTemp

end Function


Function arrySort(TmpArr,TmpStr)

	Dim arr : arr = Split(TmpArr,TmpStr)
	For i = 0 To UBound(arr) '0부터 배열에 있는 요소의 갯수만큼 루프를 돈다.
		For j = 1 To UBound(arr) '1부터 배열에 있는 요소의 갯수만큼 루프를 돈다.
			If arr(j-1) > arr(j) Then '앞 요소의 값이 뒷 요소보다 크면 값을 바꾼다.
				temp = arr(j-1) 
				arr(j-1) = arr(j)
				arr(j) = temp
			End If
		Next 
	Next 

	For i = 0 To UBound(arr)
		response.write(arr(i))
		If i < UBound(arr) Then 
			response.write(", ")
		Else
			response.write("&nbsp;")
		End If
	Next 
End Function


'------------------------------------------------------------------------------------
' 기초코드 리스트 셀렉트
'------------------------------------------------------------------------------------
Dim common_code_arrList
Dim common_code_cntList : common_code_cntList = -1
Sub common_code_list(Idx)
	SET objRs	= Server.CreateObject("ADODB.RecordSet")
	SET objCmd	= Server.CreateObject("ADODB.Command")

	SQL = "SELECT " &_
	"	 [Idx] " &_
	"	,[Name] " &_
	"	,[Order] " &_
	"FROM [dbo].[SP_COMM_CODE2] " &_
	"WHERE [PIdx] = ? " &_
	"AND [UsFg] = 0 " &_
	"ORDER BY [Order] ASC , [Idx] DESC "

	call cmdopen()
	with objCmd
		.CommandText = SQL
		.Parameters.Append .CreateParameter( "@PIdx" ,adInteger , adParamInput , 0, Idx )
		set objRs = .Execute
	End with
	call cmdclose()
	CALL setFieldIndex(objRs, "CCODE")
	If NOT(objRs.BOF or objRs.EOF) Then
		common_code_arrList = objRs.GetRows()
		common_code_cntList = UBound(common_code_arrList, 2)
	End If
	objRs.close	: Set objRs = Nothing
End Sub

'** ---------------------------------------------------------------------------
' 함 수 명 : RandomNumber(NumberLength,NumberString)
' 인  자 : 1. NumberLength : 출력자리수 2. NumberString : 임의의 문자로 생성
' 목    적 : 난수생성 리턴
' 플 로 우 :
' 검    수 :
' 생 성 일 : 
' 수    정 :
'** ---------------------------------------------------------------------------
Function RandomNumber(NumberLength,NumberString)

	Const DefaultString = "ABCDEFGHIJKLMNOPQRSTUVXYZ1234567890"
	Dim nCount,RanNum,nNumber,nLength

	Randomize
	If NumberString = "" Then 
		NumberString = DefaultString
	End If

	nLength = Len(NumberString)

	For nCount = 1 To NumberLength
	nNumber = Int((nLength * Rnd)+1)
	RanNum = RanNum & Mid(NumberString,nNumber,1)
	Next

	RandomNumber = RanNum
End Function


'이미지 사이즈 리턴
Class ImageClass
	   
	   Private m_Width
	   Private m_Height
	   Private m_ImageType
	   Private BinFile

	   Private BUFFERSIZE
	   Private objStream

	   Private Sub class_initialize()
	   	   	   
	   	   BUFFERSIZE = 65535

	   	   ' Set all properties to default values
	   	   m_Width	   = 0
	   	   m_Height	   = 0
	   	   m_Depth	   = 0
	   	   m_ImageType = Null

	   	   Set objStream = Server.CreateObject("ADODB.Stream")

	   End Sub

	   Private Sub class_terminate()

	   	   Set objStream = Nothing

	   End Sub

	   Public Property Get Width()
	   	   Width = m_Width
	   End Property

	   Public Property Get Height()
	   	   Height = m_Height
	   End Property

	   Public Property Get ImageType()
	   	   ImageType = m_ImageType
	   End Property
	   
	   Private Function Mult(lsb, msb)
	   	   Mult = lsb + (msb * CLng(256))
	   End Function

	   Private Function BinToAsc(ipos)
	   	   BinToAsc = AscB(MidB(BinFile, (ipos+1), 1))	   
	   End Function 
	   
	   Public Sub LoadFilePath(strPath)
	   	   If InStr(strPath, ":") = 0 Then 
	   	   	   strPath = Server.MapPath(strPath)
	   	   End If 
	   	   
	   	   objStream.Open
	   	   objStream.LoadFromFile(strPath)
	   	   BinFile = objStream.ReadText(-1)

	   End Sub 

	   Public Sub LoadBinary(BinaryFile)

	   	   BinFile = BinaryFile
	   	   
	   End Sub 
	   	   
	   Public Sub ImageRead
	   	   
	   	   If  BinToAsc(0) = 137 And BinToAsc(1) = 80 And BinToAsc(2) = 78 Then
	   	   	   ' this is a PNG file
	   	   	   m_ImageType = "png"

	   	   	   ' get bit depth
	   	   	   Select Case BinToAsc(25)
	   	   	   	   Case 0
	   	   	   	   ' greyscale
	   	   	   	   	   Depth = BinToAsc(24)
	   	   	   	   Case 2
	   	   	   	   ' RGB encoded
	   	   	   	   	   Depth = BinToAsc(24) * 3
	   	   	   	   Case 3
	   	   	   	   ' Palette based, 8 bpp
	   	   	   	   	   Depth = 8
	   	   	   	   Case 4
	   	   	   	   ' greyscale with alpha
	   	   	   	   	   Depth = BinToAsc(24) * 2
	   	   	   	   Case 6
	   	   	   	   ' RGB encoded with alpha
	   	   	   	   	   Depth = BinToAsc(24) * 4
	   	   	   	   Case Else	   
	   	   	   	   ' This value is outside of it's normal range, so we'll assume that 
'this is not a valid file
	   	   	   	   	   m_ImageType = Null
	   	   	   End Select

	   	   	   If not IsNull(m_ImageType) Then
	   	   	   	   ' if the image is valid then
        
	   	   	   	   ' get the width
	   	   	   	   m_Width = Mult(BinToAsc(19), BinToAsc(18))
           
	   	   	   	   ' get the height
	   	   	   	   m_Height = Mult(BinToAsc(23), BinToAsc(22))
	   	   	   End If
	   	   End If 

	   	   If BinToAsc(0) = 71 And BinToAsc(1) = 73 And BinToAsc(2) = 70 Then
	   	   	   ' this is a GIF file
	   	   	   m_ImageType = "gif"
        
	   	   	   ' get the width
	   	   	   m_Width = Mult(BinToAsc(6), BinToAsc(7))
        
	   	   	   ' get the height
	   	   	   m_Height = Mult(BinToAsc(8), BinToAsc(9))
        
	   	   	   ' get bit depth
	   	   	   m_Depth = (BinToAsc(10) And 7) + 1
	   	   End If
    
	   	   If BinToAsc(0) = 66 And BinToAsc(1) = 77 Then
	   	   	   ' this is a BMP file
    
	   	   	   m_ImageType = "bmp"
        
	   	   	   ' get the width
	   	   	   m_Width = Mult(BinToAsc(18), BinToAsc(19))
	           
	                   	    ' get the height
	   	   	   m_Height = Mult(BinToAsc(22), BinToAsc(23))
        
	   	   	   ' get bit depth
	   	   	   m_Depth = BinToAsc(28)
	   	   End If
	   
	   
	   	   If IsNull(m_ImageType) Then
	   	   	   ' if the file is not one of the above type then
	   	   	   ' check to see if it is a JPEG file
	   	   	   Dim lPos : lPos = 0
	   	   	   	   	   	   	   	   
	   	   	   Do
	   	   	   	   ' loop through looking for the byte sequence FF,D8,FF
	   	   	   	   ' which marks the begining of a JPEG file
	   	   	   	   ' lPos will be left at the postion of the start
	   	   	   	   If (BinToAsc(lPos) = &HFF And BinToAsc(lPos + 1) = &HD8 _  
	   	   	   	   	    And BinToAsc(lPos + 2) = &HFF) _
	   	   	   	   	    Or (lPos >= BUFFERSIZE - 10) Then Exit Do
	   	   	   	   
	   	   	   	   	   ' move our pointer up
	   	   	   	   	   lPos = lPos + 1
	   	   	   	   
	   	   	   	   	   ' and continue
	   	   	   Loop
	   	   	   	   
	   	   	   lPos = lPos + 2
	   	   	   If lPos >= BUFFERSIZE - 10 Then Exit Sub
	   	   	   
	   	   	   
	   	   	   Do
	   	   	   	   ' loop through the markers until we find the one 
	   	   	   	   ' starting with FF,C0 which is the block containing the 
	   	   	   	   ' image information
	   	   	   	   
	   	   	   	   Do
	   	   	   	   	   ' loop until we find the beginning of the next marker
	   	   	   	   	   If BinToAsc(lPos) = &HFF And BinToAsc(lPos + 1) _
	   	   	   	   	   	   <> &HFF Then Exit Do
	   	   	   	   	   	   lPos = lPos + 1
	   	   	   	   	   	   If lPos >= BUFFERSIZE - 10 Then Exit Sub
	   	   	   	   Loop
	   	   	   	   
	   	   	   	   ' move pointer up
	   	   	   	   lPos = lPos + 1
	   	   	   	   
	   	   	   	   If  (BinToAsc(lPos) >= &HC0 And BinToAsc(lPos) <= &HC3) Or _
	   	   	   	   (BinToAsc(lPos) >= &HC5 And BinToAsc(lPos) <= &HC7) Or _
	   	   	   	   (BinToAsc(lPos) >= &HC9 And BinToAsc(lPos) <= &HCB) Or _
	   	   	   	   (BinToAsc(lPos) >= &HCD And BinToAsc(lPos) <= &HCF) Then
	   	   	   	   	   Exit Do 
	   	   	   	   End If 

	   	   	   	   ' otherwise keep looking
	   	   	   	   lPos = lPos + Mult(BinToAsc(lPos + 2), BinToAsc(lPos + 1))
	   	   	   	   	   
	   	   	   	   ' check for end of buffer
	   	   	   	   If lPos >= BUFFERSIZE - 10 Then Exit Sub
	   	   	   	   	   
	   	   	   Loop
	   	   	   	   
	   	   	   ' If we've gotten this far it is a JPEG and we are ready
	   	   	   ' to grab the information.
	   	   	   	   
	   	   	   m_ImageType = "jpg"
	   	   	   	   
	   	   	   ' get the height
	   	   	   m_Height = Mult(BinToAsc(lPos + 5), BinToAsc(lPos + 4))
	   	   	   	   
	   	   	   ' get the width
	   	   	   m_Width = Mult(BinToAsc(lPos + 7), BinToAsc(lPos + 6))
	   	   	   	   
	   	   	   ' get the color depth
	   	   	   m_Depth = BinToAsc(lPos + 8) * 8
	   	   	   	   
	   	   End If
	   End Sub 
	   
End Class

Sub DeleteFile(basePath, filePath)
  Set fso = CreateObject("Scripting.FileSystemObject")
  If (fso.FileExists(basePath & filePath)) Then
    fso.deleteFile(basePath & filePath)
  End If
  Set fso = Nothing
End Sub

Sub DeleteFileNotPath(fullPath)
  Set fso = CreateObject("Scripting.FileSystemObject")
  If (fso.FileExists(fullpath)) Then
    fso.deleteFile(fullPath)
  End If
  Set fso = Nothing
End Sub
%>