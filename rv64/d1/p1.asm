; nasm p1.asm -o p1
; ./p1 < data/input.txt

              org     0x00010000

ehdr:                                                 ; elf64_hdr
              db      0x7F, "ELF", 2, 1, 1, 0         ;   e_ident
      times 8 db      0
              dw      2                               ;   e_type
              dw      0xf3                            ;   e_machine
              dd      1                               ;   e_version
              dq      _start                          ;   e_entry
              dq      phdr - $$                       ;   e_phoff

_start:       ; your program here (max 12 bytes)

              dw      0x4401            ; li s0, 0    ;   e_shoff
              dw      0x42a9            ; li t0, 10
              dd      0x03f00893        ; li a7, 63
readline:
              dw      0x4481            ; li s1, 0    ;   e_flags
              dw      0xa83d            ; j readchar

              dw      ehdrsize                        ;   e_ehsize
              dw      phdrsize                        ;   e_phentsize
phdr:                                                                   ; elf64_phdr
              dw      1                               ;   e_phnum       ;   p_type
              dw      0                               ;   e_shentsize
              dw      5                               ;   e_shnum       ;   p_flags
              dw      0                               ;   e_shstrndx

ehdrsize      equ     $ - ehdr

              dq      0                                                 ;   p_offset
              dq      $$                                                ;   p_vaddr
              dq      $$                                                ;   p_paddr
              dq      filesize                                          ;   p_filesz
              dq      filesize                                          ;   p_memsz
              dq      0x1000                                            ;   p_align

phdrsize      equ     $ - phdr

readchar:
              dw      0x4501            ; li a0, 0
              dw      0x858a            ; mv a1, sp
	      dw      0x4605            ; li a2, 1
              dd      0x00000073        ; ecall
              dw      0xc51d            ; beq a0, x0, extra
              dw      0x6682            ; ld a3, (sp)
              dw      0x16d9            ; addi a3, a3, -'\n'
              dw      0xca99            ; beqz a3, add
              dd      0xfda68693        ; addi a3, a3, -('0' - '\n')
              dd      0xfe56f5e3        ; bgeu a3, t0, readchar
              dw      0xe481            ; bnez s1, skip
              dd      0x02568733        ; mul a4, a3, t0
              dw      0x943a            ; add s0, s0, a4
skip:
              dw      0x84b6            ; mv s1, a3
              dw      0xbff1            ; j readchar
add:
              dw      0x9426            ; add s0, s0, s1
              dw      0xbf61            ; j readline
div:
              dd      0x02546533        ; rem a0, s0, t0
              dd      0x03050513        ; add a0, a0, '0'
              dw      0xe188            ; sd a0, (a1)
              dd      0x02544433        ; div s0, s0, t0
extra:
              dw      0x0485            ; add s1, s1, 1
              dw      0x0585            ; add a1, a1, 1
              dw      0xf47d            ; bnez s0, div
              dw      0x0885            ; add a7, a7, 64 - 63
print:
              dw      0x15fd            ; add a1, a1, -1
              dw      0x4505            ; li a0, 1
              dd      0x00000073        ; ecall
              dw      0x14fd            ; add s1, s1, -1
              dw      0xf8fd            ; bnez s1, print
exit:
              dw      0x08f5            ; add a7, a7, 93 - 64
              db      0x73              ; ecall

filesize      equ     $ - $$
