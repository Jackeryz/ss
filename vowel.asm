STACK SEGMENT
    db 100h dup(?)
STACK ENDS
DATA SEGMENT
    msg1 db 10,13,"Enter a string : $"
    msg2 db 10,13,"Number of vowels is : $"
    str db 100 dup(?)
DATA ENDS
CODE SEGMENT
START:
    ASSUME CS:CODE, DS:DATA, SS:STACK
    mov ax,DATA
    mov ds,ax
    mov ax,STACK
    mov ss,ax
    mov sp,100h

    lea dx,msg1
    mov ah,09h
    int 21h

    xor cx,cx
    lea si,str

READ:
    mov ah,01h
    int 21h
    cmp al,13
    je OK
    mov [si],al
    inc cl
    inc si
    jmp READ

OK:
    xor si,si
    lea si,str
    xor bx,bx

VOWEL:
    mov al,[si]
    cmp cl,0
    je DONE

    cmp al,'A'
    je COUNT
    cmp al,'E'
    je COUNT
    cmp al,'I'
    je COUNT
    cmp al,'O'
    je COUNT
    cmp al,'U'
    je COUNT
    cmp al,'a'
    je COUNT
    cmp al,'e'
    je COUNT
    cmp al,'i'
    je COUNT
    cmp al,'o'
    je COUNT
    cmp al,'u'
    je COUNT
    jmp NEXT

COUNT:
    inc bx
NEXT:
    inc si
    dec cl
    jmp VOWEL

DONE:

    lea dx,msg2
    mov ah,09h
    int 21h
    cmp bx,0
    jne NORMAL
    mov dx,'0'
    mov ah,02h
    int 21h
    jmp EXIT

NORMAL:
    xor cx,cx
    mov ax,bx
    mov bx,10
    xor dx,dx
    
CONVERT:
    cmp ax,0
    je PRINT    
    div bx
    push dx
    inc cl
    xor dx,dx
    jmp CONVERT

PRINT:
    cmp cl,0
    je EXIT
    pop dx
    add dl,'0'
    mov ah,02h
    int 21h
    dec cl
    jmp PRINT

EXIT:
    mov ah,4ch
    int 21h

CODE ENDS
END START