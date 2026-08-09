Enable_Print_DONE:

	ld a,(Ctrl_1)
	set 0,a
	ld (Ctrl_1),a

	ret

; ------------------------------------------------------------------------
;
;	30/4/26
;
;	Pantalla de nueva "Max. puntuación", si la puntuación máxima ha sido superada nos pedirá nombre, en caso_
;	_contrario volvemos al menú principal como un pardillo.

Enter_name_screen:

	di
	
;	En primer lugar comparamos la máxima puntuación almacenada con la puntuación actual.

	ld hl, (Score_hex_max)
	ld de, (Score_hex)

	and a
	sbc hl,de

	call c, New_max_score

;	Inicializamos nueva partida:

Init_New_Game:

	call Clean_boxes_and_albums
	call Inicializa_Variables_DRAW
	call Clean_and_initcialize_Draw1

	ret

New_max_score:

	ex de,hl

	ld (Score_hex_max),hl 						; we´ve a new max.score.

	call Clean_and_logo
	call New_best_msg

; 	Reutilizamos variables para evitar la repetición de teclas.
;
;	Coordenada_X
;	Coordenada_y

	ld hl,Coordenada_X
	ld (hl),a
	inc hl
	ld (hl),8

	ld hl,Ctrl_7
	res 0,(hl) 									; Restoring the bit is necessary to avoid being returned by the routine [Carrusell].

	ld hl,Ctrl_6
	set 3,(hl) 									; Activamos este bit para asegurarnos de SALIR de la rutina de interrupciones en cuanto entremos.

	call Clean_champions_name

	push hl
	call Carrusell
	pop hl

	res 3,(hl)

	ld bc,$ffff
	call DELAY

	ret

; ------------------------------------------------------------------------
;
;	19/6/26
;
;	Imprime la pantalla de felicitaciones con la puntuación máxima. Recoge e imprime el nombre del nuevo champion.

Carrusell:

;	El formato: FBPPPIII (Flash, Brillo, Papel, Tinta).
;
;	COLORES: 0 ..... NEGRO
;    		 1 ..... AZUL
; 			 2 ..... ROJO
;			 3 ..... MAGENTA
; 			 4 ..... VERDE
; 			 5 ..... CIAN
;			 6 ..... AMARILLO
; 			 7 ..... BLANCO
;
;			$4049 - $4057


	ld c,$41 								; attrs. Arrancamos con: - BRIGHT, PAPER BLACK, INK BLUE -.
3 ld hl,$5829                             	; Dirección inicial de atributos de pantalla, (esquina superior izquierda de la nave).
	ld b,$0f								; N° de columnas que tiene el logo.

2 ei
	halt

	di

	call Colorea_columna_logo

	inc l 									; Sitúa en siguiente columna.

;	Temporización:

;	Tiempo que tardamos en modificar los attrs. de la siguiente columna.

	call Enter_name

	ld a,(Ctrl_7)
	bit 0,a
	ret nz

	djnz 2B 								; Siguiente columna.

;	Todo el logo pintado con los attrs., (c).

	inc c 									; New color.

	bit 3,c 								; Ya hemos pintado de blanco ???, si es así repetimos la secuencia.
	jr z,3B

	jr Carrusell

; ------------------------------------------------------------------------
;
;	19/6/26
;
;	Colorea una de las 15 columnas que tiene el logo "Amadeus".

Colorea_columna_logo:

	push hl
	push bc

	ld b,3 									; 3 Files.

1 ld a,l
	add 32
	ld l,a 									; Situamos HL en la siguiente fila, (dirección de atributos de pantalla).

	ld (hl),c
	djnz 1B

	pop bc
	pop hl

	ret

; ------------------------------------------------------------------------
;
;	30/11/25
;
;	Repone attrs. de las dos últimas líneas de pantalla.

Replace_Amadeus_attr_zone:

	ld a,%01000101 											; ($45). Bright, Black paper, Cyan ink.
	ld b,64
	ld hl,$5ac0

1 ld (hl),a
	inc l
	djnz 1B

	ret

; ------------------------------------------------------------------------
;
;	30/11/25
;
;	Genera estrellas en pantalla.

make_stars:

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
;	19/7/25
;
;	Imprime en pantalla la imagen del logo principal.

Imprime_Logo_principal:

;	Datos.

	ld hl,Direccion_Logo_principal 									; $4049,$404a,$404b ..... $5849,$584a,$584b
;																	; $4069,$406a,$406b
; 																	; $4089,$408a,$408b

	ld de,Logo_nave													; (3x24)

	ld a,%01000101													; Attr. en A. --- Bright, black paper, ink cyan.
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

;																	; $406c, $406d, $406e ..... $586c
;																	; $408c, $408d, $408e

	ld a,%01000101													; Attr. en A. --- Bright, black paper, ink cyan.
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

;								 									; $404f,$4050,$4051 ..... $584f,$5850,$5851
;																	; $406f,$4070,$4071
; 																	; $408f,$4090,$4091

	ld de,logo_ad													; (3x24)

	ld a,%01000101													; Attr. en A. --- Bright, black paper, ink cyan.
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

;																	; $4072, $4073, $4074 ..... $5872, ...
;																	; $4092, $4093, $4094

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

;																	; $4075, $4076, $4077 ..... $5875, ...
;																	; $4095, $4096, $4097

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


Transicion_de_salida:

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
;	29/4/26
;
;	Activa FLAG (GAME OVER), "reutilizamos" el .defw (Entidad_sospechosa_de_colision) como contador de 16 bits.
;	Lo utilizaremos como temporizador. Determina el tiempo que aparece el msg. "GAME OVER" en pantalla.

game_over:

	ld hl,Ctrl_5
	set 6,(hl)

	ld hl,$0150
	ld (Entidad_sospechosa_de_colision),hl

	ret

; ------------------------------------------------------------------------

Dispara_salida_de_amadeus:


;	DONE msg, (Print & clear message).

	ld a,(Ctrl_2)
	bit 6,a
	ret nz															;	RET si ya se ha disparado la salida de Amadeus.

	ld a,(Shield)
	and a
	ret nz

	ld a,70 														; 	Tiempo que queremos que tarde el mensaje DONE en aparecer.

	ld hl,Temp_Amadeus_exit
	dec (hl) 														;	Inicialmente 60d

	cp (hl)

	push hl
	call z,Enable_Print_DONE
	pop hl

	inc (hl)
	dec (hl)

	ret nz

	ld hl,Ctrl_2
	set 6,(hl)														;	Bit 6 de Ctrl_2 indica que hemos iniciado la "Transición: nivel superado".

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

;	Indicamos "Rayo de entrada".

	ld a,(Ctrl_5)
	set 7,a
	ld (Ctrl_5),a

; 	Pintamos el rayo.

	call Construye_rayo

2 dec l
	dec l

	ld d,l

	dec e

	jr nz,3B 														;	Borramos el rayo de inicio.

; 	Hemos pintado y borrado el Rayo inicial.

;	Cargamos en (Sound) el siguiente efecto a ejecutar:

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


	pop bc

	ld a,$58
	cp h
	jr z,6F

	push bc

; 	Pinta scan.

	call Borra_pinta_scan

; Efecto Soldadura

	push hl

	ld bc,$01d0 								; B="1" efecto ruido. / C contiene el nº de ondas del sonido a ejecutar.

	call Sound_Generator

	pop hl

	call Borra_pinta_scan

	pop bc

	djnz 4B

; -----------------------------------------------------------

; 	Rayo de salida por la parte derecha de la pantalla.

; 	Situamos HL en la VRAM donde vamos a iniciar el rayo.

;	Indicamos "Rayo de salida".

6 push hl

	pop hl

	ld a,(Ctrl_5)
	res 7,a
	ld (Ctrl_5),a

	call PreviousScan
	call PreviousScan

	inc l
	inc l

	push hl

	ld d,0
	ld a,l

	call Construye_rayo

	pop hl
	ld a,l

	call Construye_rayo

; 	Borra Amadeus para enlazar con el pintado del Nivel.

;	Preparamos datos de entrada para hacer llamada a [Pinta_Sprites].
;
;	DE contiene Scanlines_album.
;	HL contiene (Puntero_objeto).

	ld de,Amadeus_scanlines_album

	push iy
	pop hl 															; (Puntero_objeto) en HL.

	ld c,%01000101 													; (Attr).

	ld a,(Columnas)

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
;
;	27/01/26

;	INPUT: A contiene (CTRL_5). El bit 7 de A nos indica, (si está a "1" que el sonido es ascendente); "0" descendente.

Construye_rayo cp d 												; Ha llegado el rayo a (p.imp.amadeus) + 2 ???
	ret z

;	Prepara INPUTS para generar efecto de sonido del rayo.

	push hl
	push de

;	Tipo de efecto y características:

	ld hl,(Laser_sound)
	ld (Sound),hl 													; Laser.
	ld bc,5															; Nº de ondas completas a ejecutar.
	ld d,1 															; Efecto ascendente por defecto.
	ld e,1 															; Nº de incrementos/decrementos que aplicaremos al delay antes de salir.

	ld a,(Ctrl_5)
	bit 7,a
	jr nz,Ejecuta_efecto

	dec d 															; El rayo está saliendo de la pantalla. Modificamos a efecto descendente.

Ejecuta_efecto 

	call Sound_Generator

	ld (Laser_sound),hl

	pop de
	pop hl

Pinta_rayo

	ld a,(hl)
	xor $ff
	ld (hl),a
	inc l
	ld a,l
	jr Construye_rayo
