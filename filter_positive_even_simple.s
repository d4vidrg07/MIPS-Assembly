# =================================================================
# File:        filter_positive_even_simple.s
# Description: MIPS assembly program that filters positive even
#              numbers from an input array into an output array,
#              and calculates their total sum.
# =================================================================
.data
input_array:      .word 12, -5, 8, 0, 3, 14, -2, 6   # input array
output_array:     .space 32                            # output buffer (8 elements * 4 bytes)
sum_val:          .word 0                              # result variable in memory
.text
.globl main
main:
				# ---- initialize pointers ----
				la $t0, input_array      # pointer to input array
				la $t1, output_array     # pointer to output array

				# ---- initialize registers ----
				li $t2, 8                # loop limit (array size = 8)
				li $t3, 0                # accumulator (sum = 0)
				li $t4, 0                # loop counter (i = 0)
				li $t8, 2                # divisor constant for even check

loop_filter:
				bge $t4, $t2, end_loop_filter   # exit when i >= size

				lw $t5, 0($t0)            # current_value = input_array[i]

check_positive:
				# keep only strictly positive numbers
				blez $t5, next_element

check_even:
				# check parity using the remainder
				div $t5, $t8
				mfhi $t6                  # t6 = current_value % 2
				bnez $t6, next_element    # skip odd numbers

store_element:
				sw $t5, 0($t1)
				addi $t1, $t1, 4           # advance output pointer

				add $t3, $t3, $t5           # accumulate sum

next_element:
				addi $t4, $t4, 1
				addi $t0, $t0, 4
				j loop_filter

end_loop_filter:
				sw $t3, sum_val            # save final sum back to memory

				li $v0, 10
				syscall
