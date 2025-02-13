.data
	bitmap: .word 0x10040000
	.align 2
	tamanho: .word 16384
	
	modos: .asciiz "Escolha o modo que deseja executar:"
	proprio: .asciiz "1- Criar Proprio"
	life: .asciiz "2- Game of Life"
	ant: .asciiz "3- Langton's Ant"

.text

main:
	
	lw $s0, bitmap

	li $a0, 256
	li $a1, 256
	li $a3, 0x00FFFF00	
	jal PintaQuadradro

li $v0, 10
syscall

PintaQuadradro:
	sll $a1, $a1, 9
	li $s1, 256
	add $t0, $a0, $a1
	add $s0, $s0, $t0
	
	LoopPinta:
		li $s2, 16
		LoopLinha:
			sw $a3, 0($s0)
		addi $s0, $s0, 4
		addi $s2, $s2, -1
		bne $s2, $0, LoopLinha	
	addi $s0, $s0, 512
	addi $s1, $s1, -1
	bne $s1, $0, LoopPinta
jr $ra
		