# as p1.S -march=rv64gc -o p1.o && ld -s p1.o -o p1 && truncate -s 265 p1
# ./p1 < data/input.txt

.global _start

_start:
  li s0, 0
readline:
  li s1, 0
readchar:
  addi a0, x0, 0
  addi a1, sp, 0
  addi a2, x0, 1
  addi a7, x0, 63
  ecall
  beq a0, x0, div
  ld a3, (sp)
  addi a3, a3, -'\n'
  beq a3, x0, add
  addi a3, a3, -('0' - '\n')
  li t0, 10
  bgeu a3, t0, readchar
  bne s1, x0, skip
  mul a4, a3, t0 
  add s0, s0, a4
skip:
  addi s1, a3, 0
  j readchar
add:
  add s0, s0, s1
  j readline
div:
  rem a0, s0, t0
  add a0, a0, '0'
  sd a0, (a1)
  addi a1, a1, 1
  addi s1, s1, 1
  div s0, s0, t0
  bne s0, x0, div
  addi a7, a7, 64 - 63
print:
  addi a1, a1, -1
  addi a0, x0, 1
  ecall
  addi s1, s1, -1
  bne s1, x0, print
  addi a7, a7, 93 - 64
  ecall
