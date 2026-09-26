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

Tabla_de_pintado ds 30								; PUEDE HABER CAMBIO DE BYTE ALTO EN LA TABLA DE PINTADO.
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

Indice_de_cajas_master:

	defw Caja_master_1
	defw Caja_master_2
	defw Caja_master_3

Caja_master_1:

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; ---------- ---------- ---------- ---------- ----------	

Caja_master_2:

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

; ---------- ---------- ---------- ---------- ----------	

Caja_master_3:

	db 0 											; (Clase).
	db 0 											; (Tipo).
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

Indice_de_cajas_de_entidades:

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
	db 0											; (Contador_de_vueltas).
Impacto_Amadeus	db 0								; (Impacto).
p.imp.amadeus defw 0								; (Puntero_de_impresion).
Pamm_Amadeus defw 0									; (Puntero_de_almacen_de_mov_masticados).
Comm_Amadeus defw 0 								; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
Attr_Amadeus db 0 									; (Attr).

CX_Amadeus db 0,$15                            		; (Coordenada_X), (Coordenada_Y).

; ---------- ---------- ---------- ---------- ----------
;
;	12/4/25
;
; 	(Cada caja tiene 14 bytes).
;

Caja_1 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).

; ---------- ---------- ---------- ---------- ----------	

Caja_2 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).

; --------------------------------------------------------------------------
; FREE SPACE $04, 04d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $9100

Caja_3

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).

; ---------- ---------- ---------- ---------- ----------

Caja_4 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).

; ---------- ---------- ---------- ---------- ----------

Caja_5 

	db 0 											; (Clase).
	db 0 											; (Tipo).
	db 0											; (Contador_de_vueltas).
	db 0											; (Impacto).
	defw 0											; (Puntero_de_impresion).
	defw 0											; (Puntero_de_almacen_de_mov_masticados).
	defw 0 											; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
	db 0 											; Atributos.

	db 0 											; (Coordenada_X).
	db 0 											; (Coordenada_Y).

; -------------------------------------------------------------------------------------
;
;	9/9/26
;
;	CLASES de "Entidades maliciosas" que quieren conquistar la Tierra.	
;
;	(Definiciones de entidades).
;
;	El (Tipo) de la entidad define el patrón de movimientos.

Indice_de_definiciones_de_entidades:

	defw Entidad_Tipo_Badsat
	defw Entidad_Tipo_Badsat
	defw Entidad_Tipo_Badsat
	defw Entidad_Tipo_Badplate
	defw Entidad_Tipo_Badplate
	defw Entidad_Tipo_Badplate

; Entidades (Tipo) BADSAT. (Satélites poseidos). 
; (Clase): 1,2 y 3

Entidad_Tipo_Badsat:

	db $81,2,2		                				; (Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badsat_der							; (Indice_Sprite_der).
	defw Indice_Badsat_izq							; (Indice_Sprite_izq).
	defw $4060		              					; (Posicion_inicio).
	db %01000100 									; (Attr).


; Entidades (Tipo) BADPLATE. (Platillos volantes).
; (Clase): 4 y 5

Entidad_Tipo_Badplate:

	db $82,2,2						                ; (Tipo) / (Filas) / (Columns).
	db 2											; (Contador_de_vueltas). "2": Sólo una vuelta lenta. "1" Dos vueltas lentas.
	defw Indice_Badplate_der						; (Indice_Sprite_der).
	defw Indice_Badplate_izq						; (Indice_Sprite_izq).
	defw $4060	                					; (Posicion_inicio).
	db %01000100 									; (Attr).

;	Definición de Amadeus.

Definicion_Amadeus:

	db 0,2,2		                     			; (Tipo) / (Filas) / (Columns).
	db 0
	defw Indice_Amadeus_der							; (Indice_Sprite_der).
	defw Indice_Amadeus_izq							; (Indice_Sprite_izq).
	defw $50c1	                                    ; (Posicion_inicio).
	db %01000101									; (Attr).

; ---------------------------------------------
; ---------------------------------------------
; ---------------------------------------------
; ---------------------------------------------
; ---------------------------------------------

DONE_NOTES_MELODY_INDEX:

	defw Note_1x
	defw Note_2x
	defw Note_3x
	defw Pause_1x
	defw Note_4x
	defw Note_5x
	defw Pause_2x
	defw Note_6x
	defw Note_7x
	defw Note_8x
	defw Pause_3x
	defw Note_9x
	defw Note_10x
	defw Pause_4x
	defw Note_11x
	defw Pause_5x
	defw Note_12x
	defw Note_13x
	defw Note_14x
	defw Note_15x
	defw 0

Note_1x:

;	ld bc,$0014                                             ; No ruido / 20 ondas completas
;	ld de,$0005                                             ; Nota descendente / 5 unid. decrease.
;	ld hl,$015e                                             ; Note init. value. 

	defw $0014
	defw $0005
	defw $015e 

Note_2x:

;    ld c,$14                                                ; Duración de la nueva nota, 20 ondas.
;    ld e,0                                                  ; No existe decremento. (sonido plano).

	defw $0014
	defw $0000
	defw $00fa

Note_3x:

;	ld c,$24                                                ; Duración de la nueva nota.
;	ld l,$a5                                                ; (HL) = $00a5. Nota, (duración de un semiciclo).

	defw $0024
	defw $0000
	defw $00a5

Pause_1x:

;   ld bc,$4000            

	defw $4000

Note_4x:

;	ld c,$14                                                ; Duración de la nueva nota.
;	ld l,$fa                                                ; New note, (HL) = $00fa

	defw $0014
	defw $0000
	defw $00fa

Note_5x:

;	ld c,$21                                                ; Duración de la nueva nota.
;	ld l,$b7                                                ; New note, (HL) = $00b7

	defw $0021
	defw $0000
	defw $00b7

Pause_2x:

;   ld bc,$4000             

	defw $4000

Note_6x:

;   ld c,$14                                                ; Duración de la nueva nota.
;	ld l,$fa                                                ; New note, (HL) = $00fa

	defw $0014
	defw $0000
	defw $00fa

Note_7x:

;	ld c,$24                                                ; Duración de la nueva nota.          
;	ld l,$cd                                                ; New note, (HL) = $00cd

	defw $0024
	defw $0000
	defw $00cd

Note_8x:

;    ld c,$2d                                                ; Duración de la nueva nota.         
;    ld de,$0101                                             ; Nota ascendente / 1 unid. increase..

	defw $002d
	defw $0101
	defw $00cd

Pause_3x:

;   ld bc,$1000         

	defw $1000

Note_9x:

;    dec d
;    dec e                                                  ; Prepara Nota descendente / "0" decrease. Sonido plano.
;                                                           ; (HL) ha subido hasta $00fa.
;    ld c,$16                                               ; Duración, 22 ondas de sonido.                

	defw $0016
	defw $0000
	defw $00fa

Note_10x:

;	ld c,$21
;	ld l,$cd

	defw $0021
	defw $0000
	defw $00cd

Pause_4x:

;   ld bc,$4000          

	defw $4000

Note_11x:

;	ld c,$21
;	ld l,$d4

	defw $0021
	defw $0000
	defw $00d4

Pause_5x:

;   ld bc,$5ff0

	defw $5ff0

Note_12x:

;	ld c,$23                    
;	ld hl,$0117

	defw $0023
	defw $0000
	defw $0117

Note_13x:

; 	ld c,$14                                                ; Duración.
;    ld e,3                                                 ; (D)="0" / Decrease "3".
;                                                           ; (HL) down to $00db, (Note).

	defw $0014
	defw $0003
	defw $0117

Note_14x:

;    ld c,$10
;    ld de,$0102                                            ; (D)="1" / Increase "2"
;                                                           ; (HL) up to $00fb

	defw $0010
	defw $0102
	defw $00db

Note_15x:

;   dec l                                                   ; Note: $00fa.
;   dec e
;   dec e                                                   ; Clear increase.
;   ld c,$40                                                ; Duration.

	defw $0040
	defw $0100
	defw $00fa
