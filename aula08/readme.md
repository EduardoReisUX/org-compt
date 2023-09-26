Organização de Computadores, Roteiro da Aula Prática 8, 26 de setembro de 2023.

---

**Sumário**

- [Objetivo da aula](#objetivo-da-aula)
- [Roteiro](#roteiro)
- [Criando o código assembly Hello World](#criando-o-código-assembly-hello-world)
  - [Executando](#executando)
- [Criando o código assembly Hello World3](#criando-o-código-assembly-hello-world3)
  - [Executando](#executando-1)
- [Referências](#referências)
  - [Linux System Call Table](#linux-system-call-table)

## Objetivo da aula

Foi feita uma simulação com a linguagem ASSEMBLY. Foi discutido como o compilador C faz a compilação para o arquivo .asm e o montador monta em .exe.

Foi feito um código hello world em .asm

## Roteiro

## Criando o código assembly Hello World

Através de um sistema operacional Linux:

Abrir o editor de código Kate:


```assembly
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

```

Salvar como hello.asm

### Executando

Com o bash, ao executar o código abaixo, (montará?) TODO:

```bash
nasm -f elf64 -F stabs hello.asm -o hello.o
```

O código abaixo criará um (link?) TODO:

```bash
ld -m elf_x86_64 hello.o -o hello
```

O comando abaixo irá executar o código, printando "Hello World" na tela:

```bash
./hello
```

## Criando o código assembly Hello World3

Salvar o seguinte código como `hello3.asm`:

```assembly

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
```

### Executando

Com o bash, ao executar o código abaixo, (montará?) TODO:

```bash
nasm -f elf64 -F stabs hello3.asm -o hello3.o
```

O código abaixo criará um (link?) TODO:

```bash
ld -m elf_x86_64 hello3.o -o hello3
```

O comando abaixo irá executar o código, printando "Hello World" na tela:

```bash
./hello3
```

## Referências

### Linux System Call Table

<a href="https://faculty.nps.edu/cseagle/assembly/sys_call.html">Link para uma tabela de chamadas ao sistema</a>

Não precisa fazer relatório dessa aula prática, serve apenas para estudos da P3.