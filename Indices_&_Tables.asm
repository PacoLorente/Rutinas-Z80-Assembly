
;   Índices.

Almacen_de_movimientos_masticados_1 defw $5fe6
Almacen_de_movimientos_masticados_2 defw 0
Almacen_de_movimientos_masticados_3 defw 0

	defw 0

Contador_general_de_mov_masticados_1 defw 0
Contador_general_de_mov_masticados_2 defw 0
Contador_general_de_mov_masticados_3 defw 0

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

Indice_de_vidas:

	defw Vida_1,Amadeus,$0302							; (Puntero_de_impresion), (Puntero_objeto) y (Columnas/Filas).
	defw Vida_2,Amadeus_Fb,$0302
	defw Vida_3,Amadeus,$0302

Indice_de_escudos:

	defw Escudo_1,Escudo_00,$0201
	defw Escudo_2,Escudo_00_Fb,$0301
	defw Escudo_3,Escudo_00,$0201

Msg_level_index:

	defw Msg_1
	defw Msg_2
	defw Msg_3
;	defw Msg_4

	defw 0
	defw 0

Indice_de_cajas_master:

	defw Caja_master_1
	defw Caja_master_2
	defw Caja_master_3

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

Indice_de_definiciones_de_entidades:

	defw Entidad_Clase_1
	defw Entidad_Clase_2
	defw Entidad_Clase_3
	defw Entidad_Clase_4
	defw Entidad_Clase_5
	defw Entidad_Clase_6

Indice_de_disparos_entidades:

	defw Disparo_1
	defw Disparo_2
	defw Disparo_3
	defw Disparo_4
	defw Disparo_5
	defw Disparo_6
	defw Disparo_7

Indice_de_mov_segun_tipo_de_entidad:

	defw Indice_mov_Baile_de_BadSat											;	(Tipo)="$81"
	defw Indice_mov_Baile_de_Badplate 										;	(Tipo)="$82"
; 	defw ...
	defw 0

Indice_de_tablas_Random:

; Entidades (Tipo) (1), (2) y (3). Son entidades (tipo) BadSat.

	defw Tabla_Random_BadSat
	defw Tabla_Random_Badplate
	defw 0

;	...
;	...
;	+ Tablas ...

	defw 0


Index_big_numbers:

	DEFW Cero
	DEFW Uno
	DEFW Dos
	DEFW Tres
	DEFW Cuatro
	DEFW Cinco
	DEFW Seis
	DEFW Siete
	DEFW Ocho
	DEFW Nueve

Indice_de_digitos_score:

	DEFW	Cero_Score
	DEFW	Uno_Score
	DEFW	Dos_Score
	DEFW	Tres_Score
	DEFW	Cuatro_Score
	DEFW	Cinco_Score
	DEFW	Seis_Score
	DEFW	Siete_Score
	DEFW	Ocho_Score
	DEFW	Nueve_Score

Indice_Explosion_entidades:

	defw Explosion_entidades_1
	defw Explosion_entidades_2
	defw Explosion_entidades_3

Indice_Explosion_Amadeus:

	defw Explosion_Amadeus_1
	defw Explosion_Amadeus_2
	defw Explosion_Amadeus_3

Indice_disparo_Amadeus:

	defw Disparo_0
	defw Disparo_f9
	defw Disparo_fb
	defw Disparo_fd

Indice_Amadeus_der:

	defw Amadeus
	defw 0
	defw Amadeus_F9								; [$F9] right - [$FA] left
	defw 0
	defw Amadeus_Fb     						; [$FB] right - [$FC] left
	defw 0
	defw Amadeus_Fd								; [$FD] right - [$FE] left
	defw 0	 									; (Fín de índice).

Indice_Amadeus_izq:

	defw Amadeus
	defw 0
	defw Amadeus_Fd								; [$F9] right - [$FA] left
	defw 0
	defw Amadeus_Fb     						; [$FB] right - [$FC] left
	defw 0
	defw Amadeus_F9								; [$FD] right - [$FE] left
	defw 0	 									; (Fín de índice).

Indice_Badsat_izq:

	defw Badsat_izquierda
	defw Badsat_izq_fe
	defw Badsat_izq_fd
	defw Badsat_izq_fc
	defw Badsat_izq_fb
	defw Badsat_izq_fa
	defw Badsat_izq_f9
	defw Badsat_izq_f8

Indice_Badsat_der:

	defw Badsat_derecha
	defw Badsat_der_f8
	defw Badsat_der_f9
	defw Badsat_der_fa
	defw Badsat_der_fb
	defw Badsat_der_fc
	defw Badsat_der_fd
	defw Badsat_der_fe

Indice_Badplate_der:

	defw Badplate
	defw Badplate_f8
	defw Badplate_f9
	defw Badplate_fa
	defw Badplate_fb
	defw Badplate_fc
	defw Badplate_fd
	defw Badplate_fe

Indice_Badplate_izq:

	defw Badplate
	defw Badplate_fe
	defw Badplate_fd
	defw Badplate_fc
	defw Badplate_fb
	defw Badplate_fa
	defw Badplate_f9
	defw Badplate_f8

; -----------------------------------------------------------

;   Tables.

Tabla_de_pintado: ds 30								; No puede haber cambio de byte alto en la Tabla_de_pintado.

	org $a200

Tabla_de_borrado: ds 24

Non_authorized_KEY_CODES:

    db $27,$18,$23,$24,$1c,$14,$0c,$04,$03,$0b,$13,$1b

Tabla_de_puntuacion:

	db 20
	db 30
	db 40
	db 50
	db 60

Tabla_de_conversion_KEYCODE_ASCII_CODE:

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


Tabla_Random_BadSat:

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

Tabla_Random_Badplate:

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
