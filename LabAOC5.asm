.data
    str1:       .asciiz "Entre com a string numerica: "
    str2:       .asciiz "A string em codigo Morse eh: "
    mc0:        .asciiz "- - - - -"
    mc1:        .asciiz ". - - - -"
    mc2:        .asciiz ". . - - -"
    mc3:        .asciiz ". . . - -"
    mc4:        .asciiz ". . . . -"
    mc5:        .asciiz ". . . . ."
    mc6:        .asciiz "- . . . ."
    mc7:        .asciiz "- - . . ."
    mc8:        .asciiz "- - - . ."
    mc9:        .asciiz "- - - - ."

.text

.globl main

main:
    
    la $a0, str1
    jal print_string
    la $a0, 10
    jal print_char
    
    jal Ler_string
    
    la $a0, str2
    jal print_string
    jal Print_morse

    LoopStack:
        addi $sp, $sp, 4
        addi $t1, $t1, -1
        beq $t1, $zero, Fim
    j LoopStack
    
    
    Fim:
        li $v0, 10
        syscall

print_string:
    li $v0, 4
    syscall
    jr $ra
    
print_char:
    li $v0, 11
    syscall
    jr $ra
    
ler_char:
    li $v0, 12
    syscall
    jr $ra
    
malloc:
    li $v0, 9
    syscall
    jr $ra
    
Ler_string:
    move $t0, $ra
    li $a0, 4
    jal malloc
    move $s0, $v0
    
    sw $t0, 0($s0)
    move $s1, $sp
    
    Loop:
        jal ler_char
        
        beq $v0, 32, Loop
        
        addi $sp, $sp, -4
        sw $v0, 0($sp)
        beq $v0, 10, FimLoop    
    
    j Loop
    
    FimLoop:
        lw $ra, 0($s0)
        jr $ra
        
Print_morse:
    sw $ra, 0($s0)
    li $t1, 0
    
    
    LoopPrint:
        addi $s1, $s1, -4
        lw $t0, 0($s1)
        
        addi $t0, $t0, -48
        
        addi $t1, $t1, 1
        
        beq $t0, 0, morse_0
        beq $t0, 1, morse_1
        beq $t0, 2, morse_2
        beq $t0, 3, morse_3
        beq $t0, 4, morse_4
        beq $t0, 5, morse_5
        beq $t0, 6, morse_6
        beq $t0, 7, morse_7
        beq $t0, 8, morse_8
        beq $t0, 9, morse_9
        
        lw $ra 0($s0)
        jr $ra
        
        morse_0:
            la $a0, mc0
            jal print_string
            j prox
        
        morse_1:
            la $a0, mc1
            jal print_string
            j prox
        
        morse_2:
            la $a0, mc2
            jal print_string
            j prox
        
        morse_3:
            la $a0, mc3
            jal print_string
            j prox
        
        morse_4:
            la $a0, mc4
            jal print_string
            j prox
        
        morse_5:
            la $a0, mc5
            jal print_string
            j prox
        
        morse_6:
            la $a0, mc6
            jal print_string
            j prox
        
        morse_7:
            la $a0, mc7
            jal print_string
            j prox
        
        morse_8:
            la $a0, mc8
            jal print_string
            j prox
        
        morse_9:
            la $a0, mc9
            jal print_string
            j prox
        
        prox:
        
            li $a0, 32
            jal print_char
            
            j LoopPrint
    
