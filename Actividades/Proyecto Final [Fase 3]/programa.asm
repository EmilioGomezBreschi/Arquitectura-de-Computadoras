inicio:
nop
addi $t0, $zero, 10
nop
nop

addi $s0, $zero, 4
nop
nop

add $t1, $t0, $s0
sub $t2, $t0, $s0
and $t3, $t0, $s0
or $t4, $t0, $s0
slt $t5, $s0, $t0
nop
nop

andi $t6, $t0, 3
ori $t7, $zero, 5
slti $t8, $zero, 10
nop
nop

sw $t0, 0($zero)
nop
nop

lw $t9, 0($zero)
nop
nop

jal funcion
nop
nop

funcion:
ori $s1, $zero, 7
nop
nop

beq $zero, $zero, etiqueta
nop
nop

etiqueta:
j inicio
