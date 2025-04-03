; 19/1/24

Indice_de_niveles

	defw Nivel_1
	defw Nivel_2

;	...
;	...
;	+ Niveles ...

	defw 0
	defw 0

; NIVEL_1. Tres tipos de BadSat. 

Nivel_1 db 2
	db 1,2

Nivel_2 db 12									; Nº de entidades.
	db 2,1,1,1,1,2								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 2,1,1,1,1,2

	defw 0
	defw 0

; --------------------------------------------------------------------------------------------------------------

Indice_de_tablas_Random

; Entidades (Tipo) (1), (2) y (3). Son entidades (tipo) BadSat.

	defw Tabla_Random_BadSat
	defw Tabla_Random_BadSat
	defw Tabla_Random_BadSat

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

	db 0,2
	defw $0f01
	defw Random_6_1_15	;	Igual
	defw Random_7_1_15	;	Igual

	defw 0

