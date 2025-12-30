; ------------------------------------------------------------------------
;
;	30/11/25
;
;	Genera estrellas en pantalla.

make_stars:

;	Genera 7 nº aleatorios.

	ld bc,$0705										 	; Generamos 7 nº aleatorios.

3 push bc

	ld hl,Numeros_aleatorios 								; Dirección de mem. donde almacenamos los nº RND.
	call Derivando_RND 										; Rutina de generación de nº aleatorios.

;	Datos iniciales.

2 ld b,6 													; nº de estrellas.
	ld hl,Numeros_aleatorios
	ld de,$4080												; A partir de esta dirección se pueden generar estrellas.

1 push bc
	push hl

;	Extraemos nº de 16 bits, ($0000 - $1fff).

	ld c,(hl)
	inc l
	ld a,(hl)
	and $1f
	ld b,a

;	Construimos dirección aleatoria de pantalla:

	ld l,c
	ld h,b

	adc hl,de 												; Dirección aleatoria de pantalla en HL.

;	Está dentro de los límites??

	ld a,$57
	sub h
	jr nc,4F

;	La dirección de pantalla supera los límites.

	ld h,d

	push af

	ld a,l
	cp e
	jr nc,5F

	ld h,$48

5 pop af

6 inc h
	inc a
	jr nz,6B

;		Las estrellas se pintarán a partir de la 4ª fila del 1er tercio de pantalla, ($4080).
;		$4080 + $177f = $57ff

4 ld a,$10
	ld (hl),a

	pop hl
	inc l
	pop bc
	djnz 1B

	pop bc
	dec c
	ret z

	jr 3B

; ------------------------------------------------------------------------
;
;	27/11/25
;
;	Imprime en pantalla la Luna lunera.

Print_Moon:

	ld hl,$401a
	ld de,$8ef4
	ld a,%01000111
	ld b,6
	ld c,5

	call Pinta_imagen

	ret

; ------------------------------------------------------------------------
;
;	19/7/25
;
;	Imprime en pantalla la imagen del logo principal.

Imprime_Logo_principal

;	Datos.

	ld hl,Direccion_Logo_principal
	ld de,Logo_nave													; (3x24)

	ld a,%01000101													; Attr. en A.
	ld b,3															; Nº de Columnas en B.
	ld c,3															; Nº de Filas en C.

	push hl
	call Pinta_imagen												; Pinta la nave.
	pop hl

;	Calculamos la dirección de pantalla de la siguiente imagen que forma el logo. ""ma"".

	ld a,l
	add $20
	ld l,a															; Sitúa en Fila inferior.

	inc l															; Sitúa en la columna correspondiente.
	inc l
	inc l

;	Datos.

	ld de,Logo_ma													; (3x16)

	ld a,%01000101													; Attr. en A.
	ld b,3															; Nº de Columnas en B.
	ld c,2															; Nº de Filas en C.

	push hl
	call Pinta_imagen												; Pinta "ma".
	pop hl

;	Calculamos la dirección de pantalla de la siguiente imagen que forma el logo. ""ad"".

	ld a,l
	sub $20
	ld l,a															; Sitúa en Fila superior.

	inc l															; Sitúa en la columna correspondiente.
	inc l
	inc l

;	Datos.

	ld de,logo_ad													; (3x24)

	ld a,%01000101													; Attr. en A.
	ld b,3															; Nº de Columnas en B.
	ld c,3															; Nº de Filas en C.

	push hl
	call Pinta_imagen												; Pinta "ad".
	pop hl


;	Calculamos la dirección de pantalla de la siguiente imagen que forma el logo. ""eu"".

	ld a,l
	add $20
	ld l,a															; Sitúa en Fila inferior.

	inc l															; Sitúa en la columna correspondiente.
	inc l
	inc l

;	Datos.

	ld de,logo_eu													; (3x16)

	ld a,%01000101													; Attr. en A.
	ld b,3															; Nº de Columnas en B.
	ld c,2															; Nº de Filas en C.

	push hl
	call Pinta_imagen												; Pinta "eu".
	pop hl

;	Calculamos la dirección de pantalla de la siguiente imagen que forma el logo. ""us"".

	inc l															; Sitúa en la columna correspondiente.
	inc l
	inc l

;	Datos.

	ld de,logo_us													; (3x16)

	ld a,%01000101													; Attr. en A.
	ld b,3															; Nº de Columnas en B.
	ld c,2															; Nº de Filas en C.

	push hl
	call Pinta_imagen												; Pinta "us".
	pop hl

	ret

; ------------------------------------------------------------------------
;
;	24/10/25
;
;	Nivel superado.
;
;	Descripción de la animación:
;
;	Amadeus va desapareciendo scan a scan por la parte baja de la pantalla.

; 	Nota: Cuando se inicia el proceso de desaparición de Amadeus, se imprimirá nuestra nave en pantalla en cada FRAME, (aunque no haya movimiento).
;	Bit 5 (Ctrl_3) a "1".

;	INPUTS: IX contiene (Puntero_de_impresion).
; 			DE contiene (Puntero_objeto).
;			HL contiene (Album_de_pintado_Amadeus).

;	Se ha iniciado el proceso de Transición de salida de Amadeus ???.


Transicion_de_salida

;	Temporizador

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
;	2/12/25
;
;	Activa FLAG (GAME OVER) y ajusta el temporizador (GAME OVER), para ello "reutilizamos": (Temp_new_live).

game_over:

	ld hl,Ctrl_5
	set 6,(hl)

	ld a,200 														;	Tiempo que tarda en comenzar la secuencia: GAME OVER.
	ld (Temp_new_live),a

	ret

; ------------------------------------------------------------------------

Dispara_salida_de_amadeus:

	ld hl,Temp_Amadeus_exit
	dec (hl)
	ret nz

	ld hl,Ctrl_2
	set 6,(hl)														;	Bit 6 de Ctrl_2 indica que hemos iniciado la "Transicion_de_salida" de Amadeus.

	ret

; ------------------------------------------------------------------------
;
;	28/06/25
;
;	Descripción de la animación:
;
;	Un rayo que arranca desde el lado izquierdo de la pantalla va dibujando nuestra nave, scan a scan.
;	El rayo desaparece por la parte derecha de la pantalla.

Transicion_de_entrada:

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

2 dec l
	dec l

	ld d,l

	dec e

	jr nz,3B 														;	Borramos el rayo de inicio.

; 	Hemos pintado y borrado el Rayo inicial.

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

Pinta_rayo cp d 													; Ha llegado el rayo a (p.imp.amadeus) + 2 ???
	ret z

	ld bc,$0b00
	call DELAY

	ld a,(hl)
	xor $ff
	ld (hl),a
	inc l
	ld a,l
	jr Pinta_rayo
