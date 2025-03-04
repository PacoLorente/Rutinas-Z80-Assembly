; 19/1/24

Indice_de_niveles

	defw Nivel_1
	defw Nivel_2

;	...
;	...
;	+ Niveles ...

	defw 0
	defw 0

Nivel_1 db 1									; Nº de entidades.
	db 1										; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.		

Nivel_2 db 12									; Nº de entidades.
	db 2,1,1,1,1,2								; Tipo de entidad que vamos a introducir en las 7 cajas de DRAW.			
	db 2,1,1,1,1,2

; --------------------------------------------------------------------------------------------------------------

Indice_de_tablas_Random

	defw Tabla_Random_Entidad_tipo_1
;	defw Tabla_Random_Entidad_tipo_2
;	...
;	...
;	+ Tablas ...

	defw 0
	defw 0

; --------------------------------------------------------------------------------------------------------------
;
;	4/3/25
;
;	En 1er lugar identificamos si existe .db de CTRL, ($a2).
;	$a2 indica que se debe de introducir el mismo nº RND en las dos siguientes defw.
;	Los 2 siguientes .db indican el rango del nº aleatorio:
;
;	1er .db (valor mín.)
;	2º .db (valor máx.)

Tabla_Random_Entidad_tipo_1

	db 1,10
	defw Random_1_1_10

	db 1,15
	defw Random_2_1_15

	db $a2,1,15
	defw Random_3_1_15	;	Igual
	defw Random_4_1_15	;	Igual

	db 1,15
	defw Random_5_1_15

	db $a2,1,15
	defw Random_6_1_15	;	Igual
	defw Random_7_1_15	;	Igual

	defw 0

Aplica_rnd_al_baile


	ret