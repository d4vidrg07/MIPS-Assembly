# -----------------------------------------------------------
# Program: Greatest Common Divisor (GCD) - basic version
# Euclidean algorithm. The remainder is computed by repeated
# subtraction, since MIPS has no direct "mod" instruction.
# -----------------------------------------------------------

.data
a_val:      .word 48
b_val:      .word 18
remainder:  .word 0
.text
.globl main
main:
        lw $t0, a_val
        lw $t1, b_val
        lw $t2, remainder

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
        li $v0, 10
        syscall
