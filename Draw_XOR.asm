; ------------------------------------------------------------------
;
; 27/8/26
;

Draw:

	ld hl,(Posicion_actual)
	ld a,h
	or l
	jr nz,Entidad_iniciada 										; Si el contenido de (Posicion_actual) es distinto de "0" la entidad ya se ha iniciado.

	call Inicia_Puntero_mov

	ld hl,(Posicion_inicio)
	ld (Posicion_actual),hl
	ld (Puntero_de_impresion),hl

Entidad_iniciada:

	ld ix,(Puntero_de_impresion) 								; (Puntero_de_impresion) de la anterior (Posicion_actual). Necesario para averiguar si existe_
; 																; _cambio de cuadrante cuando el sprite está incompleto.
	call Calcula_Cuad_objeto  									; (Cuad_objeto) de la nueva (Posicion_actual).

	call calcula_CColumnass										; Define el valor de la variable (Columnas). Nº de columnas que se van a pintar de la entidad.
;																; También comprueba si en la nueva (Posicion_actual) el Sprite se imprime COMPLETO o INCOMPLETO, (Sprite_completo_1).

;	----------------------------------------

;	push hl
;	push bc
;	push af
;	push de
;	push ix
;	push iy


;	ld hl,(Posicion_actual)

;	ld ix,(Puntero_de_impresion)
;	ld iy,(Puntero_objeto)

;	ld a,(Columns)
;	ld b,a
;	ld a,(Columnas)
;	ld c,a

;	ld a,(Sprite_completo)
;	ld e,a

;	ld a,(Cuad_objeto)

;	jr $

;	pop iy
;	pop ix
;	pop de
;	pop af
;	pop bc
;	pop hl

;	----------------------------------------

	call Drive													; Después de ejecutar esta rutina tenemos el puntero de impresión en HL.

;	----------------------------------------

;;	push hl
;;	push bc
;;	push af
;;	push de
;;	push ix
;;	push iy


;;	ld hl,(Posicion_actual)

;;	ld ix,(Puntero_de_impresion)
;;	ld iy,(Puntero_objeto)

;	ld a,(Columns)
;	ld b,a
;	ld a,(Columnas)
;	ld c,a

;	ld a,(Sprite_completo)
;	ld e,a

;	ld a,(Cuad_objeto)

;	jr $

;	pop iy
;	pop ix
;	pop de
;	pop af
;	pop bc
;	pop hl

;	----------------------------------------

;	HL (Posicion_actual)
;	IX (Puntero_de_impresion)
;	IY (Puntero_objeto)
;	 A (Cuad_objeto)
;	 E (Sprite_completo)
;	 B (Columns)
;	 C (Columnas)

	ld a,(Ctrl_0)												; Antes de salir de la rutina restauramos los bits 0,1,2,3 y 5 de (Ctrl_0).
	and $d0									
	ld (Ctrl_0),a

	ret

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;   23/8/26
;
;	Calcula el cuadrante de pantalla donde se encuentra la entidad: (Cuad_objeto), "1", "2", "3" o "4".
;	Esta información es necesaria para poder calcular el (Puntero_de_impresion) de la entidad.
;
;	INPUT:  HL contiene (Posicion_actual).
;	OUTPUT: (Cuad_objeto) y A contienen "1", "2", "3" o "4" en función del cuadrante de pantalla en el que se encuentra la entidad.		
;			HL contiene (Posicion_actual).
;
;	MODIFY: A.	


Calcula_Cuad_objeto:

	call calcula_tercio

;	Ahora tenemos "0", "1" o "2" en el acumulador en función del tercio de pantalla en el que nos encontremos.

	jr z,Primer_tercio 													

	dec a

	jr z,Segundo_tercio

Tercer_tercio:

	call Determina_lado_de_pantalla

	jr nz,1F

	ld a,4
	ld (Cuad_objeto),a

	ret

1 ld a,3
	ld (Cuad_objeto),a

	ret	

Primer_tercio:

	call Determina_lado_de_pantalla
	jr nz,2F

	ld a,2
	ld (Cuad_objeto),a

	ret

2 ld a,1
	ld (Cuad_objeto),a

	ret

Segundo_tercio:

	ld a,l
	cp $80
	jr c,Primer_tercio
	jr Tercer_tercio

; ------------------------------------
;
;	OUTPUT: Z si estamos en la mitad derecha de la pantalla y NZ si estamos en la mitad izquierda.
;

Determina_lado_de_pantalla:

	ld a,l
	and $1f
	cp $10

	jr c,1F

	xor a
	ret

1 ld a,1
	and a
	ret

; --------------------------------------------------------------------------------------------------------------------
;
; 	23/8/26
;
;	
;	Inicializa la variable (Columnas), n° de columnas que podemos imprimir del Sprite cuando está incompleto, (apareciendo o desapareciendo)_
;	_por los extremos de la pantalla.

;	INPUT: (HL) contiene (Posicion_actual).
;		   (A) contiene (Cuad_objeto).
;		   (C) contiene (Columns).
;
;	MODIFY: (A).
;
;	OUTPUT: (Columnas).
;			(Sprite_completo).
;
;		    (A) contiene (Columnas).
;			(HL) contiene (Posicion_actual).

calcula_CColumnass:

	ld a,(Posicion_actual)
	and $1f
	jr z,One_CColumna

	dec a
	jr z,Two_CColumna

	inc a

	cp $1e
	jr c,Two_or_Three_ccolumnas

	jr z,Two_CColumna

	jr One_CColumna

Two_or_Three_ccolumnas:

	ld a,(Columns)
	ld (Columnas),a

	ret

Two_CColumna:

	ld a,2
	ld (Columnas),a

	ret

One_CColumna:

	ld a,1
	ld (Columnas),a

	ret

; --------------------------------------------------------------------------------------------------------------------
;
;   27/8/26
;
;	INPUT: (HL) contiene (Posicion_actual).
; 		    (A)    "     (Columnas).
;		   (IX)    "     (Puntero_de_impresion) de la (Posicion_actual) anterior, (antes del último movimiento).
; 						 Comparando (Cuad_objeto) de (IX) con (Cuad_objeto) de (HL) cuando el Sprite está INCOMPLETO,_
;						 _averiguamos si se ha producido cambio de cuadrante, (pasamos de la parte alta de la pantalla a la parte baja_
; 						 _o viceversa).
;
;
;	OUTPUT:	(HL) contiene  (Posicion_actual).
;		   	(IX)    "      (Puntero_de_impresion).
;			(IY)    "      (Puntero_objeto).

Drive:

;	(Columnas) en (E).
;	(Sprite_completo) en (D).

	ld e,a

	ld a,(Sprite_completo)
	ld d,a 									           ; (Sprite_completo)/(Columnas) en DE.

;	jr $

;	Situación en pantalla de la nueva (Posicion_actual).

	ld a,(Cuad_objeto)
	dec a
	jp z, Cuadrante_uno

	dec a
	jr z, Cuadrante_dos

	dec a
	jr z, Cuadrante_tres

; ------------------------------------------------------------------------------
; ------------------------ CUADRANTE 4 -----------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_cuatro:

	jr $

; ------------------------------------------------------------------------------
; ------------------------ CUADRANTE 3 -----------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_tres:

	inc d
	dec d
	jr nz, Sprite_anteriormente_completo_en_CUAD_3 	; (D) contiene (Sprite_completo), indica si el Sprite estaba COMPLETO o no en la (Posicion_actual) anterior.

Sprite_anteriormente_incompleto_en_CUAD_3:

;	Sprite INCOMPLETO en el 1er cuadrante.
;
;	(Posicion_actual) del Sprite se encuentra en zona nebulosa del 1er cuadrante. Lo primero que necesitamos saber es si el Sprite viene de otro cuadrante, (2º o 3º) o se mantiene en el mismo.

	call Comprueba_Cuad_anterior 						; (A) contiene 1,2,3 o 4 en función de la situación del anterior (Puntero_de_impresion).

	dec a
	jr z, Procede_de_cuad1_3
	dec a
	jr z, Procede_de_cuad2_3
	dec a
	jr z, Procede_de_cuad3_3

Procede_de_cuad4_3:

	jr $

Procede_de_cuad3_3:

;	No modificamos (Posicion_actual) pues seguimos en el 3er cuadrante.
;	Calculamos el nuevo (Puntero_de_impresion).

	call Modifica_columna_a_izq
	call Prepara_punteros

	call Comprueba_completo_en_Cuad_3
	ret c 												 ; El Sprite continúa INCOMPLETO, (Sprite_completo) = "0".

;	El Sprite pasa de INCOMPLETO a COMPLETO.

;	Modifica (Posicion_actual) y flag (Sprite_completo).

	ld (Posicion_actual),ix

	ld a,1
	ld (Sprite_completo),a

	ret

Procede_de_cuad2_3:

	jr $

Procede_de_cuad1_3:

;	En 1er lugar Recolocamos (Posicion_actual) pues hay cambio de Cuad. (1º a 3º).

	call PreviousScan_15
 	ld (Posicion_actual),hl
	jr Procede_de_cuad3_3

Sprite_anteriormente_completo_en_CUAD_3:

;	El Sprite estaba completo en Cuad_1,2 o 3 en su anterior (Posicion_actual). Estamos en Cuad_1.
;	Vamos a pensar que el sprite continúa completo.

	call Prepara_punteros
	call Comprueba_completo_en_Cuad_3
	ret nc 												; RET si el Sprite sigue estando COMPLETO.

;	El Sprite pasa de estar COMPLETO a estar INCOMPLETO.

;	Recolocamos (Posicion_actual)

	call Modifica_columna_a_der
	ld (Posicion_actual),hl

	xor a
	ld (Sprite_completo),a

	ret

; ------------------------------------------------------------------------------
; ------------------------ CUADRANTE 2 -----------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_dos:

	inc d
	dec d
	jr nz, Sprite_anteriormente_completo_en_CUAD_2 	; (D) contiene (Sprite_completo), indica si el Sprite estaba COMPLETO o no en la (Posicion_actual) anterior.

Sprite_anteriormente_incompleto_en_CUAD_2:

;	Sprite INCOMPLETO en el 1er cuadrante.
;
;	(Posicion_actual) del Sprite se encuentra en zona nebulosa del 1er cuadrante. Lo primero que necesitamos saber es si el Sprite viene de otro cuadrante, (2º o 3º) o se mantiene en el mismo.

	call Comprueba_Cuad_anterior 						; (A) contiene 1,2,3 o 4 en función de la situación del anterior (Puntero_de_impresion).

	dec a
	jr z, Procede_de_cuad1_2
	dec a
	jr z, Procede_de_cuad2_2
	dec a
	jr z, Procede_de_cuad3_2

Procede_de_cuad4_2:

;	En 1er lugar Recolocamos (Posicion_actual) pues hay cambio de Cuad. (4º a 2º).

	call NextScan_15
	ld (Posicion_actual),hl

;	Calculamos el nuevo (Puntero_de_impresion).

	jr Procede_de_cuad2_2

Procede_de_cuad3_2:

	jr $

Procede_de_cuad2_2:

;	No modificamos (Posicion_actual) pues seguimos en el 2º cuadrante.
;	Calculamos el nuevo (Puntero_de_impresion).

	call PreviousScan_15
	call Prepara_punteros

	call Comprueba_completo_en_Cuad_2
	ret c												; El Sprite continúa INCOMPLETO, (Sprite_completo) = "0".

;	El Sprite pasa de INCOMPLETO a COMPLETO.

;	Modifica (Posicion_actual) y flag (Sprite_completo).

	ld (Posicion_actual),ix

	ld a,1
	ld (Sprite_completo),a

	ret

Procede_de_cuad1_2:

;	En 1er lugar Recolocamos (Posicion_actual) pues hay cambio de Cuad. (1º a 2º).

	call Modifica_columna_a_izq
	ld (Posicion_actual),hl

;	Calculamos el nuevo (Puntero_de_impresion).

	jr Procede_de_cuad2_2

Sprite_anteriormente_completo_en_CUAD_2:

;	El Sprite estaba completo en Cuad_1,2 o 4 en su anterior (Posicion_actual). Estamos en Cuad_2.
;	Vamos a pensar que el sprite continúa completo.

	call Prepara_punteros
	call Comprueba_completo_en_Cuad_1
	ret nc 												; RET si el Sprite sigue estando COMPLETO.

;	El Sprite pasa de estar COMPLETO a estar INCOMPLETO.

;	Recolocamos (Posicion_actual)

	call NextScan_15
	ld (Posicion_actual),hl

	xor a
	ld (Sprite_completo),a

	ret

; ------------------------------------------------------------------------------
; ------------------------ CUADRANTE 1 -----------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_uno:

	inc d
	dec d
	jr nz, Sprite_anteriormente_completo_en_CUAD_1 	; (D) contiene (Sprite_completo), indica si el Sprite estaba COMPLETO o no en la (Posicion_actual) anterior.

Sprite_anteriormente_incompleto_en_CUAD_1:

;	Sprite INCOMPLETO en el 1er cuadrante.
;
;	(Posicion_actual) del Sprite se encuentra en zona nebulosa del 1er cuadrante. Lo primero que necesitamos saber es si el Sprite viene de otro cuadrante, (2º o 3º) o se mantiene en el mismo.

	call Comprueba_Cuad_anterior 						; (A) contiene 1,2,3 o 4 en función de la situación del anterior (Puntero_de_impresion).

	dec a
	jr z, Procede_de_cuad1
	dec a
	jr z, Procede_de_cuad2
	dec a
	jr z, Procede_de_cuad3

Procede_de_cuad4:

	jr $

Procede_de_cuad3:

;	En 1er lugar Recolocamos (Posicion_actual) pues hay cambio de Cuad. (3º a 1º).

	call NextScan_15
	ld (Posicion_actual),hl

;	Calculamos el nuevo (Puntero_de_impresion).

	jr Procede_de_cuad1

Procede_de_cuad2:

;	En 1er lugar Recolocamos (Posicion_actual) pues hay cambio de Cuad. (2º a 1º).

	call Modifica_columna_a_der
	ld (Posicion_actual),hl

;	Calculamos el nuevo (Puntero_de_impresion).

Procede_de_cuad1:

;	No modificamos (Posicion_actual) pues seguimos en el 1er cuadrante.
;	Calculamos el nuevo (Puntero_de_impresion).

	call PreviousScan_15
	call Modifica_columna_a_izq
	call Prepara_punteros

	call Comprueba_completo_en_Cuad_1
	ret c												; El Sprite continúa INCOMPLETO, (Sprite_completo) = "0".

;	El Sprite pasa de INCOMPLETO a COMPLETO.

;	Modifica (Posicion_actual) y flag (Sprite_completo).

	ld (Posicion_actual),ix

	ld a,1
	ld (Sprite_completo),a

	ret

Sprite_anteriormente_completo_en_CUAD_1:

;	El Sprite estaba completo en Cuad_1,2 o 3 en su anterior (Posicion_actual). Estamos en Cuad_1.
;	Vamos a pensar que el sprite continúa completo.

	call Prepara_punteros
	call Comprueba_completo_en_Cuad_1
	ret nc 												; RET si el Sprite sigue estando COMPLETO.

;	El Sprite pasa de estar COMPLETO a estar INCOMPLETO.

;	Recolocamos (Posicion_actual)

	call NextScan_15
	call Modifica_columna_a_der
	ld (Posicion_actual),hl

	xor a
	ld (Sprite_completo),a

	ret

; ---------------------------------------------------------------------------
;
;	Subrutinas DRIVE.
;
; ---------------------------------------------------------------------------

Comprueba_completo_04:


	ret

Comprueba_completo_en_Cuad_3:

	ld a,ixl
	and $1f
	cp 3

	ret

Comprueba_completo_en_Cuad_2:

	ld a,ixl
	and $1f
	cp $1d
	jr c,1F 								; Estamos por debajo de la columna $1d, en principio el sprite está completo

	ccf 									; Estamos por encima de la columna $1d, invertimos el FLAG CARRY y RET. Sprite INCOMPLETO.

	ret

1 ld a,ixl
	cp $a0
	ret c

	ret

Comprueba_completo_en_Cuad_1:

	ld a,ixl
	and $1f
	cp 3

	ret c 									; RET con CARRY FLAG indica que el Sprite en la actual (Posicion_actual) está INCOMPLETO.

	ld a,ixl
	cp $a0

	ret

; ---------------------------------------------------
;
;	28/8/26
;
;	OUTPUT: (A) contiene el nº de cuadrante del anterior (Puntero_de_impresion).
;

Comprueba_Cuad_anterior:

	push hl

	push ix
	pop hl

	call Calcula_Cuad_objeto

	pop hl

	ret

Prepara_punteros:

	ld (Puntero_de_impresion),hl

	push hl
	pop ix

	ld hl,(Puntero_objeto)

	push hl
	pop iy

	ret

Modifica_columna_a_izq:

	dec e 									; (E) contiene (Columnas).

	ld a,l
	sub e
	ld l,a

	ret

Modifica_columna_a_der:

	dec e 									; (E) contiene (Columnas).

	ld a,l
	inc e
	ld l,a

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

NextScan:

	inc h          							; Incrementamos el scanline.
    ld a,h
    and 7
    ret nz              							; Salimos de la rutina si el scanline se encuentra entre (1-7).

	ld a,l              							; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           							; Vamos a comprobarlo...
    ld l,a
    ret c               							; Salimos si se produce el cambio de tercio.

    ld a,h              							; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               							; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a
    ret

NextScan_15:

	ld b,15
1 call NextScan
	djnz 1B

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

PreviousScan:

	ld a,h
    dec h               							; Dec H.
    and 7
    ret nz              							; Salimos de la rutina si el scanline se encuentra entre (1-7).

    ld a,l              							; Estabamos en el scanline "0" y al decrementar nos situamos en el "7" y cambiamos de tercio.
    sub $20             							; Vamos a comprobarlo...
    ld l,a
    ret c               							; Salimos si estábamos en la primera línea y se produce el cambio de tercio.

    ld a,h              							; No estamos en la primera línea del tercio, por lo que inicializamos H sumando una_
    add a,8             							; _unidad a los bits que definen el tercio TT, (add a,$08).
    ld h,a
    ret

PreviousScan_15:

	ld b,15
1 call PreviousScan
	djnz 1B

	ret

; -----------------------------------------------------------------
;
;	4/4/25
;
;	Limpia un espacio de la memoria.
;
;	INPUTS:  HL apunta al 1er byte del espacio de memoria que queremos limpiar.
;				   BC indica el nº de bytes que vamos a poner a "0".
;
;	MODIFY: HL,DE,BC

Clean_mem:

	ld (hl),0

	push hl
	pop de

	inc de

	ldir

	ret








