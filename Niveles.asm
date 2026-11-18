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











