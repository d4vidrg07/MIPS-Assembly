# -----------------------------------------------------------
# Program: Least Common Multiple (LCM) - subroutine + keyboard input
# Reads a and b from the keyboard, computes lcm(a, b) using a
# subroutine, and prints the result.
# -----------------------------------------------------------

.data
prompt_a:    .asciiz "Enter value of a: "
prompt_b:    .asciiz "Enter value of b: "
result_msg:  .asciiz "The LCM is: "
lcm_val:     .word 0
.text
.globl main
main:
        # ---- read a ----
        li $v0, 4
        la $a0, prompt_a
        syscall

        li $v0, 5
        syscall
        move $s0, $v0          # $s0 = a

        # ---- read b ----
        li $v0, 4
        la $a0, prompt_b
        syscall

        li $v0, 5
        syscall
        move $s1, $v0          # $s1 = b

        # ---- call the lcm subroutine ----
        move $a0, $s0
        move $a1, $s1

        jal lcm

        sw $v0, lcm_val

        # ---- print the result ----
        li $v0, 4
        la $a0, result_msg
        syscall

        move $a0, $v0
        li $v0, 1
        syscall

        li $v0, 10
        syscall

# -----------------------------------------------------------
# subroutine lcm(a, b)
# Input parameters:
#   $a0 = a
#   $a1 = b
# Output parameter:
#   $v0 = lcm(a, b)
# -----------------------------------------------------------
lcm:
        move $t0, $a0
        move $t1, $a1

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
        move $v0, $t3           # return the lcm
        jr $ra
