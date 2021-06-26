.data
elPadrino: .asciiz "\t---- Casino: El Padrino ----\t\n"
mainMenu: .asciiz "\t---- Menu ----\t\n\t1)Jugar: Adivina la carta\n\t2)LeaderBoard\n\t3)Salir\n"
inputOption: .asciiz "\tIngrese una opción: "
errorMessage: .asciiz "Ingrese un número que sea válido\n"
opt1: .word 1
opt2: .word 2
opt3: .word 3

.text
main:
    li		$s1, opt1           # $s1 = opt1
    li		$s2, opt2           # $s2 = opt2
    li		$s3, opt3           # $s3 = opt3

    la		$a0, elPadrino      # Display de El Padrino
    li		$v0, 4		
    syscall

menu:
    la		$a0, mainMenu       # Display de el menú principal
    li		$v0, 4		
    syscall

    la		$a0, inputOption    # Display de Ingresar una opción
    li		$v0, 4		
    syscall

    li		$v0, 5		        #Agarrar input de un integer
    syscall
    move 	$t0, $v0		    # $t0 = $v0

    beq		$t0, $s1, option1	# if $t0 == $s1 then option1
    beq		$t0, $s2, option2	# if $t0 == $s2 then option2
    beq		$t0, $s3, Exit	    # if $t0 == $s3 then Exit
    j error

option1:
    j Exit

option2:
    j Exit

error:
    la		$a0, errorMessage		
    li		$v0, 4		
    syscall
    j menu

Exit:
    li	    $v0, 10		
    syscall