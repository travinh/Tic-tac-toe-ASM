TITLE: FinalExtra.asm

;Program Description:  I finished the game tic-tac-toe 5x5 for extra credit. I do it seperately from the 3x3 TTT because I dont want to mess
     ; with my final. Thank you Diane for helping me throughout the class. The grade is not important, and I really learned a lot from this course
;Author: Vinh Van Tran
;Creation day: 12/08/2016 

Include Irvine32.inc

.data							   ; the data segment
	
	promptWelcome	BYTE "                   Welcome to tic-tac-toe game(5x5)",0h
	promptStar		BYTE "*************************************************************************",0h
	promptWelcome1	BYTE "If you can get 5 on a row (by column, row or cross), then you win.",0h
	promptWelcome2	BYTE "Now, let's play!",0h
	beginner		BYTE	0
	NumberOfGame	BYTE	?
	Player1Won		BYTE	?
	Player2Won		BYTE	?
	ComputerWon		BYTE	?
	NumberofDrawGame	BYTE	?
	WhichOption		BYTE	?		
	
.data?
	

.code							   ; start code segment

	
	WhoPlayFirst			PROTO
	PlayTheGame				PROTO,	TypePlay1:BYTE, WhoGoFirst: BYTE
	DisplayGame				PROTO, Arr1:ptr DWORD, LengthOfArr1: BYTE, _WhoGo:BYTE
	PlayerVsComp			PROTO, WhoGo:BYTE, NumberOfTurn:BYTE, Arr2:ptr DWORD, LengthOfArr2:BYTE
	CheckWinner				PROTO, Arr3: ptr DWORD, _WhoGoFirst: BYTE, LengthOfArr3:BYTE
	AskPlayGain				PROTO
	DisplayGameInfo			PROTO, NumOfGame:BYTE, Player1Win:BYTE, Player2Win:BYTE, GameDraw:BYTE, TypePlay:BYTE
	DisplayGame2			PROTO,	Arr2:ptr DWORD, LengthOfArr2: BYTE
	Player1AgainstPlayer2	PROTO, NumberOfTurn4:BYTE, Arr4:ptr DWORD, LengthOfArr4:BYTE
	CompAgainstComp			PROTO, Arr5:ptr DWORD, LengthOfArr5:BYTE, NumberOfTurn5:BYTE
	DisplayFinalResult		PROTO,		Arr6:ptr DWORD, LengthOfArr6: BYTE, _TypeWin:BYTE
	MainMenu				PROTO


main PROC 

		mov		edx, OFFSET promptWelcome
		call	WriteString
		call	crlf
		mov		edx, OFFSET promptStar
		call	WriteString
		call	crlf
		mov		edx, OFFSET promptWelcome1
		call	WriteString
		call	crlf
		mov		edx, OFFSET promptWelcome2
		call	WriteString
		call	crlf
		call	WaitMsg

StartTicTacToe:										

		mov		eax,0						; reset everything
		mov		ebx,0
		mov		ecx,0
		mov		edx,0
		mov		esi,0
	
		mov		NumberOfGame,0
		mov		NumberofDrawGame,0
		mov		Player1Won,0
		mov		Player2Won,0
		mov		ComputerWon,0
	INVOKE		MainMenu						;display menu
	cmp			al,1
	je			PlayerVsComputer
	cmp			al,2
	je			Player1VsPlayer2
	cmp			al,3
	je			ComputerVsComputer
	jmp			here					;exit



	;----------------------Player Vs Computer ---------------------------
PlayerVsComputer:
		mov		eax,0
		mov		WhichOption,1		; option 1: Player Vs Computer
		call	clrscr
		call	Randomize
		inc		NumberOfGame		; track how many game have played
		INVOKE	WhoPlayFirst
		mov		beginner,al
		INVOKE	PlayTheGame,WhichOption,beginner
		cmp		al,0
		je		TheGameDraw
		cmp		al,1
		je		PlayerWonGame
		inc		ComputerWon
		jmp		PlayAgainOrNot
	TheGameDraw:
		inc		NumberofDrawGame
		jmp		PlayAgainOrNot
	PlayerWonGame:
		inc		Player1Won

	PlayAgainOrNot:
		INVOKE	AskPlayGain
		cmp		al,89
		je		PlayerVsComputer	
;if player does not want to play anymore, then display infomation
	INVOKE		DisplayGameInfo,NumberOfGame,Player1Won,ComputerWon,NumberofDrawGame,WhichOption
	call		WaitMsg
	jmp			StartTicTacToe

	;------------------Player1 Against Player2--------------------
Player1VsPlayer2:	
		mov		eax,0
		mov			WhichOption,2		; option 2: Player Vs Player
		call		clrscr
		inc			NumberOfGame
		INVOKE		PlayTheGame,WhichOption,beginner
		cmp		al,0
		je		TheGameDraw1
		cmp		al,1
		je		Player1WonGame1
		inc		Player2Won
		jmp		PlayAgainOrNot1
	TheGameDraw1:
		inc		NumberofDrawGame
		jmp		PlayAgainOrNot1
	Player1WonGame1:
		inc		Player1Won

	PlayAgainOrNot1:
		INVOKE	AskPlayGain
		cmp		al,89
		je		Player1VsPlayer2	
;if player does not want to play anymore, then display infomation
	INVOKE		DisplayGameInfo,NumberOfGame,Player1Won,Player2Won,NumberofDrawGame,WhichOption
	call		WaitMsg
	jmp			StartTicTacToe

	;---------------Computer Against Computer------------------------
ComputerVsComputer:
		mov		eax,0
		mov			WhichOption,3
		call		clrscr
		INVOKE		PlayTheGame,WhichOption,beginner
	PlayAgainOrNot2:
		INVOKE	AskPlayGain
		cmp		al,89
		je		ComputerVsComputer
		jmp			StartTicTacToe

	here:
	exit
main ENDP


;*********************************************************************************************************************************
;*********************************************************************************************************************************
;*********************************************************************************************************************************
WhoPlayFirst PROC
; this is WhoPlayFirst procedures
; receive:nothing
; return: eax so who play first, 0 : computer, 1: player
; require: nothing
.data

	promptComputer	BYTE "Computer go first!",0h
	promptPlayer	BYTE "Player go first!",0h

.code

	mov	eax,2
	call	RandomRange			
;0 then computer go first, 1 player go first
	cmp		ax,0
	jne		PlayerGoFirst
	mov		edx, OFFSET promptComputer
	call	WriteString
	jmp		FinishWhoPlayFirst
PlayerGoFirst:
	mov		edx, OFFSET promptPlayer
	call	WriteString
	

FinishWhoPlayFirst:
	call	crlf
	call	WaitMsg
	ret
WhoPlayFirst ENDP
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------

PlayTheGame	PROC,	TypePlay1:BYTE, WhoGoFirst: BYTE
LOCAL	Array1:ptr DWORD,	LengthOfArray1: BYTE, TurnNumber:BYTE

; this is PlayTheGame procedures
; receive: TypePlay1 and WhoGoFirst
; return: nothing
; require: nothing

.data
	buffer	BYTE	45,45,45,45,45
	RowSize	= ($ - buffer)
		BYTE		45,45,45,45,45
		BYTE		45,45,45,45,45
		BYTE		45,45,45,45,45
		BYTE		45,45,45,45,45

	ColSize=5

.code
	cmp	TypePlay1,2
	je	PlayerVsPlayer
	cmp	TypePlay1,3
	je	CompVSComp

;-----------------Player Vs. Computer----------------------
		mov		TurnNumber,0
		mov		cl, (RowSize*ColSize)
		mov		LengthOfArray1, cl
		mov		eax, OFFSET buffer
		mov		Array1, eax
		call	clrscr
		INVOKE	DisplayGame,Array1, LengthOfArray1, WhoGoFirst
	

		INVOKE	PlayerVsComp, WhoGoFirst,TurnNumber, Array1, LengthOfArray1

		mov		cl,LengthOfArray1
		mov		esi,OFFSET buffer
		LoopFill:
			mov		bl,45
			mov		[esi],bl
			inc		esi
		Loop	LoopFill
		jmp		FinishGameHere

;-----------------------Player Vs. Player------------------------------
PlayerVsPlayer:
		mov		TurnNumber,0
		mov		cl,(RowSize*ColSize)
		mov		LengthOfArray1, cl
		mov		eax, OFFSET buffer
		mov		Array1, eax
		call	clrscr
		INVOKE	DisplayGame2,Array1,LengthOfArray1
		INVOKE	Player1AgainstPlayer2, TurnNumber, Array1, LengthOfArray1
		mov		cl,LengthOfArray1
		mov		esi,OFFSET buffer
		LoopFill1:
			mov		bl,45
			mov		[esi],bl
			inc		esi
		Loop	LoopFill1
		jmp		FinishGameHere

;-------------------Comp Vs. Comp----------------------------------
CompVSComp:
		mov			TurnNumber,0
		mov			cl,(RowSize*ColSize)
		mov			LengthOfArray1, cl
		mov			eax, OFFSET buffer
		mov			Array1, eax
		call		clrscr
		INVOKE		DisplayGame2,Array1,LengthOfArray1
		INVOKE		CompAgainstComp,Array1,LengthOfArray1, TurnNumber
		mov		cl,LengthOfArray1
		mov		esi,OFFSET buffer
		LoopFill2:
			mov		bl,45
			mov		[esi],bl
			inc		esi
		Loop	LoopFill2
		
	FinishGameHere:
	ret
PlayTheGame	ENDP

;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------

DisplayGame	PROC, Arr1:ptr DWORD, LengthOfArr1: BYTE, _WhoGo:BYTE
; this is DisplayGame procedures
; receive: Arr1, LengthOfArr1, and _WhoGO
; return: nothing
; require: nothing

	mov		esi,Arr1
	mov		cl, LengthOfArr1
	
	LoopDisplay:
		mov		al,[esi]
		cmp		_WhoGo,1
		jne		CompGoFirst
		cmp		al,88				; player using X
		jne		GoPrintChar
		mov		dl,al
		mov		eax, blue + ( white * 16)		 	; blue on white	
		call	SetTextColor
		mov		eax,0
		mov		al,dl
		jmp		GoPrintChar
CompGoFirst:						; player using O
		cmp		al,79
		jne		GoPrintChar
		mov		dl,al
		mov		eax,white + ( blue * 16)
		call	SetTextColor
		mov		eax,0
		mov		al,dl

GoPrintChar:
		call	WriteChar
		mov		eax,lightGray + ( black * 16)
		call	SetTextColor
		inc		esi
		cmp		cl,21
		je		GoToNewLine
		cmp		cl,16
		je		GoToNewLine
		cmp		cl,11
		je		GoToNewLine
		cmp		cl,6
		je		GoToNewLine
		cmp		cl,1
		je		FinishDisplay
		mov		al,124
		call	WriteChar
	Loop	LoopDisplay
	jmp		FinishDisplay
GoToNewLine:
		call	crlf
	Loop	LoopDisplay

	FinishDisplay:

	call	crlf
	call	crlf

	ret
DisplayGame	ENDP

;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
PlayerVsComp	PROC, WhoGo:BYTE, NumberOfTurn:BYTE, Arr2:ptr DWORD, LengthOfArr2:BYTE
LOCAL	ChooseRow:BYTE,		ChooseCol:BYTE

; this is PlayerVsComp procedures
; receive: Arr2, LengthOfArr2 , Whogo, numberofturn
; return: nothing
; require: nothing

.data
	RowSize = 5
	row_index = 2
	col_index = 2
	promptSquare	BYTE "Please select the square that you want to play by select row and column!",0h
	promptRow		BYTE "Select Row (1,2 or 3): ",0h
	promptCol		BYTE "Select Column (1,2, or 3): ",0h
	promptTurn1		BYTE "Computer Turn......",0h
	promptTurn2		BYTE "Your Turn.......",0h
	
	promptAlreadyTaken	BYTE	"The square that you chose already taken, please select another square",0h
	promptDraw		BYTE	"Game Draw!",0h
.code
	
GameStartHere:
	
	inc		NumberOfTurn
	cmp		WhoGo,0
	je		ComputerGoFirst
	jmp		PlayerGoFirst

	;-------------------------Computer Turn-------------------------------------------------
ComputerGoFirst:
	call	clrscr											; clear screen every move
	mov		edx, OFFSET	promptTurn1
	call	WriteString
	call	Crlf
	mov		esi,Arr2						; esi keep base offset
	add		esi,RowSize*row_index			; middle place
	add		esi,col_index
	mov		al,[esi]
	cmp		al,45
	je		GetMiddleChoice
;if middle is chosen already
ChooseSpot:
	mov		eax,5
	call	RandomRange	
	mov		ChooseRow,al
	mov		eax,5
	call	RandomRange		
	mov		ChooseCol,al
TakeMove:
	mov		esi,Arr2
	mov		al, RowSize
	mov		bl,ChooseRow
	mul		bl
	add		al,ChooseCol
	add		esi,eax
	mov		al,[esi]
	cmp		al,45
	jne		ChooseSpot

TakeO:
	cmp		WhoGo,0
	je		TakeX			; computer go first then take x
	mov		al,79			; 79= 0
	mov		[esi],al
	jmp		FinishTurn

TakeX:
	mov		al,88
	mov		[esi],al
	INVOKE	DisplayGame,Arr2, LengthOfArr2,WhoGo
	INVOKE	CheckWinner, Arr2,WhoGo, LengthOfArr2
	cmp		al,0
	jne		FinishGame
	cmp		NumberOfTurn,13
	je		DrawGame
	jmp		PlayerGoFirst

GetMiddleChoice:
	jmp		TakeO

	;-----------------Player Turn------------------------- 
PlayerGoFirst:
	
	mov		edx, OFFSET	promptTurn2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET promptSquare
	call	WriteString
	call	crlf
TakeRow:
	mov		edx, OFFSET promptRow
	call	WriteString
	call	ReadInt
	call	crlf
	cmp		eax,5
	ja		TakeRow
	cmp		eax,1
	jb		TakeRow
	dec		al
	mov		ChooseRow,al
TakeCol:
	mov		edx,OFFSET promptCol
	call	WriteString
	call	ReadInt
	call	crlf
	cmp		eax,5
	ja		TakeCol
	cmp		eax,1
	jb		TakeCol
	dec		al
	mov		ChooseCol,al

ChooseSpot2:
	mov		esi,Arr2
	mov		al, RowSize
	mov		bl,ChooseRow
	mul		bl
	add		al,ChooseCol
	add		esi,eax
	mov		al,[esi]
	cmp		al,45
	jne		AlreadyTaken
	cmp		WhoGo,1				; player go first if =1, the take x
	je		TakeX2
TakeO2:
	mov		al,79
	mov		[esi],al
	jmp		FinishTurn
TakeX2:
	mov		al,88
	mov		[esi],al
	INVOKE	DisplayGame,Arr2, LengthOfArr2,WhoGo
	INVOKE	CheckWinner, Arr2,WhoGo,LengthOfArr2
	cmp		al,0
	jne		FinishGame
	cmp		NumberOfTurn,13
	je		DrawGame
	jmp		ComputerGoFirst

AlreadyTaken:
	mov		edx, OFFSET promptAlreadyTaken
	call	WriteString
	call	crlf
	jmp		PlayerGoFirst

	;--------------------Finish 1 Turn----------------------------
	FinishTurn:
;after three turn, we have to check if there is a winner
	INVOKE	DisplayGame,Arr2, LengthOfArr2,WhoGo
	cmp		NumberOfTurn,5
	jb		GameStartHere
CheckWhoWin:
	INVOKE	CheckWinner, Arr2,WhoGo,LengthOfArr2
	cmp		al,0
	jne		FinishGame
	jmp		GameStartHere
	
DrawGame:
	
	mov		edx,OFFSET promptDraw
	call	WriteString
	call	Crlf
	
	FinishGame:
	ret
PlayerVsComp	ENDP

;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------

CheckWinner		PROC, Arr3: ptr DWORD, _WhoGoFirst: BYTE, LengthOfArr3:BYTE
LOCAL		row_index1:BYTE,	col_index1:BYTE, CheckValue:BYTE, tempIndex:BYTE, FoundWinner:BYTE, TypeWin:BYTE

; this is CheckWinner procedures
; receive: Arr3, LengthOfArr3, Whogofirst
; return: nothing
; require:  value of al (0 = not found winner, 1= player1 win, 2 = computer win or player2 win)



.data
		RowSize = 5
		promptWinner	BYTE "You Win!",0h
		promptLoser		BYTE "You Lose!",0h
		promptWinner1	BYTE "Player 1 Win!",0h
		promptWinner2	BYTE "Player 2 Win!",0h

.code
		mov		TypeWin,0
		mov		FoundWinner,0
CheckWinnerX:
		mov		CheckValue,88
CheckColumnWinner:
	mov		row_index1,0
	mov		col_index1,0
	mov		ecx,RowSize
	LoopCheck1:
		mov		esi,Arr3
		mov		al,RowSize
		mov		bl,row_index1
		mul		bl
		add		al,col_index1
		add		esi,eax
		mov		al,[esi]
		cmp		al,CheckValue
		je		CheckCol
		inc		col_index1
	Loop	LoopCheck1
	jmp		CheckRowWinner

CheckCol:
	mov		TypeWin,1
	mov		esi,Arr3
	push	ecx
	mov		dl,al				; keep the first value in dl
	mov		al,row_index1
	mov		tempIndex,al
	mov		ecx,4
	LoopCheckCol:
		
		mov		al,RowSize
		inc		row_index1
		mov		bl,row_index1
		mul		bl
		add		al,col_index1
		add		esi,eax
		mov		ebx,esi
		mov		al,[esi]
		cmp		al,dl
		jne		NotMatch1
		mov		esi,Arr3
	Loop	LoopCheckCol
	mov		esi,ebx
	cmp		CheckValue,88
	je		FoundWinnerX
	jmp		FoundWinnerO
NotMatch1:	
	mov		al,tempIndex
	mov		row_index1,al
	inc		col_index1
	pop		ecx
	Loop	LoopCheck1

	;----------------CheckRow-----------------------
CheckRowWinner:
	mov		TypeWin,2
	mov		row_index1,0
	mov		col_index1,0
	mov		ecx,RowSize
	LoopCheck2:
		mov		esi,Arr3
		mov		al,RowSize
		mov		bl,row_index1
		mul		bl
		add		al,col_index1
		add		esi,eax
		mov		al,[esi]
		cmp		al,CheckValue
		je		CheckRow
		inc		row_index1
	Loop	LoopCheck2
	jmp		CheckCrossWinner

CheckRow:
	mov		esi,Arr3
	push	ecx
	mov		dl,al				; keep the first value in dl
	mov		al,row_index1
	mov		tempIndex,al
	mov		ecx,4
	LoopCheckRow:

		mov		al,RowSize
		inc		col_index1
		mov		bl,row_index1
		mul		bl
		add		al,col_index1
		add		esi,eax
		mov		ebx,esi
		mov		al,[esi]
		cmp		al,dl
		jne		NotMatch2
		mov		esi,Arr3
	Loop	LoopCheckRow
	mov		esi,ebx
	cmp		CheckValue,88
	je		FoundWinnerX
	jmp		FoundWinnerO
NotMatch2:	
	mov		al,tempIndex
	mov		col_index1,al
	inc		row_index1
	pop		ecx
	Loop	LoopCheck2


	;-----------------------CheckCross-----------------------
CheckCrossWinner:
	mov		row_index1,0
	mov		col_index1,0

;check cross from top left
	mov		TypeWin,3
	mov		esi,Arr3
	mov		dl,[esi]			; dl keep value of base
	cmp		dl,CheckValue
	jne		NotMatch3
	mov		ecx,4
	LoopCheckCross1:
		inc		col_index1
		inc		row_index1
		mov		al,RowSize
		mov		bl,row_index1
		mul		bl
		add		al,col_index1
		add		esi,eax
		mov		al,[esi]
		cmp		al,dl
		jne		NotMatch3
		mov		esi,Arr3
	Loop	LoopCheckCross1
	cmp		CheckValue,88
	je		FoundWinnerX
	jmp		FoundWinnerO

;check cross from top right
NotMatch3:
	mov		TypeWin,4
	mov		esi,Arr3
	add		esi,4
	mov		dl,[esi]
	cmp		dl,CheckValue
	jne		NotMatch4
	mov		ecx,4
	LoopCheckCross2:
		add		esi,4
		mov		al,[esi]
		cmp		al,dl
		jne		NotMatch4
	Loop	LoopCheckCross2
	cmp		CheckValue,88
	je		FoundWinnerX
	jmp		FoundWinnerO
		
NotMatch4:
	cmp		CheckValue,79
	jne		CheckWinnerO
	jmp		FinishCheckWinner





	;-------------------------Found Winner-------------------------		
FoundWinnerX:
		
		cmp		_WhoGoFirst,0						; 0= computer go first,then computer win
		je		ComputerWinX
		cmp		_WhoGoFirst,3 
		je		PlayerVsPlayerWinner1
		cmp		_WhoGoFirst,5
		je		CompAgainstCompWin
		call	clrscr
		INVOKE	DisplayFinalResult, Arr3, LengthOfArr3,TypeWin
		mov		FoundWinner,1						; player win => FoundWinner=1
		mov		edx, OFFSET promptWinner
		call	WriteString
		call	Crlf
		jmp		FinishCheckWinner
	ComputerWinX:
		mov		FoundWinner,2						; computer win => FoundWinner=2
		call	clrscr
		INVOKE	DisplayFinalResult, Arr3, LengthOfArr3,TypeWin
		mov		edx, OFFSET promptLoser
		call	WriteString
		call	Crlf
		jmp		FinishCheckWinner
	PlayerVsPlayerWinner1:
		call	clrscr
		INVOKE	DisplayFinalResult, Arr3, LengthOfArr3,TypeWin
		mov		FoundWinner,1						; if x win, then player 1 win, then foundwinner =1
		mov		edx, OFFSET promptWinner1
		call	WriteString
		call	crlf
		jmp		FinishCheckWinner
FoundWinnerO:
		cmp		_WhoGoFirst,0						;0 = computer go first, then player win
		je		PlayerWinO
		cmp		_WhoGoFirst,3
		je		PlayerVsPlayerWinner2
		cmp		_WhoGoFirst,5
		je		CompAgainstCompWin
		call	clrscr
		INVOKE	DisplayFinalResult, Arr3, LengthOfArr3,TypeWin
		mov		FoundWinner,2						; computer win => FoundWinner=2
		mov		edx, OFFSET promptLoser
		call	WriteString
		call	Crlf
		jmp		FinishCheckWinner
	PlayerWinO:
		call	clrscr
		INVOKE	DisplayFinalResult, Arr3, LengthOfArr3,TypeWin
		mov		FoundWinner,1						; player win => FoundWinner=1
		mov		edx, OFFSET promptWinner
		call	WriteString
		call	Crlf
		jmp		FinishCheckWinner
	PlayerVsPlayerWinner2:
		call	clrscr
		INVOKE	DisplayFinalResult, Arr3, LengthOfArr3,TypeWin
		mov		FoundWinner,2					; if O win, then player 2 win, then foundwinner =2
		mov		edx,OFFSET promptWinner2
		call	WriteString
		call	Crlf
		jmp		FinishCheckWinner
CompAgainstCompWin:
		call	clrscr
		INVOKE	DisplayFinalResult, Arr3, LengthOfArr3,TypeWin
		mov		FoundWinner,1
		jmp		FinishCheckWinner

CheckWinnerO:
	mov		CheckValue,79
	jmp		CheckColumnWinner



	FinishCheckWinner:

		mov al,FoundWinner		; draw = 0, player = 1, computer win = 2
	ret
CheckWinner		ENDP
;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------

AskPlayGain	PROC

;this is AskPlayGain procedures
; receive: nothing
; return: the answer in al, Y= 89, N = 78
; require:  nothing

.data

	promptAsking1	BYTE "Do you want to play again? (Y/N) ",0h
.code

AskPlayAgain:
	mov		edx,OFFSET promptAsking1
	call	WriteString
	call	ReadChar

	cmp		al,91
	ja		ConvertToUpperCase
	jmp		CheckAnswer
ConvertToUpperCase:
	sub		al,32

CheckAnswer:
	cmp		al,89			; compare to Y (yes)
	je		FinishAsking
	cmp		al,78
	je		FinishAsking
	jmp		AskPlayAgain

	FinishAsking:
	ret
AskPlayGain	ENDP

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

DisplayGameInfo	PROC, NumOfGame:BYTE, Player1Win:BYTE, Player2Win:BYTE, GameDraw:BYTE,TypePlay:BYTE

;this is DisplayGameInfo procedures
; receive: Numberofgame, player1win, player2win, or graw game, and typeplay
; return: nothing
; require:  nothing

.data
	promptGame		BYTE "   ------Game Info------",0h
	promptGame1		BYTE "1.Number of games played: ",0h
	promptGame2		BYTE "2.How many games won by Player 1: ",0h
	promptGame31	BYTE "3.How many games won by Player 2: ",0h
	promptGame32	BYTE "3.How many games won by computer: ",0h
	promptGame4		BYTE "4.How many games resulted in a draw: ",0h

.code

	call	clrscr
	mov		eax,0						;reset eax
	mov		edx,OFFSET promptGame
	call	WriteString
	call	Crlf
	mov		edx,OFFSET promptGame1
	call	WriteString
	mov		al,NumOfGame
	call	WriteDec
	call	Crlf
	mov		edx,OFFSET promptGame2
	call	WriteString
	mov		al,Player1Win
	call	WriteDec
	call	Crlf
;check if what type of game was played (player against computer or player1 against player2)
	cmp		TypePlay,1
	jne		DisplayType2
	mov		edx,OFFSET promptGame32			; against computer
	jmp		KeepDisplayInfo
DisplayType2:								; against another player
	mov		edx,OFFSET promptGame31
KeepDisplayInfo:
	call	WriteString
	mov		al, Player2Win
	call	WriteDec
	call	Crlf
	mov		edx,OFFSET promptGame4
	call	WriteString
	mov		al, GameDraw
	call	WriteDec
	call	Crlf



	ret
DisplayGameInfo	ENDP
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

DisplayGame2	PROC,	Arr2:ptr DWORD, LengthOfArr2: BYTE

;this is DisplayGame2 procedures
; receive: Arr2, LengthOfArr2
; return: nothing
; require:  nothing

	mov		ecx,0
	mov		esi,0
	mov		esi, Arr2
	mov		cl,LengthOfArr2

	LoopDisplay2:
		mov		al,[esi]
		call	WriteChar
		inc		esi
		cmp		cl,21
		je		GoToNewLine
		cmp		cl,16
		je		GoToNewLine
		cmp		cl,11
		je		GoToNewLine
		cmp		cl,6
		je		GoToNewLine
		cmp		cl,1
		je		FinishDisplay2
		mov		al,124
		call	WriteChar
	Loop	LoopDisplay2

	GoToNewLine:
		call	crlf
		Loop	LoopDisplay2

	FinishDisplay2:
		call	crlf
		call	crlf
	ret
DisplayGame2	ENDP

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

Player1AgainstPlayer2	PROC, NumberOfTurn4:BYTE, Arr4:ptr DWORD, LengthOfArr4:BYTE
LOCAL		ChooseRow:BYTE, ChooseCol:BYTE, FlagTurn:BYTE, WhoGoFirst1:BYTE

;this is Player1AgainstPlayer2 procedures
; receive: Arr4, LengthOfArr4, numberofturn
; return: nothing
; require:  nothing

.data
	RowSize = 5
	row_index = 1
	col_index = 1
	promptSquare1		BYTE "Please select the square that you want to play by select row and column!",0h
	promptRow1			BYTE "Select Row (1,2 or 3): ",0h
	promptCol1			BYTE "Select Column (1,2, or 3): ",0h
	promptTurn11		BYTE "Player 1 turn......",0h
	promptTurn21		BYTE "Player 2 turn......",0h
	promptAlreadyTaken1	BYTE	"The square that you chose already taken, please select another square",0h
	promptDraw1		BYTE	"Game Draw!",0h

.code
		
		mov		WhoGoFirst1,3
StartPlayGameHere:
		inc		NumberOfTurn4
		mov		FlagTurn,0
;------------------Player 1 turn (X)-------------------
TakeX1:	
		mov		edx, OFFSET	promptTurn11
		call	WriteString
		call	Crlf
	TakeSquare1:
		mov		edx, OFFSET promptSquare1
		call	WriteString
		call	crlf
	TakeRow1:
		mov		edx, OFFSET promptRow1
		call	WriteString
		call	ReadInt
		call	crlf
		cmp		eax,5
		ja		TakeRow1
		cmp		eax,1
		jb		TakeRow1
		dec		al
		mov		ChooseRow,al
	TakeCol1:
		mov		edx,OFFSET promptCol1
		call	WriteString
		call	ReadInt
		call	crlf
		cmp		eax,5
		ja		TakeCol1
		cmp		eax,1
		jb		TakeCol1
		dec		al
		mov		ChooseCol,al
		cmp		FlagTurn,0
		je		ChooseSpot3X
		jmp		ChooseSpot3O

	ChooseSpot3X:
		mov		esi,Arr4
		mov		al, RowSize
		mov		bl,ChooseRow
		mul		bl
		add		al,ChooseCol
		add		esi,eax
		mov		al,[esi]
		cmp		al,45
		jne		AlreadyTaken2
		mov		al,88
		mov		[esi],al
		call	clrscr
		INVOKE	DisplayGame2,Arr4,LengthOfArr4
		INVOKE	CheckWinner, Arr4,WhoGoFirst1,LengthOfArr4
		cmp		al,0
		jne		FinishPlayerAgainstPlayerGame
		cmp		NumberOfTurn4,13
		je		DrawGame1
		jmp		TakeO1

	ChooseSpot3O:
		mov		esi,Arr4
		mov		al, RowSize
		mov		bl,ChooseRow
		mul		bl
		add		al,ChooseCol
		add		esi,eax
		mov		al,[esi]
		cmp		al,45
		jne		AlreadyTaken2
		mov		al,79
		mov		[esi],al
		call	clrscr
		INVOKE	DisplayGame2,Arr4,LengthOfArr4
		jmp		FinishTurn1


	AlreadyTaken2:
		mov		edx, OFFSET promptAlreadyTaken1
		call	WriteString
		call	crlf
		jmp		TakeSquare1

TakeO1:
		mov		edx, OFFSET promptTurn21
		call	WriteString
		call	Crlf
		inc		FlagTurn
		jmp		TakeSquare1


FinishTurn1:
	;INVOKE	DisplayGame,Arr4, LengthOfArr4,WhoGoFirst1
	cmp		NumberOfTurn4,5
	jb		StartPlayGameHere

CheckWhoWin1:
	INVOKE	CheckWinner, Arr4,WhoGoFirst1,LengthOfArr4
	cmp		al,0
	jne		FinishPlayerAgainstPlayerGame
	jmp		StartPlayGameHere

DrawGame1:
	mov		edx,OFFSET promptDraw1
	call	WriteString
	call	Crlf
			

FinishPlayerAgainstPlayerGame:

	ret
Player1AgainstPlayer2	ENDP


;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

CompAgainstComp		PROC, Arr5:ptr DWORD, LengthOfArr5:BYTE, NumberOfTurn5:BYTE
LOCAL		FlagTurn3:BYTE, WhoGoFirst3:BYTE, ChooseRow2:BYTE, ChooseCol2:BYTE

;this is CompAgainstComp procedures
; receive: Arr5, LengthOfArr5, numberofturn
; return: nothing
; require:  nothing

.data
	RowSize = 5
	row_index = 2
	col_index = 2
	promptDraw2 BYTE "Draw Game!",0h
.code
	mov		WhoGoFirst3,5
StartGameHere2:
	inc		NumberOfTurn5
	mov		FlagTurn3,0

;----------------Computer 1 Turn (x)-----------------------

TakeSquare:
	call	clrscr							; clear screen every move
	mov		esi,Arr5						; esi keep base offset
	add		esi,RowSize*row_index			; middle place
	add		esi,col_index
	mov		al,[esi]
	cmp		al,45
	je		GetMiddleChoice3
;if middle is chosen already
ChooseSpot3:
	mov		eax,5
	call	RandomRange	
	mov		ChooseRow2,al
	mov		eax,5
	call	RandomRange		
	mov		ChooseCol2,al
TakeMove3:
	mov		esi,Arr5
	mov		al, RowSize
	mov		bl,ChooseRow2
	mul		bl
	add		al,ChooseCol2
	add		esi,eax
	mov		al,[esi]	
	cmp		al,45
	jne		ChooseSpot3
	cmp		FlagTurn3,0
	je		TakeX3
	jmp		TakeO3

GetMiddleChoice3:
	cmp		FlagTurn3,0
	je		TakeX3
	jmp		TakeO3


TakeO3:
	mov		al,79			; 79= 0
	mov		[esi],al
	INVOKE	DisplayGame2,Arr5, LengthOfArr5
	mov		eax,1000
	call	Delay
	INVOKE	CheckWinner, Arr5,WhoGoFirst3,LengthOfArr5
	cmp		al,0
	jne		FinishCompVsCompGame
	jmp		FinishTurn3

TakeX3:
	mov		al,88
	mov		[esi],al
	INVOKE	DisplayGame2,Arr5, LengthOfArr5
	mov		eax,1000
	call	Delay
	INVOKE	CheckWinner, Arr5,WhoGoFirst3,LengthOfArr5
	cmp		al,0
	jne		FinishCompVsCompGame
	cmp		NumberOfTurn5,13
	je		DrawGame3
	inc		FlagTurn3				; fflagturn = 1, then will go to take 0
	jmp		TakeSquare

FinishTurn3:	
	cmp		NumberOfTurn5,5
	jb		StartGameHere2

	INVOKE	CheckWinner, Arr5,WhoGoFirst3,LengthOfArr5
	cmp		al,0
	jne		FinishCompVsCompGame
	jmp		StartGameHere2
	
DrawGame3:
	mov		edx,OFFSET promptDraw2
	call	WriteString
	call	Crlf

	FinishCompVsCompGame:

	ret
CompAgainstComp	ENDP

;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

DisplayFinalResult	 PROC,		Arr6:ptr DWORD, LengthOfArr6: BYTE, _TypeWin:BYTE

;this is CompAgainstComp procedures
; receive: Arr5, LengthOfArr5, numberofturn and esi =  adress of the last square on the row/col/cross win
; return: nothing
; require:  nothing
	
	mov		edi,Arr6
	cmp		_TypeWin,1
	je		DisplayColWin
	cmp		_TypeWin,2
	je		DisplayRowWin
	cmp		_TypeWin,3
	je		DisplayCrossLeft
	jmp		DisplayCrossRight
	;-------------------------Display Column Win----------------
DisplayColWin:
	sub		esi,20					; mov esi to the first square
	mov		ebx,esi		
	sub		ebx,edi					; we can know which col win 0,1,or 2
	mov		esi,0					; esi keep index
	mov		cl, LengthOfArr6
	LoopDisplay3:
		cmp		esi,ebx
		je		PrintColor
		add		ebx,5
		cmp		esi,ebx
		je		PrintColor
		sub		ebx,5				
	PrintCharHere:
		mov		al,[edi+esi]
		call	WriteChar
		mov		eax,lightGray + ( black * 16)			;get normal text
		call	SetTextColor
		inc		esi
		cmp		cl,21
		je		GoToNewLine1
		cmp		cl,16
		je		GoToNewLine1
		cmp		cl,11
		je		GoToNewLine1
		cmp		cl,6
		je		GoToNewLine1
		cmp		cl,1
		je		FinishFinalDisplay
		mov		al,124
		call	WriteChar
	Loop	LoopDisplay3
	jmp		FinishFinalDisplay
GoToNewLine1:
	call	crlf
	Loop	LoopDisplay3
		

PrintColor:
		mov		eax, black + ( yellow * 16)		 	; black on yellow	
		call	SetTextColor
		jmp		PrintCharHere
	

	;----------------------Display Row Win ---------------------------
DisplayRowWin:
		sub		esi,4				; esi keep the first square of row win
		mov		cl, LengthOfArr6
	LoopDisplay4:
		mov		eax,edi
		sub		eax,esi
		cmp		eax,0
		jae		PrintColor2
	
		PrintCharHere2:
			mov		al,[edi]
			call	WriteChar
			mov		eax,lightGray + ( black * 16)			;get normal text
			call	SetTextColor
			inc		edi
			cmp		cl,21
			je		GoToNewLine2
			cmp		cl,16
			je		GoToNewLine2
			cmp		cl,11
			je		GoToNewLine2
			cmp		cl,6
			je		GoToNewLine2
			cmp		cl,1
			je		FinishFinalDisplay
			mov		al,124
			call	WriteChar
	Loop	LoopDisplay4
	jmp		FinishFinalDisplay
GoToNewLine2:
	call	crlf
	Loop	LoopDisplay4

PrintColor2:
	cmp		eax,4
	ja		PrintCharHere2		
	mov		eax, black + ( yellow * 16)		 	;black on yellow	
	call	SetTextColor
	jmp		PrintCharHere2

	;-------------------------Display Cross Left Win-------------------
DisplayCrossLeft:
	mov		cl,LengthOfArr6
	LoopDisplay5:
		cmp		cl,25
		je		PrintColor3
		cmp		cl,19
		je		PrintColor3
		cmp		cl,13
		je		PrintColor3
		cmp		cl,7
		je		PrintColor3
		cmp		cl,1
		je		PrintColor3
	PrintCharHere3:
		mov		al,[edi]
		call	WriteChar
		mov		eax,lightGray + ( black * 16)			;get normal text
		call	SetTextColor
		inc		edi
		cmp		cl,21
		je		GoToNewLine3
		cmp		cl,16
		je		GoToNewLine3
		cmp		cl,11
		je		GoToNewLine3
		cmp		cl,6
		je		GoToNewLine3
		cmp		cl,1
		je		FinishFinalDisplay
		mov		al,124
		call	WriteChar
	Loop	LoopDisplay5
	jmp		FinishFinalDisplay

GoToNewLine3:
	call	crlf
	Loop	LoopDisplay5

PrintColor3:
		mov		eax, black + ( yellow * 16)		 	; black on yellow	
		call	SetTextColor
		jmp		PrintCharHere3

;-------------------------------------------

DisplayCrossRight:
	mov		cl,LengthOfArr6
	LoopDisplay6:
		cmp		cl,21
		je		PrintColor4
		cmp		cl,17
		je		PrintColor4
		cmp		cl,13
		je		PrintColor4
		cmp		cl,9
		je		PrintColor4
		cmp		cl,5
		je		PrintColor4
	PrintCharHere5:
		mov		al,[edi]
		call	WriteChar
		mov		eax,lightGray + ( black * 16)			;get normal text
		call	SetTextColor
		inc		edi
		cmp		cl,21
		je		GoToNewLine4
		cmp		cl,16
		je		GoToNewLine4
		cmp		cl,11
		je		GoToNewLine4
		cmp		cl,6
		je		GoToNewLine4
		cmp		cl,1
		je		FinishFinalDisplay
		mov		al,124
		call	WriteChar
	Loop	LoopDisplay6
	jmp		FinishFinalDisplay

GoToNewLine4:
	call	crlf
	Loop	LoopDisplay6

PrintColor4:
		mov		eax, black + ( yellow * 16)		 	; black on yellow	
		call	SetTextColor
		jmp		PrintCharHere5	


FinishFinalDisplay:
	call	Crlf
	ret
DisplayFinalResult	ENDP
;------------------------------------------------------------------------
;------------------------------------------------------------------------
;------------------------------------------------------------------------

MainMenu	PROC

;this is MainMenu procedures
; receive: nothing
; return: the option which is chosen
; require:  nothing

.data
	promptMenu			BYTE "            Menu",0h
	promptDash			BYTE "------------------------------------",0h
	promptMenu1			BYTE "1. One Player",0h
	promptMenu2			BYTE "2. Two Player",0h
	promptMenu3			BYTE "3. Computer Against Computer",0h
	promptMenu4			BYTE "4. Exit",0h

.code

StartMenuHere:
	call	clrscr
	mov		edx, OFFSET promptMenu
	call	WriteString
	call	crlf
	mov		edx,OFFSET promptDash
	call	WriteString
	call	crlf
	mov		edx, OFFSET promptMenu1
	call	WriteString
	call	crlf
	mov		edx, OFFSET promptMenu2
	call	WriteString
	call	crlf
	mov		edx, OFFSET promptMenu3
	call	WriteString
	call	crlf
	mov		edx, OFFSET promptMenu4
	call	WriteString
	call	crlf

	call	ReadInt
	cmp		al,1
	jb		StartMenuHere
	cmp		al,4
	ja		StartMenuHere

	ret
MainMenu	ENDP
;-----------------------------------------------------------------------------
END main