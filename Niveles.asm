; ------------------------------------------------------------------
;
; 	5/7/26
;

;	Fila donde se imprimen los msg: $4826

Msg_level_index:

	defw Msg_1
	defw Msg_2
	defw Msg_3
;	defw Msg_4

	defw 0
	defw 0

Msg_1 db 8,5 									; El 1er .db indica que sumamos +8 columnas a la dirección donde se imprimen los mensajes: $4826.
	defm "FLIES",0

Msg_2 db 8,5 									; El 1er .db indica que sumamos +8 columnas a la dirección donde se imprimen los mensajes: $4826.
	defm "UFOS",0

Msg_3 db 4,12
	defm "FLIES & UFOS",0

; --------------------------------------------------------------------------------------------------------------

Indice_de_vidas

	defw Vida_1,Amadeus,$0302							; (Puntero_de_impresion), (Puntero_objeto) y (Columnas/Filas).
	defw Vida_2,Amadeus_Fb,$0302
	defw Vida_3,Amadeus,$0302

Indice_de_escudos

	defw Escudo_1,Escudo_00,$0201
	defw Escudo_2,Escudo_00_Fb,$0301
	defw Escudo_3,Escudo_00,$0201

; --------------------------------------------------------------------------------------------------------------



Indice_de_tablas_Random

; Entidades (Tipo) (1), (2) y (3). Son entidades (tipo) BadSat.

	defw Tabla_Random_BadSat
	defw Tabla_Random_Badplate
	defw 0

;	...
;	...
;	+ Tablas ...

	defw 0

; --------------------------------------------------------------------------------------------------------------
;
;	4/3/25
;
;	En 1er lugar identificamos si existe .db de CTRL, ($00).
;	Al .db de CTRL $00 le seguirá otro .db indicando el nº de .defw que compartirán nº aleatorio. 
;
;	El siguiente .defw indica:
;
;	Byte alto: Límite superior que puede tener como máximo nuestro nº rnd.
;	Byte bajo: Límite inferior que puede tener como mínimo nuestro nº rnd.
;
;	Los sucesivos .defw indican la dirección o direcciones de memoria correspondientes donde se almacenará el nº aleatorio.
;	
; ----- ----- ----- ----- -----
;
;   Factor RANDOM --- BadSat.

; Random_1_1_10 (1-10) Bajo_decelerando
; Random_2_1_15 (1-15) Derecha_y_subiendo

; Random_3_1_15 (1-15) Derecha_y_bajando_1 ----- Iguales
; Random_4_1_15 (1-15) Derecha_y_bajando_2 -----

; Random_5_1_15 (1-5) Izquierda_y_subiendo

; Random_6_1_15 (1-5) Izquierda_y_bajando_1 ----- Iguales
; Random_7_1_15 (1-15) Izquierda_y_bajando_2 -----
;
; ----- ----- ----- ----- -----
;
;   Factor RANDOM --- BadPlate.

; Random_1_1_10 (1-10) Bajo_decelerando
; Random_8_1_15 (1-15) Tira_pa_la_derecha

; Random_9_1_15 (1-15) Tira_pa_la_izq
; Random_A_1_15 (1-15) Diagonal_bajando_izq
; Random_B_1_15 (1-15) Diagonal_bajando_derecha
;
; ----- ----- ----- ----- -----

Tabla_Random_BadSat

	defw $0a01
	defw Random_1_1_10

	defw $0f01
	defw Random_2_1_15

	db 0,1 				;	1 repetición.
	defw $0f01
	defw Random_3_1_15	;	Igual
	defw Random_4_1_15	;	Igual

	defw $0f01
	defw Random_5_1_15

	db 0,1
	defw $0f01
	defw Random_6_1_15	;	Igual
	defw Random_7_1_15	;	Igual

	defw 0 				;	Indica FIN de la tabla RANDOM.

Tabla_Random_Badplate

	defw $0a01
	defw Random_1_1_10

	defw $0f01
	defw Random_8_1_15

	defw $0f01
	defw Random_9_1_15

	defw $0301
	defw Random_A_1_3

	defw $0301
	defw Random_B_1_3

	defw 0				;	Indica FIN de la tabla RANDOM.

; ----------------------------------------------------------------------
;
;	19/11/25

Indice_de_niveles:

	defw Nivel_1 
	defw Nivel_2
	defw Nivel_3
;	defw Nivel_4

;	...
;	...
;	+ Niveles ...

	defw 0
;	defw 0

; NIVEL_1. Tres clases de entidades tipo BadSat.

Nivel_1 db $f0,$0a,$70,$70 						; FLIES !!!

;												; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;												; 2º byte: Define el valor de (Decrease_top_time_entities).
;												; 3er byte: Valor inicial de (Min_time_to_appear_entities).
; 												; 4º byte: Valor inicial de (CLOCK_disparos_de_entidades).

												
	db 20 										; Nº de entidades que tiene el nivel.

	db 1,2,3,1,2 								; Clases de entidades. (Irán apareciendo por este orden).
	db 3,1,2,3,1
	db 2,3,1,2,3
	db 1,2,3,1,2

; ---------------------------------------------------------------------------------------

; Nivel_2. UFO´s

Nivel_2 db $C0,$15,$50,$70 						; UFOS !!!

;												; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;												; 2º byte: Define el valor de (Decrease_top_time_entities).
;												; 3er byte: Valor inicial de (Min_time_to_appear_entities).
; 												; 4º byte: Valor inicial de (CLOCK_disparos_de_entidades).
	db 20

	db 4,5,6,4,5
	db 5,5,6,4,6
	db 4,5,6,5,4
	db 4,6,6,4,5


; ---------------------------------------------------------------------------------------

; Nivel_3. Flies & UFOS.

Nivel_3 db $b0,$15,$50,$70 						; UFOS !!!

;												; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;												; 2º byte: Define el valor de (Decrease_top_time_entities).
;												; 3er byte: Valor inicial de (Min_time_to_appear_entities).
; 												; 4º byte: Valor inicial de (CLOCK_disparos_de_entidades).

	db 20

	db 1,4,6,1,6
	db 4,6,6,1,4
	db 1,6,1,6,1
	db 4,1,6,1,6












