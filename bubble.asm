DATA SEGMENT
    msg1 db 10,13, "Enter the no. of elements : $"
    msg2 db 10,13, "Enter the elements (one-digit): $"
    msg3 db 10,13, "Sorted array is : $"
    arr db 10 dup(?)
    n db ?
DATA ENDS

CODE SEGMENT
START:
    ASSUME CS:CODE,DS:DATA
    mov ax,DATA
    mov ds,ax
    
    ; Read number of elements
    lea dx,msg1
    mov ah,09h
    int 21H

    mov ah,01h
    int 21H
    sub al,30h
    mov n,al

    ; Read array elements
    lea dx,msg2
    mov ah,09h
    int 21H

    xor si,si
    mov cl,n
READ_LOOP:
    mov ah,01h
    int 21H
    sub al,30h
    mov arr[si],al

    mov dl,' '
    mov ah,02h
    int 21H

    inc si
    dec cl
    jnz READ_LOOP

    ; Bubble sort
    mov bl,n
    dec bl            ; Outer loop count
OUTER:
    xor si,si
    mov cl,bl        ; Inner loop count
INNER:
    mov al,arr[si]
    mov dl,arr[si+1]
    cmp al,dl
    jbe NO_SWAP
    mov arr[si],dl
    mov arr[si+1],al
NO_SWAP:
    inc si
    dec cl
    jnz INNER
    dec bl
    jnz OUTER

    ; Print sorted array
    lea dx,msg3
    mov ah,09h
    int 21H

    xor si,si
    mov cl,n
PRINT:
    mov al,arr[si]
    add al,30h
    mov dl,al
    mov ah,02h
    int 21H

    mov dl,' '
    mov ah,02h
    int 21H

    inc si
    dec cl
    jnz PRINT

    ; Exit
    mov ah,4ch
    int 21h

CODE ENDS
END START
