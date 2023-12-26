; nasm p1.asm -o p1
; ./p1 < data/input.txt

bits 32
cpu 386

              org     0x058d0000

ehdr:                                         ; elf32_hdr
              db      0x7F, "ELF"             ;   e_ident
phdr:                                                           ; elf32_phdr
              dd      1                                         ;   p_type
              dd      0                                         ;   p_offset
              dd      $$                                        ;   p_vaddr
              dw      2                       ;   e_type        ;   p_paddr
              dw      3                       ;   e_machine
              dd      .start                  ;   e_version     ;   p_filesz
              dw      .start - $$             ;   e_entry       ;   p_memsz
.print:
              lea     eax, [dword 4]          ;   e_phoff       ;   p_flags
              mov     ecx, esp                ;   e_shoff       ;   p_align
              int     0x80

phdrsize      equ     $ - phdr

              pop     ecx                     ;   e_flags
              dec     esi
              jns     .print
.exit:
              int     0x80                    ;   e_ehsize

              dw      phdrsize                ;   e_phentsize
              dw      1                       ;   e_phnum
              dw      0                       ;   e_shentsize
.start:
              inc     edx                     ;   e_shnum
.readline:
              sub     al, '0'                 ;   e_shstrndx
              cmp     al, 9
              ja      .no
              test    ch, ch
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
.readchar:
              mov     ecx, esp
              push    eax
              push    3
              pop     eax
              int     0x80
              dec     eax
              mov     eax, [ecx]
              pop     ecx
              jns     .readline
              mov     al, 10
              xchg    eax, edi
.div:
              cdq
              div     edi
              add     dl, '0'
              push    edx
              inc     esi
              test    eax, eax
              jnz     .div
              inc     ebx
              mov     dl, 1
              jmp     .print
