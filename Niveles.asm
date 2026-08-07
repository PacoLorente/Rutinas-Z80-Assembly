; NIVEL_1. Tres clases de entidades tipo BadSat.

Nivel_1 db $f0,$0a,$70,$70 						; FLIES !!!

;												; 1er byte: Define el valor inicial de (Max_time_to_appear_entities).
;												; 2º byte: Define el valor de (Decrease_top_time_entities).
;												; 3er byte: Valor inicial de (Min_time_to_appear_entities).
; 												; 4º byte: Valor inicial de (CLOCK_disparos_de_entidades).

												
	db 20 										; Nº de entidades que tiene el nivel.

	db 4,5,6,4,5 								; Clases de entidades. (Irán apareciendo por este orden).
	db 6,4,5,6,4
	db 5,6,4,5,6
	db 4,5,6,4,5

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












