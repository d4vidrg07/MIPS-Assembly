###############################################################################
# bcd_adder_interactive.s
#
# Packed BCD Adder - Interactive version (MIPS Assembly)
#
# Same BCD addition logic as bcd_adder.s, but restructured into reusable
# subroutines and driven by user input instead of hard-coded constants.
#
# Flow:
#   1. Prompt the user for A and B (plain decimal integers).
#   2. Convert each decimal integer to packed BCD  -> dec_to_bcd
#   3. Add the two packed BCD numbers               -> add_bcd
#   4. Convert the packed BCD result back to decimal for display
#                                                    -> bcd_to_dec
#   5. Print the result and the overflow flag.
#
# Syscalls used:
#   4  -> print_string
#   5  -> read_int
#   1  -> print_int
#   10 -> exit
###############################################################################

.data
prompt_a:     .asciiz "Enter first number A (0-99999999): "
prompt_b:     .asciiz "Enter second number B (0-99999999): "
result_msg:   .asciiz "\nA + B = "
overflow_msg: .asciiz " (overflow: result does not fit in 8 digits)\n"
newline:      .asciiz "\n"

.text
.globl main

main:
    # ---- Read A ----
    li      $v0, 4
    la      $a0, prompt_a
    syscall

    li      $v0, 5              # read_int
    syscall
    move    $a0, $v0
    jal     dec_to_bcd
    move    $s0, $v0            # $s0 = A in packed BCD

    # ---- Read B ----
    li      $v0, 4
    la      $a0, prompt_b
    syscall

    li      $v0, 5              # read_int
    syscall
    move    $a0, $v0
    jal     dec_to_bcd
    move    $s1, $v0            # $s1 = B in packed BCD

    # ---- Add A + B in BCD ----
    move    $a0, $s0
    move    $a1, $s1
    jal     add_bcd
    move    $s2, $v0            # $s2 = sum (packed BCD)
    move    $s3, $v1            # $s3 = overflow flag

    # ---- Convert the result back to decimal for printing ----
    move    $a0, $s2
    jal     bcd_to_dec
    move    $s4, $v0            # $s4 = decimal sum

    # ---- Print result ----
    li      $v0, 4
    la      $a0, result_msg
    syscall

    li      $v0, 1              # print_int
    move    $a0, $s4
    syscall

    beqz    $s3, no_overflow
    li      $v0, 4
    la      $a0, overflow_msg
    syscall
    j       exit_prog

no_overflow:
    li      $v0, 4
    la      $a0, newline
    syscall

exit_prog:
    li      $v0, 10
    syscall


###############################################################################
# dec_to_bcd
#   Converts a plain decimal integer into packed BCD (8 digits).
#   in : $a0 = decimal value (0 .. 99999999)
#   out: $v0 = packed BCD (32 bits, 4 bits per digit)
###############################################################################
dec_to_bcd:
    li      $v0, 0              # result
    move    $t0, $a0            # working value
    li      $t1, 0              # digit index (0..7)
    li      $t6, 10

dtb_loop:
    beq     $t1, 8, dtb_end

    div     $t2, $t0, $t6       # $t2 = $t0 / 10
    rem     $t3, $t0, $t6       # $t3 = $t0 % 10

    sll     $t4, $t1, 2         # shift = i*4
    sllv    $t3, $t3, $t4       # digit << shift
    or      $v0, $v0, $t3

    move    $t0, $t2
    addi    $t1, $t1, 1
    j       dtb_loop

dtb_end:
    jr      $ra


###############################################################################
# bcd_to_dec
#   Converts a packed BCD value (8 digits) into a plain decimal integer.
#   in : $a0 = packed BCD
#   out: $v0 = decimal value
###############################################################################
bcd_to_dec:
    li      $v0, 0              # decimal value
    li      $t0, 7              # i = 7 (most significant digit first)
    li      $t5, 10

btd_loop:
    bltz    $t0, btd_end

    sll     $t1, $t0, 2
    srlv    $t2, $a0, $t1
    andi    $t2, $t2, 0xF       # current digit

    mul     $v0, $v0, $t5       # value *= 10
    add     $v0, $v0, $t2       # value += digit

    addi    $t0, $t0, -1
    j       btd_loop

btd_end:
    jr      $ra


###############################################################################
# add_bcd
#   Adds two packed BCD numbers (8 digits), applying the BCD carry
#   correction digit by digit.
#   in : $a0 = A (packed BCD), $a1 = B (packed BCD)
#   out: $v0 = sum (packed BCD), $v1 = overflow (final carry, 0 or 1)
###############################################################################
add_bcd:
    li      $v0, 0              # sum
    li      $v1, 0              # carry
    li      $t0, 0              # i

ab_loop:
    beq     $t0, 8, ab_end

    sll     $t1, $t0, 2         # shift = i*4

    srlv    $t2, $a0, $t1
    andi    $t2, $t2, 0xF       # digit of A

    srlv    $t3, $a1, $t1
    andi    $t3, $t3, 0xF       # digit of B

    add     $t4, $t2, $t3
    add     $t4, $t4, $v1       # + carry

    li      $v1, 0
    li      $t5, 9
    ble     $t4, $t5, ab_ok     # no correction needed if digit <= 9

    addi    $t4, $t4, 6
    srl     $v1, $t4, 4         # new carry

ab_ok:
    andi    $t4, $t4, 0xF
    sllv    $t4, $t4, $t1
    or      $v0, $v0, $t4

    addi    $t0, $t0, 1
    j       ab_loop

ab_end:
    jr      $ra
