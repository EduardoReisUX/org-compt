
    section .data
msg1:   db "Ja passou do meio dia (S/N)", 10
len1:   equ $-msg1
msg2:   db " ", 10
len2:   equ $-msg2
msg3:   db "Boa tarde", 10
len3:   equ $-msg3
msg4:   db "Bom dia", 10
len4:   equ $-msg4

    SECTION .text   ; code section
        global _start   ; make label

_start:  ; standart gcc entry point

    ;escreve a msg1
    mov edx,len1
    mov ecx,msg1
    mov ebx,1
    mov eax,4
    int 0x80

    ; le a msg2 entrada pelo usuario
    mov edx,len2
    mov ecx,msg2
    mov ebx,1
    mov eax,3
    int 0x80

    ; escreve ou a msg de bom dia ou boa tarde

    ;escreve Boa tarde
    mov byte al, [msg2]
    cmp al, 'S'         ; comparação
    jz boa_tarde        ; jump on zero
    cmp al, 's'
    jz boa_tarde

    ; escreve Bom dia
    mov edx,len4
    mov ecx,msg4
    mov ebx,1
    mov eax,4
    int 0x80

    jmp fim

boa_tarde:
    ; escreve Boa tarde
    mov edx,len3
    mov ecx,msg3
    mov ebx,1
    mov eax,4
    int 0x80

fim:
    ; termina o programa
    mov ebx,0
    mov eax,1
    int 0x80
