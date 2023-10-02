.data
    str1:       .asciiz "Entre com a quantidade de numeros da sequencia: \n"
    str2:       .asciiz "Entre com um valor maior que 0. \n"
    str3:       .asciiz "Entre com o numero "
    str4:       .asciiz " da sequencia: \n"
    str5:       .asciiz "Valor minimo da sequencia: "
    str6:       .asciiz "\nValor medio da sequencia: "
    str7:       .asciiz "\nValor maximo da sequencia: "
    Seq:        
        .align 2
        .space 400

.text

.globl main

main:
    la $a0, str1
    jal print_string
    
    jal LerTamanhoSeq
    move $s0, $v0
    
    li $t0, 1
    li $t1, 0
    Loop:
        la $a0, str3
        jal print_string
        move $a0, $t0
        jal print_int
        la $a0, str4
        jal print_string
        
        jal Ler_int
        sw $v0, Seq($t1)
        addi $t1, $t1, 4
        addi $t0, $t0, 1
        bgt $t0, $s0, FimSeq
    j Loop
    
    FimSeq:
        jal MinSeq
        move $s1, $t3
        
        jal MedSeq
        mflo $s2
        
        jal MaxSeq
        move $s3, $t3
    
    la $a0, str5
    jal print_string
    move $a0, $s1
    jal print_int
    
    la $a0, str6
    jal print_string
    move $a0, $s2
    jal print_int
    
    la $a0, str7
    jal print_string
    move $a0, $s3
    jal print_int
    
    li $v0, 10
    syscall
    
print_int:
    li $v0, 1
    syscall
    jr $ra

print_string:
    li $v0, 4
    syscall
    jr $ra

Ler_int:
    li $v0, 5
    syscall
    jr $ra

LerTamanhoSeq:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    Ler:
        jal Ler_int
        ble $v0, $zero, TamanhoInvalido
    
    lw $ra, 0($sp)
    addi, $sp, $sp, 4
    jr $ra    

    TamanhoInvalido:
        la $a0, str2
        jal print_string
        la $a0, str1
        jal print_string
        j Ler
    
MudarMenor:
    move $t1, $t2
    move $t3, $t4
    j proximoMin

MinSeq:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 1
    li $t1, 0
    li $t2, 4
    
    lw $t3, Seq($t1)
    beq $s0, $t0, FimMin
    
    LoopMin:
        lw $t3, Seq($t1)
        lw $t4, Seq($t2)
        
        bgt $t3, $t4, MudarMenor
        proximoMin:
            addi $t2, $t2, 4
            addi $t0, $t0, 1
            beq $t0, $s0, FimMin
            j LoopMin
        
        FimMin:
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra
    
MedSeq:
    li $t0, 0
    li $t1, 0
    li $t2, 4
    li $t3, 0
    
    lw $t4, Seq($t1)
    beq $s0, $t1, FimSoma
    
    LoopSoma:
        lw $t4, Seq($t1)
        add $t3, $t3, $t4
        addi $t1, $t1, 4
        addi $t0, $t0, 1
        beq $t0, $s0, FimSoma
    j LoopSoma
    
    FimSoma:
        div $t3, $s0
        
    jr $ra

MudarMaior:
    move $t1, $t2
    move $t3, $t4
    j proximoMax

MaxSeq:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 1
    li $t1, 0
    li $t2, 4
    
    lw $t3, Seq($t1)
    beq $s0, $t0, FimMax
    
    LoopMax:
        lw $t3, Seq($t1)
        lw $t4, Seq($t2)
        
        blt $t3, $t4, MudarMaior
        proximoMax:
            addi $t2, $t2, 4
            addi $t0, $t0, 1
            beq $t0, $s0, FimMax
            j LoopMax
        
        FimMax:
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra
