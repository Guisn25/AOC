.data
    str1:       .asciiz "Entre com a quantidade de numeros do vetor: \n"
    str2:       .asciiz "Entre com o numero "
    str3:       .asciiz " do vetor:\n"
    str4:       .asciiz "Vetor lido:"
    str5:       .asciiz "\nA media e variancia do vetor sao: "

.text

.globl main

main:
    la $a0, str1
    jal print_string
    
    jal ler_int
    move $s0, $v0   # $s0 salva o tamanho do vetor
    
    jal Ler_Vetor
    
    jal Med_Vetor   # $f0 salva a media do vetor
    
    jal Var_Vetor   # $f1 salva a variancia do vetor

    la $a0, str4
    jal print_string
    
    jal Print_Vetor
    
    la $a0, str5
    jal print_string
    
    mov.s $f12, $f0
    jal print_float
    li $a0, 44
    jal print_char
    li $a0, 32
    jal print_char
    mov.s $f12, $f1
    jal print_float
    
    li $v0, 10
    syscall
    
print_int:
    li $v0, 1
    syscall
    jr $ra

print_float:
    li $v0, 2
    syscall
    jr $ra

print_string:
    li $v0, 4
    syscall
    jr $ra
    
print_char:
    li $v0, 11
    syscall
    jr $ra

ler_int:
    li $v0, 5
    syscall
    jr $ra
    
ler_float:
    li $v0, 6
    syscall
    jr $ra

Ler_Vetor:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 0
    
    Loop:
        la $a0, str2
        jal print_string
        move $a0, $t0
        jal print_int
        la $a0, str3
        jal print_string
        
        addi $sp, $sp, -4
        jal ler_float
        s.s $f0, 0($sp)
        
        addi $t0, $t0, 1
        beq $t0, $s0, FimLoop
    j Loop
    
    FimLoop:
        li $t0, 0
        Loop2:
            addi $sp, $sp, 4
            addi $t0, $t0, 1
            beq $t0, $s0, FimLoop2
        j Loop2
    
        FimLoop2:
            lw $ra, 0($sp)
    
    jr $ra
    
Med_Vetor:
    li $t0, 0
    mtc1 $zero, $f0
    
    SomaMed:
        addi $sp, $sp, -4
        l.s $f1, 0($sp)
        
        add.s $f0, $f0, $f1
        
        addi $t0, $t0, 1
        beq $t0, $s0, FimSomaMed
    j SomaMed
    
    FimSomaMed:
        mtc1 $s0, $f1
        cvt.s.w $f1, $f1
        
        div.s $f0, $f0, $f1
    
    jr $ra
    
Var_Vetor:
    li $t0, 0
    mtc1 $zero, $f2
    
    SomaVar:
        l.s $f1, 0($sp)
        addi $sp, $sp, 4
        
        sub.s $f1, $f1, $f0
        mul.s $f1, $f1, $f1
        add.s $f2, $f2, $f1
        
        addi $t0, $t0, 1
        beq $t0, $s0, FimSomaVar
    j SomaVar
    
    FimSomaVar:
        addi $s0, $s0, -1
        mtc1 $s0, $f1
        addi $s0, $s0, 1
        cvt.s.w $f1, $f1
        
        div.s $f1, $f2, $f1
        jr $ra
        
Print_Vetor:
    sw $ra, 0($sp)
    li $t0, 0
    
    LoopPrint:
        li $a0, 32
        jal print_char
        addi $sp, $sp, -4
        l.s $f12, 0($sp)
        jal print_float
        
        addi $t0, $t0, 1
        beq $t0, $s0, FimLoopPrint
   j LoopPrint    
   
    FimLoopPrint:
       li $t0, 0
        
        LoopPrint2:
            addi $sp, $sp, 4
            addi $t0, $t0, 1
           beq $t0, $s0, FimLoopPrint2
        j LoopPrint2
        
        FimLoopPrint2:
            lw $ra, 0($sp)
            jr $ra

    