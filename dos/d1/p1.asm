; nasm p1.asm -o p1.com
; dosbox -c "mount D ." -c "D:" -c "dir p1.com" -c "P1.COM < DATA\INPUT.TXT"
  cpu 8086
  org 0x100
start:
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
  jnz readchar
  xchg ax, cx
  aad
  add bx, ax
  xor cx, cx
readchar:
  mov ah, 1
  int 0x21
  test al, al
  jnz start
  xchg bx, ax
  mov bx, 10
.div:
  xor dx, dx
  div bx
  push dx
  inc cx
  test ax, ax
  jnz .div
  mov ah, 2
.pop:
  pop dx
  add dl, '0'
  int 0x21
  loop .pop
  ret
