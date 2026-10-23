	.data 
cadena1: .asciiz "\nIntroducir dato A = "   
cadena2: .asciiz "\nIntroducir dato B = "   
cadena3: .asciiz "\nEl valor de A+B es = "   

    .data 0x10010103
# define three words from here: A, B and Sum. Be careful with the start of the segment.
    .align 2
A:       .word 0
B:       .word 0
Suma:    .word 0

	.text   
	.globl main 
main:	# add your program instructions here
        
        li $v0, 4
        la $a0, cadena1
        syscall
        
        li $v0, 5
        syscall
        sw $v0, A
        
        li $v0, 4
        la $a0, cadena2
        syscall
        
        li $v0, 5
        syscall
        sw $v0, B
        
        lw $t0, A
        lw $t1, B
        
        add $t2, $t1, $t0
        
        sw $t2, Suma
        
        li $v0, 4
        la $a0, cadena3
        syscall
        
        li $v0, 1
        lw $a0, Suma
        syscall
       
    
	
	
	
    li $v0, 10
	syscall     # exit
	
