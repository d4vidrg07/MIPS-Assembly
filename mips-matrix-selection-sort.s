        .text
        .globl bucle2
bucle2:
        # $a0 = matriz (half*)
        # $a1 = n columnas
        # $a2 = i   (fila a ordenar)

        # Frame:
        #   0($sp)  = local max (word)
        #   4($sp)  = $s4
        #   8($sp)  = $s3
        #  12($sp)  = $s2
        #  16($sp)  = $s1
        #  20($sp)  = $s0
        #  24($sp)  = $ra

        addi $sp, $sp, -28
        sw   $ra, 24($sp)
        sw   $s0, 20($sp)
        sw   $s1, 16($sp)
        sw   $s2, 12($sp)
        sw   $s3, 8($sp)
        sw   $s4, 4($sp)

        move $s3, $a0          # base matriz
        move $s1, $a1          # n columnas
        move $s4, $a2          # fila i
        addi $s2, $sp, 0       # max
        li   $s0, 0            # j = 0

for_b2:
        addi $t9, $s1, -1
        bge  $s0, $t9, fin_b2   # di j < nºcol, fin

        # max = j
        sw   $s0, 0($s2)

        # llamar a bucle3(matriz, j, i, nºcol)
        move $a0, $s3
        move $a1, $s1
        move $a2, $s4
        move $a3, $s0

        addi $sp, $sp, -4
        sw   $s2, 0($sp)
        jal  bucle3
        addi $sp, $sp, 4

        # si max != j, intercambiar M[i][j] con M[i][max]
        lw   $t0, 0($s2)       # max
        beq  $t0, $s0, next_b2

        # dir M[i][j]
        #offset
        mul  $t1, $s4, $s1
        add  $t1, $t1, $s0
        sll  $t1, $t1, 1
        add  $t2, $s3, $t1
        lh   $t3, 0($t2)

        # dir M[i][max]
        #offset
        mul  $t4, $s4, $s1
        add  $t4, $t4, $t0
        sll  $t4, $t4, 1
        add  $t5, $s3, $t4
        lh   $t6, 0($t5)

        # cambio
        sh   $t6, 0($t2)
        sh   $t3, 0($t5)

next_b2:
        addi $s0, $s0, 1
        j    for_b2

fin_b2:
        lw   $s4, 4($sp)
        lw   $s3, 8($sp)
        lw   $s2, 12($sp)
        lw   $s1, 16($sp)
        lw   $s0, 20($sp)
        lw   $ra, 24($sp)
        addi $sp, $sp, 28
        jr   $ra


        .globl bucle3
bucle3:
        # $a0 = matriz
        # $a1 = nºcol
        # $a2 = i
        # $a3 = j
        # max

        # Frame:
        #   0($sp)  = $s3
        #   4($sp)  = $s2
        #   8($sp)  = $s1
        #  12($sp)  = $s0
        #  16($sp)  = $ra
        #
        # 20($sp)

        addi $sp, $sp, -20
        sw   $ra, 16($sp)
        sw   $s0, 12($sp)
        sw   $s1, 8($sp)
        sw   $s2, 4($sp)
        sw   $s3, 0($sp)

        lw   $s1, 20($sp)      # s1 = max
        addi $s0, $a3, 1       # k = j + 1

for_b3:
        bge  $s0, $a1, fin_b3

        # valor actual: M[i][k]
        #offset y guardo el half
        mul  $t0, $a2, $a1
        add  $t0, $t0, $s0
        sll  $t0, $t0, 1
        add  $t1, $a0, $t0
        lh   $t2, 0($t1)

        # valor máximo actual: M[i][max]
        #offset y guardo el half del max
        lw   $t3, 0($s1)       # max
        mul  $t4, $a2, $a1
        add  $t4, $t4, $t3
        sll  $t4, $t4, 1
        add  $t5, $a0, $t4
        lh   $t6, 0($t5)

        # si M[i][k] > M[i][max], max = k
        ble  $t2, $t6, next_b3
        sw   $s0, 0($s1)

next_b3:
        addi $s0, $s0, 1
        j    for_b3

fin_b3:
        lw   $s3, 0($sp)
        lw   $s2, 4($sp)
        lw   $s1, 8($sp)
        lw   $s0, 12($sp)
        lw   $ra, 16($sp)
        addi $sp, $sp, 20
        jr   $ra
