.data

str1:		.asciiz "Entre com a hora de inicio (HH):"
str2:		.asciiz "Hora invalida."
str3:		.asciiz "Entre o minuto de inicio (MM): "
str4:		.asciiz "Minuto invalido."
str5:		.asciiz "Entre com as horas de duracao (HH): "
str6:		.asciiz "Entre com os minutos de duracao (MM): "
str7:		.asciiz "Horario da reuniao: "
str8:		.asciiz ":"
str9:		.asciiz " a " 

.text
.globl main

main: 	
	li $v0, 4	# code to print string
	la $a0, str1
	syscall
	
	j Ler_HoraI
	
	Hora_ErradaI:
		li $v0, 4
		la $a0, str2
	Ler_HoraI:
		li $v0, 5	# code to read integer
		syscall
		move $s0, $v0
	
	slti $t0, $s0, 0
	bne $t0, $zero, Hora_ErradaI
	slti $t0, $s0, 24
	beq $t0, $zero, Hora_ErradaI
	
	li $v0, 4	# code to print string
	la $a0, str3
	syscall
	
	j Ler_MinutoI
	
	Minuto_ErradoI:
		li $v0, 4
		la $a0, str4
	Ler_MinutoI:
		li $v0, 5	# code to read integer
		syscall
		move $s1, $v0
	
	slti $t0, $s1, 0
	bne $t0, $zero, Minuto_ErradoI
	slti $t0, $s1, 60
	beq $t0, $zero, Minuto_ErradoI

	li $v0, 4	# code to print string
	la $a0, str5
	syscall
	
	j Ler_HoraD
	
	Hora_ErradaD:
		li $v0, 4
		la $a0, str2
	Ler_HoraD:
		li $v0, 5	# code to read integer
		syscall
		move $s2, $v0
	
	slti $t0, $s2, 0
	bne $t0, $zero, Hora_ErradaD
	slti $t0, $s2, 24
	beq $t0, $zero, Hora_ErradaD
	
	li $v0, 4	# code to print string
	la $a0, str6
	syscall
	
	j Ler_MinutoD
	
	Minuto_ErradoD:
		li $v0, 4
		la $a0, str4
	Ler_MinutoD:
		li $v0, 5	# code to read integer
		syscall
		move $s3, $v0
	
	slti $t0, $s3, 0
	bne $t0, $zero, Minuto_ErradoD
	slti $t0, $s3, 24
	beq $t0, $zero, Minuto_ErradoD	

	li $v0, 4	# code to print string
	la $a0, str7
	syscall	

	slti $t0, $s0, 10
	beq $t0, $zero, Digitos_HoraI
	
	li $v0, 1
	move $a0, $zero
	syscall
	
	Digitos_HoraI:
		li $v0, 1	# code to print integer
		move $a0, $s0	# the value to be printed in $a0
		syscall
	
	li $v0, 4	# code to print string
	la $a0, str8
	syscall

	slti $t0, $s1, 10
	beq $t0, $zero, Digitos_MinutoI
	
	li $v0, 1
	move $a0, $zero
	syscall
	
	Digitos_MinutoI:
		li $v0, 1	# code to print integer
		move $a0, $s1	# the value to be printed in $a0
		syscall

	li $v0, 4	# code to print string
	la $a0, str9
	syscall
	
	add $s0, $s0, $s2
	slti $t0, $s0, 24
	bne $t0, $zero, Menos_24
	
	addi $s0, $s0, -24
	
	Menos_24:
		add $s1, $s1, $s3
		slti $t0, $s0, 60
		bne $t0, $zero, print_horas
		addi $s0, $s0, 1
		addi $s1, s1, -60
		
	print_horas:
		slti $t0, $s0, 10
		beq $s0, $zero, Digitos_HoraF
	
		li $v0, 1
		move $a0, $zero
		syscall
	
		Digitos_HoraF:
		li $v0, 1	# code to print integer
		move $a0, $s0	# the value to be printed in $a0
		syscall
	
		li $v0, 4	# code to print string
		la $a0, str8
		syscall
		
		slti $t0, $s1, 10
		beq $s1, $zero, Digitos_HoraF
	
		li $v0, 1
		move $a0, $zero
		syscall
	
		Digitos_HoraF:
		li $v0, 1	# code to print integer
		move $a0, $s1	# the value to be printed in $a0
		syscall
	

	li $v0, 10	# code for program end
	syscall

