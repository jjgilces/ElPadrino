.data
elPadrino: .asciiz "---- Casino: El Padrino ----\t\n"
mainMenu: .asciiz "\t---- Menu ----\t\n\t1)Adivina la carta\n\t2)BLACKJACK\n\t3)Salir\n"
inputOption: .asciiz "\tIngrese una opcion: "
mensajeError: .asciiz "Ingrese un número que sea válido\n"
juego1: .asciiz "\n\tUn jugador tiene 3 oportunidades para adivinar una carta que la computadora ha seleccionado al azar.\n\tUna carta esta compuesta de un numero entre 2-6 y un palo (tipo de carta).\n"
mostrarPalos: .asciiz "Escoja un palo:\n\t1)Corazon\n\t2)Brillo\n\t3)Trebol\n\t4)Picas\n"

.text

main:
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

    beq		$t0, 1, option1	    # if $t0 == $s1 then option1
    beq		$t0, 2, option2	    # if $t0 == $s2 then option2
    beq		$t0, 3, Exit	    # if $t0 == $s3 then Exit
    j error

option1:
    li      $v0, 4
    la      $a0, juego1
    syscall

    li      $v0, 4
    la      $a0, mostrarPalos
    syscall


    li		$s0, 0		        # $s0 = 0 Contador del bucle

bucleJuego:
    beq		$s0, 3, finJuego	# if $s0 == 3 then finJuego

    la		$a0, inputOption    # Display de Ingresar una opción
    li		$v0, 4		
    syscall

    li		$v0, 5		        #Agarrar input de un integer
    syscall
    move 	$a0, $v0		    # $a0 = Valor ingresado por el usuario
    
    jal verificarOpcion         #Verificación de la opción ingresada por el usuario
    
    move 	$t0, $a0		    # $t0 = $a0, opción del usuario en $t0

    li		$a1, 4		        #Límite superior del número aleatorio en 4 sin incluir
    li		$v0, 42		        #Generar número aleatorio en $a0
    syscall
    
    addi	$a0, $a0, 1			# $a0 = $a0 + 1 / Sumamos 1 para tener un random entre 1 y 4, en vez de 0 y 3
    move 	$a1, $t0		    # $a1 = $t0

    jal compararPalo

    




    
    
    #move $a1, variable <-- numero aleatorio 
    
    jal compararNumero
    #  PARA EL PALO  
    # sll $t1,$t0,2
    # add $t1,$t1,$a0 #--> a0 posición del arreglo
    # lw $t1,0($t1)
    
    

   


    j Exit

option2:
    j Exit


#una funcion, que recibe un numero 2 numeros a y b <_- usuario
#imprime si  b<a: el palo es mas alto 
#si b>a  el palo es mas bajo 

compararNumero:
    addi $sp,$sp,-12
    sw $ra, 0($sp)
    sw $a0, 4($sp) #<-- a
    sw $a1, 8($sp)

    slt $t0,$a0,$a1  #a<b 
    beq $t0,1,mostrarMenor 

    la		$a0, mostrarMayor   
    li		$v0, 4		
    syscall

#compararPalo recibe el palo del jugador y de la computadora
#devuelve 1 si el palo es el mismo, devuelve 2 si el palo es otro
compararPalo:                       



verificarOpcion:
    addi	$sp, $sp, -8		    # $sp = $sp - 8
    sw		$ra, 0($sp)		 
    sw		$a0, 4($sp) #<-- a
    
    li		$t0, 5		            # $t0 = 5
    slt     $t1, $a0, $t0           # $a0 < 5
    beq     $t1, 0, errorJugando
    beq		$a0, 0, errorJugando	# if $a0 == 0 then error

    lw		$ra, 0($sp)		 
    lw		$a0, 4($sp) #<-- a
    addi	$sp, $sp, 8			    # $sp = $sp + 8
    jr		$ra					    # jump to $ra

error:
    la		$a0, mensajeError		
    li		$v0, 4		
    syscall
    j menu

errorJugando:
    la		$a0, mensajeError		
    li		$v0, 4		
    syscall
    j bucleJuego

Exit:
    li	    $v0, 10		
    syscall