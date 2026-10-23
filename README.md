# MIPS Assembly

MIPS32 assembly programs written during my Computer Engineering degree at ULPGC (University of Las Palmas de Gran Canaria). They are meant to run in the MARS or SPIM simulators.

They show register management, memory access, the stack frame convention and subroutine calls, and how to implement algorithms without high-level instructions (for example, MIPS has no `mod`, so the remainder is computed by repeated subtraction).

## Programs

Many programs come in two versions: a **simple** one with hard-coded data, and an **interactive** one that reads from the keyboard and uses reusable subroutines.

| Topic | Files |
|---|---|
| Greatest common divisor (Euclid) | `gcd_simple.s`, `gcd_subroutine_keyboard.s` |
| Least common multiple | `lcm_simple.s`, `lcm_subroutine_keyboard.s` |
| Packed BCD addition (8 digits, with carry correction and overflow detection) | `bcd_adder.s`, `bcd_adder_interactive.s` |
| Filter the positive even numbers of an array and sum them | `filter_positive_even_simple.s`, `filter_positive_even_subroutine_keyboard.s` |
| Word-capitalizing string cipher with letter substitution | `string_cipher.s`, `string_cipher_interactive.s` |
| Selection sort of a matrix using nested subroutines and stack frames | `matrix_selection_sort.s` |
| Conditional sum of a vector read from the keyboard | `vector_conditional_sum.s` |
| Reading two values and storing them with their sum at a fixed memory address | `sum_memory.s` |

## Running

1. Open a program in the MARS or SPIM simulator.
2. Assemble it and run it. The interactive versions ask for their input in the console.

`matrix_selection_sort.s` only contains the sorting subroutines; it is called from a main program provided by the course.
