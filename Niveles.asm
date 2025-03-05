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

Tabla_Random_Entidad_tipo_1

	defw $0a01
	defw Random_1_1_10

	defw $0f01
	defw Random_2_1_15

	db 0,2
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

Aplica_rnd_al_baile

	call RND_ini

Decoder xor a
	ex af,af 			; Inicializa contador en A´.

; digit ctrl ??
; yes if "$00".

	ld a,(hl)
	and a
	jr nz,Load_limits

; Almacenamos en A' el nº de direcciones que compartiran nº rnd.

	inc l
	ld a,(hl)	
	ex af,af
	inc l
	ld a,(hl)

Load_limits

	ld c,a
	inc l
	ld b,(hl)

;	Límites en BC.

	inc l

	call Siguiente_Random_de_la_tabla
	ret z  									; FIN de la tabla_Random.

;	HL apunta a la dirección donde hemos de alojar el nº rnd.
;	Obtenemos el nº RND.

1 call Get_rnd
	call Filtra_rnd

;	Introducimos nº rnd filtrado.

	ld (hl),a
	ex de,hl

;	A'??

	ex af,af
	and a
	jr z,Decoder

; Más direcciones con el mismo mov.

	jr $

	dec a
	ex af,af
	call Siguiente_linea

	ret

; ----- ----- -----

RND_ini	exx
	ld hl,Numeros_aleatorios+6
	ld b,7
	exx
	ret
; ----- ----- -----

Get_rnd	exx
	ld a,(hl)
	djnz 1F
	exx
	call RND_ini
	ret
1 dec l
	exx
	ret

; ----- ----- -----

Filtra_rnd and %00001111		; Nº permitidos de (0-15).
	cp b
	ret z 						; RET, nº rnd = Límite sup.	
	jr c,1F

	ld a,b 						; RET, nº rnd = Límite sup.
	ret

;	Comprobamos el límite inferior.

1 cp c
	ret z 						; RET, nº rnd = Límite inf. 
	ret nc 						; RET, nº rnd dentro de los límites.
	ld a,c 						; RET, nº rnd = Límite inf. 
	ret

; ----- ----- -----

Siguiente_Random_de_la_tabla call Extrae_address

	ld a,h
	or l
	ret z 						; Hemos completado la tabla Random.

	inc e
	inc e

	ret

; ----- ----- -----

Siguiente_linea

	ret