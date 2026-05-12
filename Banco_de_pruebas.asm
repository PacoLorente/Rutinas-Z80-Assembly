
	DEVICE ZXSPECTRUM48

	include "Macros_y_herramientas.asm"

;	Reloj del juego. IM2 *******************************************************************************************************************************************************************
;
;	13/08/24
;
;	
	org $feff		;$fcff        													; (Debajo de la pila).

	defw $8310															; Indica al vector de interrupciones, (IM2), que el clock del programa se encuentra en $82a0.

;
;	12/10/24
;
; 	Constantes de programa.
;

;	Filas de pantalla. 													; Utilizaremos estas constantes para colocar el texto en pantalla.

Line_0 equ $4000
Line_1 equ Line_0 + $20
Line_2 equ Line_1 + $20
Line_3 equ Line_2 + $20
Line_4 equ Line_3 + $20
Line_5 equ Line_4 + $20
Line_6 equ Line_5 + $20
Line_7 equ Line_6 + $20

Line_8 equ $4800
Line_9 equ Line_8 + $20
Line_10 equ Line_9 + $20
Line_11 equ Line_10 + $20
Line_12 equ Line_11 + $20
Line_13 equ Line_12 + $20
Line_14 equ Line_13 + $20
Line_15 equ Line_14 + $20

Line_16 equ $5000
Line_17 equ Line_16 + $20
Line_18 equ Line_17 + $20
Line_19 equ Line_18 + $20
Line_20 equ Line_19 + $20
Line_21 equ Line_20 + $20
Line_22 equ Line_21 + $20
Line_23 equ Line_22 + $20

ROM_ASCII equ $3c00 													; A esta dirección de memoria sumaremos el código ASCII correspondiente para situarnos en los 8 bytes que forman el char.
KEY_SCAN equ $028e

FRAMES equ $5c78														; Variable de 24 bits. Almacena el nº de cuadros, (frames) que llevamos construidos. Reloj en tiempo real.
FRAMES_3 equ $5c7a

Direccion_Logo_principal equ $4049
Sprite_vacio equ $82f0													; 48 Bytes de "0".

;	Vidas y escudos:

Vida_1 equ $4001														; Dirección de pantalla donde se pintan los escudos.
Vida_2 equ $4003
Vida_3 equ $4006

Escudo_1 equ $4041														; Dirección de pantalla donde se pintan las vidas.
Escudo_2 equ $4043
Escudo_3 equ $4046

;	Contador de entidades:

Decenas_cont_ent equ $400b

Decenas_cont_ent_1 equ Decenas_cont_ent + 256
Decenas_cont_ent_2 equ Decenas_cont_ent_1 + 256
Decenas_cont_ent_3 equ Decenas_cont_ent_2 + 256
Decenas_cont_ent_4 equ Decenas_cont_ent_3 + 256
Decenas_cont_ent_5 equ Decenas_cont_ent_4 + 256
Decenas_cont_ent_6 equ Decenas_cont_ent_5 + 256
Decenas_cont_ent_7 equ Decenas_cont_ent_6 + 256

Decenas_cont_ent_8 equ Decenas_cont_ent + 32

Decenas_cont_ent_9 equ Decenas_cont_ent_8 + 256
Decenas_cont_ent_10 equ Decenas_cont_ent_9 + 256
Decenas_cont_ent_11 equ Decenas_cont_ent_10 + 256
Decenas_cont_ent_12 equ Decenas_cont_ent_11 + 256
Decenas_cont_ent_13 equ Decenas_cont_ent_12 + 256
Decenas_cont_ent_14 equ Decenas_cont_ent_13 + 256
Decenas_cont_ent_15 equ Decenas_cont_ent_14 + 256

Decenas_cont_ent_16 equ Decenas_cont_ent_8 + 32

Decenas_cont_ent_17 equ Decenas_cont_ent_16 + 256
Decenas_cont_ent_18 equ Decenas_cont_ent_17 + 256
Decenas_cont_ent_19 equ Decenas_cont_ent_18 + 256
Decenas_cont_ent_20 equ Decenas_cont_ent_19 + 256
Decenas_cont_ent_21 equ Decenas_cont_ent_20 + 256
Decenas_cont_ent_22 equ Decenas_cont_ent_21 + 256
Decenas_cont_ent_23 equ Decenas_cont_ent_22 + 256

; ----- ----- ----- ----- ----- ----- ----- -----

Unidades_cont_ent equ $400d									;$4010

Unidades_cont_ent_1 equ Unidades_cont_ent + 256
Unidades_cont_ent_2 equ Unidades_cont_ent_1 + 256
Unidades_cont_ent_3 equ Unidades_cont_ent_2 + 256
Unidades_cont_ent_4 equ Unidades_cont_ent_3 + 256
Unidades_cont_ent_5 equ Unidades_cont_ent_4 + 256
Unidades_cont_ent_6 equ Unidades_cont_ent_5 + 256
Unidades_cont_ent_7 equ Unidades_cont_ent_6 + 256

Unidades_cont_ent_8 equ Unidades_cont_ent + 32

Unidades_cont_ent_9 equ Unidades_cont_ent_8 + 256
Unidades_cont_ent_10 equ Unidades_cont_ent_9 + 256
Unidades_cont_ent_11 equ Unidades_cont_ent_10 + 256
Unidades_cont_ent_12 equ Unidades_cont_ent_11 + 256
Unidades_cont_ent_13 equ Unidades_cont_ent_12 + 256
Unidades_cont_ent_14 equ Unidades_cont_ent_13 + 256
Unidades_cont_ent_15 equ Unidades_cont_ent_14 + 256

Unidades_cont_ent_16 equ Unidades_cont_ent_8 + 32

Unidades_cont_ent_17 equ Unidades_cont_ent_16 + 256
Unidades_cont_ent_18 equ Unidades_cont_ent_17 + 256
Unidades_cont_ent_19 equ Unidades_cont_ent_18 + 256
Unidades_cont_ent_20 equ Unidades_cont_ent_19 + 256
Unidades_cont_ent_21 equ Unidades_cont_ent_20 + 256
Unidades_cont_ent_22 equ Unidades_cont_ent_21 + 256
Unidades_cont_ent_23 equ Unidades_cont_ent_22 + 256

; ----- ----- ----- ----- ----- ----- ----- -----

; SCORE:

; Direcciones de memoria ROM. Datos que forman los dígitos decimales del Spectrum.

Cero_Score equ $3d80
Uno_Score equ $3d88
Dos_Score equ $3d90
Tres_Score equ $3d98
Cuatro_Score equ $3da0
Cinco_Score equ $3da8
Seis_Score equ $3db0
Siete_Score equ $3db8
Ocho_Score equ $3dc0
Nueve_Score equ $3dc8

Unidades_Score equ $4057							;$405e

Unidades_Score_1 equ Unidades_Score + 256
Unidades_Score_2 equ Unidades_Score_1 + 256
Unidades_Score_3 equ Unidades_Score_2 + 256
Unidades_Score_4 equ Unidades_Score_3 + 256
Unidades_Score_5 equ Unidades_Score_4 + 256
Unidades_Score_6 equ Unidades_Score_5 + 256
Unidades_Score_7 equ Unidades_Score_6 + 256

Decenas_Score equ Unidades_Score - 1

Decenas_Score_1 equ Decenas_Score + 256
Decenas_Score_2 equ Decenas_Score_1 + 256
Decenas_Score_3 equ Decenas_Score_2 + 256
Decenas_Score_4 equ Decenas_Score_3 + 256
Decenas_Score_5 equ Decenas_Score_4 + 256
Decenas_Score_6 equ Decenas_Score_5 + 256
Decenas_Score_7 equ Decenas_Score_6 + 256

Centenas_Score equ Decenas_Score - 1

Centenas_Score_1 equ Centenas_Score + 256
Centenas_Score_2 equ Centenas_Score_1 + 256
Centenas_Score_3 equ Centenas_Score_2 + 256
Centenas_Score_4 equ Centenas_Score_3 + 256
Centenas_Score_5 equ Centenas_Score_4 + 256
Centenas_Score_6 equ Centenas_Score_5 + 256
Centenas_Score_7 equ Centenas_Score_6 + 256

Unidades_de_millar_Score equ Centenas_Score - 1

Unidades_de_millar_Score_1 equ Unidades_de_millar_Score + 256
Unidades_de_millar_Score_2 equ Unidades_de_millar_Score_1 + 256
Unidades_de_millar_Score_3 equ Unidades_de_millar_Score_2 + 256
Unidades_de_millar_Score_4 equ Unidades_de_millar_Score_3 + 256
Unidades_de_millar_Score_5 equ Unidades_de_millar_Score_4 + 256
Unidades_de_millar_Score_6 equ Unidades_de_millar_Score_5 + 256
Unidades_de_millar_Score_7 equ Unidades_de_millar_Score_6 + 256

Decenas_de_millar_Score equ Unidades_de_millar_Score - 1

Decenas_de_millar_Score_1 equ Decenas_de_millar_Score + 256
Decenas_de_millar_Score_2 equ Decenas_de_millar_Score_1 + 256
Decenas_de_millar_Score_3 equ Decenas_de_millar_Score_2 + 256
Decenas_de_millar_Score_4 equ Decenas_de_millar_Score_3 + 256
Decenas_de_millar_Score_5 equ Decenas_de_millar_Score_4 + 256
Decenas_de_millar_Score_6 equ Decenas_de_millar_Score_5 + 256
Decenas_de_millar_Score_7 equ Decenas_de_millar_Score_6 + 256

; ----- ----- ----- ----- ----- ----- ----- -----

Primer_scan_de_pantalla equ $4120										; Cuando (Puntero_de_impresion) se encuentra por debajo de esta dirección se generan "0" scanlines.
Almacen_de_movimientos_masticados_Amadeus equ $c800 					; ($c800 - $c9e3), 483 bytes. $1e3. Movimientos masticados de Amadeus.

; Scanlines_album. 

; 35 bytes por entidad, (7 entidades). 

; 1. 2 Bytes ..... .defw  Puntero_objeto, (mem. address donde se encuentran los .db que forman los distintos sprites).
; 2. 1 Byte ..... .db  Indica el nº de scanlines que vamos a imprimir del sprite. Generalmente 16 scanlines.
; El nº de scanlines será menor cuando estemos `desapareciendo? por la parte baja de la pantalla.					 	
; 3. 32 Bytes, (como máximo). Screen mem. address de cada uno de los scanlines que forman el sprite.

Scanlines_album equ $8000	                    ;	($8000 - $8118) 	; Inicialmente 280 bytes, $118.
Scanlines_album_2 equ $811a	                    ;   ($811a - $8232)

Amadeus_scanlines_album equ $8234	            ;	($8234 - $8256) 	; Inicialmente 34 bytes, $22.
Amadeus_scanlines_album_2 equ $8258	            ;	($8258 - $827a)

Amadeus_disparos_scanlines_album equ $827c	    ;	($827c - $8281) 	; 6 Bytes, (1 único disparo).
Amadeus_disparos_scanlines_album_2 equ $8282	;	($8284 - $8289)

Entidades_disparos_scanlines_album equ $8288	;	($8288 - $82b9)		; 49 bytes, (7 disparos, 7 bytes cada uno), $31. 
Entidades_disparos_scanlines_album_2 equ $82bb	;	($82bb - $82ec)     Burst

;	Atributos de la luna.

Attr_Moon_File4 equ $587a
Attr_Moon_File4_2 equ $587c
Attr_Moon_File4_3 equ $587e

Attr_Moon_File5 equ $589a
Attr_Moon_File5_2 equ $589c
Attr_Moon_File5_3 equ $589e

;	Sound efects.

Laser_sound_init_value equ $00a0	
Shield_sound_init_value equ $00c0
Shot_sound_init_value equ $1801
Burst_sound_init_value equ $3500				;	Longitud de la explosión de las entidades, (duración).	
Amadeus_Burst_sound_init_value equ $7000		;	Longitud de la explosión de Amadeus, (duración).

;	Mensajes de texto.

Fila_msg_de_nivel equ Line_9 + 6	;	Los mensajes de nivel se imprimen en la fila 9, columna 6, (antes del centrado).

;	Datos fijos de los álbumes de líneas de Amadeus:

	org Amadeus_scanlines_album

	db $00,$00,$10
	db $00,$50
	db $00,$51
	db $00,$52
	db $00,$53
	db $00,$54
	db $00,$55
	db $00,$56
	db $00,$57

	db $00,$50
	db $00,$51
	db $00,$52
	db $00,$53
	db $00,$54
	db $00,$55
	db $00,$56
	db $00,$57

	org Amadeus_scanlines_album_2

	db $00,$00,$10
	db $00,$50
	db $00,$51
	db $00,$52
	db $00,$53
	db $00,$54
	db $00,$55
	db $00,$56
	db $00,$57

	db $00,$50
	db $00,$51
	db $00,$52
	db $00,$53
	db $00,$54
	db $00,$55
	db $00,$56
	db $00,$57

;	Reloj del juego. IM2 ---------------------------------------------------------------------------------------------------------------------------------------------------
;
;	13/08/24
;
	org $8310

	push af
	push hl

;	BC contiene el tiempo de un semiciclo, (tiempo que tiene que estar el beeper activado/desactivado antes de cambiar_
;	_de estado).

 ;	-------------------- STOP si no hemos terminado de construir el FRAME.
	ld hl,Ctrl_3				
	bit 0,(hl)
	jr z,$
;	--------------------

; 	Disparos.

	call Pinta_disparos_Amadeus
	call Pinta_disparos_Entidades

;	Sprites.

	call Actualiza_pantalla

; 	Actualiza marcadores.

	ld hl,Ctrl_2
	bit 7,(hl)
	call nz,Borra_escudo

	ld hl,Ctrl_4
	bit 6,(hl)
	call nz,Borra_vida

	call Print_enemy_counter

	ld a,(Score_Ctrl) 													;	Sólo se imprime el marcador Score cuando este se incrementa.
	and a
	call nz, Print_Score_Counter

; Actualiza variables Shield ----------------------- ----------------------- ------------------------  

Temporizacion_shield 

	ld hl,Shield
	ld a,(hl)
	and a
	jr z,Incrementa_FRAMES												;	No hay escudo. Se agotó el tiempo Shield.

	dec (hl)															;	Decrementa tiempo Shield, (Shield).
	inc hl

	dec (hl)															;	Decrementa temporizador de estados, (Shield_2).
	jr nz,Incrementa_FRAMES

															
Cambio_de_estado      													; 	El temporizador de estados a llegado a "0". HL apunta a (Shield_2).

;	Indica cambio de estado.

	inc hl																;	Sitúa en (Shield_3).
	bit 3,(hl)
	jr z,2F	

	call Inicia_Shield

	call Play_Shield_sound_effect

	ld a,(Shield)
	and a
	jr nz,Incrementa_FRAMES

	ld hl,0
	ld (Sound),hl

	jr Incrementa_FRAMES

2 rlc (hl)																; 	Sitúa en (Shield_3) y rotamos bit. (Indica cambio de comportamiento).

	ld hl,(Puntero_datos_shield) 										;	Carga en (Shield_2) la siguiente temporización.
	inc hl
	ld (Puntero_datos_shield),hl
	ld a,(hl)
	ld (Shield_2),a														;	Iniciamos (Shield_2) con la nueva temporización.

Incrementa_FRAMES

	ld hl,(FRAMES)
	inc hl
	ld (FRAMES),hl

	ld a,h
	or l
	jr nz,1F

	ld hl,FRAMES_3
	inc (hl)

1 push de
	push bc

;	Sound efects

	call Play_burst_sound_effect
	call Play_shot_sound_effect

;	-------------------------------------------------------------
;
;	Repone_Attr_Moon
;
;	Repone los Attr. de la luna, de la zona de vidas y de Amadeus. antes de volcar pantalla, si una entidad sobrevuela sobre ella cambiaría su color.
;
;	MODIFY: HL.

;	Moon.

	ld hl,$4747 													; BRIGHT 1, BLACK paper, WHITE ink

	ld (Attr_Moon_File4),hl
	ld (Attr_Moon_File4_2),hl
	ld (Attr_Moon_File4_3),hl

	ld (Attr_Moon_File5),hl
	ld (Attr_Moon_File5_2),hl
	ld (Attr_Moon_File5_3),hl

	ld hl,Ctrl_6
	res 0,(hl) 														; Inicializa el inhibidor de efectos de sonido.

	ld a,(Ctrl_5)
	bit 6,a
	call nz,Print_Game_Over 										; Imprime "GAME OVER" si LIVES = "0".

	pop bc
	pop de
	pop hl
	pop af

	ei

	ret

;	Free mem. $836c - $83ff ..... $93 / 147d Bytes.

; --------------------------------------------------------------------------------

	include "Sprites_e_indices.asm"
	include "Cajas_y_disparos.asm"
	include "Patrones_de_mov.asm"

; --------------------------------------------------------------------------------
;
; 05/05/26
;
; Parámetros DRAW. 	
;

Bandeja_DRAW: 	; ---------------------------------------------------------------------------------------------------------------------------

Clase db 0  												; A cada entidad se le asigna un nº o (Clase) para poder asignarle una de las 3 Cajas_Master.
; 															; En cada (Nivel) sólo puede haber 3 (Clases) diferentes de entidad pués sólo dispondremos de_
; 															; _tres almacenes de Mov_masticados y 3 Cajas_Master.
; 															; Las entidades de (Clase) 1, 2 y 3 son de (Tipo) 1, (BadSat).

Tipo db 0													; Cada `tipo? de Entidad tiene unas características únicas que lo distinguen de otros tipos.
; 															; Las entidades del mismo (Tipo) comparte el MISMO PATRÓN DE MOVIMIENTO. 															
Coordenada_X db 0 											; Coordenada X del objeto. (En chars.)
Coordenada_y db 0 											; Coordenada Y del objeto. (En chars.)

Contador_de_vueltas db 0									; Contador de vueltas de entidades. Inicialmente su valor es "1". El bit se desplaza una posición_
; 															  _a la izquierda cada vez que la entidaddesaparece por la parte baja de la pantalla.
;															  Esta variable se utiliza para incrementar el perfil de velocidad de las entidades.

; Incrementa el contador de vueltas, (el contador cuenta 4 vueltas máximo).
; El perfil de velocidad de la entidad será: (Contador_de_vueltas)/8.

; Ejemplos:

;	1ª vuelta: (Contador_de_vueltas)="$02" --- (Velocidad)="0".
;	2ª vuelta: 	""	""	""	""	""  ="$04" ---   ""	 ""	  ="1".
;	3ª vuelta: 	""	""	""	""	""  ="$08" ---   ""	 ""	  ="2".
;	4ª vuelta: 	""	""	""	""	""  ="$10" ---   ""	 ""	  ="4".
;	5ª vuelta: 	""	""	""	""	""  ="$20" ---   ""	 ""	  ="8".   

Impacto db 0												; Si después del movimiento de la entidad, (Impacto) se coloca a "1", existen muchas posibilidades de_
;															  _ que esta entidad haya colisionado con Amadeus.
; 																Hay que comprobar la posible colisión después de mover Amadeus. En este caso, (Impacto2)="3".

Puntero_de_impresion defw 0									; Contiene el puntero de impresión, (calculado por DRAW). Esta dirección la utilizará la rutina_
;															; _ [Guarda_coordenadas_X] y [Compara_coordenadas_X] para detectar la colisión ENTIDAD-AMADEUS.

Puntero_de_almacen_de_mov_masticados defw 0

;															; Almacén donde la entidad guía va guardando comportamiento ya calculado, (rutinas DRAW).

Contador_de_mov_masticados defw 0							; Contador de 16 bits. La "Entidad_guía" lo aumenta en una unidad cada vez que hace el "pushado" de las tres_
;															  _palabras que componen el "movimiento_masticado".

; Variables de funcionamiento de las rutinas de movimiento. (Mov_left), (Mov_right), (Mov_up), (Mov_down).

Velocidad db 0 												; 5 vueltas max. 5 vueltas       1 - 0 (1ª vuelta - velocidad 0)
;																					 		 2 - 0 (2ª vuelta - velocidad 0)
;																					 		 4 - 1 (3ª vuelta - velocidad 1)
;																							 8 - 2 (4ª vuelta - velocidad 2)
;																				 		   $10 - 4 (5ª vuelta - velocidad 3)

Attr db 0 													; Atributos de la entidad.

; ----- ----- De aquí para arriba son los datos que se trasfieren a las cajas de entidades. ¡¡¡¡¡



Ctrl_2 db 0
;															BIT 0, Los sprites se inician con un `sprite vacío', (sprite formado por "ceros"), cuando la rutina_
;															_ [Genera_datos_de_impresion] guarda su 1ª imagen.
;															_ Más adelante las rutinas [Mov_left] y [Mov_right] restauraran (Puntero_objeto). Si el 1er movimiento
; 															_ que hace la entidad después de iniciarse es hacia arriba/abajo no se restaurará (Puntero_objeto), pués_
; 															_ las rutinas [Mov_up] y [Mov_down] no necesitan modificar el sprite.
;															_ El bit5 a "1" nos indica que el sprite se inicia por arriba o por abajo y por lo tanto hay que restaurar_
;															_ (Puntero_objeto) con (Repone_puntero_objeto) una vez iniciado y realizada su 1ª `foto'.
;														
;															BIT 1, Este bit a "1" indica que se ha iniciado el proceso de EXPLOSIÓN en una entidad.
;															BIT 2, Este bit es activado por [Movimiento]. Indica que hemos `iniciado un desplazamiento'._
;															_ Evita que volvamos a iniciar el desplazamiento cada vez que ejecutemos [Movimiento].
;															BIT 3, Indica que (Cola_de_desplazamiento)="254". Esto quiere decir que repetiremos (1-255 veces),_
;															_ el último MOVIMIENTO que hayamos ejecutado.
;															BIT 4, ???
;															BIT 5, Este bit a "1" indica que esta entidad es una "Entidad_guía".
;															BIT 6, Habilita la transición: "Salida de Amadeus" por la parte baja de la pantalla cuando completamos un nivel.
;																   La rutina [Dispara_salida_de_amadeus] pone este bit a "1" tras imprimir el msg. "DONE".
;															BIT 7, "1" Detecta que hemos pulsado "SHIELD". ; "El reloj de juego, (IM2)", borrara un escudo siempre que este FLAG esté a "1".
;															- La rutina [Borra_escudo], inicializará el FLAG.

Ctrl_0 db 0 												; Byte de control. A través de este byte de control. Las rutinas de desplazamiento: [Mov_right], [Mov_left], [Mov_up] y [Mov_down],_
;															; _indican a las subrutinas de recolocación del objeto de la rutina [DRAW]: [Comprueba_limite_horizontal] y [Comprueba_limite_vertical],_
; 															; _que desaparecemos por un extremo de la pantalla y hemos de `reaparecer? por el contrario.
; 															; Este dato es necesario debido a que las rutinas de recolocación, están ideadas para recolocar el puntero (Posicion_actual), cuando pasamos_
; 															; _de un cuadrante a otro de la pantalla pero no preveen la `desaparición? por un extremo del cuadrante y la `reaparición? por el otro.
;
; 															DESCRIPCIÖN:
;
; 															SET 0, [Reaparece_derecha]. El bit 0 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_left] detecta que el objeto ha `desaparecido? por el_
; 															_lado izquierdo de la pantalla y ha de `reaparecer? por el derecho. ([Comprueba_limite_vertical]).
; 															SET 1, [Reaparece_izquierda]. El bit 1 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_right] detecta que el objeto ha `desaparecido? por el_
; 															_lado derecho de la pantalla y ha de `reaparecer? por el izquierdo. ([Comprueba_limite_vertical]).
; 															SET 2, [Reaparece_abajo]. El bit 2 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_up] detecta que el objeto ha `desaparecido? por la_
; 															_parte superior de la pantalla y ha de `reaparecer? por el inferior. ([Comprueba_limite_horizontal]).
; 															SET 3, [Reaparece_arriba]. El bit 3 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_down] detecta que el objeto ha `desaparecido? por la_
; 															_parte inferior de la pantalla y ha de `reaparecer? por la superior. ([Comprueba_limite_horizontal]).
; 															SET 4, El Bit4 a "1", indica que hubo movimiento de la entidad. Necesitamos esta información
;												            _para "NO BORRAR/PINTAR" en objeto si NO hubo MOVIMIENTO.
;															SET 5, La rutina [Inicializacion] de Draw_XOR.asm, pone este bit a "1". Con esta información evitamos ejecutar las
;															_rutinas: (Comprueba_limite_horizontal) y (Comprueba_limite_vertical) justo después de `inicializar? un objeto.
; 															SET 6, Está a "1" si el Sprite que tenemos cargado en el `Engine? es AMADEUS.
;
; 															SET 7, El bit 7 se encuentra alto, ("1"), cuando el último movimiento horizontal se ha producido a la "DERECHA".
; 															_ Utilizo la información que proporciona este BIT para modificar (CTRL_DESPLZ) si el siguiente movimiento_
; 															_ se va a producir a la izquierda. "1" DERECHA - "0" IZQUIERDA.

Filas db 0												    ; Filas. [DRAW]. - 2ª Funcion tras haber generado los movimientos masticados: 
;															; Almacena un bit que iremos alternando: "0" a "1" mediante una función XOR. Se utiliza para cambiar los attr. de la explosión de las entidades,_ 
;															; _rojo - amarillo. 

Columns db 0 												; Nº de columnas. [DRAW]. - 2ª Funcion tras haber generado los movimientos masticados: 
;															; Almacena un bit que iremos alternando: "0" a "1" mediante una función XOR. Se utiliza para cambiar los attr. de la explosión de Amadeus, (rojo - amarillo). 														

Posicion_actual defw 0										; Dirección actual del Sprite. [DRAW]
Puntero_objeto defw 0										; Donde están los datos para pintar el Sprite.

; ---------- ---------- ---------- ---------;      ;--------- ---------- ---------- ---------- 

CTRL_DESPLZ db 0											; Este byte nos indica la posición que tiene el Sprite dentro del mapa de desplazamientos.
;															; Una vez construidos los movimientos masticados del nivel esta variable:
;
;															; Almacena un contador de scanlines que se utiliza para hacer desaparecer Amadeus por la parte baja de la pantalla.

; ---------- ---------- ---------- ---------;      ;--------- ---------- ---------- ---------- 

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


Indice_Sprite_der defw 0
Indice_Sprite_izq defw 0
Puntero_DESPLZ_der defw 0
Puntero_DESPLZ_izq defw 0
Posicion_inicio defw 0										; Dirección de pantalla donde aparece el objeto. [DRAW]. 

Cuad_objeto db 0											; Almacena el cuadrante de pantalla donde se encuentra el objeto, (1,2,3,4). [DRAW]
;															; 2ª FUNCIÓN: Temporizador, define la velocidad de la animación de Amadeus por la parte_
;															; _baja de la pantalla cuando hemos superado el nivel.

Columnas db 0
Limite_vertical db 0 										; Nº de columna. Si el objeto llega a esta columna se modifica (Posicion_actual) para poder asignar un nuevo (Cuad_objeto).
;															; 2ª Función de (Limite_vertical):
;															; Se inicializa a "0" cada vez que ejecutamos el bucle de entidades. Se utiliza como contador; se incrementa (+1) cada vez que se añade una_
;															; _descripción a la (Tabla_de_pintado). Este valor lo utiliza la rutina [Ordena_tabla_de_pintado] para ordenar la tabla antes de imprimir.



; Variables de control general.

Frames_explosion db 0 										; Nº de Frames que tiene la explosión.

; Variables de funcionamiento, (No incluidas en base de datos de entidades), a partir de aquí!!!!!

Perfiles_de_velocidad

Vel_left db 0 												; Velocidad izquierda. Nº de píxeles que desplazamos el objeto a izquierda. 1, 2, 4 u 8 px.
Vel_right db 0 												; Velocidad derecha. Nº de píxeles que desplazamos el objeto a derecha. 1, 2, 4 u 8 px.
Vel_up db 0 												; Velocidad subida. Nº de píxeles que desplazamos el objeto hacia arriba. (De 1 a 7px).
Vel_down db 0 												; Velocidad bajada. Nº de píxeles que desplazamos el objeto hacia abajo. (De 1 a 7px).

; Movimiento. ------------------------------------------------------------------------------------------------------

Puntero_tabla_Random defw 0
Puntero_indice_mov defw 0									; Puntero índice del patrón de movimiento de la entidad. "0" No hay movimiento.
Puntero_mov defw 0											; Guarda la posición de memoria en la que nos encontramos dentro de la cadena de movimiento.
Puntero_indice_mov_bucle defw 0							 
;														
;                   									
Incrementa_puntero db 0										; Byte que iremos sumando a (Puntero_indice_mov) para ir escalando por las_
;															; _ distintas cadenas de movimiento del índice de movimiento de la entidad._
;															; Va aumentando su valor en saltos de 2 uds, (0,2,4,6,8).

Incrementa_puntero_backup db 0
Repetimos_desplazamiento db 0								; El nibble bajo del 3er byte que compone un desplazamiento, indica el nº de veces que_
;															; repetimos dicho desplazamiento. Ese valor se almacena en esta variable, ($1-$f). NUNCA SERÁ "0".

Repetimos_desplazamiento_backup db 0						; Restaura (Repetimos_desplazamiento) cuando este llega a "0".
Repetimos_movimiento db 0									; Byte que indica el nº de veces que repetimos el último MOVIMIENTO.
Cola_de_desplazamiento db 0									; Este byte indica:

;
;															;	"$00" ..... Hemos finalizado la cadena de movimiento.
;															;				En este caso hemos de incrementar (Puntero_indice_mov)_
;															;				_ y pasar a la siguiente cadena de movimiento del índice.
;
;															;	"$01 - "$fe" ..... Repetición del movimiento.
;															;						Nº de veces que vamos a repetir el movimiento completo.
;															;						En este caso, volveremos a inicializar (Puntero_mov),_
;															;						_ con (Puntero_indice_mov) y decrementaremos (Cola_de_desplazamiento).
;				
;															;	"$ff" ..... Bucle infinito de repetición.
;															;				Nunca vamos a saltar a la siguiente cadena de movimiento del índice,_
;															;				,_ (si es que la hay). Volvemos a inicializar (Puntero_mov) con (Puntero_indice_mov).

Ctrl_1 db 0 												; Byte de control de propósito general.

;																DESCRIPCIÓN:
;
;															BIT 0, La rutina de generación de disparos, [Genera_disparo], pone este bit a "1" para indicar a la_
;															_ rutina [Genera_datos_de_impresion] que los datos a guardar pertenecen a un disparo y no a una entidad,_
;															_ por lo tanto hemos de almacenarlos en `Scanlines_album_disparos? en lugar de `Scanlines_album?.
;															BIT 1, Este bit indica que el disparo sale de la pantalla, ($4000-$57ff).
;															BIT 2, Este bit a "1" indica que un disparo de Amadeus ha alcanzado a una entidad. Como no sabemos cual,_
;															_ hemos de comparar las coordenadas de (Coordenadas_disparo_certero) con las de cada entidad.

;															BIT 3, Recarga de nueva oleada.
;															BIT 4, Recarga de nueva oleada.
;															BIT 5, FREEEEEEEEE !!!!!!!!!!!!!!!!!
;															BIT 6, **** Frame completo.
;															BIT 7, Indica que ya está tomada la foto de Amadeus. No tomaremos otra hasta el próximo FRAME.

Repone_puntero_objeto defw 0								; Almacena (Puntero_objeto). Cuando el Sprite se inicia por arriba o por abajo,_
; 															; _ hay que sustituirlo por un `sprite vacío' para que no se vea el 1er o último scanline.
; 															; _ Cuando hemos terminado de iniciarlo y guardado su foto, hemos de recuperar su (Puntero_objeto).
;															; (Repone_puntero_objeto) es una copia de respaldo de (Puntero_objeto) y su función es restaurarlo.
;
;															; 2ª Función:
;
;															; La rutina [Genera_cabecera] almacena la dirección del álbum de scanlines donde se inicia la cabecera para posteriormente_
;															; _guardar esta dirección en la (Tabla_de_pintado).

; Gestión de ENTIDADES y CAJAS.

Puntero_store_caja defw 0
Puntero_restore_caja defw 0
Indice_restore_caja defw 0
Puntero_indice_master defw 0

Numero_de_entidades db 0									; Nº total de entidades maliciosas que contiene el nivel.
Numero_parcial_de_entidades db 0							; Nº de cajas que contiene un bloque de entidades. (7 Cajas).
Entidades_en_curso db 0										; Entidades en pantalla.

Puntero_indice_ENTIDADES defw 0 							; Se desplazará por el índice de entidades para `meterlas' en cajas.
Datos_de_entidad defw 0										; Contiene los bytes de información de la entidad hacia la que apunta el
;															; _ puntero (Indice_entidades).

;---------------------------------------------------------------------------------------------------------------
;
;	13/10/24
;
;	Álbumes.

Stack defw 0 												; La rutinas de pintado, utilizan esta_
;															; _variable para almacenar lo posición del puntero_
; 															; _de pila, SP.
Stack_2 defw 0												; 2º variable destinada a almacenar el puntero de pila, SP.
;															; La utiliza la rutina [Extrae_foto_registros].

; Impresión. ----------------------------------------------------------------------------------------------------

Album_de_pintado defw 0
Album_de_borrado defw 0
Album_de_pintado_Amadeus defw 0
Album_de_borrado_Amadeus defw 0

Album_de_pintado_disparos_Amadeus defw 0
Album_de_borrado_disparos_Amadeus defw 0

Album_de_pintado_disparos_Entidades defw 0
Album_de_borrado_disparos_Entidades defw 0


Nivel_scan_disparos_album_de_pintado defw 0

Num_de_bytes_album_de_disparos db 0
Num_de_bytes_album_de_disparos_borrado db 0

Numero_de_disparos_de_entidades db 7

Permiso_de_disparo_Amadeus db 0								; "0" Permite disparo.
Permiso_de_disparo_Entidades db 0							; A "1", se puede generar disparo.

Techo_Scanlines_album defw 0
Techo_Scanlines_album_2 defw 0
Switch db 0
Techo defw 0
Scanlines_album_SP defw 0
India_SP defw Tabla_de_pintado 
India_2_SP defw 0
India_3_SP defw Tabla_de_borrado

Ctrl_3 db 0													; 2º Byte de Ctrl. general, (no específico) a una única entidad.
;
;															BIT 0, "1" Indica que el FRAME está completo, (hemos podido hacer la foto de todas las entidades).
;															BIT 1, "1" Indica que hemos completado todo el patrón de movimientos de este tipo de entidad.
;																_ El almacén de movimientos masticados de este tipo de entidad quedará completo. ([Inicia_entidad]).
;															BIT 2, "1" Indica que se produce movimiento en alguna entidad, (modificamos el último FRAME impreso en pantalla).
;																Habilita el borrado/pintado de sprites.
;															BIT 3, "1" Este bit lo coloca a "1" la rutina [Borra_diferencia] para indicar que hemos actualizado el (Techo_de_pintado)_
;																_ a la baja. 
; 															BIT 4, "1" Indica que hemos terminado de ordenar la Tabla_de_pintado. Podremos salir así de la rutina [Ordena_tabla_de_impresion].
;															BIT 5, "1" Indica que existe movimiento de Amadeus.
;															BIT 6, "1" Indica que Amadeus ha sido destruido. Este bit lo activa la rutina [Genera_explosion_Amadeus] despues de pintar_
; 																_ el último frame de la explosión de nuestra nave.
;															BIT 7, "1" Indica que se ha iniciado el proceso de explosión en Amadeus.
;																_ Mientras este bit este activo, no se generarán dos explosiones de entidades a la vez.

Ctrl_4 db 0													; 4º Byte de Ctrl. general, (no específico) a una única entidad.
;
;															BIT 0, "1" Cada vez que se incrementan las entidades en curso, este bit se pone a "1". Esto hará que una entidad pase de "dormida" a "activa".
;															BIT 1, (INVESTIGAR !!!)
;															BIT 2, -------------------------------------------
;															BIT 3, "1" Indica que se ha asignado un color RND a la entidad. 
; 																   _evita que se vuelva a asignar un nuevo color en la `segunda vuelta lenta?.
; 															BIT 4, "1" Indica que necesitamos 3 Filas de atributos para colorear esta entidad.
;															BIT 5, "1" Indica que ha terminado la transición de salida de Amadeus por la parte baja de la pantalla.
;															BIT 6, "1" Indica aL reloj IM2 que ha de borrar una vida de la pantalla.
; 															BIT 7, !!! Used !!!. Averiguar para qué.

Ctrl_5 db 0

;															BIT 1, "1" Indica que la entidad en curso es la alcanzada por nuestro disparo. La comparativa entre coordenadas ha sido satisfactoria.
;															BIT	2, "1" Indica que tras consecutivos desplazamientos del disparo hay que modificar el (Puntero_de_impresión) dos posiciones a la derecha.
;															BIT	3, "1" Indica que tras consecutivos desplazamientos del disparo hay que modificar el (Puntero_de_impresión) dos posiciones a la izquierda.								
;															BIT 4, ?????
;															BIT 5, "1" Indica: NIVEL SUPERADO !!!.
;															BIT 6, "1" Indica: GAME OVER !!!.
;															BIT 7, "1" Indica a la rutina de sonido que hemos de generar un efecto ascendente; (estamos pintando el rayo de entrada de la transición de entrada). 

Ctrl_6 db 0 												

;															BIT 0, "1" Activa el inhibidor de efectos de sonido. No se ejecutará [Play_burst_sound_effect], tampoco [Play_shot_sound_effect]_
; 																   _si está señal está activa.	
; 															BIT 1, "1" Este bit es activado por la rutina [Press_START] cuando el temporizador (Start_counter) llega a "0".
; 																   El bit indica a la rutina principal START: que ha de volver a mostrar el menú principal.
; 																   El submenú CONTROLS se muestra en pantalla un tiempo definido por (Start_counter), pasado este tiempo_
;																   _la rutina activa `este bit´ y sale de la rutina. El menú está así diseñado para poder DEFINIR los controles si los
; 																   _actuales no nos agradan. 
; 															BIT 2, "1" Indica que vamos a utilizar el Kempston Joystick para jugar.
; 																   Este bit lo activa la rutina de teclado: [Active_kempstom_joystick] y su función es evitar_
; 																   _que la rutina [Press_START] escanee el teclado esperando disparo para comenzar la partida.


Puntero_DESPLZ_DISPARO_ENTIDADES defw 0
Puntero_de_impresion_disparo_de_entidad defw 0				; Guardaremos aquí la dirección de pantalla del último scanline de la entidad en curso.
Impacto2 db 0												; Byte de control de impactos.

;
;															; bit_2. La rutina [Genera_coordenadas_X] coloca este bit a "1" para indicar que hay una posible colisión entre una entidad y Amadeus.
;															; Una de la entidades ha entrado en zona de Amadeus y alguna de sus columnas coincide con las de nuestra nave.
;															; El bit indica que hay que ejecutar [Detecta_colision_nave_entidad] al principio de [Main], (Construcción del frame).
;															; bit_3. La rutina [Genera_coordenadas_de_disparo_Amadeus] pone este bit a "1" para indicar que un disparo de Amadeus ha alcanzado a una entidad.

Entidad_sospechosa_de_colision defw 0						; Almacena la dirección de memoria donde se encuentra el .db_
;															; _(Impacto) de la entidad que ocupa el mismo espacio que Amadeus.
;															; Necesitaremos poner a "0" este .db en el caso de que finalmente no se produzca colisión.

Coordenadas_disparo_certero ds 2							; Almacenamos aquí las coordenadas del disparo que alcanza a una entidad, (Fila, Columna).
;											           		; (Coordenadas_disparo_certero)=Y ..... (Coordenadas_disparo_certero +1)=X.
Coordenadas_X_Entidad ds 3  								; 3 Bytes reservados para almacenar las 3 posibles columnas_
;															; _ que puede ocupar el sprite de una entidad. (Colisión).
Coordenadas_X_Amadeus ds 3									; 3 Bytes reservados para almacenar las 3 posibles columnas_
;															; _ que puede ocupar el sprite de Amadeus. (Colisión).

;---------------------------------------------------------------------------------------------------------------

; Relojes y temporizaciones.

Clock_explosion db 4										; Temporización de las explosiones, (velocidad de la explosión).
Clock_explosion_Amadeus db 5
Temp_new_live db 100										; Tiempo que tarda en aparecer una nueva nave Amadeus tras ser destruida.

RND_SP defw Numeros_aleatorios								; Puntero que se irá desplazando por el SET de nº aleatorios.
Puntero_num_aleatorios_disparos defw Numeros_aleatorios		; Puntero que se irá desplazando por el SET de nº aleatorios, (para generar disparos de entidades).
Numero_rnd_disparos db 0

Clock_next_entity db 0										; Transcurrido este tiempo aparece una nueva entidad.
Repone_CLOCK_disparos db $a0								; Reloj decreciente.
CLOCK_disparos_de_entidades db $a0

Start_counter defw 0 										; Temporizador. Espera la pulsación de "FIRE" en los menús KEYBOARD y KEMPSTON. 
Start_counter_2 db $05 										; 2º Temporizador, (3 bytes counter). Espera la pulsación "FIRE" en el menú KEMPSTON.

;---------------------------------------------------------------------------------------------------------------

; Gestión de NIVELES.

Nivel db 0													; Nivel actual del juego.
Puntero_indice_NIVELES defw Indice_de_niveles
Puntero_indice_de_almacenes defw Almacen_de_movimientos_masticados_1					
																				
Puntero_de_entidades defw 0									; Este puntero se va desplazando por los distintos bytes_
; 															; _ que definen el NIVEL.
Puntero_de_mensajes_de_niveles defw Msg_level_index 		; Inicialmente apunta al mensaje del nivel 1.

; ---------------------------------------------------------------------------------------------------------------

; Temporizaciones Shield.

Lives db 3 																
Shields db 3 												; Nº de Shields

; Temporizaciones Shield.

Datos_Shield db 4,1,4,1										; Tiempos. (Frecuencia del parpadeo de Amadeus).
Puntero_datos_shield defw 0									; Señala distintos tiempos para introducirlos en (Shield_2).
Shield db 100												; Temporización principal. Indica el tiempo que el escudo está activo. No hay escudo cuando (Shield)="0".
Shield_2 db 0 												; Estado Shield, (tiempo encendido - tiempo apagado - tiempo encendido - tiempo apagado). 4,1,4,1.
Shield_3 db 0

; HUB

Puntero_de_escudos defw Indice_de_escudos					; Ambos punteros se inician al comienzo de su respectivos índices.
Puntero_de_vidas defw Indice_de_vidas

Entidades_BCD_unidades db 0
Entidades_BCD_decenas db 0

Puntero_unidades_grandes defw 0
Puntero_decenas_grandes defw 0

Attr_big_counter db %01000110

; SCORE:

Score_hex defw 0
Score_hex_max defw 0

Score_BCD_unidades db 0
Score_BCD_decenas db 0
Score_BCD_centenas db 0
Score_BCD_unidades_de_millar db 0
Score_BCD_decenas_de_millar db 0

Puntero_de_unidades_Score defw Cero_Score
Puntero_de_decenas_Score defw Cero_Score
Puntero_de_centenas_Score defw Cero_Score
Puntero_de_um_Score defw Cero_Score
Puntero_de_dm_Score defw Cero_Score

Score_Ctrl db 0 											; Byte de control. Se utiliza para no mostrar todos los dígitos de Score.
; 															; Se irán imprimiendo dñigitos conforme la puntuación vaya creciendo.

Primer_scan_Amadeus defw $50cf

; Sounds:

Sound defw 0												; Esta variable almacenará el efecto de sonido a reproducir, (disparo, explosión, etc).
Sound_type db 0 											; Le dice a la rutina [Genera_sonido] el tipo de sonido que va a ejecutar.
Laser_sound defw Laser_sound_init_value
Shot_sound defw 0
Burst_sound defw 0
Shield_sound defw 0

; Varios:

Max_time_to_appear_entities db 0 							; Valor máximo que tarda una entidad en aparecer en pantalla.
Decrease_top_time_entities db 0 							; Cada vez que aparece una nueva entidad decrementa (Max_time_to_appear_entities) con el valor de esta variable.
Min_time_to_appear_entities db 0							;   ""  mínimo  "	 "	  "		"	 "		"	 "	    "   .
Temp_Amadeus_exit db 80										; Temporiza la secuencia de: "SALIDA DE AMADEUS", NIVEL SUPERADO.

Tabla_de_conversion_KEYCODE_ASCII_CODE

    defm "B"
    defm "H"
    defm "Y"
    defm "6"
    defm "5"
    defm "T"
    defm "G"
    defm "V"

    defm "N"
    defm "J"
    defm "U"
    defm "7"
    defm "4"
    defm "R"
    defm "F"
    defm "C"

    defm "M"
    defm "K"
    defm "I"
    defm "8"
    defm "3"
    defm "E"
    defm "D"
    defm "X"

    db $18													; SYMBOL SHIFT no dispone de código ASCII.
    defm "L"
    defm "O"
    defm "9"
    defm "2"
    defm "W"
    defm "S"
    defm "Z"

    db $20 													; SPACE ASCII CODE.
    db $21 													; ENTER ASCII CODE.
    defm "P"
    defm "0"
    defm "1"
    defm "Q"
    defm "A"
	db $27 													; CAPS SHIFT no dispone de código ASCII.

; Mensajes:

Keyboard defm "KEYBOARD",0
Kempstom defm "KEMPSTON",0
Interface defm "SINCLAIR",0
Define defm "DEFINE",0
Start defm "START",0
Top_score defm "BEST SCORE: ",0
Done defm "DONE",0
Game_Over defm "GAME OVER",0

; Msg_keyboard_menu, show CONTROLS.

a0 defm "Press ",0
a1 defm " or ",0
a2 defm " to move ",0
a3 defm " LEFT and RIGHT.",0
a4 defm " to FIRE and ",0
a5 defm "to SHIELD.",0
a6 defm "Press FIRE to START",0
a7 defm "CONTROLS:",0
a8 defm "                 ",0
;a9 defm "New Best Score!",0
;a10 defm "Enter your name",0

; DEFINE MENU.

b0 defm "DEFINE CONTROLS",0
b1 defm "LEFT",0
b2 defm "RIGHT",0
b3 defm "FIRE",0
b4 defm "SHIELD",0

; Special keys:

Symbol_key defm "SYMB.",0
Space_key defm "SPACE",0
Enter_key defm "ENTER",0
Caps_key defm "CAPS.",0

; Control de Amadeus, (KEY CODES).

No_repeat_key_code db 0

Move_LEFT db $24
Move_RIGHT db $1c
Move_FIRE db $04
Move_SHIELD db $20

Move_LEFT_ASCII_CODE db "1"
	ds 5
Move_RIGHT_ASCII_CODE db "2"
	ds 5
Move_FIRE_ASCII_CODE db "5"
	ds 5
Move_SHIELD_ASCII_CODE db " "
	ds 5

; Key code BOX.
; Almacenamos los Key_Code que tenemos configurados para el control con KEYBOARD para introducir los correspondientes al control con joystick SINCLAR.
; Si volvemos al menú principal recuperaremos los Key codes KEYBOARD.

Sinclair_db_box ds 4
Desplazamiento_level_msg db 0
Counter_msg_char db 0


; 	INICIO  *************************************************************************************************************************************************************************
;
;	19/7/25

START:

	ld sp,0													; Situamos el inicio de Stack.
	ld a,$fe 												; IM2 ON. Vector de interrupciones a $fcff, (defw debajo de la pila).
	ld i,a 													; Byte alto de la dirección donde se encuentra el vector de interrupciones.
	IM 2 											   		; Habilitamos el modo 2 de INTERRUPCIONES.

	di

Main_menu:

	call Clean_and_logo
	call Print_Main_menu
	call Main_menu_key										; Bucle cerrado de escaneo del teclado buscando: "K", "E" y "D".

	ld a,(Ctrl_6)
	bit 1,a
	jr nz,Main_menu 										; No hemos pulsado "FIRE" en los menús: Keyboard y Kempston. Pasado un tiempo, 

INICIALIZACION:

;	Marcadores. -------------------------------------

	ld a,%01000101											; Fondo NEGRO, tinta Cyan + bright.
	call Cls

;	Imprime escudos y vidas.

	call Pinta_Vida
	call Pinta_Vida
	call Pinta_Vida

	call Pinta_Escudo
	call Pinta_Escudo
	call Pinta_Escudo

;	Imprime SCORE:

	call Imprime_SCORE

;	Make Stars & moon.

	call Print_Moon
	call make_stars

Init_level:

;	Inicia los álbumes de líneas. -----------------------------------------------------------------------------------------

	call Inicia_albumes_de_lineas
	call Inicia_albumes_de_lineas_Amadeus
	call Inicia_albumes_de_disparos

;	Make 7 rnd numbers.

	ld b,7										 			; Generamos 7 nº aleatorios.
	ld hl,Numeros_aleatorios 								; Dirección de mem. donde almacenamos los nº RND.
	call Derivando_RND

	call Extrae_numero_aleatorio_y_avanza
	ld (Clock_next_entity),a 								; El 1er nº aleatorio define cuando aparece la 1ª entidad en pantalla.

;	Inicia el 1er nivel del juego. ------------------------------------------------------------------------------------------

	call Inicializa_Nivel

;	Imprime Contador de entidades.

	push hl
	call Print_enemy_counter

;	Imprime Puntuación.

	push bc
	call Print_Score_Counter

	ld bc,$ffff
    call DELAY
	ld bc,$afff
    call DELAY

;	Imprime mensaje de nivel.

	call Print_level_msg

	pop bc
	pop hl

;	Prepara cajas.

	call Prepara_Cajas_Master	 							; Generamos las distintas coreografías de la entidades que componen el nivel. También se inicializan las cajas "Master".
	call Prepara_Cajas_de_Entidades

;	Inicia Amadeus. -----------------------------------------------------------------------------------------------------------

	call Inicia_Amadeus
;														 	; La rutina [Genera_datos_de_impresion] habilita las interrupciones antes del RET.
;														 	; DI nos asegura que no vamos a ejecutar FRAME hasta que no tengamos todas las entidades iniciadas.
;														 	; La rutina [Genera_datos_de_impresion] activa las interrupciones antes del RET.
	ld de,Amadeus_BOX
	call Parametros_de_bandeja_DRAW_a_Caja_Master	 		; Volcamos Amadeus en (Amadeus_BOX).

;	Limpiamos la bandeja DRAW.

	ld hl,Clase
	ld bc,37
	call Clean_mem

; 	Situamos a Amadeus en el centro de la pantalla.

	ld b,60
2 call Amadeus_a_izquierda
	djnz 2B

	call Genera_datos_de_impresion_Amadeus

;! ------------------

	call Inicia_punteros_de_cajas						 	; Situa (Puntero_store_caja) en el 1er .db de la 1ª caja del índice de entidades.
	call Inicia_Shield

	ld hl,(Scanlines_album_SP)
	ld (Techo_Scanlines_album),hl

	ld hl,(Album_de_borrado)
	ld (Scanlines_album_SP),hl

	ld hl,Tabla_de_pintado
	ld (India_SP),hl

	ld hl,Ctrl_3
	set 0,(hl) 												; Indica Frame completo.
	set 2,(hl)
	set 5,(hl)												; Imprimimos Amadeus.

	call Clear_level_msg

;	Transicion_de_entrada

	call Transicion_de_entrada

;	Borramos el mensaje de nivel.

	ld a,4
	ld (Cuad_objeto),a 										; Retardo, (transición de salida de Amadeus cuando superamos un nivel).

	ei

	halt

; ------------------------------------
;
;	02/12/25

Main: 

	ld hl,Ctrl_4
	bit 5,(hl)
	jp nz,Next_level 										; Nivel Superado !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; 	Gestión de disparos.

	call Change_Disparos									; Intercambiamos los álbumes de disparos.
	call Motor_de_disparos_entidades
	call Motor_Disparos_Amadeus								; Mueve y detecta colisión de los disparos de Amadeus.

; 	En el FRAME que acabamos de pintar puede existir una posible colisión entre alguna entidad y Amadeus.
; 	Si alguna de las coordenadas_X de alguna entidad que esté en zona de Amadeus coincide con alguna de las coordenadas_X de Amadeus, habrá que comprobar si existe colisión.
; 	Este hecho lo indica el bit2 de (Impacto2).

	call Detecta_colision_nave_entidad 						; La rutina verifica la colisión entre una entidad y Amadeus, (RES 2 Impacto2).

; 	TEMPORIZACIONES !!!!!!!!!!!!!!!!

	ld a,(Permiso_de_disparo_Amadeus)
	and a
	jr z,8F

	dec a
	ld (Permiso_de_disparo_Amadeus),a

8 ld hl,CLOCK_disparos_de_entidades
	dec (hl)

;>  *****************************************************************************
;>	*****************************************************************************
;>	***** Comentando la siguiente línea eliminamos los disparos de las entidades.
	call z,Autoriza_disparo_de_entidades
;>  *****************************************************************************
;>	*****************************************************************************

;	(Clock_next_entity) contiene un nº de 16 bits. El 1er nº aleatorio de los 7 generados define su valor inicial, ($0000 - $00ff).
;	Si en el FRAME anterior hemos eliminado a una entidad, programamos la salida de una nueva entidad para dentro de 0,8 segundos.

; 	GESTIÓN DE ENTIDADES.

;	Si aún quedan entidades por aparecer del bloque de entidades, (4 cajas), incrementaremos (Entidades_en_curso) y calcularemos_
;	_ (Clock_next_entity) para la siguiente entidad.

;	--- Numero_de_entidades db 0							; Nº total de entidades maliciosas que contiene el nivel.
; 	--- Numero_parcial_de_entidades db 5					; Nº de cajas que contiene un bloque de entidades. (5 Cajas).
; 	--- Entidades_en_curso db 0								; Entidades en pantalla.

	ld hl,Numero_parcial_de_entidades
	ld b,(hl)

; ----------------------------------------------------------------

	ld a,(Entidades_en_curso)									; Entidades que hay en pantalla.
	cp b
	jr z,1F

	ld a,(FRAMES)
	ld b,a
	ld a,(Clock_next_entity)
	sub b
	jr nz,1F

; - Define el tiempo que ha de transcurrir para que aparezca la siguiente entidad. ----------------------------

	call Extrae_numero_aleatorio_y_avanza 					; A contiene un nº aleatorio (0-255). De 0 a 5 segundos, aproximadamente.
	call Define_Clock_next_entity

;	Incrementamos (Entidades_en_curso) y DEC (Numero_parcial_de_entidades) y (Numero_de_entidades).

	ld hl,Entidades_en_curso
	inc (hl)

	ld hl,Ctrl_4
	set 0,(hl)												; Permiso para activar a una entidad "dormida".

1 ld a,(Entidades_en_curso)
	and a
	jp z,Gestion_de_Amadeus									; Si no hay entidades en curso saltamos a [Avanza_puntero_de_Scanlines_album_de_entidades].

	ld b,a													; No hay entidades que gestionar.

; ( Código que ejecutamos con cada entidad: ).

; --------------------------------------- GESTIÓN DE ENTIDADES. !!!!!!!!!!

	ld hl,Tabla_de_pintado 									; Inicializa `Tabla_de_pintado?.
	ld (India_SP),hl

	ld hl,Ctrl_3 											; Indica que se produce movimiento.
	set 2,(hl)

	call Change 											; Intercambio `Album_de_pintado - Album_de_borrado?.
;															; `Album_de_pintado' pasa a ser ahora `Album_de_borrado' y_
;	 														; _viceversa.
	xor a
	ld (Limite_vertical),a 									; Inicializa el contador de entidades "visibles" en pantalla, (se cargan en la Tabla_de_pintado).

Bucle_de_entidades:

	push bc 												; Nº de entidades en curso.

;	En primer lugar vamos a crear un puntero para ir almacenando las columnas de las distintas unidades.
;	Utilizamos (Puntero_indice_mov) como puntero e Indice_Sprite_der como primer .db de almacenamiento.

6 ld ix,(Puntero_store_caja)								; A partir de ahora IX apunta al 1er .db (Clase) de la entidad, (caja de entidades correspondiente).
	call Salta_caja_de_entidades_vacia

; Esta caja contiene datos. Es una entidad "dormida"???. Si no es así gestionamos esta entidad, (jr 5F).

	ld a,(ix+1) 
	bit 7,a 
	jr z,5F

; Esta entidad esta "dormida", tenemos permiso para despertarla. ???

	ld hl,Ctrl_4
	bit 0,(hl)
	call z,Incrementa_punteros_de_cajas 					; Si no tenemos permiso para despertarla saltaremos a la siguiente entidad activa.

	jr z,6B 

	res 0,(hl)												; Restaura bit "despertador".
	res 7,a
	ld (ix+1),a												; Convierte esta entidad dormilona en una entidad ACTIVA.

; En 1er lugar, ... existe (Impacto) de un disparo de Amadeus en esta entidad ???
; Si es así, comprobamos si es la entidad en curso la alcanzada por nuestro disparo. 

5 ld a,(Impacto2)
	bit 3,a
	call nz,Compara_con_coordenadas_de_disparo

; Existe colisión en esta entidad por un disparo de Amadeus ???

	ld a,(ix+5)												; (ix+5) - (Impacto)
	bit 1,a
	call nz,Genera_explosion
	jr nz,Gestiona_siguiente_entidad

	ld a,(ix+5)												; ld a,(Impacto)
	and a
	jr z,3F

; IMPACTO en entidad por colisión con Amadeus.

; 5/7/24
; Nota importante: 
; Dos entidades pueden chocar entre ellas en zona de Amadeus. La rutina [Detecta_colision_nave_entidad] comprobará si existe colisión con la última entidad gestionada, (colisionada) y _
;	_en caso de no existir colisión pondrá su .db (Impacto) a "0" pero esa 1ª entidad "colisionada" seguirá manteniendo su .db (Impacto) a "1" por lo que para considerarse "colisión",_
;	_es requisito imprescindible que Amadeus tenga su .db (Impacto) también a "1"; en caso contrario colocaremos el .db (Impacto) de la entidad a "0" para que se vuelva a gestionar.

	ld a,(Impacto_Amadeus)
	and a
	call nz,Genera_explosion
	jr nz,Gestiona_siguiente_entidad

; 	Falsa colisión !!!
	
	ld (Impacto),a											; Colocamos el .db (Impacto) de la entidad en curso a "0".

; -------------------------------------------
 
; 	Movement !!!

3 call Ajusta_velocidad_entidad								; Ajusta el perfil de velocidad de la entidad en función de (Contader_de_vueltas).
	call Scanlines_generator

; -------------------------------------------

;	TODO: Generamos disparo ???

	ld a,(Permiso_de_disparo_Entidades)
	and a
	call nz,Entidad_genera_disparo_si_procede

4 call Colision_Entidad_Amadeus								; Si hay posibilidad de COLISION, set 2,(Impacto2) y (Impacto) de entidad en curso a "1".

Gestiona_siguiente_entidad
 
	call Incrementa_punteros_de_cajas

	pop bc

	dec b
	jp nz,Bucle_de_entidades

	ld hl,Impacto2 											; Inicializamos el FLAG de impacto.
	res 3,(hl)

; 	Hemos gestionado todas las entidades.					--------------------------------------------------------------------------------------------------

	call Inicializa_India_y_limpia_Tabla_de_impresion 		; Inicializa el puntero (India_SP) y sanea la (Tabla_para_ordenar_entidades_antes_de_pintar).
	call Ordena_tabla_de_pintado
	call Inicia_punteros_de_cajas 							; Hemos terminado de mover todas las entidades. Nos situamos al principio del índice de entidades.

	call Borra_diferencia

	ld a,(Ctrl_3)
	bit 3,a
	jr nz,Gestion_de_Amadeus

	ex de,hl
	ld (hl),c
	inc l
	ld (hl),b												; Nuevo techo, mayor que el anterior.

;	! GESTIONA AMADEUS !!!!!!!!!!

Gestion_de_Amadeus:

	ld hl,Ctrl_5
	bit 6,(hl)
	jr z,7F

;	El bit 6 de (Ctrl_5) indica que la partida ha terminado. Ahora el .defw (Entidad_sospechosa_de_colision) es un temporizador_
;	_de 16 bits que determina cuanto tiempo va a estar el mensaje "GAME OVER" en pantalla.

;	GAME OVER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	ld hl,(Entidad_sospechosa_de_colision)
	dec hl

	ld a,h
	or l
	call z,Enter_name_screen
	jp z,Main_menu

	ld (Entidad_sospechosa_de_colision),hl
	jr End_frame

7 ld hl,Ctrl_3
	bit 6,(hl)
	jr z,Amadeus_vivo

; 	Amadeus ha sido destruido.
; 	Decrementa (Temp_new_live).

	ld hl,Temp_new_live
	dec (hl)
	jr nz,End_frame

; 	Una vida menos. Reinicia Amadeus, reinicia Shield. (aparece nueva nave).

	ld hl,Lives
	dec (hl)
	call z,game_over
	jr z,End_frame

New_Amadeus:

	call Reinicia_Amadeus
	jr End_frame

; 	Hay Impacto???, Existe movimiento???, Disparamos???, Pausamos el juego???

Amadeus_vivo:

	ld a,(Impacto_Amadeus)
	and a
	call nz,Genera_explosion_Amadeus
	jr nz,End_frame

	ld a,(Numero_parcial_de_entidades)
	and a
	call z,Dispara_salida_de_amadeus

;	Control.

	call Main_keyboard_routine
	call Kempston_control


	ld hl,Ctrl_2
	bit 6,(hl)
	jr z,2F

;	Se ha iniciado la salida de Amadeus por la parte baja de la pantalla, NIVEL SUPERADO.

	ld hl,Cuad_objeto                                       ; 2ª Función de (Cuad_objeto).
	dec (hl)												; DEC temporizador, (FRAME rate) de la transición de salida.
	jr nz,2F												; No forzamos la impresión de Amadeus si no ha habido pulsación de teclas.

;	Forzamos la impresión de Amadeus e inicializamos el temporizador.

	ld a,2
	ld (hl),a												; INICIALIZA el temporizador, (FRAME/rate) de la transición de salida.

	ld hl,Ctrl_3
	set 5,(hl)

	jr Vivo_y_coleando

2 ld hl,Ctrl_3
	bit 5,(hl)
	jr z,End_frame											; NO hemos pulsado tecla, NO hay transición.

Vivo_y_coleando

	call Change_Amadeus
	call Genera_datos_de_impresion_Amadeus					; Genera los datos de impresión de la nave.

End_frame:

; 	23/08/24 Llegados a este punto: NO HAY POSIBILIDAD DE GENERAR MÁS DISPAROS.
; 	Generamos los datos de impresión en el álbum_de_pintado y limpiamos el sobrante de datos del anterior FRAME si toca.

	call Genera_datos_de_impresion_disparos_Entidades
	call Genera_datos_de_impresion_disparos_Amadeus			; Genera los datos de impresión de los disparos de Amadeus y entidades.
	call Calcula_bytes_pintado_disparos
	call Limpia_album_de_pintado_disparos_entidades

; ------------ ------------- --------------

	ld hl,(Album_de_borrado)
	ld (Scanlines_album_SP),hl

	ld hl,Tabla_de_borrado
	ld (India_3_SP),hl

	ld hl,Ctrl_3
	set 0,(hl) 												; Indica Frame completo.

	res 3,(hl)
	res 4,(hl)

	ld hl,Ctrl_4
	res 0,(hl)

	xor a
	out ($fe),a

	halt												

	jp Main

; 	------------------------------------------------------------------------
; 	------------------------------------------------------------------------
; 	------------------------------------------------------------------------

; 	----- ----- ----- ----- ----- ----- ----- ----- -----
;
;	24/07/24

Reinicia_Amadeus:

;	Reinicia posición y estado.

	ld hl,$50de
	ld (p.imp.amadeus),hl									; Inicializa el puntero de impresión.
	ld hl,Almacen_de_movimientos_masticados_Amadeus + $f0
	ld (Pamm_Amadeus),hl									; Inicializa el puntero de almacén de movimientos masticados.
	ld hl,$003d
	ld (Comm_Amadeus),hl									; Inicializa el contador de movimientos masticados.
	ld a,%01000101
	ld (Attr_Amadeus),a 									; Tras la explosión volvemos a ser azules.

;	limpiamos el álbum de borrado.

	ld hl,(Album_de_borrado_Amadeus)

	xor a
	ld (hl),a
	inc l
	ld (hl),a

; 	Restauramos el FLAG: Amadeus vivo.

	ld hl,Ctrl_3
	res 6,(hl)

	call Genera_datos_de_impresion_Amadeus

;	Reinicia temporizaciones.

	call Inicia_Shield

	ld a,90
	ld (Shield),a 											; Hemos iniciado SHIELD, inicializamos el temporizador SHIELD.

	ld a,100
	ld (Temp_new_live),a

;	Fuerza la impresión de la nave en el siguiente frame.

	ld hl,Ctrl_3
	set 5,(hl)

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	23/11/24

Ajusta_velocidad_entidad:

	ld a,(ix+12)											; ld a,(Velocidad)
	and a
	ret z 													; En la 1ª vuelta (Contador_de_vueltas) será "1" o "2", dependiendo de si queremos_
	;									  					_ una o dos vueltas "lentas" iniciales. En ambos casos, (Velocidad)="0", pues:
	;									  					_ (Velocidad)=(Contador_de_vueltas)/4.


; Incrementa (Contador_de_vueltas)x2. 
; (Velocidad) de la entidad será: (Contador_de_vueltas)/4.

;	1ª vuelta: (Contador_de_vueltas)="$02" --- (Velocidad)="0".
;	2ª vuelta: 	""	""	""	""	""  ="$04" ---   ""	 ""	  ="1".
;	3ª vuelta: 	""	""	""	""	""  ="$08" ---   ""	 ""	  ="2".
;	4ª vuelta: 	""	""	""	""	""  ="$10" ---   ""	 ""	  ="4".
;	5ª vuelta: 	""	""	""	""	""  ="$20" ---   ""	 ""	  ="8".   

	sla a 													; Multiplica x2 (Velocidad) en cada FRAME.
	ld (ix+12),a											; ld (Velocidad),a
	and $10
	ret z


; Restaura (Velocidad) a razón del nº de vueltas. Se ha superado (Velocidad)x8.

;	Decrementa (Contador_de_mov_masticados), (SI SU CONTENIDO NO ES "0").

	ld l,(ix+10)
	ld h,(ix+11)

	ld a,h
	and a
	jr nz,1F

	inc l
	dec l

	ret z													; RET. Hay que REINICIAR LA ENTIDAD. (Contador_de_mov_masticados) = "0".

1 dec hl

	ld (ix+10),l
	ld (ix+11),h

	ld a,(ix+4)												; ld a,(Contador_de_vueltas)
	sra a
	sra a
	ld (ix+12),a	

	ld l,(ix+8)
	ld h,(ix+9)												; HL contiene (Puntero_de_almacen_de_mov_masticados)

	inc hl
	inc hl
	inc hl
	inc hl

	ld (ix+8),l
	ld (ix+9),h												; (Puntero_de_almacen_de_mov_masticados) actualizado.

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	25/08/24

Change:

	ld a,(Switch)
	xor 1
	ld (Switch),a

	ld hl,(Album_de_pintado)
	ld de,(Album_de_borrado)
	ex de,hl
	ld (Album_de_pintado),hl
	ld (Scanlines_album_SP),hl
	ld (Album_de_borrado),de
	ret

Change_Amadeus:

	ld hl,(Album_de_pintado_Amadeus)
	ld de,(Album_de_borrado_Amadeus)
	ex de,hl
	ld (Album_de_pintado_Amadeus),hl
	ld (Album_de_borrado_Amadeus),de
	ret

Change_Disparos:

; Álbumes de Amadeus.

1 ld hl,(Album_de_pintado_disparos_Amadeus)
	ld de,(Album_de_borrado_disparos_Amadeus)
	ex de,hl
	ld (Album_de_pintado_disparos_Amadeus),hl
	ld (Album_de_borrado_disparos_Amadeus),de
	call Limpia_album_de_pintado_disparos_Amadeus

; Álbumes de entidades.

	ld hl,(Album_de_pintado_disparos_Entidades)
	ld de,(Album_de_borrado_disparos_Entidades)
	ex de,hl
	ld (Album_de_pintado_disparos_Entidades),hl
	ld (Album_de_borrado_disparos_Entidades),de
	ld (Nivel_scan_disparos_album_de_pintado),hl

	ld a,(Num_de_bytes_album_de_disparos)
	ld (Num_de_bytes_album_de_disparos_borrado),a

	ret

; ------------------------------------
;
; 	18/11/25

; 	Fija en A un nº aleatorio comprendido entre 0-255 y desplaza el puntero (RND_SP) al siguiente nº.
; 	Si el puntero está situado en el último nº, lo volvemos a situar al principio.

;	DESTRUYE: HL,DE,A
;	OUTPUTS: A contiene un Nº aleatorio. Actualiza el puntero de nº aleatorios (RND_SP).

;	Variables implicadas: (RND_SP).

Extrae_numero_aleatorio_y_avanza:

	ld hl,Numeros_aleatorios+7
	ex de,hl
	ld hl,(RND_SP)

	ld a,e
	sub l
	jr nz,1F

; Sitúa HL al principio de la tabla de nº aleatorios.

	ld hl,Numeros_aleatorios
	ld (RND_SP),HL

; Coloca el nº aleatorio en A y mueve el puntero al siguiente nº.

1 ld a,(hl)
	inc l
	ld (RND_SP),hl

	ret

; ------------------------------------
;
; 	21/11/25
;
;	INPUTS: A contiene un nº aleatorio comprendido entre ($00 y $ff).
;
;			La rutina sumará este valor a (FRAMES) siendo este nuevo valor el tiempo que tardará en aparecer una nueva entidad, (Clock_next_entity).
;
;			Antes de sumar el valor de (A) a (FRAMES), la rutina "filtra" esa cantidad manteniéndola entre 2 valores:
;			(Max_time_to_appear_entities) ... Valor máximo de tiempo. (A) no podrá superar nunca este valor.
;			(Min_time_to_appear_entities) ... Valor mínimo. (A) no podrá tener un valor más bajo que este.
;
;			Nota: Se puede dar el caso de que (Max_time_to_appear_entities) y (Min_time_to_appear_entities) contengan el mismo valor debido a que_
;				  _la rutina [Decrementa_techo] irá decrementando el valor de (Max_time_to_appear_entities) un nº de unidades definido por:
;				  _(Decrease_top_time_entities) cada vez que eliminamos a una entidad. De esta manera iremos aumentando la dificultad del nivel a_
;				  _medida que transcurre el tiempo.
;
;	OUTPUT: Define (Clock_next_entity).

Define_Clock_next_entity:

	ld hl,Max_time_to_appear_entities  										
	cp (hl)
	ld c,a 												; Nº aleatorio ($00 - $ff) en A.

	jr c,1F

;	Por encima o igual que (Max_time_to_appear_entities).
;	Siempre que el nº aleatorio se encuentra por debajo del límite inferior, decrementamos el límite en 10 unidades.

	ld c,(hl)

;	El nº aleatorio no supera el valor de (Max_time_to_appear_entities).
;	Por debajo del mínimo?, (Min_time_to_appear_entities)??.

1 inc hl
	inc hl

	cp (hl)

	jr nc,2F

;	Por DEBAJO de (Min_time_to_appear_entities).

	ld c,(hl)

2 ld a,(FRAMES)
	add c
	ld (Clock_next_entity),a

	ret

; ------------------------------------
;
; 	18/03/24

Borra_diferencia 

	ld bc,(Scanlines_album_SP)

	ld a,(Switch)
	and a
	jr z,2F

	ld hl,(Techo_Scanlines_album_2)
	ld de,Techo_Scanlines_album_2
	jr 3F

2 ld hl,(Techo_Scanlines_album)
	ld de,Techo_Scanlines_album

; Diferencia. 

3 sbc hl,bc

	ret z
	ret c

; Nuevo techo, (más bajo que el anterior). 
; Fijamos nuevo techo y borramos bytes sobrantes.

	ex de,hl

	ld (hl),c
	inc l
	ld (hl),b

	xor a
	ld b,e

	ld hl,(Scanlines_album_SP)

1 ld (hl),a
	inc hl
	djnz 1B

; Indicamos que tenemos nuevo techo más bajo con el FLAG:

	ld hl,Ctrl_3
	set 3,(hl)

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	28/3/25
;
;	INPUT: IX apunta al 1er .db (Tipo) de la entidad, (caja de entidades correspondiente).	
;
;	Estructura de cada línea en la (Tabla_de_pintado):
;
;	(Columna_Y), (Attr), (Columnas) y .defw (Album_de_pintado).
;	.db, .db, .db, .defw

Entidad_a_Tabla_de_pintado

	ld hl,Limite_vertical
	inc (hl)		 										; (Limite_vertical) actúa ahora como contador de entidades imprimibles.
;                                                           ; El nº de entidades almacenadas en la Tabla_de_pintado lo utilizara [Ordena_tabla_de_impresion] más adelante.
	ld hl,(India_SP) 				 

	ld e,(ix+3)
	ld d,(ix+13)
	ld a,(Columnas)

	ld (hl),e        										; (Columna_Y).
	inc l
	ld (hl),d 		 										; (Attr).
	inc l
	ld (hl),a 		 										; (Columnas).
	inc l

	ld de,(Repone_puntero_objeto)				 			; .defw (Album_de_pintado).

	ld (hl),e   
	inc l
	ld (hl),d 		 
	inc l 			 										; (Album_de_pintado).

	ld (India_SP),hl

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	27/03/24
;
;	Limpia el `resto de la tabla de impresión? y sitúa el puntero de la tabla, (India_SP) al_
;	_comienzo de la misma.


Inicializa_India_y_limpia_Tabla_de_impresion 

	ld hl,(India_SP)
	ld bc,Tabla_de_borrado-1								; Bytes de (Tabla_de_pintado)-1.

	ld a,c
	sub l
	jr z,2F
	ld b,a													; Nº de bytes a limpiar de la tabla. Si la Tabla está completa, omitimos limpiar_
;															; _ y pasamos a inicializar (India_SP).
	xor a

1 ld (hl),a
	inc l
	djnz 1B													; Limpia Tabla.

2 ld hl,Tabla_de_pintado									; Inicializa (India_SP).
	ld (India_SP),hl

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	28/3/25

Ordena_tabla_de_pintado

;	INPUT: HL está situado en el 1er byte de la Tabla de pintado.

	ld a,(Limite_vertical)
	cp 4
	ret c 													; < 4 entidades, no ordenamos la Tabla.

	dec a
	ld c,a 													; (Entidades_en_curso)-1 en C.
	ld d,c 													; Copia de respaldo.

	ld a,(hl)												; Nº de Fila de la 1ª entidad, (1er byte de la tabla).
	ld hl,Tabla_de_pintado+5
	ld b,(hl) 												; Nº de Fila de la 2ª entidad a comparar.

	ld (India_2_SP),hl										; Apunta a la segunda entidad a comparar.

; --- --- --- --- --- --- ---
;
;	Comparador.

1 cp b  				 						

	jr c, Avanza_India_2_SP
	jr z, Avanza_India_2_SP
;
; --- --- --- --- --- --- --- 

	call Trueque

	jr Avanza_India_2_SP

	ret

Avanza_India_2_SP

	dec c
	call z,Avanza_punteros_indios
	ret z 													; Tabla_de_pintado ordenada !!!

	inc l
	inc l
	inc l
	inc l
	inc l

	ld b,(hl)

	ld (India_2_SP),hl 										; Siguiente entidad en la Tabla.

	jr 1B 													; Salta al comparador.

Trueque 

	push de 												; Preservo (Entidades_en_curso)-1.
	push hl													; Preservo (India_2_SP).

;	Intercambia (Fila).

	ld de,(India_SP)
	ex de,hl
	ld (hl),b
	ld (de),a												; Intercambio de Fila, (Coordenada_Y).

	call Intercambia_1_byte 								; Intercambio de Attrs.
	call Intercambia_1_byte									; Intercambio de Columna.

;	Intercambiamos (Scanlines_album) .defw

	call Intercambia_1_byte									; low byte.
	call Intercambia_1_byte									; high byte.

; Volvemos a iniciar A. Vuelve a contener `el nuevo contenido, (Fila), de (India_SP).
; Recuperamos (India_2_SP) en HL.

	ld hl,(India_SP)
	ld a,(hl)

	pop hl
	pop de

	ret

; --------------------------------------------------------------------------------------------------------------
 
Avanza_punteros_indios 

	dec d
	jr z,Prepara_salida

	ld c,d

	ld hl,(India_SP)

	inc l
	inc l
	inc l
	inc l
	inc l

	ld a,(hl)
	ld (India_SP),hl

	ret

Prepara_salida 

	ld hl,Tabla_de_pintado
	ld (India_SP),hl
	xor a

	ret

;	----- ----- ----- ----- -----

Intercambia_1_byte 

	inc l
	inc e

	ld b,(hl)
	ld a,(de)
	ex de,hl
	ld (hl),b
	ld (de),a												; Byte de menor peso de las dos direcciones de memoria, ----- INTERCAMBIADAS -----.

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	17/02/25
;
;	INPUTS: IX contiene (Puntero_de_impresion)
;			IY contiene (Puntero_objeto)

Codifica_Puntero_de_impresion:

	ld a,(Columnas)
	dec a
	jr z,Una_Columna
	dec a
	jr z,Dos_Columnas
	ret

Dos_Columnas 

	ld a,ixh
	set 7,a
	ld ixh,a

;	Si nos encontramos en el lado derecho de la pantalla no modificamos (Puntero_objeto).	

1 ld a,(Cuad_objeto)
	and 1
	ret z

	call Ajusta_Puntero_objeto

	ret

Una_Columna 					

; (Puntero_objeto) en ROM ????

	ld a,ixh
	bit 6,a
	jr nz,2F

; Cuando estamos apareciendo por la izquierda y el objeto está en ROM, IXH ="$f_".

	set 7,a
	set 6,a
	set 4,a

2 set 5,a
	ld ixh,a

	jr 1B

; ----- ----- ----- ----- -----

Ajusta_Puntero_objeto:

	ld a,(Columnas)
	ld b,a
	ld a,(Columns)
	sub b	
	ret z
	ld b,a

1 inc iyl
	djnz 1B	

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	12/1/24
;
;	INPUTS: HL a de contener (Puntero_de_almacen_de_mov_masticados).

Actualiza_Puntero_de_almacen_de_mov_masticados:

	ld hl,(Puntero_de_almacen_de_mov_masticados)
	ld bc,4
	and a
	adc hl,bc
	ld (Puntero_de_almacen_de_mov_masticados),hl
	ret

; ------------------------------------------
;
;	9/8/25
;
;	Extraemos movimiento del (Almacen_de_mov_masticados):
;
;	INPUTS: IX,(Puntero_store_caja). 
;		    (1er .db de la caja de la entidad en curso, (Tipo).)
;
;	OUTPUTS: (Puntero_objeto) en DE.
;	         (Puntero_de_impresion) codificado en BC.
;			 (Puntero_de_almacen_de_mov_masticados) actualizado en su correspondiente caja de entidades.
;
;	MODIFY: A,BC,DE y HL. 


Take_movement:

	ld l,(ix+10)
	ld h,(ix+11)

;	(Contador_de_mov_masticados) en HL.

	ld a,h
	and a
	jr nz,1F

	inc l
	dec l

	call z,Reinicia_entidad_maliciosa

;	El (Contador_de_mov_masticados) no ha llegado a "0". Dec.

1 dec hl

	ld (ix+10),l
	ld (ix+11),h 											; (Contador_de_mov_masticados) actualizado.

	ld l,(ix+8)
	ld h,(ix+9) 											; (Puntero_de_almacen_de_mov_masticados) en HL.

	ld (Stack),sp
	ld sp,hl
	
	xor a
	ld h,a
	ld l,h													; ld hl,"0"

	pop de													; (Puntero_objeto) en DE.
	pop bc													; (Puntero_de_impresion) codificado en BC.

	add hl,sp

	ld (ix+8),l
	ld (ix+9),h												; (Puntero_de_almacen_de_mov_masticados) de la caja de entidades actualizado.

	ld sp,(Stack)

	ret

; Decodificamos (Puntero_de_impresion) para almacenarlo correctamente.

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
;
;	9/8/25
;
;
;	INPUTS: IX apunta al .db de la caja de entidades correspondiente.
;			BC contiene (Puntero_de_impresion) codificado.
;
;	OUTPUT: BC contiene el (Puntero_de_impresion) decodificdo.
;
;			Se actualizan las variables: (Puntero_de_impresion) y (Columnas) de la bandeja DRAW.

Decodifica_Puntero_de_impresion:

;	Inicialmente suponemos que la entidad está apareciendo por el lado izquierdo de la pantalla, (1 Columna) y (Puntero_objeto) se encuentra en ROM, (por debajo de $4000).

	ld a,1															
	ld (Columnas),a

	ld a,b
	and $f0
	cp $f0
	jr nz,1F

	res 7,b
	res 6,b
	jr 2F

1 bit 6,b
	jr z,3F

	bit 5,b
	jr z,3F
	res 5,b
	jr 2F

;	Dos Columnas ???

3 ld a,3
	ld (Columnas),a

	bit 7,b
	jr z,2F

	res 7,b
	dec a
	ld (Columnas),a

2 ld (ix+6),c
	ld (ix+7),b												; Actualiza el (Puntero_de_impresion) decodificado en la caja de entidades.

	ld (Puntero_de_impresion),bc

	ret

; ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
;
;	1/4/25
;
;	Tras ejecutar esta rutina tendremos:
;
;	DE ..... (Puntero_objeto) de la explosión.
;	IX ..... (Puntero_de_impresion) de la explosión. 

Cargamos_registros_con_explosion

	ld l,(ix+8)
	ld h,(ix+9)														

; (Puntero_de_almacen_de_mov_masticados) en HL.

	call Extrae_address
	ex de,hl												; Puntero objeto de la (Explosión), en DE.

	ld l,(ix+6)
	ld h,(ix+7)			

	push hl
	pop ix													; (Puntero_de_impresion) en IX.

	ret

; ---------------------------------------------------------------------------------------------------------------------
;
; 8/1/23
;
; (Puntero_store_caja) contendrá la dirección donde se encuentran los parámetros de la 1ª entidad del índice.
; (Indice_restore_caja) se sitúa en la 2ª entidad del índice. 	
; (Puntero_restore_caja) contendrá la dirección donde se encuentran los parámetros de la 2ª entidad del índice.

; Destruye HL y DE !!!!!
 
Inicia_punteros_de_cajas 

	ld hl,Indice_de_cajas_de_entidades
    call Extrae_address
    ld (Puntero_store_caja),hl
	ld hl,Indice_de_cajas_de_entidades+2
	ld (Indice_restore_caja),hl
	call Extrae_address
	ld (Puntero_restore_caja),hl
    ret

; *************************************************************************************************************************************************************

;
; 20/10/22
;
; Extrae la direccio? que contiene un puntero, (HL), también en HL.
;
; Destruye el puntero y DE !!!!!

Extrae_address ld e,(hl)
	inc hl
	ld d,(hl)
	dec hl
	ex de,hl
	ret

; *************************************************************************************************************************************************************
;
;	19/5/25
;
;	Iniciamos (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq). 
;	Sitúa (Puntero_objeto) en el Sprite correspondiente en función de su (Posicion_inicio).
;
;   Destruye HL y BC !!!!!, 
;
;	BIT 7 (Ctrl_0). "1" ..... Derecha.
;					"0" ..... Izquierda.

Inicia_Puntero_objeto 

	ld a,(Posicion_inicio)
	and $1f
	cp $10
	jr c,Inicia_puntero_objeto_der

; Arrancamos desde la parte derecha de la pantalla.
; Iniciamos (Indice_Sprite_izq).  

Inicia_puntero_objeto_izq ld hl,(Indice_Sprite_izq)			
	ld (Puntero_DESPLZ_izq),hl
	call Extrae_address
	ld (Puntero_objeto),hl

	ld hl,(Indice_Sprite_der)								; Cuando "Iniciamos el Sprite a izquierda",_
	ld (Puntero_DESPLZ_der),hl								; _situamos (Puntero_DESPLZ_der) en el último defw_
	ret

; Arrancamos desde la parte izquierda de la pantalla.
; Iniciamos (Indice_Sprite_der).  

Inicia_puntero_objeto_der ld hl,(Indice_Sprite_der)			
	ld (Puntero_DESPLZ_der),hl
	call Extrae_address
	ld (Puntero_objeto),hl

	ld hl,(Indice_Sprite_izq)								; Cuando "Iniciamos el Sprite a derecha",_
	ld (Puntero_DESPLZ_izq),hl
	ret

; **************************************************************************************************
;
;	27/11/24
;
;	INPUT: IX contiene (Puntero_store_caja).
;
;	No situamos en la siguiente caja de entidades si esta está vacía.
	
Salta_caja_de_entidades_vacia 

	ld a,(ix+1)
	and a
	ret nz					

	call Incrementa_punteros_de_cajas
	ld ix,(Puntero_store_caja)
	jr Salta_caja_de_entidades_vacia

	ret

; **************************************************************************************************
;
;	08/05/23
;
;	Incrementamos los dos punteros de entidades. (+1).

Incrementa_punteros_de_cajas 

	ld hl,(Puntero_restore_caja)
	ld (Puntero_store_caja),hl 				
	ld hl,(Indice_restore_caja)
	inc hl
	inc hl
	ld (Indice_restore_caja),hl
    call Extrae_address
    ld (Puntero_restore_caja),hl
    ret

; **************************************************************************************************
;
; Temporización.

; $0320 ..... El RASTER va a empezar a pintar el 1er scanline de la primera FILA de la pantalla.
;       ..... (14175 T/States) + 71 es lo que tarda el RASTER en llegar al 1er SCANLINE de la 1ª FILA.
; $00ff ..... Es lo que tarda el RASTER en pintar 1 SCANLINE. (31 T/States) + 71. ..... 102 T/States aprox. 
;		..... 224 T/States es lo que tarda el raster en pintar 1 scanline.

; $0045 ..... Es lo que tardamos en pintar 1 FILA completa, (8 Scanlines). (1794 T/States) + 71 ..... 1 FILA.
;       ..... (14920 T/States) + 71  ..... Es lo que tarda el RASTER en pintar 1 TERCIO.
; $0365 ..... Llegamos al final de la 1ª FILA, (8 Scanlines).

; A partir de $4f61 no hace falta DELAY.
;
;	INPUT: BC, ($0000).
;
;	!!!!!!!! DESTRUYE BC !!!!!!!!!!!

DELAY
;															;$0320 ..... Delay mínimo
	dec bc  												;Sumaremos $0045 por FILA a esta cantidad inicial. Ejempl: si el Sprite ocupa la 1ª y 2ª_
	
	ld a,b
	or c
	jr nz,DELAY

	ret

; ---------------------------------------------------------------------------------------------------------------
;
;	13/07/24
;

; Variables Shield.

; Datos_Shield db 4,1,4,1									; Tiempos. (Frecuencia del parpadeo de Amadeus).
; Puntero_datos_shield defw 0								; Señala distintos tiempos para introducirlos en (Shield_2).
; Shield db 90												; Temporización principal. Indica el tiempo que el escudo está activo. No hay escudo cuando (Shield)="0".
; Shield_2 db 0 											; Almacena un tiempo, ( hacía el que apunta:  Puntero_datos_shield ).
; Shield_3 db 0

Inicia_Shield

	ld hl,Datos_Shield
	ld (Puntero_datos_shield),hl 							; Inicia el puntero (Puntero_datos_shield), lo situamos en la 1ª temporización.

	ld a,(hl)
	ld (Shield_2),a											; (Shield_2) contiene la primera temporización.

	ld a,1
	ld (Shield_3),a											; (Shield_3) se inicia con "1".

;	Sonido, (Efecto_escudo).

	ld hl,Shield_sound_init_value 							; Inicia sonido.
	ld (Shield_sound),hl

	xor a

	ret

; ---------- ---------- ---------- ---------- ---------- 
;
;	30/11/24
;
;	Limpia la caja de entidades de una entidad eliminada. 
; 	
;	INPUT: IX contiene el 1er .db de la entidad en curso.
;	MODIFY: A,BC,DE y HL.

Limpia_caja_de_entidades

	push ix
	pop hl
	xor a
	ld (hl),a
	ld e,l
	ld d,h
	inc e
	ld bc,13
	ldir 
	ret

; ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
;
;	26/01/25
;
;	Es la 1ª rutina que se ejcuta tras la rutina de interrupciones.
; 	
;	ACTUALIZA LA PANTALLA siempre que se haya producido algún movimiento, (entidades, Amadeus).
;

Actualiza_pantalla 

	ld a,2	
	out ($fe),a												

	ld a,(Ctrl_3)
	bit 2,a
	jr z,Ejecuta_escudo                                     ; No hay movimiento de entidades. Saltamos a Amadeus.

;	Inicializamos el (Puntero_de_columnas) para el borrado, (Puntero_indice_mov).

Borrando_entidades

	ld hl,(India_3_SP) 										; (Attr), (Columnas) y (.defw).

	ld a,(hl)
	and a
	jr z,Pintando_entidades

	ld c,a 													; (Attr) en C.

;	Limpiamos (Attr) de (India_3_SP).

	xor a
	ld (hl),a

	inc l

	ld a,(hl) 												; (Columnas) en A.
	ld (Columnas),a

;	Limpiamos (Columnas) de (India_3_SP).

	xor a
	ld (hl),a

;	Adquirimos dirección de Scanlies_album.

	inc l

	call Extrae_address

	ld (de),a
	inc e
	ld (de),a
	inc e
	ld (India_3_SP),de

	call Extrae_address
	call Pinta_Sprites

	jr Borrando_entidades
	
Pintando_entidades

;	(Columna_Y), (Attr), (Columnas) y .defw (Album_de_pintado).
;	.db, .db, .db, .defw

	ld hl,Tabla_de_borrado
	ld (India_3_SP),hl 										; Inicializa el puntero de la (Tabla_de_borrado).

;	Recabamos los datos de la (Tabla_de_pintado).

3 ld hl,(India_SP) 										; (India_SP) se encuentra al comienzo de la TABLA_DE_PINTADO.

	inc l													; Nota: No cambia el byte alto en las tablas de pintado y borrado.

	ld a,(hl) 							
	and a
	jr z,Ejecuta_escudo 									; (Tabla_de_pintado) vacía. Saltamos a Amadeus.

	ld (Attr),a
	ld c,a 	 												; (Attr) en C.

	inc l

	ld a,(hl) 							
	ld (Columnas),a
	inc l

	call Extrae_address 									; .defw (Album_de_pintado) en HL.

	inc e
	inc e

	ld (India_SP),de 										; Puntero (India_SP) situado en la siguiente línea de la tabla.
;
;															; Tenemos: 	C, (Attr).
; 												  			 			A, (Columnas).
;																	   HL, (Datos_en_album_de_pintado).

; Datos a Tabla_de_borrado.

	ex de,hl
	ld hl,(India_3_SP)

	ld (hl),c 												; (Attr).
	inc l
	ld (hl),a 												; (Columnas).
	inc l
	ld (hl),e 												; (.defw) dentro del (Album_de_pintado).
	inc l
	ld (hl),d
	inc l

	ld (India_3_SP),hl

	ex de,hl

; ----- ----- ----- -----

	call Extrae_address
	call Pinta_Sprites
	jr 3B

; --------------------- ----------------------- ---------------------- ---------------------- ---------------

Ejecuta_escudo

	ld a,3
	ld (Columnas),a

	ld a,(Attr_Amadeus)
	ld c,a

	call Force_Amd_attr 									; Siempre fijamos attr. Exista o no exista movimiento de Amadeus.

	ld a,(Shield)
	and a
	jr nz,Aplica_Shield

Borrando_Amadeus

	ld hl,Ctrl_3
	bit 5,(hl)
	jr z,1F													; No borramos. No ha habido movimiento.

	ld a,6
	out ($fe),a 											; Morado. Indica (borrado-Pintado) de Amadeus.

	ld hl,(Album_de_borrado_Amadeus)
	call Extrae_address
	inc h
	dec h
	jr z,Pintando_Amadeus

	call Pinta_Sprites

Pintando_Amadeus

	ld hl,(Album_de_pintado_Amadeus)
	call Extrae_address
	inc h
	dec h
	jr z,1F

	call Pinta_Sprites

; --------------------- ----------------------- ---------------------- ---------------------- ---------------

1 ld a,1													; Borde azul.
	out ($fe),a

	ld hl,Ctrl_3
	res 0,(hl)												; Reinicia el flag de FRAME completo.
	res 2,(hl)												; Reinicia el flag DETECTA MOVIMIENTO, (entidades).
	res 5,(hl)												; Reinicia el flag MOVIMIENTO DE AMADEUS.

	ret

;	Ejecuta Shield. 

Aplica_Shield 

;	Bit 1 "1" (Shield_3) Sólo borra.
;		  "0"     ""     Borra/Pinta.
;	Bit 2    ""  RET.	 No borra, no pinta. 

	ld hl,Shield_3

	bit 3,(hl)

	jr nz,Pintando_Amadeus

	bit 2,(hl)
	jr nz,1B

	bit 1,(hl)
	call nz,Borra_Amadeus_shield
	
	jr z,Borrando_Amadeus
	jr 1B

; ----- ----- ----- ----- ----- ----- ----- ----- -----  

Borra_Amadeus_shield

	ld a,(Ctrl_3)
	bit 5,a
	jr z,1F

	ld hl,(Album_de_borrado_Amadeus)
	call Extrae_address
	jr 2F

1 ld hl,(Album_de_pintado_Amadeus)
	call Extrae_address

2 call Pinta_Sprites

	xor a
	inc a													; Asegura NZ en la salida de la rutina.

	ret
	
Pinta_Amadeus_shield 

	ld hl,(Album_de_pintado_Amadeus)
	call Extrae_address
	call Pinta_Sprites

	xor a
	inc a													; Asegura NZ en la salida de la rutina.

	ret

Borra_Pinta_Amadeus_shield

	call Borra_Amadeus_shield
	call Pinta_Amadeus_shield

	ret

; ------------------------------------------------------------------------------------------------------------------------ 
;
;	29/12/25
;

Genera_explosion:

;	En primer lugar activamos el sonido de la explosión.

	call Init_Burst_sound

	ld hl,Clock_explosion
	dec (hl)
	jr z,Siguiente_frame_explosion							; Gestionamos la siguiente entidad.

Borra_entidad_colisionada

	ld a,(Filas)
	and a
	jr nz,1F

	ld a,%01000110 											; Amarillo.
	ld (ix+13),a

1 push ix 													; Push 1er .db (Clase) de la entidad, (caja de entidades correspondiente).

	call Cargamos_registros_con_explosion
	call calcula_CColumnass_Explosion_entidad

;	HL e IX contienen (Puntero_de_impresion). de la explosión.
;	DE contiene (Puntero_objeto).

	pop ix													; Pop 1er .db (Clase) de la entidad, (caja de entidades correspondiente).
	call Explosion_scanlines_generator

	xor a
	inc a 													; Necesario NZ a la salida de la subrutina.

	ret

Siguiente_frame_explosion

	ld a,%01000010  										; Rojo.
	ld (ix+13),a

	ld a,(Filas)
	xor 1
	ld (Filas),a 											; 2ª función de (Filas). Ahora almacena 1 bit que alterna su estado para cambiar los attr. de la explosión.
;															; _de la explosión amarillo-rojo.

	ld (hl),4 												; Inicializamos (Clock_explosion), (velocidad de la explosión).

; Avanza Frame de explosión.

	ld l,(ix+8)
	ld h,(ix+9)												; ld hl,(Puntero_de_almacen_de_mov_masticados).

	ld bc,Indice_Explosion_entidades+4

	ld a,c
	sub l
	jr nz,1F

; Fín de la entidad !!!!!!!!!!!!!
; Gestionamos entidades !!!!!!!!!!!!!!!!!!!!!!!!!!

; Numero_de_entidades db 0									; Nº total de entidades maliciosas que contiene el nivel.
; Numero_parcial_de_entidades db 0							; Nº de cajas que contiene un bloque de entidades. (6 Cajas).
; Entidades_en_curso db 0									; Entidades en pantalla.

	call Incrementa_Score
	call Score_a_BCD
	call Actualiza_Punteros_Score 							; Actualizamos los dígitos BCD del marcador Score, (Score_hex) y fijamos los punteros BCD_Score.

	call Decrementa_techo 									; Cada vez que eliminamos a una entidad decrementamos el valor de (Max_time_to_appear_entities).

; La entidad eliminada, es la última del nivel ?

	ld a,(Numero_de_entidades)
	and a
	jr z,2F

; Decrementa (Numero_de_entidades)

	dec a
	ld (Numero_de_entidades),a

	ld hl,Entidades_en_curso
	dec (hl)

	ld hl,Numero_parcial_de_entidades
	add (hl)

; ----------------------------------

	call nz, M_entidades_a_BCD								; Actualizamos la representación BCD de (Numero_de_entidades) + (Numero_parcial_de_entidades).

; Restauramos una nueva entidad de la caja "Master" correspondiente.
; IX apunta al 1er .db de la entidad eliminada.

	ld hl,(Puntero_de_entidades)
	ld a,(hl) 												; Clase de la siguiente entidad que hay que reponer en la caja.
	inc l
	ld (Puntero_de_entidades),hl

	call Obtiene_datos_de_Caja_Master						; HL apunta al 1er .db, (Tipo) de la "Caja Master" correspondiente al (Tipo) de entidad.

	push ix
	pop de

	ld bc,14
	ldir	

; Generamos (Puntero_de_impresion) y coordenadas de la nueva entidad restaurada.

	call Take_movement
	call Decodifica_Puntero_de_impresion

	ld l,(ix+6)
	inc l
	ld h,(ix+7)												; (Puntero_de_impresion) en HL.

	call Genera_coordenadas

	ld bc,(Coordenada_X)

	ld (ix+2),c
	ld (ix+3),b												; (Coordenada_X) y (Coordenada_Y) en caja de entidad.

	xor a
	inc a 													; Necesario NZ a la salida de la subrutina.

	ret

; Decrementa (Numero_parcial_de_entidades) y (Entidades_en_curso).

2 ld hl,Numero_parcial_de_entidades
	dec (hl)

	ld a,(hl)
	call M_entidades_a_BCD									; Actualizamos la representación BCD de (Numero_de_entidades) + (Numero_parcial_de_entidades).

	inc hl
	dec (hl)		

	call Limpia_caja_de_entidades
	jp Borra_entidad_colisionada

1 inc hl
	inc hl

	ld (ix+8),l
	ld (ix+9),h												; (Puntero_de_almacen_de_mov_masticados) a la siguiente explosión.

	jp Borra_entidad_colisionada

; ----- ----- ----- ----- -----
;
;	10/3/25

calcula_CColumnass_Explosion_entidad

	ld a,l
	and $1f
	jr z,Aparece_izquierda

	ex af,af
	ld a,3
	ld (Columnas),a
	ex af,af

	cp $1e
	ret c

	jr z,Dos_columnas_derecha

Aparece_derecha

	ld a,1
	ld (Columnas),a
	ret

Dos_columnas_derecha 

	ld a,2
	ld (Columnas),a
	ret

Aparece_izquierda inc a
	inc a
	ld (Columnas),a
	inc e

	ret

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
;
;	24/07/25
;

Genera_explosion_Amadeus:

;	Autoriza sonido de explosión.

	call Init_Burst_sound

	ld hl,Clock_explosion_Amadeus
	dec (hl)
	jr z,Siguiente_frame_explosion_Amadeus					; Gestionamos la siguiente entidad.

Borra_Amadeus_impactado

	ld a,(Columns)
	and a

	jr nz,3F

	ld a,%01000110 											; Amarillo.
	ld (Attr_Amadeus),a

3 call Change_Amadeus
	call Cargamos_registros_con_explosion_Amadeus

;	Situación actual:
;
;	DE y HL contienen (Puntero_objeto) de la explosión de Amadeus.
;	IX contiene el (Puntero_de_impresión) de la nave.

;	Detecta si Amadeus esta pegado al extremo derecho de la pantalla.
;	IX contiene (Puntero_de_impresion) de Amadeus.

	ld a,ixl
	and $1f
	cp $1e
	jr nz,2F

;	La explosión de Amadeus ocupa tres columnas por lo que corregiremos su (Puntero_de_impresion) para_
;	_que no aparezca parte de la explosión en la 1ª columna de pantalla.

	dec ixl 												; ($1d).

2 call Genera_datos_de_impresion_Amadeus

	ld hl,Ctrl_3
	set 5,(hl)												; Indicamos que hay movimiento, (se modifica el Sprite debido a la explosión).

	xor a
	inc a 													; Necesario NZ a la salida de la subrutina.

	ret

Siguiente_frame_explosion_Amadeus 

	ld (hl),5 												; Inicializamos (Clock_explosion_Amadeus), (velocidad de la explosión).

	ld a,%01000010  										; Rojo.
	ld (Attr_Amadeus),a

	ld a,(Columns)
	xor 1
	ld (Columns),a

; Avanza Frame de explosión.

	ld hl,(Pamm_Amadeus)
	ld bc,Indice_Explosion_Amadeus+4

	ld a,c
	sub l
	jr nz,1F

; Fín de Amadeus !!!!!!!!!!!!!
; Activamos el FLAG de Amadeus destruido, ( bit_6 Ctrl_3 ).

	xor a
	ld (Impacto_Amadeus),a

	ld hl,Ctrl_3
	set 6,(hl)												; Indica que Amadeus ha sido destruido. Ya se imprimió en pantalla la última explosión.

	ld hl,Ctrl_4
	set 6,(hl)												; Indica al reloj que ha de borrar una vida de la pantalla.

;	Evitamos que la rutina [Pintando_Amadeus] llame a la rutina de pintado, [Pinta_sprites] y vuelva a pintar la última explosión. 
;	Hace que la rutina [Pintando_Amadeus] interprete que (Album_de_pintado_Amadeus) está vacío. 

	xor a

	ld hl,(Album_de_borrado_Amadeus)
	ld (hl),a
	inc l
	ld (hl),a

	call Change_Amadeus

	ld hl,Ctrl_3
	set 5,(hl)												; Indicamos que hay movimiento, (se modifica el Sprite debido a la explosión).

	xor a
	inc a 		

	ret

1 inc hl
	inc hl
	ld (Pamm_Amadeus),hl
	jr Borra_Amadeus_impactado

; ---------------------------------------------------------------
;
;	12/2/26

Init_Burst_sound:

;	ret si ya está iniciado el efecto.

	ld hl,(Burst_sound)
	ld a,h
	or l
	ret nz

;	Init Burst_sound_efect.

;	La explosión de Amadeus ha de ser más larga que la de las entidades.

	ld hl,Burst_sound_init_value

	ld a,(Impacto_Amadeus)
	and a
	jr z,1F

	ld hl,Amadeus_Burst_sound_init_value
	
1 ld (Burst_sound),hl

	ret

; ---------------------------------------------------------------
;
;	21/11/25
;
;	Decrementa el valor de (Max_time_to_appear_entities) en (Decrease_top_time_entities) unidades.
;	(Max_time_to_appear_entities) nunca será mayor que (Min_time_to_appear_entities).

Decrementa_techo:

	ld hl, Max_time_to_appear_entities
	ld a,(hl)
	inc hl
	sub (hl)

;	New TOP-time in A.

	inc hl

	cp (hl)

	jr nc,1F

;	Si estamos por debajo del valor mínimo corregimos:

	ld a,(hl)

1 dec hl
	dec hl

	ld (hl),a

	ret

; ------------------------------
;
;	20/10/25
;
;	INPUTS: IX apunta al prumer .db (Clase) de la caja de entidades.

Incrementa_Score:

	ld a,(ix+1)
	ld b,a

	ld hl,Tabla_de_puntuacion -1
1 inc hl
	djnz 1B

	ld c,(hl) 								; C contiene la puntuación BASE.

	ld l,(ix+6)
	ld h,(ix+7)

	call calcula_tercio
	jr z,vel

	dec c
	dec c
	dec c

	dec a
	jr z,vel

	dec c
	dec c

vel

	ld a,(ix+12)

	add c
	ld c,a

suma 

	and a
	ld hl,(Score_hex)
	adc hl,bc

	ld (Score_hex),hl

	ret

; ------------------------------------------------------------------------
;
;	08/04/26
;
;	Inizializa el siguiente nivel.

Next_level:

	di

;	Eliminamos el disparo de Amadeus y su sonido.

    xor a

    ld b,4
    ld hl,Disparo_Amad

1 ld (hl),a
    inc hl
    djnz 1B

	ld hl,0
	ld (Shot_sound),hl

	call Change_Disparos							; Intercambiamos los álbumes de disparos.
    call Pinta_disparos_Amadeus
	call Change_Disparos							; Intercambiamos los álbumes de disparos.

	call Done_melody

	ld bc,$05ff
    call DELAY

	ld hl,Ctrl_4
	res 5,(hl)

	call Clean_DONE   								;	Inicializa FLAF: (Nivel superado) y limpia el mensaje DONE.

	call Replace_Amadeus_attr_zone 					;	Repone los atributos de las 2 últimas líneas de pantalla para que la entrada de Amadeus del siguiente nivel sea azul.


;	Vamos a empezar de nuevo. En primer lugar limpiamos los distintos álbumes de líneas.
;	El álbum de líneas de Amadeus no está vacío. Para acelerar el proceso de pintado tiene almacenados los scanlines, ($00, $50, $00, $51, ..., $00, $57).

;	Scanlines_album equ $8000	                    ;	($8000 - $8118) 	
;	Scanlines_album_2 equ $811a	                    ;   ($811a - $8232)

;	Amadeus_scanlines_album equ $8234	            ;	($8234 - $8256) 	
;	Amadeus_scanlines_album_2 equ $8258	            ;	($8258 - $827a)

;	Amadeus_disparos_scanlines_album equ $827c	    ;	($827c - $8281) 	
;	Amadeus_disparos_scanlines_album_2 equ $8282	;	($8284 - $8289)

;	Entidades_disparos_scanlines_album equ $8288	;	($8288 - $82b9)		
;	Entidades_disparos_scanlines_album_2 equ $82bb	;	($82bb - $82ec)

;	Limpiamos Scanlines_album y Scanlines_album_2:
;	Sólo limpiamos los primeros 35 bytes de cada álbum pues "eliminamos" a una última y única unidad para pasar de nivel.

	ld hl,Scanlines_album
	ld bc,34
	call Clean_mem
;
	ld hl,Scanlines_album_2
	ld bc,34
	call Clean_mem

;	Limpiamos:

;	Numeros_aleatorios ds 7
;	Numeros_aleatorios_baile ds 7

;	Tabla_de_pintado ds 30								
;	Tabla_de_borrado ds 24

	ld hl,Numeros_aleatorios
	ld bc,67
	call Clean_mem

;	Limpiamos las 3 cajas Master.

	ld hl,Caja_master_1
	ld bc,41
	call Clean_mem

;	Limpiamos la caja de Amadeus.

	ld hl,Amadeus_BOX
	push hl
	ld bc,13
	call Clean_mem
	pop hl

	inc hl
	inc hl
	inc hl

	ld (hl),15

;	Limpiamos Almacenes de movimientos masticados de Amadeus  entidades.

	ld hl,Almacen_de_movimientos_masticados_Amadeus
	ld bc,$36fe
	call Clean_mem

	call Inicializa_Bandeja_DRAW

	ld hl,Amadeus_scanlines_album
	call Inicializa_Amadeus_scanline_album

	ld hl,Amadeus_scanlines_album_2
	call Inicializa_Amadeus_scanline_album

;	Actualiza (Puntero_indice_NIVELES).

	ld hl,(Puntero_indice_NIVELES)

	inc hl
    inc hl

    ld (Puntero_indice_NIVELES),hl

    jp Init_level

;	-----------------------------------------------------------------------------------------

;	Rutinas consecutivas, no hay bytes libres entre ellas.

	include "Rutinas_de_teclado.asm"
	include "RND_Derivando.asm"
	include "Rutinas_de_inicio_y_niveles.asm"
	include "calcula_tercio.asm"
	include "Cls.asm"
	include "Genera_coordenadas.asm"
	include "Transiciones_y_efectos.asm"
	include "Genera_datos_de_impresion.asm"
	include "Pinta_Sprites.asm"
	include "Draw_XOR.asm"
	include "Direcciones.asm"
	include "Movimiento.asm"
	include "Disparo.asm"
	include "Sound.asm"
	include "Print_text_msg.asm"
	include "Niveles.asm"


	SAVESNA "Amadeus.sna", START




