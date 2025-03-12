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
	and $d0									
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
;	OUTPUT: (Cuad_objeto) y A contienen "1", "2", "3" o "4" en función del cuadrante de pantalla en el que se encuentra la entidad.		
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
;	25/02/25
;
; 	Comprueba_limite_horizontal.
;
;	La rutina comprueba si hemos sobrepasado el (Limite_horizontal) definido en la rutina [Inicializacion]. Este será:_
;	_ $4fc0 si partimos de los cuadrantes 1 o 2 de pantalla o $4820 si partimos de los cuadrantes 3 o 4.
; 
;	Si sobrepasamos o alcanzamos el límite horizontal establecido, la rutina cargará el registro E con un "1".
;	Si NO HEMOS SOBREPASADO (Limite_horizontal), E="0".
;	E="2" indica que hemos alcanzado el centro de la pantalla aunque NO HEMOS SUPERADO (Limite_horizontal), (ZONA NEBULOSA).

;	INPUT: HL contiene (Posicion_actual).

Comprueba_limite_horizontal 

	ld e,0											; Inicializamos E.

;	Exclusiones !!!

	ld a,(Ctrl_0)									; RET cuando hemos desaparecido por la parte alta o baja de pantalla.
	and $0c
	ret nz

	call calcula_tercio  							; RET cuando no estamos en el centro de la pantalla, (2º tercio).
	ret z

	dec a
	dec a
	ret z

;	HL (Posicion_actual).
;	E=0

	ld a,(Cuad_objeto)
	cp 2
	jr z,1F
	jr c,1F

;	Nos encontramos en la parte INFERIOR de la pantalla.
;	En este caso superamos el CENTRO de la pantalla cuando L < $80

	ld a,$7f 
	sub l
	ret c											
	ret nz											; RET no hemos llegado al centro de la pantalla, E=0.

	ld e,2											; Zona NEBULOSA que no es poca cosa.

	ld a,(Limite_horizontal)
	sub l
	ret c											; RET con E=2.

2 dec e
	ret												; RET con E=1.

;	Nos encontramos en la parte SUPERIOR de la pantalla.
;	En este caso superamos el CENTRO de la pantalla cuando L =< $7f

1 ld a,$80
	sub l
	ret nc											; RET no hemos llegado al centro de la pantalla, E=0.
	ret nz

	ld e,2											; Zona NEBULOSA que no es poca cosa.

	ld a,(Limite_horizontal)
	sub l
	jr z,2B
	jr c,2B

	ret												; RET con E=2.

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;   12/3/25
;
;	Comprueba_limite_vertical
;
;	Modifica el registro L del puntero de pantalla cuando se sobrepasa la columna límite, (Limite2).
;	Dependiendo del cuadrante en el que nos encontremos, sumaremos o restaremos, (Columnas-1) a L. 
;	
;	INPUT: HL contiene (Posicion_actual).

Comprueba_limite_vertical 

;	Exclusiones:

;	No comprobamos (Limite_vertical) cuando E=2. (Zona nebulosa horizontal) pero si modificamos (Cuad_objeto)_
;	y (Posicion_actual) para evitar que haya problemas de impresión en la salida por los extremos.

	ld a,e

	dec a
	dec a
	jr nz,2F

	call Salida_nebulosamente_por_la_derecha
	ret z
	call Salida_nebulosamente_por_la_izquierda
	ret

;	No comprobamos (Limite_vertical) cuando hemos desaparecido por los extremos.

2 ld a,(Ctrl_0)
	and 3
	jr nz,Consulta_E

;	E=1 / E=0 y NO HEMOS DESAPARECIDO por los lados de la pantalla.
;	Comprobamos (Limite_vertical).

	ld a,(Cuad_objeto)
	and 1
	jr z,1F

;	Nos encontramos en la parte IZQUIERDA de la pantalla.

	call Comprobacion
	jr nc,Comprueba_centro_vertical_izquierdo

;	Cambiamos de cuadrante, hemos superado (Limite_vertical). 
;	Pasamos de la mitad izquierda de la pantalla a la mitad derecha.

	dec c											 				; (Columns-1) en C.
	ld a,l
	sub c
	ld (Posicion_actual),a
	call Inicializacion

	jr Consulta_E

;	Nos encontramos en la parte DERECHA de la pantalla.

1 call Comprobacion
	jr c,Comprueba_centro_vertical_derecho

;	Cambiamos de cuadrante, hemos superado (Limite_vertical). 
;	Pasamos de la mitad derecha de la pantalla a la mitad izquierda.

	dec c											 				; (Columns-1) en C.
	ld a,l
	add c
	ld (Posicion_actual),a
	call Inicializacion

;	E puede tener valor "0" o "1".

Consulta_E 

	ld a,e
	dec a
	call z,Modificaccionne
	ret

; ----- ----- ----- ----- ----- 

Comprobacion ld a,l							
	and $1f
	ld d,a
	ld a,(Limite_vertical)  
	sub d
	ret

Comprueba_centro_vertical_izquierdo ld a,$0e		; RET. Estamos en zona nebulosa vertical.
	sub d
	ret c

	jr Consulta_E

Comprueba_centro_vertical_derecho ld a,$11
	sub d
	ret nc

	jr Consulta_E

; --------------------

Modifica_Pos_actual ld b,15                         ; Scanlines-1 en B.
1 call PreviousScan
    djnz 1B
	ld (Posicion_actual),hl
	call Inicializacion
	xor a 											; Carry a "0". Evita que vuelva a entrar consecutivamente.
	ret

; --------------------

Modifica_Pos_actual2 ld b,15                        ; Scanlines-1 en B.
1 call NextScan
    djnz 1B
	ld (Posicion_actual),hl
	call Inicializacion
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

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

Salida_nebulosamente_por_la_derecha

;	E=2. Estamos en la zona nebulosa horizontal. Existe posibilidad de salida por el lado derecho ???

	jr $

	ld a,(Posicion_actual)
	and $1f
	cp $1e
	ret c

; 	Existe posibilidad de desaparecer por el lado derecho de la pantalla. Si (Cuad_objeto) indica que_
;	_estamos en la parte izquierda de la pantalla, (1/3), la salida será defectuosa. 

	ld a,(Cuad_objeto)
	and 1
	ret z 							; RET. (Cuad_objeto) indica el cuadrante correcto. No habrá problemas en la salida.

	ld a,(Cuad_objeto)
	inc a
	ld (Cuad_objeto),a 				; Corregimos (Cuad_objeto) y activamos FLAG para que no haya llamada a [Inicializacion] más adelante.

	dec c							; (Columns-1) en C.
	ld a,l
	sub c
	ld (Posicion_actual),a

	dec e
	dec e 							; E=0 , evita que ejecutemos [Salida_nebulosamente_por_la_izquierda].

	ret

Salida_nebulosamente_por_la_izquierda

;	E=2. Estamos en la zona nebulosa horizontal. Existe posibilidad de salida por el lado izquierdo ???.

	jr $

	ld a,(Posicion_actual)
	and $1f
	cp $01
	ret nc
	ret nz

; 	Existe posibilidad de desaparecer por el lado izquierdo de la pantalla. Si (Cuad_objeto) indica que_
;	_estamos en la parte derecha de la pantalla, (2/4), la salida será defectuosa. 

	ld a,(Cuad_objeto)
	and 1
	ret nz 							; RET. (Cuad_objeto) indica el cuadrante correcto. No habrá problemas en la salida.

	ld a,(Cuad_objeto)
	dec a 
	ld (Cuad_objeto),a 				; Corregimos (Cuad_objeto) y activamos FLAG para que no haya llamada a [Inicializacion] más adelante.

	dec c											 				; (Columns-1) en C.
	ld a,l
	inc c
	ld (Posicion_actual),a

	ret

; *************************************************************************************************************************************************************************************************
;
;	25/02/25
;
;	Inicializacion
;
;	Entrega "1", "2", "3" o "4" en (Cuad_objeto) en función del cuadrante de pantalla en el que nos encontremos.
;	Asigna (Limite_vertical) y (Limite_horizontal) en función de (Cuad_objeto).

; 	La rutina se ejecuta cada vez que la entidad supera el (Limite_horizontal) o el (Limite_vertical).
;	También cuando la entidad desaparece/aparece por cualquier lado de la pantalla.

;	INPUT: [HL] contendrá la dirección de pantalla a la que queremos asignar cuadrante. HL=(Posicion_inicio).
; 		   [BC] contendrá (Filas)/(Columns) del objeto a inicializar.

; 	OUTPUT: (Cuad_objeto), (Limite_vertical), (Limite_horizontal) y set5(Ctrl_0).
;
;	MODIFY: A,E,HL,B

Inicializacion 

	call Calcula_Cuad_objeto
	ld e,a												; (Cuad_objeto) en A y E.
	and 1
	jr nz,Left_screen

Right_screen

	ld hl,Limite_vertical								; En la parte DERECHA de la pantalla, (Limite_vertical) = "$0d".
	ld (hl),$0d       	
	dec e
	dec e
	jr z,Up_screen
	jr Down_screen

Left_screen

	ld hl,Limite_vertical								; En la parte IZQUIERDA de la pantalla, (Limite_vertical) = "$12".
	ld (hl),$12	   
	srl e
	jr z,Up_screen 

Down_screen	

	ld a,$40    
	ld (Limite_horizontal),a
	jr 1F

Up_screen 

	ld a,$c0
	ld (Limite_horizontal),a

1 ld hl,(Posicion_actual)
	call Genera_coordenadas

	ld hl,Ctrl_0
	set 5,(hl)

	ret

; --------------------------------------------------------------------------------------------------------------------
;
; 	3/2/25
;
;	Modify: A.
;	
;	INPUT: A contiene el byte bajo de (Posicion_actual).
;	OUTPUT: (Columnas).
;	

calcula_CColumnass ld a,(Posicion_actual)
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
;   2/3/25
;
;	Calcula el puntero de impresión del sprite, (arriba-izquierda).
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

	ld a,l
	and $1f
	jr z,4F

6 dec hl
	djnz 6B

	jr 4F

Cuadrante_cuatro

	ld hl,(Posicion_actual) 
	jr 4F

Cuadrante_uno

	call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.

	ld a,l
	and $1f
	jr z,3F

1 dec hl
	djnz 1B

3 ld b,15
2 call PreviousScan
	djnz 2B

	jr 4F

Cuadrante_dos

	call Operandos					; (Posicion_actual) en HL y (Columnas)-1 en B.
	ld b,15
5 call PreviousScan
	djnz 5B

4 ld (Puntero_de_impresion),hl

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
;	OUTPUT:
;
;	- LD (Filas/Columns) del objeto a pintar en [BC].
;	- LD (Posicion_actual) del objeto en [HL].
;
;	MODIFY: HL y BC.

Prepara_draw ld hl,Filas 		 					 					 ; Prepara los registros BC, E y HL. 
	ld b,(hl) 														     ; Carga Filas/Columns del objeto a pintar o inicializar en BC. 
	inc hl 												 				 ; Carga (Posicion_actual) en HL.
	ld c,(hl) 											
	ld hl,(Posicion_actual)
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


	









