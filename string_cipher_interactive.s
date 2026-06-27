###############################################################################
# string_cipher_interactive.s
#
# Interactive version of the string cipher, built around a reusable
# subroutine.
#
# Subroutine cifrar(str, str2, letter, substitute):
#   Capitalizes the first letter of every word in "str" and replaces every
#   occurrence of "letter" (in either case) with "substitute", while
#   counting how many substitutions were made.
#
#   Input parameters:
#     $a0 -> address of the source string (str)
#     $a1 -> address of the destination string (str2)
#     $a2 -> letter to search for (character value, lowercase)
#     $a3 -> substitute character (character value)
#
#   Output parameter:
#     $v0 -> number of characters that were substituted
#
# main():
#   Reads the string, the target letter and the substitute character from
#   the keyboard, calls cifrar(), and prints the resulting string together
#   with the substitution count.
###############################################################################

.data
prompt_string:        .asciiz "Enter the string (lowercase letters and spaces only): "
prompt_letter:         .asciiz "Enter the letter to search for: "
prompt_substitute:     .asciiz "Enter the substitute character: "

input_buffer:          .space  128         # holds the string typed by the user
output_buffer:         .space  128         # holds the resulting cipher text

msg_output:            .asciiz "\nEncrypted string : "
msg_count:              .asciiz "\nSubstitutions    : "
newline:                .asciiz "\n"

.text
.globl main

###############################################################################
# main
###############################################################################
main:
    li   $v0, 4
    la   $a0, prompt_string
    syscall

    li   $v0, 8                  # read_string
    la   $a0, input_buffer
    li   $a1, 128
    syscall

    jal  strip_newline           # replace the trailing '\n' with '\0'

    li   $v0, 4
    la   $a0, prompt_letter
    syscall
    li   $v0, 12                 # read_char
    syscall
    move $t2, $v0                # $t2 = target letter
    li   $v0, 12                 # consume the trailing newline left in stdin
    syscall

    li   $v0, 4
    la   $a0, prompt_substitute
    syscall
    li   $v0, 12                 # read_char
    syscall
    move $t3, $v0                # $t3 = substitute character
    li   $v0, 12                 # consume the trailing newline left in stdin
    syscall

    la   $a0, input_buffer
    la   $a1, output_buffer
    move $a2, $t2
    move $a3, $t3
    jal  cifrar

    move $t5, $v0                 # save the substitution count returned by cifrar

    li   $v0, 4
    la   $a0, msg_output
    syscall

    li   $v0, 4
    la   $a0, output_buffer
    syscall

    li   $v0, 4
    la   $a0, msg_count
    syscall

    li   $v0, 1
    move $a0, $t5
    syscall

    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 10                  # exit
    syscall

###############################################################################
# strip_newline
#   Replaces the first '\n' found in input_buffer with a '\0', so the string
#   read with syscall 8 can be treated as a clean, null-terminated string.
#   Does not use any registers that need to be preserved by the caller.
###############################################################################
strip_newline:
    la   $t0, input_buffer
strip_loop:
    lb   $t1, 0($t0)
    beq  $t1, $zero, strip_done
    beq  $t1, 10, found_newline   # 10 = '\n'
    addi $t0, $t0, 1
    j    strip_loop
found_newline:
    sb   $zero, 0($t0)
strip_done:
    jr   $ra

###############################################################################
# cifrar(str, str2, letter, substitute)
#   See header comment for the calling convention. Leaf subroutine: only
#   temporary registers are used, so no registers need to be saved/restored.
###############################################################################
cifrar:
    move $t0, $a0                 # $t0 -> current char of str
    move $t1, $a1                 # $t1 -> current char of str2
    move $t2, $a3                 # $t2 = substitute character
    li   $t4, 1                   # word_start_flag (1 = capitalize next letter)
    li   $t5, 0                   # substitution_count

    move $t8, $a2                 # $t8 = target letter (lowercase)
    addi $t9, $t8, -32             # $t9 = target letter (uppercase)

cifrar_loop:
    lb   $t6, 0($t0)
    beq  $t6, $zero, cifrar_end

    beq  $t6, 32, cifrar_space     # 32 = ' '

    bne  $t4, 1, cifrar_check_sub
    addi $t6, $t6, -32             # capitalize first letter of the word
    li   $t4, 0
cifrar_check_sub:
    beq  $t6, $t8, cifrar_substitute
    beq  $t6, $t9, cifrar_substitute
    j    cifrar_store

cifrar_space:
    li   $t4, 1                    # next letter starts a new word
    j    cifrar_store

cifrar_substitute:
    move $t6, $t2
    addi $t5, $t5, 1

cifrar_store:
    sb   $t6, 0($t1)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j    cifrar_loop

cifrar_end:
    sb   $zero, 0($t1)             # null-terminate str2
    move $v0, $t5                  # return substitution count
    jr   $ra
