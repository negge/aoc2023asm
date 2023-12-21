; nasm p1.asm -o p1
; ./p1 < data/input.txt

bits 32
cpu 386

              org     0x00010000

ehdr:                                         ; elf32_hdr
              db      0x7F, "ELF"             ;   e_ident
phdr:                                                           ; elf32_phdr
              dd      1                                         ;   p_type
              dd      0                                         ;   p_offset
              dd      $$                                        ;   p_vaddr
              dw      2                       ;   e_type        ;   p_paddr
              dw      3                       ;   e_machine
              dd      _start                  ;   e_version     ;   p_filesz
              dd      _start                  ;   e_entry       ;   p_memsz
              dd      4                       ;   e_phoff       ;   p_flags

phdrsize      equ     $ - phdr + 4

_start:       ; your program here (max 10 bytes)
              inc     edx                     ;   e_shoff       ;   p_align
              nop
.readline:
              sub     al, '0'
              cmp     al, 9                   ;   e_flags
              ja      .no
              jmp     .skip                   ;   e_ehsize
              dw      phdrsize                ;   e_phentsize
              dw      1                       ;   e_phnum
              dw      0                       ;   e_shentsize
              dw      0                       ;   e_shnum
.skip:
              test    ch, ch                  ;   e_shstrndx
              jnz     .first
              mov     ch, al
.first:
              mov     cl, al
.no:
              cmp     al, 10 - '0'
              xchg    eax, ecx
              jnz     .readchar
              aad
              add     edi, eax
              xor     eax, eax
.readchar:
              mov     ecx, esp
              push    eax
              push    3
              pop     eax
              int     0x80
              test    eax, eax
              mov     eax, [ecx]
              pop     ecx
              jnz     .readline
              mov     al, 10
              xchg    eax, edi
.div:
              xor     edx, edx
              div     edi
              add     dl, '0'
              push    edx
              inc     esi
              test    eax, eax
              jnz     .div
              inc     ebx
              mov     dl, 1
.print:
              mov     al, 4
              mov     ecx, esp
              int     0x80
              pop     ecx
              dec     esi
              jns     .print
.exit:
              int     0x80

filesize      equ     $ - $$
