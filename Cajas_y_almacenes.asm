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

Numeros_aleatorios: ds 7
Numeros_aleatorios_baile: ds 7

Score_max_msg: ds 6
Nombre_del_campeon: ds 6
Sinclair_db_box: ds 4

;* Caja del disparo de Amadeus y cajas de disparos de entidades.

Disparo_Amad:

	defw 0											; Puntero objeto.
	defw 0											; Puntero de impresión.


	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_7: db 0	     								; Control.
						
	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_6: db 0		    							; Control.

	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_5: db 0			    						; Control.
						
	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_4: db 0				     					; Control.

	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_3: db 0					    				; Control.
						
	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_2: db 0						    			; Control.

	db 0,0,0										; Puntero objeto.
	defw 0											; Puntero de impresión.
Disparo_1: db 0										; Control.

;	Cajas Master. ---------------------------------------------------------

Caja_master_1:

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

Caja_master_2:

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

Caja_master_3:

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

;	Caja de Amadeus.

Amadeus_BOX: db 0,0									; (Clase), (Tipo).
CX_Amadeus: db 0,$15                            	; (Coordenada_X), (Coordenada_Y).
	db 0											; (Contador_de_vueltas).
Impacto_Amadeus:	db 0							; (Impacto).
p.imp.amadeus: defw 0								; (Puntero_de_impresion).
Pamm_Amadeus: defw 0								; (Puntero_de_almacen_de_mov_masticados).
Comm_Amadeus: defw 0 								; (Contador_de_mov_masticados).
	db 0											; (Velocidad).
Attr_Amadeus: db 0 									; (Attr).

;	Cajas de entidades.

Caja_1:

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

Caja_2:

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

Caja_3:

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

Caja_4:

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

Caja_5:

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

