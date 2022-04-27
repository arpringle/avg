TITLE avgprog

INCLUDE irvine32.inc

.DATA

welcomeMsg  BYTE    "Welcome to the grade avg program!",0
infoMsg     BYTE    "Enter integer grades in the range [1,100]",0
avgMsg      BYTE    "To print the totals, enter an invalid value",0
quitMsg     BYTE    "To exit, enter nothing as a first input",0
promptMsg   BYTE    "Enter integer grade [0,100]: ",0
resultMsgS  BYTE    "The sum of all of the grades is: ",0
resultMsgC  BYTE    "The total number of grades that were entered: ",0
resultMsgA  BYTE    "The average of the grades, rounded down: ",0
resultMsgR  BYTE    "The remainder from the average: ",0

NumOfGrades DWORD   0   ;Rolling counter, stores total number of grades entered so far
GradesTotal DWORD   0   ;Rolling accumulator, stores sum of all grades entered so far                                               
GradeAvg    DWORD   0   ;Average of the grade
GradeAvgRem DWORD   0   ;Remainder from the 

buffer		BYTE    21 DUP(0)
byteCount	DWORD 	?

firstFlag   DWORD   1   ;Flag to tell whether a given input is the first on this round of inputs

.CODE

main PROC
    ;the following lines print all startup messages.
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
    
    ;Here we prompt for input:
    
    mov  EDX,OFFSET promptMsg
    call WriteString
    call Crlf

    ;Then, we put our buffer memory location and size into the correct registers to make ReadString work
    ;This, of course, is basically our prayer offering to Kip Irvine, god of MASM.

    mov  EDX, OFFSET buffer
	mov  ECX, SIZEOF buffer

    call ReadString             ;The Irvine(tm) method of reading a string from Windows command line
    mov  byteCount,EAX          ;Let's count those bytes! move the string we just got from the user into byteCount
    mov  EDX, OFFSET buffer     ;Update buffer mem location as stored in EDX
	mov  ECX, byteCount         ;Update current byteCount as stored in EDX

    ;Next we actually need to check the validity of this input.
    ;Is it between 0-100? Is it even an integer? Is it ANYTHING?
    ;We will check to be sure.

    ;The following 2 sections are the main body for the checks that we are performing.
IsValid:
    cmp EAX,0       ;Is the string input null?
    jne IsInt0to100 ;If no, jump to integer check. If yes...
    cmp firstFlag,1 ;...check if that null input was the first input...
    je  Quit        ;...and, if it is, we're going to quit...
    jmp Print       ;...and, if it's not, we'll just print the results from this round.

IsInt0to100:
    call ParseInteger32 ;Our god Kip Irvine made this nifty function to parse strings as ints
    
    jo  Print ;If the function above causes the overflow flag to trip, then that int ain't an int, so, print results.
    
    cmp EAX,0   ;If the integer was parsed successfully, check it against 0
    jl  Print   ;It should be greater than or equal to 0, so if it's less, we're done
    
    cmp EAX,100 ;Now we check against 100
    jg  Print   ;It should be less than or equal to 100. If not, we're done.
    
    jmp addint  ;If the input passed all of these tests, we can take it.

AddInt:
    mov EBX,GradesTotal ;Temporarily move the current total sum of the grades into EBX
    add EBX,EAX         ;Add the newly accepted grade (in EAX) into the sum (in EBX)
    mov GradesTotal,EBX ;Put the newly updated grade sum back into GradesTotal

    mov EBX,NumOfGrades ;Temporarily move the current count of the grades into EBX
    add EBX,1           ;Increment grade counter value in EBX by one
    mov NumOfGrades,EBX ;Put the updated sum back into NumOfGrades

    mov firstFlag,0     ;If we're accepting an int, this definitely isn't the first input anymore
    call Crlf           ;New line on terminal
    jmp GetInput        ;And, let's go get another grade.

Print:
    ;To print, we must first get the average.
    mov EAX,GradesTotal ;We put the sum of all grades so far into EAX
    cdq                 ;This means "convert doubleword to quadword," used so we can execute the upcoming division
    mov EBX,NumOfGrades ;Move the grade count into EBX
    div EBX             ;Divide EAX (currently the grade sum) by EBX (grade count)

    ;When you execute the div instruction, EAX is divided by the provided register. (EBX, in this case)
    ;The value of EAX is changed to be the whole-number-part of the result
    ;The remainder is placed into the EDX register.
    
    mov GradeAvg,EAX        ;Put the final average into the memory location reserved for it
    mov GradeAvgRem,EDX     ;Put the remainder from the division into the memory location reserved for it

    call Crlf

    ;Print the sum of the grades and its preceding message
    mov EDX,OFFSET resultMsgS
    call WriteString
    mov EAX,GradesTotal
    call WriteInt
    call Crlf

    ;Print the count of the grades and its preceding message
    mov EDX,OFFSET resultMsgC
    call WriteString
    mov EAX,NumOfGrades
    call WriteInt
    call Crlf

    ;Print the average of the grades and its preceding message
    mov EDX,OFFSET resultMsgA
    call WriteString
    mov EAX,GradeAvg
    call WriteInt
    call Crlf

    ;Print the remainder of the grade average and its preceding message
    mov EDX,OFFSET resultMsgR
    call WriteString
    mov EAX,GradeAvgRem
    call WriteInt
    call Crlf

    ;Reset all values to prep for another round of input
    mov GradesTotal,0
    mov NumOfGrades,0
    mov GradeAvg,0
    mov GradeAvgRem,0

    call Crlf

    mov firstFlag,1     ;The next input will be the first of a new round
    jmp GetInput

Quit:
    
    exit

main ENDP
END main