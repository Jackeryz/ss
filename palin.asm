data segment 
    msg1 db 10,13, "Enter a string : $"
    msgp db 10,13, "The string is a palindrome.$"
    msgnp db 10,13, "The string is not a palindrome.$"
    str db 100 dup(?)
data ends
code segment
start:
    assume cs:code,ds:data
    mov ax,data
    mov ds,ax

    lea dx,msg1
    mov ah,09h
    int 21h

    xor cx,cx
    xor si,si
    lea si,str

read:
    mov ah,01h
    int 21h
    cmp al,13
    je OK
    mov [si],al
    inc si
    inc cx
    jmp read

OK:
    xor si,si
    xor di,di
    dec cx
    lea si,str
    lea di,str
    add di,cx

PALIN:
    mov al,[si]
    cmp al,[di]
    jne NO
    inc si
    dec di
    cmp si,di
    jae YES
    jmp PALIN

YES:
    lea dx,msgp
    jmp print
NO:
    lea dx,msgnp

print:
    mov ah,09h
    int 21h

    mov ah,4ch
    int 21h

code ends 
end start


