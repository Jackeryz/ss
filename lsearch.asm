; LINEAR SEARCH PROGRAM (MASM 8086)
; Works perfectly in DOSBox

DATA SEGMENT
    MSG1 DB 10,13,'Enter number of elements (max 10): $'
    MSG2 DB 10,13,'Enter each element (press ENTER after each): $'
    MSG3 DB 10,13,'Enter element to search: $'
    MSG_FOUND DB 10,13,'Element found at position: $'
    MSG_NOTFOUND DB 10,13,'Element not found.$'

    N DB ?              ; number of elements
    ARR DB 10 DUP(?)    ; array
    KEY DB ?            ; search key
    POS DB ?            ; position found
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA

START:
    MOV AX, DATA
    MOV DS, AX

    ;----------------------------------------
    ; Get number of elements
    ;----------------------------------------
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

    CALL READ_NUM
    MOV N, AL

    ;----------------------------------------
    ; Get array elements
    ;----------------------------------------
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

    MOV CL, N
    XOR CH, CH
    XOR SI, SI

READ_LOOP:
    CALL READ_NUM
    MOV ARR[SI], AL
    INC SI
    LOOP READ_LOOP

    ;----------------------------------------
    ; Get search key
    ;----------------------------------------
    LEA DX, MSG3
    MOV AH, 9
    INT 21H

    CALL READ_NUM
    MOV KEY, AL

    ;----------------------------------------
    ; Linear Search
    ;----------------------------------------
    MOV CL, N
    XOR CH, CH
    XOR SI, SI
    MOV BL, 1
    MOV BH, 0

SEARCH_LOOP:
    MOV AL, ARR[SI]
    CMP AL, KEY
    JE FOUND
    INC SI
    INC BL
    LOOP SEARCH_LOOP
    JMP NOT_FOUND

FOUND:
    MOV POS, BL
    MOV BH, 1

    LEA DX, MSG_FOUND
    MOV AH, 9
    INT 21H

    MOV AL, POS
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 2
    INT 21H
    JMP EXIT

NOT_FOUND:
    LEA DX, MSG_NOTFOUND
    MOV AH, 9
    INT 21H

EXIT:
    MOV AH, 4CH
    INT 21H

;----------------------------------------
; READ_NUM: Reads a single-digit number (skips ENTER)
;----------------------------------------
READ_NUM PROC
READ_AGAIN:
    MOV AH, 1
    INT 21H
    CMP AL, 13        ; Is it ENTER?
    JE READ_AGAIN     ; Ignore ENTER, read again
    SUB AL, 30H       ; Convert ASCII → number
    RET
READ_NUM ENDP

CODE ENDS
END START
