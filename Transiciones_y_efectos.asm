; ------------------------------------------------------------------------
;
;	11/07/25
;
;	Nivel superado.
;
;	Descripción de la animación:
;
;	Amadeus va desapareciendo scan a scan por la parte baja de la pantalla.


; 	Nota: Cuando se inicia el proceso de desaparición de Amadeus, se imprimirá nuestra nave en pantalla en cada FRAME, (aunque no haya movimiento).
;	Bit 5 (Ctrl_3) a "1".

;	Se ha iniciado el proceso de Transición de salida de Amadeus ???.

Transicion_de_salida

	ld bc,$0101

	ld a,(CTRL_DESPLZ)
	and a
	jr z,Inicia_transicion_de_salida

;	Proceso de transición de salida iniciado.

	cp $10
	jr nz,2F

;	Hay que borrar el último Scan de Amadeus.

	ld hl,Ctrl_4
	set 5,(hl)														;	Indica FIN de la transición.

	dec a

	ld hl,Sprite_vacio

	push hl
	pop de

2 ld b,a
	ld c,b

Inicia_transicion_de_salida

	push ix
	pop hl 															;	(Puntero_de_impresion) en HL.

1 call NextScan
	djnz 1B															;	Inc. scan.

	inc c
	ld a,c

	ld (CTRL_DESPLZ),a												;	Inc. contador. (Incrementos de scanlines).

	push hl
	pop ix															;	Nuevo (Puntero_de_impresion) en IX para generar datos de impresión.

	ret

; ------------------------------------------------------------------------
;
;	10/7/25
;

Dispara_salida_de_amadeus

	ld hl,Cuad_objeto

	inc (hl)
	dec (hl)

	jr nz,1F

	ld (hl),20

1 ld hl,Ctrl_2
	set 6,(hl)														;	Bit 6 de Ctrl_2 indica que hemos iniciado la "Transicion_de_salida" de Amadeus.

	ld hl,Ctrl_3													;	Bit 5 de Ctrl_3 indica que existe movimiento en Amadeus.
	set 5,(hl)

	ret

; ------------------------------------------------------------------------
;
;	28/06/25
;
;	Descripción de la animación:
;
;	Un rayo que arranca desde el lado izquierdo de la pantalla va dibujando nuestra nave, scan a scan.
;	El rayo desaparece por la parte derecha de la pantalla.

Transicion_de_entrada

	ld hl,(p.imp.amadeus)
	inc l
	inc l

	ld d,l															;	(p.imp.amadeus) + 2 en D.

	dec l
	dec l

	ld e,2

; 	Nos situamos en la primera columna del 1er scan de Amadeus.

3 ld a,l
	and $f0
	ld l,a

; 	Pintamos el rayo.

	call Pinta_rayo

; 	Decrece scan.

2 dec l
	dec l

	ld d,l
	dec e

	jr nz,3B

	inc l
	inc l

; 	Borra la pequeña cortina que irá bajando pintando Amadeus.

	call Borra_pinta_scan

; 	HL e IX contienen (p.imp.amadeus).
; 	IY contiene (Puntero_objeto) de Amadeus.

; 	Animación de pintado de Amadeus. ---------------------------------------------
;
; 	Comenzamos en el 1er Scan de Amadeus, (No hay cortina, la acabamos de borrar).
;
; 	Secuencia:
;
; 	1. Pinta scan de Amadeus.
; 	2. Sitúa en el siguiente Scan.
; 	3. Pinta cortina.
; 	4. DELAY.
; 	5. Borra cortina.

	push iy
	pop de

	ld b,16

4 push bc
	push hl
	ld b,2

5 ld a,(de)
	ld (hl),a

	inc l
	inc e

	djnz 5B

	inc e
	pop hl
	call NextScan

	ld a,$58
	cp h
	jr z,6F

; 	Pinta scan.

	call Borra_pinta_scan

	ld bc,$2000
	call DELAY

	call Borra_pinta_scan

	pop bc
	djnz 4B

; -----------------------------------------------------------

; 	Rayo de salida por la parte derecha de la pantalla.

; 	Situamos HL en la VRAM donde vamos a iniciar el rayo.

6 call PreviousScan
	call PreviousScan

	inc l
	inc l

	push hl

	ld d,0
	ld a,l

	call Pinta_rayo

	pop hl
	ld a,l

	call Pinta_rayo

; 	Borra Amadeus para enlazar con el pintado del Nivel.

;	Preparamos datos de entrada para hacer llamada a [Pinta_Sprites].
;
;	DE contiene Scanlines_album.
;	HL contiene (Puntero_objeto).

	ld de,Amadeus_scanlines_album

	push iy
	pop hl 															; (Puntero_objeto) en HL.

	ld c,%01000101 													; (Attr).

	call Pinta_Sprites

	ret

;	 Subrutinas ------------------------------------------------

Borra_pinta_scan ld b,2

1 ld a,$ff
	xor (hl)
	ld (hl),a

	inc l
	djnz 1B

	dec l
	dec l

	ret

;	-----------------------------

Pinta_rayo cp d
	ret z

	ld bc,$0b00
	call DELAY

	ld a,(hl)
	xor $ff
	ld (hl),a
	inc l
	ld a,l
	jr Pinta_rayo
