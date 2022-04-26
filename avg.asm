TITLE avgprog

INCLUDE irvine32.inc

.DATA

welcomeMsg  BYTE    "Welcome to the grade avg program!",0
infoMsg     BYTE    "Enter integer grades in the range [1,100]",0
avgMsg      BYTE    "To print the totals, enter an invalid value",0
quitMsg     BYTE    "To exit, enter nothing as a first input",0
promptMsg   BYTE    "Enter integer grade [0,100]: "

NumOfGrades DWORD   0   ;rolling counter, stores total number of grades entered so far
GradesTotal DWORD   0   ;rolling accumulator, stores sum of all grades entered so far                                               
GradeIntAvg DWORD   0   ;when the print is invoked, the average is saved here (using int division)
GradeAvgRem DWORD   0

buffer		BYTE    21 DUP(0)
byteCount	DWORD 	?

.CODE

main PROC
    mov EDX,OFFSET welcomeMsg
    call WriteString
    call Crlf

    mov EDX,OFFSET infoMsg
    call WriteString
    call Crlf
    
    mov EDX,OFFSET avgMsg
    call WriteString
    call Crlf
    
    mov EDX,OFFSET quitMsg
    call WriteString
    call Crlf

GetInput:
    mov EDX,OFFSET promptMsg
    call WriteString
    call Crlf

    mov edx, OFFSET buffer
	mov ecx, SIZEOF buffer
    call ReadString

IsValid:


IsInt: