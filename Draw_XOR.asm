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

	ld a,(Filas)
	ld b,a
	ld a,(Columns)
	ld c,a														; (Filas/Columns) en BC.

	ld ix,(Puntero_de_impresion) 								; (Puntero_de_impresion) de la anterior (Posicion_actual). Necesario para averiguar si existe_
; 																; _cambio de cuadrante cuando el sprite está incompleto.

	call Calcula_Cuad_objeto  									; (Cuad_objeto) de la nueva (Posicion_actual).

1 call calcula_CColumnass										; Define el valor de la variable (Columnas). Nº de columnas que se van a pintar de la entidad.

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
;
;	MODIFY: (A).
;
;	OUTPUT: (Columnas).
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
;		   (BC)    "     (Filas)/(Columns).
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

	jr $

;	Situación de pantalla, (cuadrante) de la nueva (Posicion_actual).

	ld a,(Cuad_objeto)
	dec a
	jr z, Cuadrante_uno

	dec a
	jr z, Cuadrante_dos

	dec a
	jr z, Cuadrante_tres

; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_cuatro:

;	En el 4° cuadrante, (Posicion_actual) y (Puntero_de_impresion) siempre indicarán la esquina superior izquierda del Sprite ya esté_
;	_completo o incompleto.

	inc d
	dec d
	jr nz, Sprite_completo_04

	call Prepara_punteros
	call Comprueba_completo_04

	jr c, Sprite_incompleto_004
	jp Sprite_entero

Sprite_incompleto_004:

;	No modificamos (Posicion_actual) si el Sprite ya permanecía incompleto.

	inc d
	dec d
	ret z											; El Sprite estaba incompleto y continuará INCOMPLETO. No modificamos (Posicion_actual).

;	El Sprite estaba COMPLETO pero ahora pasa a INCOMPLETO:

	xor a
	ld (Sprite_completo),a

	ret

Sprite_completo_04:

;	(HL) contiene (Posicion_actual).

	call Comprueba_completo_04

	jr c, Sprite_incompleto_004
	jp Sprite_entero

; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_tres:

;	En el 3er cuadrante, (Posicion_actual) estará señalando la esquina superior derecha, (Sprite incompleto), o la esquina sup. izq., (Sprite completo).

	inc d
	dec d
	jr nz, Sprite_completo_03

Sprite_incompleto_03:

	call Modifica_columna_a_izq
	call Prepara_punteros
	call Comprueba_completo_03

	jr c, Sprite_incompleto_003
	jp Sprite_entero

Sprite_incompleto_003:

;	No modificamos (Posicion_actual) si el Sprite ya permanecía incompleto.

	inc d
	dec d
	ret z											; El Sprite estaba incompleto y continuará INCOMPLETO. No modificamos (Posicion_actual).

;	El Sprite estaba COMPLETO pero ahora pasa a INCOMPLETO:

	xor a
	ld (Sprite_completo),a

;	Modifica_(Posicion_actual).

	call Modifica_columna_a_der

	ld (Posicion_actual),hl

	ret

Sprite_completo_03:

;	(HL) contiene (Posicion_actual).

	ld (Puntero_de_impresion),hl
	call Comprueba_completo_01

	jr c, Sprite_incompleto_003
	jp Sprite_entero

; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_dos:

;	En el 2° cuadrante, (Posicion_actual) estará señalando la esquina inferior izquierda, (Sprite incompleto), o la esquina sup. izq., (Sprite completo).

	inc d
	dec d
	jr nz, Sprite_completo_02

Sprite_incompleto_02:

;	Calculamos (Puntero_de_impresion) y preparamos salida:
;
;		   	(IX) contiene (Puntero_de_impresion).
;			(IY)    "     (Puntero_objeto).

	call PreviousScan_00
	call Prepara_punteros
	call Comprueba_completo_02

	jr c, Sprite_incompleto_002
	jp Sprite_entero

Sprite_incompleto_002:

;	No modificamos (Posicion_actual) si el Sprite ya permanecía incompleto.

	inc d
	dec d
	ret z											; El Sprite estaba incompleto y continuará INCOMPLETO. No modificamos (Posicion_actual).

;	El Sprite estaba COMPLETO pero ahora pasa a INCOMPLETO:

	xor a
	ld (Sprite_completo),a

;	Modifica_(Posicion_actual).

	call NextScan_00

	ld (Posicion_actual),hl

	ret


Sprite_completo_02:

;	(HL) contiene (Posicion_actual).

	ld (Puntero_de_impresion),hl
	call Comprueba_completo_02

	jr c, Sprite_incompleto_002
	jr Sprite_entero

; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------

Cuadrante_uno:

;	En el 1er cuadrante, (Posicion_actual) estará señalando la esquina inferior derecha, (Sprite incompleto), o la esquina sup. izq., (Sprite completo).

	inc d
	dec d
	jr nz, Sprite_completo_01 						; (D) contiene (Sprite_completo), averigua si el Sprite está COMPLETO.

Sprite_incompleto_01:

;	Calculamos (Puntero_de_impresion) y preparamos salida:
;
;		   	(IX) contiene (Puntero_de_impresion).
;			(IY)    "     (Puntero_objeto).

	call PreviousScan_00 							; Sitúa HL, (Posicion_actual) 15 scans. arriba, pasamos del último scanline al primero del Sprite.
	call Modifica_columna_a_izq 					; (Posicion_actual) pasa de apuntar la esquina sup. derecha del Sprite a la esquina sup. izquierda.
	call Prepara_punteros 							; (Puntero_de_impresion) actualizado en IX, (Puntero_objeto) en IY.
	call Comprueba_completo_01

	jr c, Sprite_incompleto_001
	jp Sprite_entero

Sprite_incompleto_001:

;	No modificamos (Posicion_actual) si el Sprite ya permanecía incompleto.

	inc d
	dec d
	ret z											; El Sprite estaba incompleto y continuará INCOMPLETO. No modificamos (Posicion_actual).

;	El Sprite estaba COMPLETO pero ahora pasa a INCOMPLETO:

	xor a
	ld (Sprite_completo),a

;	Modifica_(Posicion_actual).

	call NextScan_00
	call Modifica_columna_a_der

	ld (Posicion_actual),hl

	ret

Sprite_completo_01:

;	(HL) contiene (Posicion_actual).
	
	call Prepara_punteros
	call Comprueba_completo_01

	jr c, Sprite_incompleto_001
	jr Sprite_entero

; ---------------------------------------------------------------------------
;
;	Subrutinas DRIVE.
;
; ---------------------------------------------------------------------------

Comprueba_completo_04:

	ld hl, (Puntero_de_impresion)

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como máximo en la columna ($1a).

	ld a,l
	and $1f
	cp $1a

	jr c,1F
	jr z,1F

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como mínimo en la sexta fila de pantalla, ($a0).

1 ld a,l
	cp $7f

	ccf

	ret

Comprueba_completo_03:

	ld hl, (Puntero_de_impresion)

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como mínimo en la cuarta columna de pantalla, ($03).

	ld a,l
	and $1f
	cp 3

	ret c

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como mínimo en la sexta fila de pantalla, ($a0).

	ld a,l
	cp $7f

	ccf

	ret

Comprueba_completo_02:

	ld hl, (Puntero_de_impresion)

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como máximo en la columna ($1a).

	ld a,l
	and $1f
	cp $1a

	jr c,1F
	jr z,1F

;	Sprite incompleto, RET con Carry activo:

	ccf 									; Invertimos el FLAG Carry del registro F, RET con "C".

	ret

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como mínimo en la sexta fila de pantalla, ($80).

1 ld a,l
	cp $80

	ret

Comprueba_completo_01:

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como mínimo en la cuarta columna de pantalla, ($03).

	ld a,ixl
	and $1f
	cp 3

	ret c

;	Para que el Sprite se considere completo, (Puntero_de_impresion) ha de situarse como mínimo en la quinta fila de pantalla, ($80).

	ld a,ixh
	and $18
	sra a
	sra a
	sra a

	dec a
	ret z

	ld a,ixl
	cp $80

	ret

Sprite_entero:

	ld a,(Sprite_completo)
	and a
	ret nz 												; El Sprite estaba completo y continuará COMPLETO.

;	El Sprite pasa de modo INCOMPLETO a COMPLETO.

	inc a
	ld (Sprite_completo),a

;	Modificamos (Posicion_actual).

	ld (Posicion_actual),ix

	ret

Prepara_punteros:

	ld (Puntero_de_impresion),hl

	push hl
	pop ix

	ld hl,(Puntero_objeto)

	push hl
	pop iy

	ret

NextScan_00:

	ld b,15
1 call NextScan
	djnz 1B

	ret

PreviousScan_00:

	ld b,15
1 call PreviousScan
	djnz 1B

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








