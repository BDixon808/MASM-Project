TITLE String Primatives & macros     (Proj6_dixonbre.asm)

; Author: Brett Dixon 
; Description: The program first prompts greets the user and introduces the program then prompts to enter a string of signed integers
;				the string is then validated and converted to an array of integers, the sum and average of the array is
;				calculated then the arrays (numbers, sum, average) are converted into a string of ASCII characters 
;				and printed to the console.

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Prompts user for input and gets user input
;
; Preconditions: must have string adresses as arguments
;
; Receives:
; inputPrompt = string prompt address
; numbersEntered = string address
;
; returns: numbersEntered = string from user input
; ---------------------------------------------------------------------------------
mGetString	MACRO	inputPrompt, numbersEntered

	; Display input prompt to user
	MOV		EDX, inputPrompt
	CALL	WriteString
	
	; Get  User Input
	MOV		EDX, numbersEntered
	MOV		ECX, 13
	CALL	ReadString



ENDM


; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Displays string to the console
;
; Preconditions: must have string adresses as arguments
;
; Receives:
; stringMsg = string prompt address
; stringToDisplay = string address
;
; returns: None
; ---------------------------------------------------------------------------------
mDisplayString	MACRO	stringMsg, stringToDisplay

	CALL	crlf

	; Display message to user
	MOV		EDX, stringMsg
	CALL	WriteString

	; Display string to user
	MOV		EDX, stringToDisplay
	CALL	WriteString


ENDM


; Constants
  MIN = -2147483648
  MAX = 2147483647
  MAXSIZE = 12


.data
  ; Variables
  programmersName		BYTE	"By: Brett Dixon",0
  programTitle			BYTE	"String Primatives & Macros Program",0
  userInstructions		BYTE	"Enter 10 signed numbers and I will show you the average and sum!",0
  userPrompt			BYTE	"Please enter a signed integer: ",0
  stringLength			SDWORD	?
  numbers				SBYTE	11 DUP(?),0
  farewellMessage		BYTE	"Farewell! Thanks for using my program, have a great day! :)",0
  mainLoopCount			DWORD	0
  convertedNumbers		DWORD	10 DUP(?),0
  numbersLength			SDWORD	LENGTHOF convertedNumbers
  charCount				DWORD	0
  ErrrorMessage			BYTE	"Error: The number you entered is too big or is wasn't a signed integer!",0
  signBool				SDWORD	0
  arrayIndex			SDWORD  0
  isNegative			SDWORD  0
  sum					SDWORD	1 DUP(?),0
  average				SDWORD	1 DUP(?),0
  sumMessage			BYTE	"The sum of your numbers is: ",0
  averageMessage		BYTE	"The truncated average is: ",0
  numbersMessage		BYTE	"The numbers you entered are: ",0
  convertedString		BYTE	110 DUP(?), 0
  runningTotal			SDWORD	0
  stringIndex			SDWORD	0
  sumLength				SDWORD	LENGTHOF sum
  avgLength				SDWORD	LENGTHOF average
  sumString				BYTE	10 DUP(?),0
  avgString				BYTE	10 DUP(?),0
	
.code
main PROC

  ; Introduction
  PUSH		OFFSET userInstructions
  PUSH		OFFSET programmersName
  PUSH		OFFSET programTitle
  CALL		Intro
  CALL		Crlf



  CALL		Crlf

  ; Counted Read Loop

_readLoop:
  PUSH		isNegative
  PUSH		arrayIndex
  PUSH		OFFSET ErrrorMessage
  PUSH		signBool
  PUSH		charCount
  PUSH		OFFSET convertedNumbers
  PUSH		mainLoopCount
  PUSH		MAXSIZE
  PUSH		OFFSET numbers
  PUSH		OFFSET UserPrompt
  CALL		ReadVal
  XOR		EDX, EDX
  MOV		EDX, arrayIndex
  ADD		EDX, 4
  MOV		arrayIndex, EDX
  XOR		EDX, EDX
  MOV		EDX, mainLoopCount
  INC		EDX
  MOV		mainLoopCount, EDX
  CMP		mainLoopCount, 10
  JL		_readLoop




  ; Calculate Sum and Average
  PUSH		OFFSET average
  PUSH		OFFSET sum
  PUSH		OFFSET convertedNumbers
  Call		CalculateSumAndAverage


  ; Clear Main Loop Count and registers
  MOV		EDX, mainLoopCount
  MOV		EDX, 0
  MOV		mainLoopCount, EDX
  XOR		EAX, EAX
  XOR		EBX, EBX
  XOR		ECX, ECX
  XOR		EDX, EDX






  ; Counted Write Loop
  MOV		ESI, OFFSET convertedNumbers
  MOV		EDI, OFFSET convertedString
_writeLoop:
  PUSH		OFFSET convertedString
  PUSH		mainLoopCount
  PUSH		numbersLength
  PUSH		OFFSET numbersMessage
  CALL		WriteVal
  XOR		EDX, EDX
  MOV		EDX, mainLoopCount
  INC		EDX
  MOV		mainLoopCount, EDX
  CMP		EDX, numbersLength
  JL		_writeLoop



  ; Clear Main Loop Count 
  MOV		EDX, mainLoopCount
  MOV		EDX, 0
  MOV		mainLoopCount, EDX
  XOR		EAX, EAX
  XOR		EBX, EBX
  XOR		ECX, ECX
  XOR		EDX, EDX





  ; Counted Write Sum Loop
  MOV		ESI, OFFSET sum
  MOV		EDI, OFFSET sumString
_sumWriteLoop:
  PUSH	OFFSET sumString
  PUSH	mainLoopCount
  PUSH	sumLength
  PUSH	OFFSET sumMessage
  CALL	WriteVal
  XOR		EDX, EDX
  MOV		EDX, mainLoopCount
  INC		EDX
  MOV		mainLoopCount, EDX
  CMP		EDX, sumLength
  JL		_sumWriteLoop




  ; Clear Main Loop Count 
  MOV		EDX, mainLoopCount
  MOV		EDX, 0
  MOV		mainLoopCount, EDX
  XOR		EAX, EAX
  XOR		EBX, EBX
  XOR		ECX, ECX
  XOR		EDX, EDX






  ; Counted Write Average Loop
  MOV		ESI, OFFSET average
  MOV		EDI, OFFSET avgString
_avgWriteLoop:
  PUSH		OFFSET avgString
  PUSH		mainLoopCount
  PUSH		avgLength
  PUSH		OFFSET averageMessage
  CALL		WriteVal
  XOR		EDX, EDX
  MOV		EDX, mainLoopCount
  INC		EDX
  MOV		mainLoopCount, EDX
  CMP		EDX, avgLength
  JL		_avgWriteLoop

  ; Clear Main Loop Count 
  MOV		EDX, mainLoopCount
  MOV		EDX, 0
  MOV		mainLoopCount, EDX
  XOR		EAX, EAX
  XOR		EBX, EBX
  XOR		ECX, ECX
  XOR		EDX, EDX





  ; Farewell :)
  CALL		Crlf
  CALL		Crlf
  PUSH		OFFSET farewellMessage
  CALL		farewell


	Invoke ExitProcess,0	; exit to operating system
main ENDP



; ---------------------------------------------------------------------------------
; Name: Intro
; 
; Prints the program title and programmers name and also greeting message 
; and instructions for the user.
;
; Preconditions: all strings pushed must be defined 
;
; Postconditions: None
;
; Receives: userInstructions, programTitle, programmersName
;
; Returns: None
; ---------------------------------------------------------------------------------
Intro PROC
  PUSH		ESP
  MOV		EBP, ESP
  PUSHAD


  ; Display Name and title
  MOV		EDX, [EBP + 8]
  CALL	WriteString
  CALL	Crlf
  MOV		EDX, [EBP + 12]
  CALL	WriteString
  CALL	Crlf

  ; Display Instructions
  MOV		EDX, [EBP + 16]
  CALL	WriteString

  POPAD
  POP		ESP
	RET 12
Intro ENDP




; ---------------------------------------------------------------------------------
; Name: ReadVal
; 
; Prompt the user to enter a signed integer and reads the integer via invoking
; mGetString MACRO which returns a string of the signed integer entered.
; The string is then converted into integer. Each integer is then validated 
; to be in a range that can fit in a 32 bit register and is a signed integer
; this repeats until 10 valid numbers are entered. the numbers are then 
; converted into an array of integers
; 
;
; Preconditions: The user must enter a valid signed integer that can 
; fit in a 32 bit registar, mGetString MACRO must be defined and working.
;
; Postconditions: None
;
; Receives: All Registars, isNegative, arrayIndex, ErrrorMessage, signBool
; charCount, convertedNumbers, mainLoopCount, MAXSIZE, numbers, UserPrompt
;
; Returns: convertedNumbers array is filled with valid integers.
; ---------------------------------------------------------------------------------
ReadVal PROC


  PUSH		ESP
  MOV		EBP,	ESP
  PUSHAD

  ; Returns here if input is invalid to retry
_notValid:

  ; Move the array/string into reg
  MOV		EDX,	[EBP + 8]
  MOV		ESI,	[EBP + 12]
  MOV		EBX,	[EBP + 16]



  ; Invoke get string MACRO
	mGetString EDX, ESI, EBX

  ; Check if entered string is over 11 characters 
  CMP		EAX, 12
  JE		_error


  ; set up the string primative
  CLD
	MOV		ECX, EAX
	MOV		ESI, EDX
	MOV		EDI, [EBP + 24]


  ; this keeps track of the array index
  MOV		EBX, [EBP + 40]
  ADD		EDI, EBX


  ; loop through and convert and validate the input
_charLoop:
  XOR		EAX, EAX
  LODSB     

  ; Check if sign bool is true
  MOV		EBX, [EBP + 32]
  CMP		EBX, 1
  JE		_contCharLoop

  ; Check for sign and set bool 
  CMP		AL, 43
  JE		_sign

  CMP		AL, 45
  JE		_sign



_contCharLoop:
  ; check >48 and <57
  CMP		AL, 48
  JL		_error
  CMP		AL, 57
  JG		_error

  ; sub 48 to get numnber and add ten times the running total
  SUB     EAX, 48
  PUSH		EAX
  MOV		EAX, [EBP + 28]
  MOV		EBX, 10
  IMUL		EBX
  POP		EDX
  ADD		EAX, EDX
  MOV		[EBP + 28], EAX
  CMP		ECX, 0
  JE		_check
  LOOP	_charLoop

  ;CheckSize
_check:

  CMP		EAX, MAX
  JG		_error
  CMP		EAX, MIN
  JL		_error



  MOV		EBX, [EBP + 44]
  CMP		EBX, 1
  JE		_negAdd


  ; add pos to array
  STOSD
  MOV		EBX, 0
  MOV		[EBP + 32], EBX
  JMP		_endRead

_negAdd:
  ; add neg to array
  NEG		EAX
  STOSD
  MOV		EBX, 0
  MOV		[EBP + 32], EBX
  JMP		_endRead




  ;Handle Sign
_sign:
  MOV		EBX, 1
  MOV		[EBP + 32], EBX
  CMP		AL, 45
  JE		_negBool
  LOOP	_charLoop

  ; this sets the negative boolean
_negBool:
  MOV		EBX, 1
  MOV		[EBP + 44], EBX
  LOOP	_charLoop

  ; displays error message and clear registers and retry input
_error:
  MOV		EDX, [EBP + 36]
  CALL	WriteString
  CALL	Crlf
  MOV		EBX, 0
  MOV		[EBP + 32], EBX
  MOV		EAX, 0
  MOV		[EBP + 28], EAX
  XOR		EAX, EAX
  XOR		EBX, EBX
  XOR		ECX, ECX
  XOR		EDX, EDX
  JMP		_notValid


_endRead:
  POPAD
  POP		ESP
	RET 48
ReadVal ENDP



; ---------------------------------------------------------------------------------
; Name: CalculateSumAndAverage
; 
; Calculated the sum and average of the valid integers entered
;
; Preconditions: convertedNumbers must be filled
;
; Postconditions: None
;
; Receives: average, sum, convertedNumbers
;
; Returns: Average and Sum of the covertedNumbers Array is moved into 
; sum and average
; ---------------------------------------------------------------------------------
CalculateSumAndAverage PROC

  PUSH	ESP
  MOV		EBP,	ESP
  PUSHAD
  XOR		EBX, EBX


  ; Calculate Sum
  CLD
  MOV		ESI, [EBP + 8]
  MOV		ECX, 10
  MOV		EDI, [EBP + 12]
_sumLoop:
  LODSD
  ADD		EBX, EAX
  LOOP	_sumLoop
  MOV		EAX, EBX
  STOSD



  ; Calculate Average
  MOV		EDI, [EBP + 16]
  MOV		EBX, 10
  CDQ
  IDIV		EBX
  STOSD


  POPAD
  POP		ESP
	RET 12
CalculateSumAndAverage ENDP



; ---------------------------------------------------------------------------------
; Name: WriteVal
; 
; The procedure converts an array of integers to a string and then prints the string 
; to the console by invoking mDisplayString Macro.
;
; Preconditions: mDisplayString Macro must be defined as well as the provided array.
; The source array must be moved into ESI and the destination string must be put into
; EDI
;
; Postconditions: EAX is saved
;
; Receives: ESI, EDI, EAX, convertedString, mainLoopCount, numbersLength, numbersMessage, 
; sumString, sumLength, sumMessage, avgString, mainLoopCount, avgLength, averageMessage
;
; Returns: convertedString, sumString, avgString,
; ---------------------------------------------------------------------------------
WriteVal PROC

  PUSH		ESP
  MOV		EBP, ESP
  PUSH		EDX
  PUSH		EBX
  PUSH		ECX
  XOR		EDX, EDX
  MOV		EDX, [EBP + 16]
  MOV		EBX, [EBP + 12]
  SUB		EBX, 1
  CMP		EDX, EBX
  JE		_display


_contNext:
  ; load in number
  XOR		EAX, EAX
  XOR		EBX, EBX
  XOR		ECX, ECX
  LODSD



  ; check sign 
  CMP		EAX, 0
  JGE		_addPos
  CMP		EAX, 0
  JL		_addNeg



  ; Convert to ASCII
_intLoop:
  MOV		EBX, 10
  CDQ
  IDIV		EBX
  ADD		EDX, 48
  PUSH	    EDX
  INC		ECX
  CMP		EAX, 0
  JNE		_intLoop


  ; use STOSB to store ASCII number
_storeString:
  POP		EAX
  STOSB
  LOOP		_storeString
  JMP		_ReadValEnd

  ; add the signs
_addPos:
  MOV		EDX, EAX
  MOV		EAX, " "
  STOSB
  MOV		EAX, EDX
  MOV		EAX, EDX
  MOV		EDX, EAX
  MOV		EAX, "+"
  STOSB
  MOV		EAX, EDX
  JMP		_intLoop

_addNeg:
  MOV		EDX, EAX
  MOV		EAX, " "
  STOSB
  MOV		EAX, EDX
  MOV		EDX, EAX
  MOV		EAX, "-"
  STOSB
  MOV		EAX, EDX
  XOR		EDX, EDX
  CMP		EAX, -2147483648
  JE		_handleEdgeCase
  NEG		EAX
  JMP		_intLoop


  ; my algorithm doesnt handle the lower bound well so one special case :P
  _handleEdgeCase:
  XOR		EAX, EAX
  MOV		AL, 2
  ADD		AL, 48
  STOSB
  MOV		AL, 1
  ADD		AL, 48
  STOSB
  MOV		AL, 4
  ADD		AL, 48
  STOSB
  MOV		AL, 7
  ADD		AL, 48
  STOSB
  MOV		AL, 4
  ADD		AL, 48
  STOSB
  MOV		AL, 8
  ADD		AL, 48
  STOSB
  MOV		AL, 3
  ADD		AL, 48
  STOSB
  MOV		AL, 6
  ADD		AL, 48
  STOSB
  MOV		AL, 4
  ADD		AL, 48
  STOSB
  MOV		AL, 8
  ADD		AL, 48
  STOSB
  JMP	   _contNext
  ; Invoke diplay MACRO
_display:
  mDisplayString [EBP + 8], [EBP + 20]


_ReadValEnd:
  POP		ECX
  POP		EBX
  POP		EDX
  POP		ESP
	RET 16
WriteVal ENDP



; ---------------------------------------------------------------------------------
; Name: Farewell
; 
; Prints a farewell message to the console
; 
; Preconditions: The farwell message string must be defined
;
; Postconditions: None
;
; Receives: farewellMessage address
;
; Returns: None
; ---------------------------------------------------------------------------------
Farewell PROC

  PUSH		ESP
  MOV		EBP, ESP
  PUSHAD

  ; Display the farewell message
  MOV		EDX, [EBP + 8]
  CALL	WriteString
  CALL	Crlf


  POPAD
  POP		ESP
	RET 4

Farewell ENDP
END main
