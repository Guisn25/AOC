.data
	bitmap: .word 0x10040000
	buffer: .word 0x10240000
	.align 2
	tamanho: .word 16384
	
	modos: .asciiz "Escolha o modo que deseja executar:"
	proprio: .asciiz "1- Criar Proprio(opções de estilo iguais aos modos)"
	life: .asciiz "2- Game of Life"

.text

main:
	lw $s0, bitmap
	lw $s1, buffer
	
	li $a0, 31
	li $a1, 15
	li $t9, 0
	jal PintaContorno
SetupLoop:
	li $v0, 12
	syscall
	
	beq $v0, 97, Esquerda
	beq $v0, 100, Direita
	beq $v0, 119, Cima
	beq $v0, 115, Baixo
	beq $v0, 32, Pinta
	beq $v0, 10, Exit

j SetupLoop
	Esquerda:
		beq $a0, $0, SetupLoop
		li $t9, 1 
		jal PintaContorno
		
		addi $a0, $a0, -1
		move $t9, $0
		jal PintaContorno 
	j SetupLoop
	Direita:
		addi $t0, $a0, -63
		beq $t0, $0, SetupLoop
		li $t9, 1
		jal PintaContorno
		
		addi $a0, $a0, 1
		move $t9, $0
		jal PintaContorno
	j SetupLoop
	Cima:
		beq $a1, $0, SetupLoop
		li $t9, 1
		jal PintaContorno
		
		addi $a1, $a1, -1
		move $t9, $0
		jal PintaContorno
	j SetupLoop
	Baixo:
		addi $t0, $a1, -31
		beq $t0, $0, SetupLoop
		li $t9, 1
		jal PintaContorno
		
		addi $a1, $a1, 1
		move $t9, $0
		jal PintaContorno
	j SetupLoop
	Pinta:
		lw $t0, -4100($s0)
		slt $t9, $0, $t0 
		lw $s0, bitmap
		jal PintaQuadrado
		li $t9, 0
		jal PintaContorno 
	j SetupLoop

#AJEITAR ESSA PARTE
Executa:
	li $t9, 1
	jal PintaContorno
	
	lw $s0, bitmap
	lw $s1, buffer
	li $s3, 2
	li $s4, 3
	
	
	li $a1, 0
	
	li $t1, 32
	LoopColuna:
		li $a0, 0
		li $t0, 64
		LoopLinha:
			jal ConfereEstado
			
			move $a3, $s2
			jal AtualizaBuffer
			
			addi $a0, $a0, 1
		addi $t0, $t0, -1
		bne $t0, $0, LoopLinha
		
		addi $a1, $a1, 1
	addi $t1, $t1, -1
	bne $t0, $0, LoopColuna
	
Exit:
li $v0, 10
syscall

PintaContorno: #$a0 = Xpos, $a1 = Ypos, $a2 = cor
	lw $s0, bitmap
	sll $t0, $a0, 6			#Xpos*4(byte/pixel)*16(pixel)
	sll $t1, $a1, 16		#Ypos*4(byte/pixel)*16(pixel/coluna)*64(coluna/linha)*16(pixel)
	add $t0, $t0, $t1
	add $s0, $s0, $t0
	
	li $t1, 15
	li $a2, 0x00FF0000
	beq $t9, $0, LoopPintaLinhas
	lw $a2, 4100($s0)	
	LoopPintaLinhas:
		sw $a2, 0($s0)
		sw $a2, 61444($s0) 	#61444=4096(byte/linha)*15(linha)+4(byte/pixel)
		
		addi $s0, $s0, 4	#pos+4(byte/pixel) = Próximo pixel
	addi $t1, $t1, -1
	bne $t1, $0, LoopPintaLinhas
	
	li $t1, 15
	LoopPintaColunas:
		sw $a2, 0($s0)
		sw $a2, 4036($s0)	
		
		addi $s0, $s0, 4096 		#pos+(1024(pixel)-16(pixel))*4(byte/pixel) = Próxima linha
	addi $t1, $t1, -1
	bne $t1, $0, LoopPintaColunas
jr $ra

#Quadrado $t1x$t2 = 16x16 em um bitmap 1024x512
PintaQuadrado:	#$a0 = Xpos, $a1 = Ypos, $a2 = cor		
	sll $t0, $a0, 6			#Xpos*4(byte/pixel)*16(pixel)
	sll $t1, $a1, 16		#Ypos*4(byte/pixel)*16(pixel/coluna)*64(coluna/linha)*16(pixel)
	add $t0, $t0, $t1
	add $s0, $s0, $t0
	
	li $t1, 16
	li $a2, 0x00FFFFFF
	beq $t9, $0, LoopPintaQuadrado
	li $a2, 0x00000000
	LoopPintaQuadrado:
		li $t2, 16
		LoopLinhaQuadrado:
			sw $a2, 0($s0)
			addi $s0, $s0, 4	#pos+4(byte/pixel) = Próximo pixel
		addi $t2, $t2, -1
		bne $t2, $0, LoopLinhaQuadrado
	addi $s0, $s0, 4032 		#pos+(1024(pixel)-16(pixel))*4(byte/pixel) = Próxima linha
	addi $t1, $t1, -1
	bne $t1, $0, LoopPintaQuadrado
jr $ra

ConfereEstado:
addi $sp, $sp, -4
sw $ra, 0($sp)
	
	li $s2, 0

VizinhosEsquerda:
	beq $a0, $0, VizinhosDireita
	
	addi $t3, $a0, -1
	jal VerificaVizinho
	add $s2, $s2, $v0
	
	addi $t4, $a1, -1
	jal VerificaVizinho
	add $s2, $s2, $v0
	
	addi $t4, $a1, 1
	jal VerificaVizinho
	add $s2, $s2, $v0
	
VizinhosDireita:
	addi $t2, $a0, -63
	beq $t2, $0, VizinhoCima
	
	addi $t3, $a0, 1
	jal VerificaVizinho
	add $s2, $s2, $v0
	
	addi $t4, $a1, -1
	jal VerificaVizinho
	add $s2, $s2, $v0
	
	addi $t4, $a1, 1
	jal VerificaVizinho
	add $s2, $s2, $v0

VizinhoCima:
	beq $a1, $0, VizinhoBaixo
	move $t3, $a0
	
	addi $t4, $a1, -1
	jal VerificaVizinho
	add $s2, $s2, $v0
	
VizinhoBaixo:
	addi $t2, $a1, -31
	beq $t2, $0, ExitConfere

	addi $t4, $a1, 1
	jal VerificaVizinho
	add $s2, $s2, $v0

ExitConfere:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

VerificaVizinho:
	lw $s0, bitmap
	sll $t5, $t3, 6			#Xpos*4(byte/pixel)*16(pixel)
	sll $t6, $t4, 16		#Ypos*4(byte/pixel)*16(pixel/coluna)*64(coluna/linha)*16(pixel)
	add $t5, $t5, $t6
	add $s0, $s0, $t5
	
	lw $t7, 0($s0)
	
	slt $v0, $0, $t7
jr $ra

AtualizaBuffer:
	slt $v1, $a3, $s3
	slt $v1, $s4, $a3
	li $s7, 2
	move $t3, $t7
	beq $v1, $s7, LoopAtualiza
	li $t3, 0x00FFFFFF
	beq $v1, $0, Loopatualiza
	li $t3, 0x00000000
	
	lw $s0, buffer
	jal PintaQuadrado
	
