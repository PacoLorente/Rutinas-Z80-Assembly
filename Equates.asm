;   CONSTANTES / DEFINICIONES.

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

Inicio_de_msg_de_nombre equ Line_20 + 14  								; En esta dirección de pantalla se imprime el 1er caracter del nombre.

ROM_ASCII equ $3c00 													; A esta dirección de memoria sumaremos el código ASCII correspondiente para situarnos en los 8 bytes que forman el char.
KEY_SCAN equ $028e

Sprite_vacio equ $82f0													; 48 Bytes de "0".

; 	Dirección de la variable ROM, (FRAMES).

FRAMES equ $5c78														; Variable de 24 bits. Almacena el nº de cuadros, (frames) que llevamos construidos. Reloj en tiempo real.
FRAMES_3 equ $5c7a

; 	Direcciones de pantalla de vidas, escudos, Firma y cartel Best_Score:

Direccion_Logo_principal equ $4049                                      ; Logo "Amadeus" Screen's address.
Cartel_Score_address equ $4012                                          ; Logo "Score"     "         "   .
Firma_address equ $50da 		 										; Dirección de pantalla donde se imprime la Firma.
Best_Score_address equ Line_20 + 1 										; Dirección de pantalla donde se imprime el cartel "Best_Score".

Vida_1 equ $4001														; Dirección de pantalla donde se pintan las 3 vidas.
Vida_2 equ $4003
Vida_3 equ $4006

Escudo_1 equ $4041														; Dirección de pantalla donde se pintan los 3 escudos.
Escudo_2 equ $4043
Escudo_3 equ $4046

;	 Contador de entidades:

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

Unidades_cont_ent equ $400d

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

Unidades_Score equ $4057
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
Primer_scan_Amadeus equ $50cf
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

; Dirección de Atributos de video de la luna.

Attr_Moon_File4 equ $587a
Attr_Moon_File4_2 equ $587c
Attr_Moon_File4_3 equ $587e

Attr_Moon_File5 equ $589a
Attr_Moon_File5_2 equ $589c
Attr_Moon_File5_3 equ $589e

;	Sound efects.

Laser_sound_init_value equ $00a0 				;	Valor inicial del efecto, (ascendente/descendente) de sonido del laser.
Construction_Amadeus_effect equ $d0				; 	Longitud del efecto de sonido "construcción de Amadeus".
Shield_sound_init_value equ $c0 				;	Valor del BEEP que construye SHIELD_sound_effect.
Burst_sound_init_value equ $35					;	Longitud de la explosión de las entidades, (duración).
Amadeus_Burst_sound_init_value equ $75			;	Longitud de la explosión de Amadeus, (duración).
Shot_sound_init_value equ $1601 				;	Valor inicial del efecto de disparo de Amadeus.

;	Mensajes de texto.

Fila_msg_de_nivel equ Line_9 + 6				;	Los mensajes de nivel se imprimen en la fila 9, columna 6, (antes del centrado).
