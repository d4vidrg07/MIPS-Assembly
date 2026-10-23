.data
vector: .space 10
.align 2
result: .space 4
str1: .asciiz "\nIntroducir elemento("
str2: .asciiz ") del vector[]: "
str3: .asciiz "\nSuma: "

.text
.globl main

main:	
        	#######################################
			# add your code from here on...
			li $t0, 1		# i = 1, to iterate
			li $t1, 10		#number of iterations 
			la $t2, vector	#where the numbers will be stored
			li $t3, 5		#to check whether it equals 5
			li $t4, 3		#to check whether it is a multiple of 3
			li $s0, 0		#where the sum is accumulated

bucle:		
			bgt $t0, $t1, fin		#stops when i is greater than 10

			#first print all the messages, then start asking for input

			li $v0, 4				#print str1
			la $a0, str1			
			syscall

			li $v0, 1				#print the counter
			move $a0, $t0
			syscall
			
			li $v0, 4				#print str2
			la $a0, str2
			syscall

			li $v0, 5				#read the integer
			syscall					#store it
			move $t6, $v0			#move it to $t6, to keep it in a safe register

			blt $t6, -128, bucle	#in case of blt or bgt, start over and ask for the number again
			bgt $t6, 127, bucle


			sb $t6, 0($t2)      	# Guardo
			addi $t2, $t2, 1    	# Avanzo puntero

			beq $t6, $t3, validez		#compare to check whether it equals 5


			div $t6, $t4			#check whether it is a multiple of 3
			mfhi $t5				#move the remainder somewhere
			beqz $t5, validez		#compare the remainder with 0 to continue

			j contar		#ir a incrementar

validez:						

		add $s0, $s0, $t6

contar:
		addi $t0, $t0, 1
		j bucle

fin:		
			sw $s0, result		#store the result in memory

			li $v0, 4			#texto suma
			la $a0, str3
			syscall

			li $v0, 1			#the sum word itself
			move $a0, $s0		#move it to an $a register to print
			syscall				#imprimes



        	#######################################		
			li	$v0, 10
			syscall         # exit
		
