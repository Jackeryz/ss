DATA SEGMENT
MSG1 DB 10,13,"ENTER A STRING: $"
MSG2 DB 10,13,"NUMBER OF VOWELS = $"
STR DB 50 DUP(?) ; storage for input
COUNT DB ? ; number of vowels
DISP DB 5 DUP('$') ; buffer to display result (max 5 digits)
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA

START:
; Initialize DS
MOV AX, DATA
MOV DS, AX

; Show prompt
LEA DX, MSG1
MOV AH, 09h
INT 21h

; Read string using DOS function (AH=0Ah) - buffered input
; Define input buffer in STR:
; STR[0] = max chars allowed (let's assume 49)
; STR[1] = number of chars entered
; STR[2...] = actual characters

MOV BYTE PTR STR, 49 ; set max chars
LEA DX, STR
MOV AH, 0Ah
INT 21h

; Initialize counters
MOV CL, [STR+1] ; number of chars entered
MOV CH, 0
LEA SI, STR+2 ; point to first char
XOR BL, BL ; BL = vowel count = 0

NEXT_CHAR:
CMP CL, 0 ; processed all characters?
JE PRINT_RESULT

MOV AL, [SI] ; get current char
; Convert to uppercase for easy checking
CMP AL, 'a'
JB CHECK_VOWEL
CMP AL, 'z'
JA CHECK_VOWEL
SUB AL, 20h ; make lowercase to uppercase (a→A)

CHECK_VOWEL:
CMP AL, 'A'
JE IS_VOWEL
CMP AL, 'E'
JE IS_VOWEL
CMP AL, 'I'
JE IS_VOWEL
CMP AL, 'O'
JE IS_VOWEL
CMP AL, 'U'
JE IS_VOWEL
JMP NEXT_STEP

IS_VOWEL:
INC BL ; increase vowel count

NEXT_STEP:
INC SI
DEC CL
JMP NEXT_CHAR

; ---- Print Result ----
PRINT_RESULT:
MOV COUNT, BL ; store count
LEA DX, MSG2
MOV AH, 09h
INT 21h

; Convert number in BL → ASCII string in DISP
MOV AL, COUNT
XOR AH, AH
MOV CX, 0
LEA DI, DISP+4 ; point to end of buffer
MOV BYTE PTR [DI], '$' ; string terminator
DEC DI

CONVERT_LOOP:
MOV DX, 0
MOV BX, 10
DIV BX ; AX / 10
ADD DL, 30h ; remainder → ASCII
MOV [DI], DL
DEC DI
INC CX
CMP AX, 0

JNE CONVERT_LOOP

INC DI
LEA DX, [DI]
MOV AH, 09h
INT 21h

; ---- Exit ----
DONE:
MOV AH, 4Ch
INT 21h

CODE ENDS
END START