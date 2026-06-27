###############################################################################
# bcd_adder.s
#
# Packed BCD Adder - MIPS Assembly
#
# Adds two 8-digit packed Binary-Coded Decimal (BCD) numbers stored as
# 32-bit words (4 bits per decimal digit), performing the BCD carry
# correction digit by digit and reporting overflow if the result does
# not fit in N digits.
#
# Input (constants in .data):
#   A    = 0x12829516
#   B    = 0x39490678
#   N    = 8           number of BCD digits
#   mask = 0x0000000F  mask to isolate one digit (4 bits)
#
# Output (memory):
#   sum      -> result of A + B, packed BCD (32 bits)
#   overflow -> 1 if the result does not fit in N digits, 0 otherwise
#
# Registers:
#   $t0 = A                  $t1 = B                  $t2 = N
#   $t4 = i (loop counter)    $t5 = shift (i*4)        $t6 = digit of A
#   $t7 = mask                $t8 = digit of B          $t9 = scratch
#   $s0 = carry              $s1 = 9 (BCD digit limit)  $s2 = 4 (carry shift)
#   $s3 = sum (accumulator)  $s4 = overflow
###############################################################################

.data
A:          .word 0x12829516
B:          .word 0x39490678
N:          .word 8
mask:       .word 0x0000000F
sum:        .word 0
overflow:   .word 0

.text
.globl main

main:
    lw      $t0, A
    lw      $t1, B
    lw      $t2, N          # N -> number of BCD digits
    lw      $t7, mask

    li      $t4, 0          # i = 0
    li      $s0, 0          # carry = 0
    li      $s1, 9          # upper bound for a valid BCD digit
    li      $s2, 4          # fixed shift to extract the carry (>> 4)
    li      $s3, 0          # sum = 0
    li      $s4, 0          # overflow = 0

loop:
    beq     $t4, $t2, end_loop      # if i == N, exit the loop

    sll     $t5, $t4, 2             # shift = i * 4

    # digit1 = (A >> shift) & mask
    srl     $t6, $t0, $t5
    and     $t6, $t6, $t7

    # digit2 = (B >> shift) & mask
    srl     $t8, $t1, $t5
    and     $t8, $t8, $t7

    # temp = digit1 + digit2 + carry
    add     $t9, $t6, $t8
    add     $t9, $t9, $s0

    li      $s0, 0                  # carry = 0 (recomputed below if needed)

    ble     $t9, $s1, no_adjust     # if temp <= 9, no BCD correction needed

    # BCD correction: temp += 6 ; carry = temp >> 4
    addi    $t9, $t9, 6
    srl     $s0, $t9, $s2

no_adjust:
    andi    $t9, $t9, 0xF           # keep the digit (low 4 bits)
    sll     $t9, $t9, $t5           # place it in its position

    or      $s3, $s3, $t9           # sum |= temp

    addi    $t4, $t4, 1             # i++
    j       loop

end_loop:
    move    $s4, $s0                # overflow = final carry

    sw      $s3, sum
    sw      $s4, overflow

    li      $v0, 10                 # exit syscall
    syscall
