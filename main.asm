.data
paloA: .space 4
numA: .space 4
elPadrino: .asciiz "\t---- Casino: El Padrino ----\t\n"
mainMenu: .asciiz "\t---- Menu ----\t\n\t1)Adivina la carta\n\t2)Tabla de Posiciones\n\t3)Salir\n"
inputOption: .asciiz "\tIngrese una opcion: "
inputNumero: .asciiz "\tIngrese un  numero entre el 1 al 10: "
mensajeError: .asciiz "\tIngrese un numero que sea valido\n"
juego1: .asciiz "\n\tTiene 3 oportunidades para adivinar una carta que la computadora ha seleccionado al azar.\n\tUna carta esta compuesta de un numero entre 1-10 y un palo (tipo de carta).\n"
mostrarPalos: .asciiz "\n\tEscoja un palo:\n\t1)Corazon\n\t2)Brillo\n\t3)Trebol\n\t4)Picas\n"
esMayor: .asciiz "\n\tEl numero oculto es mas alto!"
esMenor: .asciiz "\n\tEl numero oculto es mas bajo!"
.text

main:
    la		$a0, elPadrino      # Muestra  El Padrino
    li		$v0, 4		
    syscall

menu:
    la		$a0, mainMenu       # Muestra de el menú principal
    li		$v0, 4		
    syscall

    la		$a0, inputOption    # Muestra de Ingresar una opción
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
    #CREAR EL  NUMERO ALEATORIO Y GUARDRLO EN LA VARIABLE GLOBAL
    li		$a1, 10		        #Límite superior del número aleatorio en 11 sin incluir
    li		$v0, 42		        #Generar número aleatorio en $a0
    syscall

    addi	$a0, $a0, 1			# $a0 = $a0 + 1 / Sumamos 1 para tener un random entre 1 y 4, en vez de 0 y 3
    sw $a0, numA
    #CREAR EL  PALO ALEATORIO Y GUARDRLO EN LA VARIABLE GLOBAL
    li		$a1, 4		        #Límite superior del número aleatorio en 11 sin incluir
    li		$v0, 42		        #Generar número aleatorio en $a0
    syscall

    addi	$a0, $a0, 1			# $a0 = $a0 + 1 / Sumamos 1 para tener un random entre 1 y 4, en vez de 0 y 3
    sw $a0, paloA
    #TODO 

    li      $v0, 4
    la      $a0, mostrarPalos
    syscall
    
    li		$s0, 0		        # $s0 = 0 Contador del bucle

    bucleJuego:
        la		$a0, inputOption    # Muestra de Ingresar una opción
        li		$v0, 4		
        syscall

        li		$v0, 5		        #Agarrar input de un integer
        syscall
        move 	$a0, $v0		    # $a0 = Valor ingresado por el usuario
        
        li $a1, 5     #Solo hay 4 palos

        jal verificarOpcion         #Verificación de la opción ingresada por el usuario
        
        move 	$t0, $a0		    # $t0 = $a0, opción del usuario en $t0

        li      $v0, 4
        la      $a0, inputNumero
        syscall

        li		$v0, 5		        #Agarrar input de un integer
        syscall	

        move 	$a0, $v0		    # $a0 = Valor ingresado por el usuario
        
        li $a1, 11   #Solo hay 10 cartas
        jal verificarOpcion    

        move 	$t1, $a0    # el numero del 1 al 10 
        lw  	$t2, numA		    # $a1 = $t0


      
 
        #t0 palo usuario 
        #t1 numero usuario 
        #t2 numero aleatorio
        # jal compararPalo

        jal compararNumero

        #  PARA EL PALO  
        # sll $t1,$t0,2
        # add $t1,$t1,$a0 #--> a0 posición del arreglo
        # lw $t1,0($t1)  

        j Exit

option2:
    j Exit


#una funcion, que recibe  2 numeros a y b <- usuario
#imprime si  b<a: el palo es mas alto 
#si b>a  el palo es mas bajo 

compararNumero:
    addi $sp,$sp,-12
    sw $ra, 0($sp)
    sw $a0, 4($sp) #<-- numero aleatorio
    sw $a1, 8($sp)  # <-- numero del usuario

    slt $t0,$a0,$a1  #a<b
    beq $t0,0,mostrarMenor 
    la	$a0, esMayor   
    li	$v0, 4		
    syscall
    j fin

    mostrarMenor: 
        la		$a0, esMenor   
        li		$v0, 4		
        syscall

    fin: 
        lw $ra, 0($sp)
        lw $a0, 4($sp) #<-- numero aleatorio
        lw $a1, 8($sp)  # <-- numero del usuario
        addi	$sp, $sp, 8			    # $sp = $sp + 8
    	

#compararPalo recibe el palo del jugador y de la computadora
#devuelve 1 si el palo es el mismo, devuelve 2 si el palo es otro

compararPalo:                       



verificarOpcion:
    addi	$sp, $sp, -8		    # $sp = $sp - 8
    sw		$ra, 0($sp)		 
    sw		$a0, 4($sp) #<-- a
    sw		$a1, 8($sp) #<-- numero maximo por teclado 
    
    move	$t0, $a1	            # $t0 = n
    slt     $t1, $a0, $t0           # $a0 < n
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