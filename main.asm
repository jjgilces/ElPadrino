.data
paloA: .space 4
numA: .space 4
elPadrino: .asciiz "\t---- Casino: El Padrino ----\t\n"
mainMenu: .asciiz "\t---- Menu ----\t\n\t1)Adivina la carta\n\t2)Tabla de Posiciones\n\t3)Salir\n"
inputOption: .asciiz "\tIngrese una opcion: "
inputPalo: .asciiz "\tIngrese un palo: "
inputNumero: .asciiz "\tIngrese un  numero entre el 1 al 10: "
paloAdivinado: .asciiz "\n\t¡El palo de carta es correcto! "
numAdivinado: .asciiz "\n\t¡El numero de carta es correcto! "
paloEsRojo: .asciiz "\n\t¡El palo de la carta es color Rojo! "
paloEsNegro: .asciiz "\n\t¡El palo de la carta es color Negro! "
mensajeError: .asciiz "\tIngrese un numero que sea valido\n"
juego1: .asciiz "\n\tTiene 3 oportunidades para adivinar una carta que la computadora ha seleccionado al azar.\n\tUna carta esta compuesta de un numero entre 1-10 y un palo (tipo de carta).\n"
mostrarPalos: .asciiz "\n\tEscoja un palo:\n\t1)Corazon\n\t2)Brillo\n\t3)Trebol\n\t4)Picas\n"
esMayor: .asciiz "\n\t¡El numero oculto es mas alto!"
esMenor: .asciiz "\n\t¡El numero oculto es mas bajo!"
cartaAdvinidada: .asciiz "\n\t¡Ha adivinado la carta!"
juegoNuevo: .asciiz "\n\t¿Quiere volver a jugar?\n\t1)Sí\n\t2)No\n"
saltoLinea: .asciiz "\n"
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

    beq		$t0, 1, option1	    # if $t0 == 1 then option1
    beq		$t0, 2, option2	    # if $t0 == 2 then option2
    beq		$t0, 3, Exit	    # if $t0 == 3 then Exit
    j error

option1:
    li      $v0, 4              #Imprime las reglas del juego
    la      $a0, juego1
    syscall

    #CREAR EL  NUMERO ALEATORIO Y GUARDRLO EN LA VARIABLE GLOBAL
    li		$a1, 10		        #Límite superior del número aleatorio en 10 sin incluir
    li		$v0, 42		        #Generar número aleatorio en $a0
    syscall
    
    addi	$a1, $a1, 1			# $a1 = $a1 + 1 / Sumamos 1 para tener un random entre 1 y 10, en vez de 0 y 9
    
    sw $a0, numA

    #CREAR EL PALO ALEATORIO Y GUARDRLO EN LA VARIABLE GLOBAL
    li		$a1, 4		        #Límite superior del número aleatorio en 11 sin incluir
    li		$v0, 42		        #Generar número aleatorio en $a0
    syscall

    addi	$a0, $a0, 1			# $a0 = $a0 + 1 / Sumamos 1 para tener un random entre 1 y 4, en vez de 0 y 3
    
    sw $a0, paloA
    
    #TODO 

    li      $v0, 4
    la      $a0, mostrarPalos       # Muestra los números para los palos
    syscall
    
    li		$s0, 0		            # $s0 = 0 Contador del bucle
    li		$s6, 0		            # $s6 = 0 Contador del dinero
    
    bucleJuego:
        beq		$s0, 3, derrota	    # if $s0 == $s0 then derrota
        
        # PARTE DEL PALO
        la		$a0, inputPalo      # Muestra de Ingresar un palo al jugador
        li		$v0, 4		
        syscall

        li		$v0, 5		        # Agarrar input de un integer
        syscall
        move 	$a0, $v0		    # $a0 = Valor ingresado por el usuario
        
        li $a1, 5                   # Solo hay 4 palos

        jal verificarOpcion         # Verificación de la opción ingresada por el usuario}

        move 	$s1, $a0		    # $s1 = $a0 / SE ALMACENA EL PALO DEL JUGADOR EN S1
        
        # PARTE DEL NUMERO
        la      $a0, inputNumero
        li      $v0, 4
        syscall

        li		$v0, 5		        #Agarrar input de un integer
        syscall	
        move 	$a0, $v0		    # $a0 = Valor ingresado por el usuario
        
        li $a1, 11                  #Solo hay 10 cartas
        
        jal verificarOpcion    

        move 	$s2, $a0		    # $s1 = $a0 / SE ALMACENA EL NÚMERO DEL JUGADOR EN S2
        
        lw  	$s3, paloA		    # Se carga paloA en $s3
        lw      $s4, numA           # Se carga numA en $s4

        #############IMPRESIÓN DE VERIFICACION#########################
        li		$v0, 1		    # $v0 = 1
        move 	$a0, $s1		# $a0 = $s1
        syscall

        li		$v0, 1		    # $v0 = 1
        move 	$a0, $s2		# $a0 = $s1
        syscall

        li		$v0, 1		    # $v0 = 1
        move 	$a0, $s3		# $a0 = $s1
        syscall

        li		$v0, 1		    # $v0 = 1
        move 	$a0, $s4		# $a0 = $s1
        syscall
        #################################################################
        
        #t0 palo usuario 
        #t1 numero usuario 
        #t2 numero aleatorio
        # jal compararPalo

        move 	$a0, $s1		# $a0 = $s1 / En $a0 el palo del jugador
        move    $a1, $s3        # $a1 = $s3 / En $a1 el palo aleatorio de la máquina

        li		$s5, 0		    # $s5 = 0 / Variable para controlar la victoria, si es igual a 2 ha ganado.

        jal compararPalo

        move 	$a0, $s2		# $a0 = $s2 / En $a0 el número del jugador
        move    $a1, $s4        # $a1 = $s4 / En $a1 el número aleatorio de la máquina

        jal compararNumero

        beq		$s5, 2, victoria	    # if $s5 == 2 then victoria
        addi	$s0, $s0, 1			    # $s0 = $s0 + 1
        
        j		bucleJuego				# jump to bucleJuego
        
        #  PARA EL PALO  
        # sll $t1,$t0,2
        # add $t1,$t1,$a0 #--> a0 posición del arreglo
        # lw $t1,0($t1)  

        j Exit



victoria:
    li		$s0, 0		# $s0 = 0
    
    la      $a0, cartaAdvinidada
    li      $v0, 4
    syscall

    la      $a0, juegoNuevo
    li      $v0, 4
    syscall

    li		$v0, 5		        #Agarrar input de un integer
    syscall	
    move 	$t0, $v0

    beq		$t0, 0, finJuego	# if $t0 == 1 finJuego
    addi	$s6, $s6, 0			# $s6 = $s6 + 0
    
    


derrota:
    la      $a0, numAdivinado
    li      $v0, 4
    syscall

option2:
    j Exit


#Función que compara el número del usuario con el de la máquina
#

compararNumero:
    addi $sp,$sp,-12
    sw $ra, 0($sp)
    sw $a0, 4($sp)  #<-- EL NUMERO DEL JUGADOR
    sw $a1, 8($sp)  #<-- EL NUMERO DE LA MAQUINA

    beq		$a0, $a1, numCorrecto	# if $a0 == $a1 then numCorrecto

    slt $t0,$a0,$a1  # numJugador < numMaquina
    beq $t0, 1, mostrarMayor 
    
    la	$a0, esMenor   
    li	$v0, 4		
    syscall
    j outComparacionNum

    mostrarMayor: 
    la		$a0, esMayor   
    li		$v0, 4		
    syscall
    j outComparacionNum

    numCorrecto:
    la      $a0, numAdivinado
    li      $v0, 4
    syscall
    addi	$s5, $s5, 1			# $s5 = $s5 + 1
    

    outComparacionNum:
    lw		$ra, 0($sp)		 
    lw		$a0, 4($sp) #<-- EL NUMERO DEL JUGADOR
    lw		$a1, 8($sp) #<-- EL NUMERO DE LA MAQUINA
    addi	$sp, $sp, 8			    # $sp = $sp + 8
    jr		$ra					    # jump to $ra

    	

#compararPalo recibe el palo del jugador y de la computadora
#Imprime si el palo es correcto si adivina, de lo contrario indica el color del palo a adivinar

compararPalo:                       
    addi	$sp, $sp, -8		    # $sp = $sp - 8
    sw		$ra, 0($sp)		 
    sw		$a0, 4($sp) #<-- EL PALO DEL JUGADOR
    sw		$a1, 8($sp) #<-- EL PALO DE LA MÁQUINA

    beq		$a0, $a1, paloCorrecto	# if $a0 == $a1 then paloCorrecto
    
    beq		$a1, 1, paloRojo	    # if $a1 == 1 then paloRojo
    beq		$a1, 2, paloRojo	    # if $a1 == 2 then paloRojo

    beq		$a1, 3, paloNegro	    # if $a1 == 3 then paloNegro
    beq		$a1, 4, paloNegro	    # if $a1 == 4 then paloNegro

    paloRojo:
    la      $a0, paloEsRojo
    li      $v0, 4
    syscall
    j		outComparacionPalo				# jump to outComparacionPalo
    
    paloNegro:
    la      $a0, paloEsNegro
    li      $v0, 4
    syscall
    j		outComparacionPalo				# jump to outComparacionPalo
    
    paloCorrecto:
    la      $a0, paloAdivinado
    li      $v0, 4
    syscall
    addi	$s5, $s5, 1			            # $s5 = $s5 + 1
    

    outComparacionPalo:
    lw		$ra, 0($sp)		 
    lw		$a0, 4($sp) #<-- EL PALO DEL JUGADOR
    lw		$a1, 8($sp) #<-- EL PALO DE LA MÁQUINA
    addi	$sp, $sp, 8			    # $sp = $sp + 8
    jr		$ra					    # jump to $ra



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
    lw		$a1, 8($sp) #<-- numero maximo por teclado
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