###############################################################################
# string_cipher.s
#
# Word-capitalizing string cipher with letter substitution.
#
# Given a string that contains only lowercase letters and spaces, this
# program builds a new string in which:
#   - The first letter of every word is capitalized.
#   - Every occurrence of a given target letter (in either case) is replaced
#     by a substitute character.
#
# The number of substitutions performed is stored in "substitution_count".
#
# Example:
#   input_str        = "hola mundo esto es una prueba"
#   target_letter     = 'e'
#   substitute_char   = '*'
#   output_str        = "Hola Mundo *sto *s Una Pru*ba"
#   substitution_count = 3
###############################################################################

.data
input_str:              .asciiz "hola mundo esto es una prueba"
output_str:              .space  64          # must be >= len(input_str) + 1
target_letter:           .byte   'e'         # letter to search for (lowercase)
substitute_char:         .byte   '*'         # replacement character
substitution_count:      .word   0

msg_output:              .asciiz "Encrypted string : "
msg_count:                .asciiz "\nSubstitutions    : "
newline:                  .asciiz "\n"

.text
.globl main

main:
    la   $t0, input_str          # $t0 -> current char of input_str
    la   $t1, output_str         # $t1 -> current char of output_str
    li   $t4, 1                  # word_start_flag (1 = capitalize next letter)
    li   $t5, 0                  # substitution_count

    lb   $t8, target_letter      # $t8 = target letter (lowercase)
    addi $t9, $t8, -32           # $t9 = target letter (uppercase)
    lb   $s0, substitute_char    # $s0 = substitute character

while_loop:
    lb   $t6, 0($t0)             # $t6 = current character
    beq  $t6, $zero, end_while   # stop at the null terminator

    beq  $t6, 32, is_space       # 32 = ' '

    bne  $t4, 1, check_substitution
    addi $t6, $t6, -32           # capitalize first letter of the word
    li   $t4, 0
check_substitution:
    beq  $t6, $t8, do_substitution
    beq  $t6, $t9, do_substitution
    j    store_char

is_space:
    li   $t4, 1                  # next letter starts a new word
    j    store_char

do_substitution:
    move $t6, $s0
    addi $t5, $t5, 1

store_char:
    sb   $t6, 0($t1)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j    while_loop

end_while:
    sb   $zero, 0($t1)           # null-terminate output_str
    sw   $t5, substitution_count

    # --- print results ---
    li   $v0, 4
    la   $a0, msg_output
    syscall

    li   $v0, 4
    la   $a0, output_str
    syscall

    li   $v0, 4
    la   $a0, msg_count
    syscall

    li   $v0, 1
    lw   $a0, substitution_count
    syscall

    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 10                 # exit
    syscall
