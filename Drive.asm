; ******************************************************************************************************************************************************************************************
;
; 13/3/25
;
; DRAW. ************************************************************************************************************************************************************************************

Drive:

	ld hl,(Posicion_actual)

	ld a,h
	or l
	jr nz,Entidad_iniciada 										; Si el contenido de (Posicion_actual) es distinto de "0" la entidad ya se ha iniciado.

	call Inicia_Puntero_mov 									; Inicializa (Puntero_mov) y lo coloca en el 1er mov. de su danza.

	ld hl,(Posicion_inicio)
	ld (Posicion_actual),hl

; --------------------------------------------------

Entidad_iniciada:

	call Drive_00

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


Drive_00:

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

	jr nz,3F

	ld a,2
	ld (Cuad_objeto),a

	call calcula_Puntero_objeto_2

	ret

3 ld a,1
	ld (Cuad_objeto),a

	call calcula_Puntero_objeto_1

	ret

Segundo_tercio:

	ld a,l
	cp $7f
	jr c,Primer_tercio
	jr z,Primer_tercio

	jr Tercer_tercio

; --------------------------------------------------------
;
;	OUTPUT: A contiene "0" si estamos en la mitad derecha de la pantalla y "1" si estamos en la mitad izquierda.
;

Determina_lado_de_pantalla:

	ld a,l
	and $1f
	cp $10
	jr c,1F

	xor a

	ret

1 ld a,1

	ret

; --------------------------------------------------------
;
;	17/8/26
;

calcula_Puntero_objeto_1:

	jr $

;	Imprimimos todos los scanlines?, Estamos apareciendo por arriba?

	ld a,l
	and $f0
	cp $20
	jr z,





	ld a,l
	and $0f
	jr z,Una_columna

	dec a
	jr z,Dos_columnas

	inc a

Tres_columnas:





Una_columna:







Dos_columnas:














calcula_Puntero_objeto_2:

	jr $

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








