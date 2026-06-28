# -----------------------------------------------------------
# Program: Least Common Multiple (LCM) - basic version
# Finds the LCM by checking successive multiples of the
# larger number until one is also a multiple of the smaller
# number. "Is a multiple of" is checked manually (repeated
# subtraction), since MIPS has no direct "mod" instruction.
# -----------------------------------------------------------

.data
a_val:      .word 6
b_val:      .word 4
max_val:    .word 0
candidate:  .word 0
.text
.globl main
main:
        lw $t0, a_val
        lw $t1, b_val
        lw $t2, max_val
        lw $t3, candidate

# ---- find the larger of a and b ----
check_max:
        blt $t0, $t1, else_block

        move $t2, $t0          # max_val = a
        j end_if
else_block:
        move $t2, $t1          # max_val = b
end_if:
        move $t3, $t2          # candidate = max_val

        li $t4, 0              # t4 = found flag

while_loop:
        bne $t4, $zero, end_while

        move $t5, $t3          # remainder_a = candidate
calc_remainder_a:
        blt $t5, $t0, end_calc_a
        sub $t5, $t5, $t0
        j calc_remainder_a
end_calc_a:
        move $t6, $t3          # remainder_b = candidate
calc_remainder_b:
        blt $t6, $t1, end_calc_b
        sub $t6, $t6, $t1
        j calc_remainder_b
end_calc_b:

check_remainders:
        bne $t5, $zero, not_multiple
        bne $t6, $zero, not_multiple

        li $t4, 1               # found! candidate is a multiple of both
        j while_loop

not_multiple:
        add $t3, $t3, $t2       # try the next multiple
        j while_loop

end_while:
        move $t7, $t3           # t7 = lcm

        li $v0, 1
        move $a0, $t7
        syscall

        li $v0, 10
        syscall
