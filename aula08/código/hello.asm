; hello.asm um primeiro programa nasm para Linux; Intel, gcc.

; assemble:     nasm -f elf64 -F stabs hello.asm -o hello.o
; link:         ld -m elf_x86_64 hello.o -o hello
; run:          ./hello
; output is:    Hello World

SECTION.data                ; seção de dados
msg: db "Hello World",10    ; string a ser impressa 10=cr
len: equ $-msg              ; "$" significa aqui

SECTION.text                ; seção de código
    global main, _start     ; torna o rótulo disponível para o linker
main:                       ; main é o ponto de entrada padrão para o gcc
_start:

    mov edx, len            ; arg3, tamanho da string a ser impressa
    mov ecx, msg            ; arg2, ponteiro para string
    mov ebx, 1              ; arg1, onde escrever: no caso escreveremos para a tela
    mov eax, 4              ; write system call: chamada ao sistema para escrever
    int 0x80                ; interrupção 80 hex, chama o kernel do S.O.

    mov ebx, 0              ; código de saída: 0 = normal
    mov eax, 1              ; chamada para o S.O.
    int 0x80                ; interrupção 80 hex, chama o kernel do S.O.
