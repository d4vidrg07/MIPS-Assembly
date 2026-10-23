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
			# añada su código a partir de aquí...
			li $t0, 1		# i = 1, para iterar
			li $t1, 10		#cantidad iteraciones 
			la $t2, vector	#donde guardare los numeros
			li $t3, 5		#para comprobar si es igual a 5
			li $t4, 3		#para comprobar si es multiplo de 3
			li $s0, 0		#donde voy a sumar las cosas

bucle:		
			bgt $t0, $t1, fin		#cuando 1 es mayor que 10 se para

			#primero imprimo todos los mensajes y luego empiezo a pedir

			li $v0, 4				#imprimo str1
			la $a0, str1			
			syscall

			li $v0, 1				#imprimir el contaodr
			move $a0, $t0
			syscall
			
			li $v0, 4				#imprimes el str2
			la $a0, str2
			syscall

			li $v0, 5				#leo el entero
			syscall					#lo guardo
			move $t6, $v0			#lo muevo a $t6, para dejarlo en un registro seguro

			blt $t6, -128, bucle	#en caso de blt o bgt vuelvo a iniciar y pedir el numero
			bgt $t6, 127, bucle


			sb $t6, 0($t2)      	# Guardo
			addi $t2, $t2, 1    	# Avanzo puntero

			beq $t6, $t3, validez		#comparo si es igual a 5


			div $t6, $t4			#comparo si es multiplo de 3
			mfhi $t5				#mueves el resto a algun lado
			beqz $t5, validez		#comparas el resto con 0 para seguir

			j contar		#ir a incrementar

validez:						

		add $s0, $s0, $t6

contar:
		addi $t0, $t0, 1
		j bucle

fin:		
			sw $s0, result		#guardo el resultado en la memoria

			li $v0, 4			#texto suma
			la $a0, str3
			syscall

			li $v0, 1			#el propio word de la suma
			move $a0, $s0		#mueves a un a para imprimir
			syscall				#imprimes



        	#######################################		
			li	$v0, 10
			syscall         # exit
		
