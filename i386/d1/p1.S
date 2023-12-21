# as -32 p1.S -o p1.o && ld -s -n -m elf_i386 p1.o -o p1 && truncate -s 260 p1
# ./p1 < data/input.txt

.global _start
.intel_syntax noprefix

_start:
  inc edx
.readline:
  sub al, '0'
  cmp al, 9
  ja .no
  test ch, ch
  jnz .first
  mov ch, al
.first:
  mov cl, al
.no:
  cmp al, 10 - '0'
  xchg eax, ecx
  jnz .readchar
  aad
  add edi, eax
  xor eax, eax
.readchar:
  mov ecx, esp
  push eax
  push 3
  pop eax
  int 0x80
  test eax, eax
  mov eax, [ecx]
  pop ecx
  jnz .readline
  mov al, 10
  xchg eax, edi
.div:
  xor edx, edx
  div edi
  add dl, '0'
  push edx
  inc esi
  test eax, eax
  jnz .div
  inc ebx
  mov dl, 1
.print:
  mov al, 4
  mov ecx, esp
  int 0x80
  pop ecx
  dec esi
  jns .print
.exit:
  int 0x80
