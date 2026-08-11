; -------------------------------------------------------------------------------------
;
;	11/8/26
;
;	TIPOS de "Entidades maliciosas" que quieren conquistar la Tierra.
;
;	(Definiciones de entidades).
;
;	El (Tipo) de la entidad define el patrón de movimientos.


;	Entidades (Tipo) BADSAT. (Satélites poseidos).
; 	(Clases): 1,2 y 3

Tipo_BadSat: db $81,2,2		                		; (Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db %01000100 									; (Attr).

; 	Entidades (Tipo) BADPLATE. (Platillos volantes).
; 	(Clases): 4 y 5

Tipo_BadPlate: db $82,2,2		                	; (Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badplate_der						; (Indice_Sprite_der).
	defw Indice_Badplate_izq						; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
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
;	11/8/26
;
;	Definición de Amadeus.
;
;	Amadeus no utiliza el parámetro: (Contador_de_vueltas). Lo colocamos a "0".
;	Inicialmente situamos a Amadeus en el centro de la pantalla.

Definicion_Amadeus:

	db 0,0,2,2		                     			 ; (Clase),(Tipo) / (Filas) / (Columns).
	db 0											 ; (Contador_de_vueltas).
	defw Indice_Amadeus_der							 ; (Indice_Sprite_der).
	defw Indice_Amadeus_izq							 ; (Indice_Sprite_izq).
	defw $50c1	                                     ; (Posicion_inicio).
	db 3											 ; (Cuad_objeto).
	defw Almacen_de_movimientos_masticados_Amadeus	 ; (Puntero_de_almacen_de_mov_masticados).
	db %01000101									 ; (Attr).
