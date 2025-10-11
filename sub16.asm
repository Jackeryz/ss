DATA SEGMENT
    MSG1 DB 10,13,"ENTER THE FIRST 4-DIGIT NUMBER: $"
    MSG2 DB 10,13,"ENTER THE SECOND 4-DIGIT NUMBER: $"
    MSG3 DB 10,13,"RESULT OF SUBTRACTION = $"
    N1 DB 4 DUP(?)         
    N2 DB 4 DUP(?)         
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA

START:
    MOV AX, DATA
    MOV DS, AX

    LEA DX, MSG1
    MOV AH, 09h
    INT 21h

    MOV CX, 4            
    LEA SI, N1           

INPUT_FIRST:
    MOV AH, 01h            
    INT 21h
    SUB AL, 30h            
    CMP AL, 9
    JA INPUT_FIRST         
    MOV [SI], AL
    INC SI
    LOOP INPUT_FIRST

    LEA DX, MSG2
    MOV AH, 09h
    INT 21h

    MOV CX, 4              
    LEA DI, N2             

INPUT_SECOND:
    MOV AH, 01h
    INT 21h
    SUB AL, 30h
    CMP AL, 9
    JA INPUT_SECOND
    MOV [DI], AL
    INC DI
    LOOP INPUT_SECOND

    MOV CX, 4            
    LEA SI, N1
    LEA DI, N2
    ADD SI, 3           
    ADD DI, 3              
    XOR BH, BH    

SUB_LOOP:
    MOV AL, [SI]      
    MOV BL, [DI]       

    SUB AL, BH          

    CMP AL, BL
    JB BORROW           

    SUB AL, BL          
    MOV BH, 0           
    JMP STORE_RESULT

BORROW:
 
    ADD AL, 10
    SUB AL, BL
    MOV BH, 1            

STORE_RESULT:
    MOV [DI], AL         
    DEC SI
    DEC DI
    LOOP SUB_LOOP

    LEA DX, MSG3
    MOV AH, 09h
    INT 21h

    CMP BH, 0
    JNE NEGATIVE_RESULT

PRINT_DIGITS:
    MOV CX, 4
    LEA SI, N2

PRINT_LOOP:
    MOV AL, [SI]
    ADD AL, 30h          
    MOV DL, AL
    MOV AH, 02h
    INT 21h
    INC SI
    LOOP PRINT_LOOP

    JMP DONE

NEGATIVE_RESULT:
 
    MOV DL, '-'
    MOV AH, 02h
    INT 21h

    MOV CX, 4
    LEA SI, N2


DONE:
    MOV AH, 4Ch
    INT 21h

CODE ENDS
END START

