	.data 
cadena1: .asciiz "\nIntroducir dato A = "   
cadena2: .asciiz "\nIntroducir dato B = "   
cadena3: .asciiz "\nEl valor de A+B es = "   

    .data 0x10010103
# definir a partir de aquí tres palabras: A, B y Suma. Tenga cuidado con el comienzo del segmento.
    .align 2
A:       .word 0
B:       .word 0
Suma:    .word 0

	.text   
	.globl main 
main:	# añada aquí las instrucciones de su programa
        
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
	
