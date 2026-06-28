# =================================================================
# File:        filter_positive_even_subroutine_keyboard.s
# Description: Reads an array from the keyboard, filters out the
#              positive even numbers into a separate array using a
#              subroutine, and prints the filtered array and the
#              sum of its elements.
# =================================================================
.data
prompt_size:    .asciiz "Enter the number of elements: "
prompt_elem:    .asciiz "Enter element: "
msg_sum:        .asciiz "Sum of positive even numbers: "
msg_array:      .asciiz "Filtered array: "
elem_sep:       .asciiz " "
newline:        .asciiz "\n"
vector_in:      .space 80    # up to 20 elements
vector_out:     .space 80    # up to 20 elements
sum_val:        .word 0
.text
.globl main
main:
				# ---- read the array size ----
				li $v0, 4
				la $a0, prompt_size
				syscall

				li $v0, 5
				syscall
				move $s0, $v0           # s0 = size

				# ---- read the elements ----
				la $s1, vector_in        # s1 = pointer for storing input
				li $s2, 0                 # s2 = read counter
read_loop:
				bge $s2, $s0, end_read_loop

				li $v0, 4
				la $a0, prompt_elem
				syscall

				li $v0, 5
				syscall
				sw $v0, 0($s1)

				addi $s1, $s1, 4
				addi $s2, $s2, 1
				j read_loop
end_read_loop:

				# ---- call the subroutine ----
				la $a0, vector_in
				la $a1, vector_out
				move $a2, $s0

				jal filter_positive_even

				move $s3, $v1            # s3 = number of filtered elements
				sw $v0, sum_val

				# ---- print the sum ----
				li $v0, 4
				la $a0, msg_sum
				syscall

				lw $a0, sum_val
				li $v0, 1
				syscall

				li $v0, 4
				la $a0, newline
				syscall

				# ---- print the filtered array ----
				li $v0, 4
				la $a0, msg_array
				syscall

				la $t1, vector_out
				li $t2, 0
print_loop:
				bge $t2, $s3, end_print_loop

				lw $a0, 0($t1)
				li $v0, 1
				syscall

				li $v0, 4
				la $a0, elem_sep
				syscall

				addi $t1, $t1, 4
				addi $t2, $t2, 1
				j print_loop
end_print_loop:
				li $v0, 4
				la $a0, newline
				syscall

				li $v0, 10
				syscall

# -----------------------------------------------------------
# subroutine filter_positive_even(in_addr, out_addr, size)
# Input parameters:
#   $a0 = address of the input array
#   $a1 = address of the output array
#   $a2 = number of elements in the input array
# Output parameters:
#   $v0 = sum of the positive even numbers found
#   $v1 = number of elements written to the output array
# -----------------------------------------------------------
filter_positive_even:
				move $t0, $a0            # input pointer
				move $t1, $a1            # output pointer
				move $t2, $a2            # loop limit (size)
				li $t3, 0                 # accumulator (sum)
				li $t4, 0                 # loop counter (i)
				li $t7, 0                 # count of stored elements
				li $t8, 2                 # divisor constant for even check

loop_filter:
				bge $t4, $t2, end_loop_filter

				lw $t5, 0($t0)             # current_value

check_positive:
				blez $t5, next_element     # keep only strictly positive numbers

check_even:
				div $t5, $t8
				mfhi $t6                    # t6 = current_value % 2
				bnez $t6, next_element      # skip odd numbers

store_element:
				sw $t5, 0($t1)
				addi $t1, $t1, 4
				addi $t7, $t7, 1

				add $t3, $t3, $t5

next_element:
				addi $t4, $t4, 1
				addi $t0, $t0, 4
				j loop_filter

end_loop_filter:
				move $v0, $t3              # return the sum
				move $v1, $t7              # return the count
				jr $ra
