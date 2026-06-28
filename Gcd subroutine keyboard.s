# -----------------------------------------------------------
# Program: Greatest Common Divisor (GCD) - subroutine + keyboard input
# Reads a and b from the keyboard, computes gcd(a, b) using a
# subroutine, and prints the result.
# -----------------------------------------------------------

.data
prompt_a:    .asciiz "Enter value of a: "
prompt_b:    .asciiz "Enter value of b: "
result_msg:  .asciiz "The GCD is: "
gcd_val:     .word 0
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

        # ---- call the gcd subroutine ----
        move $a0, $s0
        move $a1, $s1

        jal gcd

        sw $v0, gcd_val

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
# subroutine gcd(a, b)
# Input parameters:
#   $a0 = a
#   $a1 = b
# Output parameter:
#   $v0 = gcd(a, b)
# -----------------------------------------------------------
gcd:
        move $t0, $a0
        move $t1, $a1
loop_1:
        beq $t1, $zero, end_while

        move $t2, $t0          # remainder = a

loop_2:
        blt $t2, $t1, end_while_2

        sub $t2, $t2, $t1

        j loop_2

end_while_2:
        move $t0, $t1

        move $t1, $t2

        j loop_1

end_while:
        move $v0, $t0
        jr $ra
