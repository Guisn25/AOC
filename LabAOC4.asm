.data
    opcoes:     .asciiz "1 - Inserir na fila\n2 - Remover da fila\n3 - sair\n"
    str1:       .asciiz "Valor a se inserir:"
    str2:       .asciiz "Fila atual:"
    str3:       .asciiz "Erro: fila vazia."

.text

.globl main

main:
    li $a0, 4
    jal malloc
    move $s0, $v0
    
    li $s1, 1
    li $s2, 2
    li $s3, 3
    li $s4, 0
    
    sw $sp, 0($s0)
    Menu:
        jal menu
        beq $t0, $s1, Inserir 
        #beq $t0, $s2, Remover    
        beq $t0, $s3, Sair
    
    Sair:
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
    
print_char:
    li $v0, 11
    syscall
    jr $ra

ler_int:
    li $v0, 5
    syscall
    jr $ra
    
malloc:
    li $v0, 9
    syscall
    jr $ra
    
menu:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    la $a0, opcoes
    jal print_string
    
    jal ler_int
    move $t0, $v0
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
Inserir:
    addi $sp, $sp, -4
    jal ler_int
    sw $v0, 0($sp)
    addi $s4, $s4, 1
    
    j Print_Fila
    
Remover: #NOVA IDEIA MELHOR DE MANIPULAR MEMÓRIA: FICAR PULANDO DE REGISTRADOR
    lw $t0, 0($s0) #FAZER ISSO O TEMPO TODO
    beq $sp, $t0, Fila_vazia
    
    addi $t0, $t0, -4
    lw $t0, 0($s0)
    
    sw $zero, 0(0($s0)) #PRA NÃO ESCREVER COISAS ASSIM, E SIM, 0($t0), POR EXEMPLO
    
    Alinhar_Fila:
        beq $sp, 0($s0), Fila_alinhada
        addi 0($s0), 0($s0), -4
        
        lw $t0, 0(0($s0))
        sw $t0, 4(0($s0))
    
    j Alinhar_Fila
    
    Fila_alinhada:
        addi $sp, $sp, 4
        addi $s4, $s4, -1
        li $t0, 0
        
        
        Loop:
            addi $s0, $s0, 4
            addi $t0, $t0, 1
            beq $t0, $s4, FimLoop
        j Loop
    
    FimLoop:
        j Print_Fila
    
    Fila_vazia:
        la $a0, str3
        jal print_string
        j Menu
 
Print_Fila:
    la $a0, str2
    jal print_string
    
    beq $sp, 0($s0), Fim_Print
    
    lw $sp, 0($s0)
    li $t0, 0
    LoopPrint:
        li $a0, 32
        jal print_char
        addi $sp, $sp, -4
        lw $a0, 0($sp)
        jal print_int
        addi $t0, $t0, 1
        beq $t0, $s4, Fim_Print
    j LoopPrint
    
    Fim_Print:
        li $a0, 10
        jal print_char
        
        j Menu
    
    