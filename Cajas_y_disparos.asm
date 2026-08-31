; ---------------------------------------------------------------------
; Cajas de entidades, Amadeus y disparos. Índices de disparos y cajas. 
; Índice de Patrón de movimiento para tipo de entidad.
; ---------------------------------------------------------------------

; 	14/06/26
;
;	En esta tabla iremos almacenando:
;
;	(Columna_Y),(Dirección de memoria donde se encuentran almacenados los scanlines masticados de cada entidad, (Scanlines_album)).
;	
;	Los 6 últimos bytes contienen el borrado/pintado de Amadeus, (Amadeus_scanlines_album).

;	Free mem. $8cc6 - $8cff .....$39 / 57d Bytes.

	org $9000

Numeros_aleatorios ds 7
Numeros_aleatorios_baile ds 7

Tabla_de_pintado ds 30								; No puede haber cambio de byte alto en la Tabla_de_pintado.
Tabla_de_borrado ds 24

;	db 0, defw 0, db 0
;	.....

Almacen_de_movimientos_masticados_1 defw $c9e6													
Almacen_de_movimientos_masticados_2 defw 0
Almacen_de_movimientos_masticados_3 defw 0

	defw 0

Contador_general_de_mov_masticados_1 defw 0  	
Contador_general_de_mov_masticados_2 defw 0
Contador_general_de_mov_masticados_3 defw 0

; -------------------------------------------------------------------------------------------------------

Indice_de_mov_segun_tipo_de_entidad defw Indice_mov_Baile_de_BadSat			;	(Tipo)="$81"
	defw Indice_mov_Baile_de_Badplate 										;	(Tipo)="$82"
; 	defw ...
	defw 0

;* Caja del disparo de Amadeus y cajas de disparos de entidades.

Disparo_Amad defw 0									; Puntero objeto.
	defw 0									; Puntero de impresión.

Indice_de_disparos_entidades defw Disparo_1
	defw Disparo_2
	defw Disparo_3
	defw Disparo_4
	defw Disparo_5
	defw Disparo_6
	defw Disparo_7

	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_7 db 0	     								; Control.
						
	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_6 db 0		    							; Control.

	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_5 db 0			    						; Control.
						
	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_4 db 0				     					; Control.

	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_3 db 0					    				; Control.
						
	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_2 db 0						    			; Control.

	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_1 db 0										; Control.
		
; -------------------------------------------------------------------------------------
;
;	Índice de cajas_Masters.
;
;	12/4/25
;
;	14 bytes.

Indice_de_cajas_master						

	defw Caja_master_1
	defw Caja_master_2
	defw Caja_master_3

Caja_master_1 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; ---------- ---------- ---------- ---------- ----------	

Caja_master_2 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; ---------- ---------- ---------- ---------- ----------	

Caja_master_3 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.
	
; -------------------------------------------------------------------------------------
;
;	Índice de cajas de entidades.
;
;	18/1/24
;

Indice_de_cajas_de_entidades						

	defw Caja_1
	defw Caja_2
	defw Caja_3
	defw Caja_4
	defw Caja_5

;	defw Caja_6
;	defw Caja_7

	defw 0
	defw 0

; ---------- ---------- ---------- ---------- ----------
;
;	17/4/25
;

Amadeus_BOX db 0,0									; (Clase), (Tipo).
CX_Amadeus db 0,$15                            		; (Coordenada_X), (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
Impacto_Amadeus	db 0								; (Impacto).
p.imp.amadeus defw 0								; (Puntero_de_impresion).
Pamm_Amadeus defw 0									; (Puntero_de_almacen_de_mov_masticados).
Comm_Amadeus defw 0 								; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
Attr_Amadeus db 0 									; (Attr).

; ---------- ---------- ---------- ---------- ----------
;
;	12/4/25
;
; 	(Cada caja tiene 14 bytes).
;

Caja_1 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; ---------- ---------- ---------- ---------- ----------	

Caja_2 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; --------------------------------------------------------------------------
; FREE SPACE $04, 04d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $9100

Caja_3

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; ---------- ---------- ---------- ---------- ----------

Caja_4 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; ---------- ---------- ---------- ---------- ----------

Caja_5 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; -------------------------------------------------------------------------------------
;
;	06/4/25
;
;	CLASES de "Entidades maliciosas" que quieren conquistar la Tierra.	
;
;	(Definiciones de entidades).
;
;	El (Tipo) de la entidad define el patrón de movimientos.

Indice_de_definiciones_de_entidades

	defw Entidad_Clase_1
	defw Entidad_Clase_2
	defw Entidad_Clase_3
	defw Entidad_Clase_4
	defw Entidad_Clase_5
	defw Entidad_Clase_6

; Entidades (Tipo) BADSAT. (Satélites poseidos). 
; (Clase): 1,2 y 3

Entidad_Clase_1 db 1,$81,2,2		                ; (Clase) /(Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db 0											; (Cuad_objeto).
	defw 0 											; (Puntero_de_almacen_de_mov_masticados)
	db %01000100 									; (Attr).

; ----- . ----- . ----- . ----- . -----

Entidad_Clase_2 db 2,$81,2,2		                ; (Clase) /(Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db 0											; (Cuad_objeto).
	defw 0 											; (Puntero_de_almacen_de_mov_masticados)
	db %01000100 									; (Attr).

; ----- . ----- . ----- . ----- . -----

Entidad_Clase_3 db 3,$81,2,2		                ; (Clase) /(Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db 0											; (Cuad_objeto).
	defw 0 											; (Puntero_de_almacen_de_mov_masticados)
	db %01000100 									; (Attr).

; Entidades (Tipo) BADPLATE. (Platillos volantes).
; (Clase): 4 y 5

Entidad_Clase_4 db 4,$82,2,2		                ; (Clase) /(Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badplate_der						; (Indice_Sprite_der).
	defw Indice_Badplate_izq						; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db 0											; (Cuad_objeto).
	defw 0 											; (Puntero_de_almacen_de_mov_masticados)
	db %01000100 									; (Attr).

Entidad_Clase_5 db 5,$82,2,2		                ; (Clase) /(Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badplate_der						; (Indice_Sprite_der).
	defw Indice_Badplate_izq						; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db 0											; (Cuad_objeto).
	defw 0 											; (Puntero_de_almacen_de_mov_masticados)
	db %01000100 									; (Attr).

Entidad_Clase_6 db 6,$82,2,2		                ; (Clase) /(Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badplate_der						; (Indice_Sprite_der).
	defw Indice_Badplate_izq						; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db 0											; (Cuad_objeto).
	defw 0 											; (Puntero_de_almacen_de_mov_masticados)
	db %01000100 									; (Attr).

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
; -------------------------------------------------------------------------------------
;
;	17/4/25
;
;	Definición de Amadeus.
;
;	Amadeus no utiliza el parámetro: (Contador_de_vueltas). Lo colocamos a "0".
;	Inicialmente situamos a Amadeus en el centro de la pantalla.

Definicion_Amadeus 

	db 0,0,2,2		                     												; (Clase),(Tipo) / (Filas) / (Columns).
	db 0																						; (Contador_de_vueltas).
	defw Indice_Amadeus_der													; (Indice_Sprite_der).
	defw Indice_Amadeus_izq													; (Indice_Sprite_izq).
	defw $50c1	                                     									; (Posicion_inicio).
	db 3																						; (Cuad_objeto).
	defw Almacen_de_movimientos_masticados_Amadeus		; (Puntero_de_almacen_de_mov_masticados).
	db %01000101																	; (Attr). 
