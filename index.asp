<!-- #include file = "./_lib/header.asp" -->
<!-- #include file = "./_lib/template.class.asp" -->
<!-- #include file = "_lib/pront.common.asp" -->
<%
Dim boardKey   : boardKey   = 1  ' 공지사항 IDX
Dim galleryKey : galleryKey = 14 ' 갤러리 IDX

Call Expires()
Call dbopen()
	'Call getList()
Call dbclose()


dim ntpl
set ntpl = new SkyTemplate
ntpl.setBlockErrorCheck(false)
ntpl.setTplDir( FRONT_ROOT_DIR & TPL_DIR_FOLDER )

ntpl.setFile array( _
	 array("HEADER" , "_inc/new_header.html") _
	,array("MAIN"   , "main/main.html") _
	,array("FOOTER" , "_inc/footer.html") _
), ""

' 카드 반복
Call ntpl.setBlock("MAIN", array("CARD_LOOP"))

Dim cardArr(9, 2)

' (x, 0) : img
' (x, 1) : title
' (x, 2) : text
cardArr(0, 0) = "01"
cardArr(0, 1) = "커피바리스타"
cardArr(0, 2) = "커피바리스타 응시 접수/안내"
cardArr(1, 0) = "01"
cardArr(1, 1) = "라떼아트/핸드드립"
cardArr(1, 2) = "라떼아트/핸드드립 응시 접수/안내"
cardArr(2, 0) = "02"
cardArr(2, 1) = "와인소믈리에"
cardArr(2, 2) = "와인소믈리에 응시 접수/안내"
cardArr(3, 0) = "02"
cardArr(3, 1) = "워터마스터소믈리에"
cardArr(3, 2) = "워터마스터소믈리에 응시 접수/안내"
cardArr(4, 0) = "03"
cardArr(4, 1) = "믹솔로지스트"
cardArr(4, 2) = "믹솔로지스트 응시 접수/안내"
cardArr(5, 0) = "03"
cardArr(5, 1) = "외식경영관리사"
cardArr(5, 2) = "외식경영관리사 응시 접수/안내"
cardArr(6, 0) = "04"
cardArr(6, 1) = "식음료관리사"
cardArr(6, 2) = "식음료관리사 응시 접수/안내"
cardArr(7, 0) = "04"
cardArr(7, 1) = "외식실무영어"
cardArr(7, 2) = "외식실무영어 응시 접수/안내"
cardArr(8, 0) = "05"
cardArr(8, 1) = "외식실무일본어"
cardArr(8, 2) = "외식실무일본어 응시 접수/안내"
cardArr(9, 0) = "05"
cardArr(9, 1) = "쇼콜라띠에"
cardArr(9, 2) = "쇼콜라띠에 응시 접수/안내"

For i = 0 To UBound(cardArr, 1)
  ntpl.setBlockReplace array( _
    array("card_img", cardArr(i, 0)) _
    ,array("card_title", cardArr(i, 1)) _
    ,array("card_text", cardArr(i, 2)) _
  ), ""
  ntpl.tplParseBlock("CARD_LOOP")
Next

ntpl.tplAssign array(   _
	 array("imgDir", TPL_DIR_IMAGES ) _
	,array("boardKey", boardKey) _
	,array("galleryKey", galleryKey) _
), ""

'// 예제에서 { 마크 사용을 위한 것
ntpl.tplAssign "m", "{"

ntpl.tplParse()  '// 설정한 템플릿 파일처리
ntpl.tplPrint()  '// 출력

set ntpl = Nothing


Sub getList()
	SET objRs	= Server.CreateObject("ADODB.RecordSet")
	SET objCmd	= Server.CreateObject("ADODB.Command")
	
	SQL = "SET NOCOUNT ON; " &_
	"DECLARE @BoardKey INT,@galleryKey INT;" &_
	"SET @BoardKey   = ?; " &_
	"SET @galleryKey = ?; " &_

	"SELECT TOP 5 " &_
	"	 [Idx] " &_
	"	,[Title] " &_
	"	,CONVERT(VARCHAR(10),[Indate],111) AS [Indate] " &_
	"FROM [smileh_kfba].[dbo].[SP_BOARD] " &_
	"WHERE [BoardKey] = @BoardKey AND [Dellfg] = 0 " &_
	"ORDER BY [Idx] DESC; " &_

	"SELECT TOP 4 " &_
	"	 [Idx] " &_
	"	,[Title] " &_
	"	,[File] " &_
	"	,CONVERT(VARCHAR(10),[Indate],111) AS [Indate] " &_
	"FROM [smileh_kfba].[dbo].[SP_BOARD] " &_
	"WHERE [BoardKey] = @galleryKey AND [Dellfg] = 0 AND [File] <> '' AND [File] is not null " &_
	"ORDER BY [Idx] DESC; " &_

	"SELECT TOP 5 " &_
	"	 A.[Idx] " &_
	"	,A.[CodeIdx] " &_
	"	,CONVERT(varchar(10),A.[StartDate],23) AS [StartDate] " &_
	"	,CONVERT(varchar(10),A.[EndDate],23) AS [EndDate] " &_
	"	,ISNULL( A.[MaxNumber] , 0 ) AS [MaxNumber] " &_
	"	,A.[Kind] " &_
	"	,A.[Class] " &_
	"	,CONVERT(VARCHAR(10),A.[OnData],111) AS [OnData] " &_
	"	,( SELECT [Name] FROM [dbo].[SP_COMM_CODE2] WHERE [Idx] = A.[CodeIdx] ) AS [ProgramName] " &_
	"FROM [dbo].[SP_PROGRAM] A " &_
	"LEFT JOIN ( " &_
	"	SELECT " &_
	"		 [ProgramIdx] " &_
	"		,COUNT(*) AS [CNT_APP] " &_
	"	FROM [dbo].[SP_PROGRAM_APP] " &_
	"	WHERE [State] != 2 " &_
	"	GROUP BY [ProgramIdx] " &_
	") B ON(A.[Idx] = B.[ProgramIdx] ) " &_
	"WHERE [Dellfg] = 0 " &_
	"ORDER BY A.[OnData] DESC; "


	call cmdopen()
	with objCmd
		.CommandText = SQL
		.Parameters.Append .CreateParameter( "@BoardKey"   ,adInteger , adParamInput ,  0  , BoardKey )
		.Parameters.Append .CreateParameter( "@galleryKey" ,adInteger , adParamInput ,  0  , galleryKey )

		set objRs = .Execute
	End with
	call cmdclose()
	'공지사항 리스트
	CALL setFieldIndex(objRs, "NT")
	If NOT(objRs.BOF or objRs.EOF) Then
		arrNoti = objRs.GetRows()
		cntNoti = UBound(arrNoti, 2)
	End If
	'갤러리
	set objRs = objRs.NextRecordset
	CALL setFieldIndex(objRs, "GL")
	If Not(objRs.Eof or objRs.Bof) Then		
		arrgallery = objRs.GetRows()
		cntgallery = UBound(arrgallery, 2)
	End If
	'응시일정
	set objRs = objRs.NextRecordset
	CALL setFieldIndex(objRs, "AP")
	If Not(objRs.Eof or objRs.Bof) Then		
		arrAppl = objRs.GetRows()
		cntAppl = UBound(arrAppl, 2)
	End If
	Set objRs = Nothing
End Sub
%>