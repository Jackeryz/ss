data segment
    msg1 db 10,13, "Enter the number of terms : $"
    msg2 db 10,13, "Enter the terms : $"
    msg3 db 10,13, "Enter the key to be searched : $"
    msgf db 10,13, "Key found at position : $"
    msgnf db 10,13, "Key not found in the array.$"
    n db ?
    arr db 100 dup(?)
    key db ?
data ends
code segment 
start:
    assume cs:code,ds:data
    mov ax,data
    mov ds,ax

    lea dx,msg1
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,30h
    mov n,al

    lea dx,msg2
    mov ah,09h
    int 21h

    xor si,si
    xor cx,cx
    mov cl,n
    lea si,arr

read:
    mov ah,01h
    int 21h
    sub al,30h
    mov [si],al
    inc si
    mov dl,' '
    mov ah,02h
    int 21h
    loop read

    lea dx,msg3
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,30h
    mov key,al


    xor cx,cx
    mov cl,n
    xor si,si
    lea si,arr
    mov bh,0
    mov bl,1

search:
    mov al,[si]
    cmp al,key
    je found
    inc si
    inc bl
    loop search
    jmp nfound

found:
    lea dx,msgf
    mov ah,09h
    int 21h

    mov al,bl
    add al,30h
    mov dl,al
    mov ah,02h
    int 21h
    jmp exit

nfound:
    lea dx,msgnf
    mov ah,09h
    int 21h

exit:
    mov ah,4ch
    int 21h

code ends
end start