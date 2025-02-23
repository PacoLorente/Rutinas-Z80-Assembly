; ******************************************************************************************************************************************************************************************
;
; 26/06/23
;
; DRAW. ************************************************************************************************************************************************************************************

Draw 

	call Prepara_draw 
	ld a,h 						 					; El objeto existe, o se está iniciando?. Si se está iniciando, (Posicion_inicio = Posicion_actual) y saltamos_
	and a 											; _a la subrutina [Inicializacion] donde asignaremos cuadrante y límites.
	jr z,2F

	ld a,(Cuad_objeto)			 					; El objeto ya se inició. Cargamos en A el cuadrante de pantalla en el que lo hizo y saltamos a 1F.
	jr 1F

;	Inicia entidad.

2 ld hl,(Posicion_inicio) 							; No hay (Posicion_actual), por lo que el objeto se está iniciando.
	ld (Posicion_actual),hl							; Indicamos que (Posicion_actual) = (Posicion_inicio) y saltamos a la subrutina [Inicializacion], (donde asignaremos_			

	call Inicializacion   							; _(Limite_horizontal), (Limite_vertical) y (Cuad_objeto). También asignaremos las coordenadas X e Y. (Posición 0,0)_
;													; _la esquina superior izquierda de la pantalla.	
	call Inicia_Puntero_mov							; El objeto está inicializado. Antes de salir inicializamos tb el puntero de movimiento de la entidad.

1 ld a,(Ctrl_0)
	bit 5,a
	jr nz,3F										; Si acabamos de inicializar un objeto, NO COMPROBAMOS LÍMITES. 

	call Comprueba_limite_horizontal   				
	call Comprueba_limite_vertical

; Llegados a este punto, tengo Filas/Columnas en BC y (Cuad_objeto) en A´.
; -----------------------
; -----------------------
; -----------------------

3 call calcula_CColumnass							; Define el valor de la variable (Columnas). Nº de columnas que se van a pintar de la entidad.
	call Calcula_puntero_de_impresion				; Después de ejecutar esta rutina tenemos el puntero de impresión en HL.

	ld a,(Ctrl_0)									; Antes de salir de la rutina restauramos los bits 0,1,2,3 y 5 de (Ctrl_0).
	and %11011100									
	ld (Ctrl_0),a

	ret

; *******************************************************************************************************************************************************************************************
; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;   14/02/25
;
;	Calcula el cuadrante de pantalla donde se encuentra la entidad: (Cuad_objeto), "1", "2", "3" o "4".
;	Esta información es necesaria para poder calcular el (Puntero_de_impresion) de la entidad.
;
;	INPUT:  HL contiene (Posicion_actual).
;	OUTPUT: (Cuad_objeto) contiene "1", "2", "3" o "4" en función del cuadrante de pantalla en el que se encuentra la entidad.		
;
;	MODIFY: A.	


Calcula_Cuad_objeto

	call calcula_tercio																			

;	Ahora tenemos "0", "1" o "2" en el acumulador en función del tercio de pantalla en el que nos encontremos.

	jr z,Primer_tercio 													
	dec a
	jr z,Segundo_tercio

Tercer_tercio

	call Determina_lado_de_pantalla
	jr nz,1F
	ld a,4
	jr 2F

1 ld a,3
2 ld (Cuad_objeto),a

	ret	

Primer_tercio

	call Determina_lado_de_pantalla
	jr nz,3F
	ld a,2
	jr 2B

3 ld a,1
	jr 2B

Segundo_tercio

	ld a,l
	cp $7f
	jr c,Primer_tercio
	jr z,Primer_tercio
	jr Tercer_tercio

; ------------------------------------

Determina_lado_de_pantalla ld a,l
	and $1f
	cp $10
	jr c,1F
	xor a
	ret

1 ld a,1
	ret

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	16/02/25
;
; 	Comprueba_limite_horizontal.
;
;	La rutina comprueba si hemos sobrepasado el (Limite_horizontal) definido en la rutina [Inicializacion]. Este será:_
;	_ $4fc0 si partimos de los cuadrantes 1 o 2 de pantalla o $4820 si partimos de los cuadrantes 3 o 4.
; 
;	Si sobrepasamos o alcanzamos el límite horizontal establecido, la rutina cargará el registro E con un "1".
;	Si NO HEMOS SOBREPASADO (Limite_horizontal), E="0".
;	E="1" indica que HEMOS SOBREPASADO el (Limite_horizontal).

Comprueba_limite_horizontal 

	ld a,(Ctrl_0)									; Si no hemos desaparecido por arriba o por abajo, saltamos a 1F para comprobar_
	bit 2,a											; _si hemos llegado o sobrepasado (Limite_horizontal). Seguimos con la rutina.
	jr z,1F											; Si por el contrario hemos desaparecido por arriba o por abajo, (bit2/bit3 de (Ctrl_0)="1"))_
	res 2,a											; _hay que modificar el puntero de posición. Antes inicializaremos los_ 

2 ld (Ctrl_0),a										; _ bits 2 y 3 de (Ctrl_0).
	call Inicializacion								
	ret

1 bit 3,a
	jr z,3F	
	res 3,a
	jr 2B

3 push hl						        			; (Posicion_actual).

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

; Comprobamos si hemos llegado al (Limite_horizontal). E="0".

	ex de,hl 										; Averiguamos si hemos llegado o sobrepasado el (Limite_horizontal). Hemos simplificado la operación SBC_			

	ld hl,(Limite_horizontal) 						; _cargando el tercio de pantalla en el byte alto.
	call calcula_tercio 							; (Posicion_actual) - (Limite_horizontal).
	ld h,a 											 

	ex de,hl 										; ARRIBA a ABAJO .......... E="1" cuando ( Z y NC ).

	call calcula_tercio                             ; ABAJO a ARRIBA .......... E="1" cuando ( Z y C ).
	ld h,a 											 
	and a 											
	sbc hl,de 										; (Posicion_actual) - (Limite_horizontal).

	ex af,af 										; Guardo el registro F con los flags resultantes de la operación SBC.

	ld a,(Cuad_objeto)
	cp 2
	jr c,4F
	jr z,4F

;	Partimos de la mitad inferior de la pantalla.

	ex af,af 										; Partimos de LA MITAD INFERIOR. Recupero resultado de (Posicíon - Límite) en AF.

    jr z,5F
    jr c,5F 										; ABAJO a ARRIBA .......... E="1" cuando (Z y C). HEMOS SOBREPASADO_
 
;    pop hl

;	jr Calcula_centro

 	ld e,0											; _ (Limite_horizontal), saltamos a 7F.

 	pop hl

	ret

;	Partimos de la mitad superior de la pantalla.

4 ex af,af 											; Partimos de LA MITAD SUPERIOR. Recupero resultado de (Posicíon - Límite) en AF.

	jr z,5F
	jr nc,5F										; E="1" cuando (Z y NC).

;	pop hl

;	jr Calcula_centro

 	ld e,0

	pop hl

	ret

;! Sobrepasamos el Límite_Horizontal. !!!!!!!!!!!!!!!!!!

5 ld e,1 											; SOBREPASAMOS (Limite_horizontal) !!!. E="1", pop HL y RET.

	pop hl

	ret

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- 
;
;	INPUT: HL contiene (Posicion_actual).
;		   AF' contiene (Cuad_objeto).

Calcula_centro

 	ex af,af
	cp 2
	jr c,6F 											; (Cuad_objeto) en C. 
	jr z,6F

; Partimos de la parte inferior de la pantalla.

	ld a,$7f
	cp l

	jr z,7F
	jr nc,7F

	ld e,0
	ret

; Partimos de la parte superior de la pantalla.

6 ld a,$80
	cp l

	jr z,7F
	jr c,7F

	ld e,0
	ret

; Activa E2. Hemos superado el centro de pantalla.

7 ld e,2

	ret

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;   21/02/25
;
;	Comprueba_limite_vertical
;
;	Modifica el registro L del puntero de pantalla cuando se sobrepasa la columna límite, (Limite2).
;	Dependiendo del cuadrante en el que nos encontremos, sumaremos o restaremos, (Columnas-1) a L. 
;	
;	INPUT: HL contiene (Posicion_actual).

Comprueba_limite_vertical 

;	Excepciones:

;	Si el registro E="2" salimos sin comprobar el límite vertical.

	ld a,(Ctrl_0)
	and 3
	jr z,2F

	dec e
	ret nz

	call Modificaccionne  
	call Inicializacion

	ret

; ----- ----- ----- ----- -----

2 ld a,(Posicion_actual)
	and $1F
	ld d,a 											 

	ld a,(Limite_vertical)
	cp d 											; Límite - Posición.
	ex af,af 										; Resultado de CP d en F'.

	ld a,(Cuad_objeto)								; Averiguamos en que cuadrante estamos.
	bit 0,a
	jr z,1F 										; Si A´es PAR, estamos en el 2º o 4º cuadrante. Saltamos a [3F], (cuadrantes 2º y 4º).

;	Cuando partimos del lado IZQUIERDO de la pantalla, superamos (lIMITE_VERTICAL) cuando hay "acarreo".

	ex af,af 										
	jr c,Limite_vertical_superado										

;	No hemos superado el (Limite_vertical). Estamos en zona nebulosa ???
 
    ld a,(Posicion_actual)
	and $1F
 
    ld d,Centro_izquierda
    sub d 											 ; Posición - Centro_izquierda.

	ret z											 ; Si no hemos superado (Limite_vertical) pero si hemos superado el centro de la pantalla,_
	ret nc											 ; _salimos sin modificar nada.

    jr No_centro_de_pantalla

;	Cuando partimos del lado DERECHO de la pantalla, superamos (lIMITE_VERTICAL) cuando NO HAY "acarreo".

1 ex af,af 											 
	jr nc,Limite_vertical_superado					 

;	No hemos superado el (Limite_vertical). Estamos en zona nebulosa ???

    ld a,(Posicion_actual)
	and $1F

    ld d,Centro_derecha
    sub d

    ret z
    ret c                                            ; Si no hemos superado (Limite_vertical) pero si hemos superado el centro de la pantalla,_
;                                                    ; _salimos sin modificar nada.
No_centro_de_pantalla

	bit 0,e
 	ret z											 ; No hemos sobrepasado (Centro_izquierda). Si E="0", salimos sin modificar posición.

	push bc 										 ; Reservo (Filas) / (Columns) en la pila.
    call Modificaccionne
	pop bc
 
	call Inicializacion

	ret 				 							 ; Salimos de la rutina.

; ----- ----- ----- Cambio de cuadrante ----- ----- -----
;
;	Filas/Columns en BC.
;	(Posicion_actual) en HL.
;	(Cuad_objeto) en AF´.

Limite_vertical_superado 

	push bc											 ; (Filas) / (Columns).

	ld b,c
	dec b											 ; (Columns)-1 en B.

	ld a,l

	ex af,af                           				 ; Consultamos el cuadrante del que partimos.
	bit 0,a
	jr nz,2F

; 	Parte DERECHA de la pantalla. Por el centro ?? o desaparecemos ??.

	ex af,af 										 ; Estamos en la parte derecha de la pantalla, (cuadrantes 2º o 4º). En ese caso, sumamos (Columnas-1) a L.
                               
; Hemos sobrepasado el (Limite_vertical) de la mitad derecha a la izquierda. Ahora necesitamos saber si E="0".

 	add b 				 							 ; Si hemos sobrepasado el (Limite_vertical) pero no hemos llegado al centro horizontal_			 																			
    ld l,a	 										 ; _de la pantalla, E="0" modificamos L, Inicializamos el objeto y salimos.
	ld (Posicion_actual),hl
                                     
	jr 4F

; Cambio de cuadrante, partimos de la parte IZQUIERDA de la pantalla. Por el centro ?? o desaparecemos ??.

2 ex af,af

; Hemos sobrepasado el (Limite_vertical) de la mitad IZQUIERDA a la DERECHA. Ahora necesitamos saber si E="0".

	sub b 																						
    ld l,a
	ld (Posicion_actual),hl

4 dec e
	jr nz,3F

	call Modificaccionne                            ; Si hemos sobrepasado (Limite_vertical) y (Limite_horizontal), E="1". Modificamos HL,L,_
 
3 pop bc

    call Inicializacion

	ret

; --------------------

Modifica_Pos_actual ld b,15                                         ; Scanlines-1 en B.
1 call PreviousScan
    djnz 1B
	ld (Posicion_actual),hl
	xor a 											; Carry a "0". Evita que vuelva a entrar consecutivamente.
	ret

; --------------------

Modifica_Pos_actual2 ld b,15                                         ; Scanlines-1 en B.
1 call NextScan
    djnz 1B
	ld (Posicion_actual),hl
	xor a 											; Fijo el acarreo a "0" para asegurarme de no volver a entrar en la rutina.
	ret

; --------------------
;
;	22/01/23
;
;	E="1". Hemos cambiado de cuadrante. 
;	Si estamos en la mitad superior de pantalla: CALL [Modifica_Pos_actual].
;	Si estamos en la mitad inferior de pantalla: CALL [Modifica_Pos_actual2].


Modificaccionne 
	
	ld a,(Cuad_objeto)
	cp 2
    call z,Modifica_Pos_actual                      ; Si por el contrario estamos en la mitad inferior, call Modifica_Pos_actual2.
    call c,Modifica_Pos_actual
	ret z
    call Modifica_Pos_actual2
    ret

; *************************************************************************************************************************************************************************************************
;
;	13/8/22
;
;	Inicializacion
;
;	Entrega "1", "2", "3" o "4" en (Cuad_objeto) en función del cuadrante de pantalla en el que nos encontremos.
;	Fija los punteros del objeto a pintar, (varían en función del cuadrante en el que nos encontremos).
;	También calcula los límites horizontal y vertical. Estos dependen del tamaño del objeto a imprimir.
;	
; 	La rutina se ejecuta cada vez que el objeto supera el (Limite_horizontal) y el (Limite_vertical). Esto sucede_
;	_ cada vez que el objeto supera el centro de la pantalla tanto en sentido horizontal como vertical y cuando_
;	_ desaparece/aparece.	

;	[Puntero_datas]: Dirección de memoria donde se encuentra el 1er byte que pinta el objeto. 
;	[Puntero_attr_datas]: Dirección de memoria donde se encuentra el byte de atributos del objeto. 
;
;	INPUT: [HL] contendrá la dirección de pantalla a la que queremos asignar cuadrante. HL=(Posicion_inicio).
; 		   [BC] contendrá (Filas)/(Columns) del objeto a inicializar.
; 		   [E] ="0"

; 	OUTPUT: DESTRUYE [AF] y [D].
	 
Inicializacion 

	call Calcula_Cuad_objeto

	ex af,af										; Copia de respaldo de (Cuad_objeto) en A´.

	ld a,(Cuad_objeto)
	and 1
	jr nz,Uno_Tres

Dos_Cuatro

	ld a,(Cuad_objeto)
	dec a
	dec a
	jr z,segcuad
	jr cuarcuad

Uno_Tres

	ld a,(Cuad_objeto)
	srl a
	jr z,primcuad 
	jr tercuad

; ----- ----- ----- ----- ----- 

cuarcuad 

	ld hl,$4820
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$0d
	jr 1F

tercuad	

	ld hl,$4820
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$12
	jr 1F

segcuad 

	ld hl,$4fc0
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$0d
	jr 1F

primcuad 

	ld hl,$4fc0
	ld (Limite_horizontal),hl
	ld hl,Limite_vertical
	ld (hl),$12

1 ld hl,(Posicion_actual)
	call Genera_coordenadas

	ld hl,Ctrl_0
	set 5,(hl)

	ret

; ------------------------------------------------------------------------------------------------------------------

; Esta pequeña subrutina determina el nº de columna en la que nos encontramos, Introducimos en A el valor absoluto de L, (0-31).
; 
; OUTPUT: "FLAG C". Si se produce 1, nos encontramos en las primeras 16 columnas de pantalla, (cuadrantes 1 y 3). Si no es así, (cuadrantes 2 y 4).

column ld a,l
	and $1f 											
 	cp $10												
 	ret

; --------------------------------------------------------------------------------------------------------------------
;
; 	3/2/25
;
;	Modify: A.
;
;	Output: (Columnas).
;	

calcula_CColumnass 

	ld a,(Posicion_actual)
	and $1f
	jr z,One_CColumna
	dec a
	jr z,Due_CColumna
	inc a
	cp $1e
	jr c,one_or_due_ccolumnas
	jr z,Due_CColumna
	jr One_CColumna

one_or_due_ccolumnas ld a,(Columns)
	ld (Columnas),a
	ret

Due_CColumna ld a,2
	jr 1F
One_CColumna ld a,1
1 ld (Columnas),a
	ret

; --------------------------------------------------------------------------------------------------------------------
;
;   19/7/23
;
;	Calcula el puntero de impresión del sprite, (arriba-izquierda).
;	Almacena en IY (Puntero_objeto). La rutina de impresión requiere de esta dirección para situar el SP a la hora de pintar.
;
;	OUTPUT: IX Contienen el puntero de impresión.
;			HL e IY Contienen (Puntero_objeto).
;
;	DESTRUYE: HL,B Y A.	

Calcula_puntero_de_impresion

	ld a,(Cuad_objeto)
	and 1
	jr nz,Lado_izquierdo

Lado_derecho

	ld a,(Cuad_objeto)
	dec a
	dec a
	jr z,Cuadrante_dos
	jr Cuadrante_cuatro

Lado_izquierdo

	ld a,(Cuad_objeto)
	srl a
	jr z,Cuadrante_uno 

; Estamos situados en el 3er cuadrante de pantalla. ----- ----- -----

	call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.

9 ld a,l
	and $1f
	jr z,7F
	dec hl
	djnz 9B
	jr 7F

Cuadrante_cuatro

3 ld hl,(Posicion_actual) 
	jr 7F

1 jr z,2F

Cuadrante_uno

	call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.

4 ld a,l
	and $1f
	jr z,6F
	dec hl
	djnz 4B
6 ld b,15
5 call PreviousScan
	djnz 5B
	jr 7F

Cuadrante_dos

2 call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.
	ld b,15
8 call PreviousScan
	djnz 8B

7 ld (Puntero_de_impresion),hl

	push hl
	pop ix

	ld hl,(Puntero_objeto)

	push hl
	pop iy

	ret

; --------------------------------------------------------------------------------------------------------------------
;
;	2/1/23
;
;	Sub-rutina de [Calcula_puntero_de_impresion].
;	
;	Tras esta rutina tenemos:
;
;	OUTPUT: HL contiene (Posicion_actual).
;			B contiene (Columnas)-1. Nota: Este valor `nunca' será "0". El valor mínimo es "1".
;
;	DESTRUYE!!!!! HL,B y A.

Operandos ld hl,(Posicion_actual)
	ld a,(Columnas)
	dec a
	jr nz,1F
	inc a
1 ld b,a
	ret

; --------------------------------------------------------------------------------------------------------------------
;
;	Prepara_draw
;
;	Es una rutina de carga.
;	Carga los registros BC,HL y E para posteriormente llamar a la rutina de pintado [DRAW].
;	
;	FUNCIONAMIENTO:
;
;	- LD (Filas/Columns) del objeto a pintar en [BC].
;	- LD (Posicion_actual) del objeto en [HL].
;	- LD E,0. (Dígito de control utilizado por Draw para cálculos internos de la rutina. Ha de estar a "0").
;
;	DESTRUYE:
;
;	Logicamente, BC,HL y E quedan destruidos.	

Prepara_draw ld hl,Filas 		 					 					 ; Prepara los registros BC, E y HL. 
	ld b,(hl) 														     ; Carga Filas/Columns del objeto a pintar o inicializar en BC. 
	inc hl 												 				 ; Carga (Posicion_actual) en HL.
	ld c,(hl) 											
	ld hl,(Posicion_actual)
	ld e,0 																 ; Byte de control. Ha de estar a "0" cuando llamamos a [DRAW].
	ret

;----------------------------------------------------------------------------------------------------------------
;
;	5/08/22
;
;   NextScan. 
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el siguiente scanline. (Inc H, línea abajo).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el siguiente scanline.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

NextScan inc h          ; Incrementamos el scanline.
    ld a,h
    and 7
    ret nz              ; Salimos de la rutina si el scanline se encuentra entre (1-7).

	ld a,l              ; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           ; Vamos a comprobarlo...
    ld l,a
    ret c               ; Salimos si se produce el cambio de tercio.

    ld a,h              ; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               ; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a
    ret

;----------------------------------------------------------------------------------------------------------------     
;
;	5/08/22
;
;   PreviousScan.
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el scanline anterior. (Dec H, línea arriba).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el scanline anterior.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

PreviousScan ld a,h         
    dec h               ; Dec H.
    and 7
    ret nz              ; Salimos de la rutina si el scanline se encuentra entre (1-7).

    ld a,l              ; Estabamos en el scanline "0" y al decrementar nos situamos en el "7" y cambiamos de tercio.
    sub $20             ; Vamos a comprobarlo...
    ld l,a
    ret c               ; Salimos si estábamos en la primera línea y se produce el cambio de tercio.

    ld a,h              ; No estamos en la primera línea del tercio, por lo que inicializamos H sumando una_
    add a,8             ; _unidad a los bits que definen el tercio TT, (add a,$08).
    ld h,a
    ret


	









