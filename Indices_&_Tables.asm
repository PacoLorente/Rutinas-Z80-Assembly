
;   Índices.

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

