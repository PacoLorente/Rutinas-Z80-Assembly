; ---------------------------------------------------------------------------------------------------------------------
;
;	13/03/24
;
;	Inicialización de los álbumes de líneas, (pintado/borrado).

Inicia_albumes_de_lineas

	ld hl,Scanlines_album
	ld (Album_de_pintado),hl
	ld (Scanlines_album_SP),hl

	ld hl,Scanlines_album_2
	ld (Album_de_borrado),hl

	ret

Inicia_albumes_de_lineas_Amadeus

	ld hl,Amadeus_scanlines_album
	ld (Album_de_pintado_Amadeus),hl
	ld hl,Amadeus_scanlines_album_2
	ld (Album_de_borrado_Amadeus),hl

	ret

Inicia_albumes_de_disparos

	ld hl,Amadeus_disparos_scanlines_album
	ld (Album_de_pintado_disparos_Amadeus),hl
	ld hl,Amadeus_disparos_scanlines_album_2
	ld (Album_de_borrado_disparos_Amadeus),hl

	ld hl,Entidades_disparos_scanlines_album
	ld (Album_de_pintado_disparos_Entidades),hl
	ld (Nivel_scan_disparos_album_de_pintado),hl

	ld hl,Entidades_disparos_scanlines_album_2
	ld (Album_de_borrado_disparos_Entidades),hl

	ret

;---------------------------------------------------------------------------------------------------------------
;
;   17/4/25
;
;	Prepara las CAJAS MASTER y genera los movimientos masticados de todas las entidades que aparecerán en el nivel.
;
;	INPUTS:		B contiene (Numero_de_entidades).
;						C contiene el (Tipo) de la 1ª entidad del nivel.
; 					 	HL contiene (Datos_de_nivel).

Genera_movimientos_masticados_del_nivel 

	push hl															; Push (Datos_de_nivel).
	push bc														; Push (Numero_de_entidades)/(Tipo).

;	Preparamos el puntero_master para que apunte al .defw correspondiente del índice según el (Tipo) de entidad.

	ld a,c														
	ex af,af
	ld a,c 															; (Tipo) de la entidad en A y A´.

	call Situa_en_Caja_Master							; Situa HL en el 1er .db de la "Caja Master" que corresponde a este (Tipo) de entidad.

;	Caja Master inicializada ???
;	HL en el 1er .db de la Caja Master correspondiente, (definida por (Tipo)).

	ld a,(hl)
	and a
	jr nz,Movimientos_masticados_construidos 

	ex af,af 																			; (Tipo) de la entidad en A.

	call Definicion_segun_tipo												; HL apunta al 1er .db que define la entidad.
	call Definicion_de_entidad_a_bandeja_DRAW					; Vuelca los datos de la definición de entidad en DRAW.

; 	Ya tenemos la definición de entidad en la bandeja_DRAW.
;	Inicializamos (Puntero_de_almacen_de_mov_masticados) para poder generar todos los mov. masticados.

	ld hl,(Puntero_indice_de_almacenes)
	call Extrae_address
	ld (Puntero_de_almacen_de_mov_masticados),hl 			; Fija el (Puntero_de_almacen_de_mov_masticados) al comienzo del 1er almacén.


;	Construimos movimientos masticados de este (Tipo) de entidad.

	ld b,7   											 						
	ld hl,Numeros_aleatorios_baile 							
	call Derivando_RND 										 	; Generamos 7 nº RND para construir los mov. masticados.

; $88f6 (Donde se almacenan los nº aleatorios). 

	ld a,(Tipo)

	call Situa_en_Tabla_Random 						; Sitúa HL en el 1er .db de la `Tabla_Random´ del (Tipo) de entidad correspondiente.
;	$8c45

	call Aplica_rnd_al_baile

	pop bc
	pop hl

	push hl
	push bc

; 	Antes de empezar a generar los "movimientos masticados" de esta entidad necesitamos determinar su (Posicion_inicio).

	ld hl,Numeros_aleatorios_baile+3								
	ld a,(hl)
	and $1f																			; Define el nº de columna por el que va a aparecer la entidad.

	ld hl,Posicion_inicio
	ld (hl),a

	ld a,(Tipo)
	call Situa_Puntero_indice_mov			 	 						; Sitúa (Puntero_indice_mov) según el (Tipo) de entidad en el 1er .defw del índice de su coreogradía.

;	Ya disponemos de una (Posicion_inicio) aleatoria y la definición de la entidad en la "Bandeja DRAW". 
;	Generamos "Movimientos masticados" de la entidad.

	call Construye_movimientos_masticados_entidad

	ld hl,(Puntero_indice_master)
	call Extrae_address

	ld e,l
	ld d,h

	call Parametros_de_bandeja_DRAW_a_caja	 				; Caja de entidades Master completa.

Movimientos_masticados_construidos 

; Generamos un nuevo set de nº aleatorios para poder generar un NUEVO baile distinto.

	jr $

	pop bc																				; Pop (Numero_de_entidades)/(Tipo).
	pop hl																				; Pop (Datos_de_nivel).

	inc l																					; Datos_de_nivel +1 en HL.

	ld c,(hl)																			; (Tipo) de la siguiente entidad en C.
	djnz Genera_movimientos_masticados_del_nivel 			; dec (Numero_de_entidades).

	ret

; -----------------------------------------------------------------------------------
;
;	20/01/24
;
;

Construye_movimientos_masticados_entidad	

	ld hl,(Puntero_de_almacen_de_mov_masticados)			; Guardamos en la pila la dirección inicial del puntero, (para reiniciarlo más tarde).
	push hl
	call Actualiza_Puntero_de_almacen_de_mov_masticados 	; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;															; _ el (Contador_de_mov_masticados).    
	call Inicia_Puntero_objeto								; Inicializa (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq).
;															; Inicializa (Puntero_objeto) en función de la (Posicion_inicio) de la entidad.	
	call Recompone_posicion_inicio

1 call Draw

	call Codifica_Puntero_de_impresion
	call Guarda_movimiento_masticado

	call Movimiento

	ld a,(Ctrl_3)											; El bit1 de (Ctrl_3) a "1" indica que hemos completado todo el patrón de movimiento_
	bit 1,a 												; _ que corresponde a esta entidad.
	jr z,1B

;	jr $


; Hemos completado un ^ Almacén_de_mov_masticados ^.
; Vamos a asignar una dirección de comienzo al almacén siguiente.

	call Situa_en_nuevo_almacen

;	Hemos completado el almacén de movimientos masticados de la entidad. ($EBB4).
;	Reinicializamos (Puntero_de_almacen_de_mov_masticados).

	pop hl 													; Recuperamos la dirección inicial de (Puntero_de_almacen_de_mov_masticados).

	ld (Puntero_de_almacen_de_mov_masticados),hl

; Guardamos el nº total de movimientos masticados de esta entidad en su (Contador_general_de_mov_masticados). 

	call Situa_en_contador_general_de_mov_masticados

; HL apunta al 1er byte del (Contador_general_de_mov_masticados) de esta entidad.
; Guardamos (Contador_de_mov_masticados) en el (Contador_general_de_mov_masticados) de esta entidad.

	ld bc,(Contador_de_mov_masticados)

	ld (hl),c
	inc hl
	ld (hl),b

	ret

; -----------------------------------------------------------------------------------
;
;	28/12/23
;
;	Guarda el "movimiento_masticado" en el {Almacen_de_movimientos_masticados} de la entidad.
;	Actualiza el (Puntero_de_almacen_de_mov_masticados) tras el guardado.

Guarda_movimiento_masticado	

	ld (Stack),sp
	ld sp,(Puntero_de_almacen_de_mov_masticados)			; Guardamos el movimiento masticado en el almacén.

    push ix 												; Pushea el Puntero_de_impresión, (1er scanline).
    push iy 												; Pushea Puntero_objeto.
 
    ld sp,(Stack)

   	ld hl,(Contador_de_mov_masticados)						; Incrementa en una unidad el (Contador_de_mov_masticados).
	inc hl
	ld (Contador_de_mov_masticados),hl

    call Actualiza_Puntero_de_almacen_de_mov_masticados 	; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;															; _ el (Contador_de_mov_masticados).    
    ret

; -----------------------------------------------------------------------------
;
;	3/4/25
;
;	Adelanta (Puntero_indice_de_almacenes) dentro del índice de almacenes de mov. masticados.
;	Sitúa (Puntero_de_almacen_de_mov_masticados) al principio del siguiente almacén.

Situa_en_nuevo_almacen ld hl,(Puntero_de_almacen_de_mov_masticados)

	dec hl
	dec hl

	ex de,hl

	ld hl,(Puntero_indice_de_almacenes)
	inc l
	inc l
	ld (Puntero_indice_de_almacenes),hl

	ld (hl),e
	inc l
	ld (hl),d

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	6/3/25
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
;	Tabla_Random_Entidad_tipo_1

;	defw $0f01
;	defw Random_2_1_15

;	db 0,2
;	defw $0f01
;	defw Random_3_1_15	;	Igual
;	defw Random_4_1_15	;	Igual

;	defw 0

Aplica_rnd_al_baile

	call RND_ini

	xor a

2 ex af,af 										; A' contiene el .db que acompaña al byte de control, ($00).
;												; Inicializamos a $00, (no existe).

; 	digit ctrl ??
;   Yes if "$00".
;	HL se encuentra en el 1er .db de la Tabla_Random de la entidad correspondiente.	

	ld a,(hl)
	and a
	jr nz,Load_limits							; A es NZ. El nº RND sólo se aplica a una única dirección de mem.

; Almacenamos en A' el nº de direcciones que compartiran nº RND y sitúamos HL en el .defw que indica los límites.

	inc l
	ld a,(hl)	
	ex af,af
	inc l
	ld a,(hl)

Load_limits

	ld c,a
	inc l
	ld b,(hl)

;	Límites que tendrá este nº RND en BC.
;	B contiene lím.sup. y C contiene límite inf.

	inc l

	call Extrae_address_y_avanza
	ret z  										; Z Indica: FIN de la Tabla_Random.

;	HL apunta a la dirección donde hemos de alojar el nº rnd.
;	DE está situado en la siguiente línea de la Tabla.
;	Obtenemos el nº RND.

1 call Get_RND    								; Nº RND , (sin filtrar) en A.
	call Filtra_RND

;	Introducimos nº rnd filtrado.

3 ld (hl),a
	ex de,hl

;	Tenemos que seguir utilizando este nº RND con la siguiente .defw ???
;	Para averiguarlo consultamos el byte de "Repeticiones", (A´).

	ex af,af
	and a
	jr z,2B

; Más direcciones con el mismo mov.

	dec a
	ex af,af

	push af
	call Extrae_address_y_avanza
	pop af

	jr 3B

	ret

; ----- ----- -----
;
;	HL' será el puntero que se irá desplazando por los distintos nº aleatorios.
;	Comenzamos por el último, (Numeros_aleatorios+6).
;	B actúa como contador, (7 nº aleatorios).	

RND_ini	exx
	ld hl,Numeros_aleatorios_baile+6
	ld b,7
	exx
	ret

; ----- ----- -----
;
;	Extrae el nº aleatorio, decrementa el contador de nº RND, (B) y actualiza el puntero HL' situándolo en el siguiente nº.
;	Inicializamos HL y B cuando hemos terminado de introducir todos los nº., (call RND_ini).
;		

Get_RND	

	exx
	ld a,(hl)
	djnz 1F
	exx
	call RND_ini
	ret
1 dec l
	exx
	ret

; ----- ----- -----

Filtra_RND and %00111100		; Convertimos el byte, (RND), en Nibble, valores comprendidos entre (0-15).
	srl a	 					
	srl a  						; % 00001111, nº RND (0-15).

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

Extrae_address_y_avanza call Extrae_address

	ld a,h 						
	or l
	ret z 						; Detecta FIN de Tabla_Random.
				
	inc de
	inc de 						; DE será el puntero que se irá desplazando por las distintas líneas de la Tabla_Random.
	;							; Lo situamos en la siguiente línea de la tabla.

	ret

;---------------------------------------------------------------------------------------------------------------
;
;   7/3/25
;
;	Inicializa el 1er Nivel del juego.
;	
;	OUTPUT:	Inicializa: (Puntero_indice_NIVELES) ... Situado en el 1er Nivel del Índice de Niveles, (.defw).
;									(Numero_de_entidades)    ... Contiene el nº de entidades del nivel, (.db).
;									(Datos_de_nivel)         ... Puntero,  (.defw). Define el (Tipo) de las distintas entidades que componen el nivel.
;
;					B contiene (Numero_de_entidades).
;					C contiene el (Tipo) de la 1ª entidad del nivel.
;
;	MODIFY: A,HL,BC y DE.

Inicializa_Nivel 

	ld hl,Indice_de_niveles
	call Extrae_address   						 									; Sitúa HL en el 1er byte que define el 1er nivel del juego, (Nº de entidades).
	ld (Puntero_indice_NIVELES),de											; Inicializa (Puntero_indice_NIVELES), contiene: defw Nivel_1

	ld a,(hl)
	ld (Numero_de_entidades),a					 							; Inicializa (Numero_de_entidades).
	ld b,a

	inc l
	ld (Datos_de_nivel),hl															; Inicializa (Datos_de_nivel), .defw que define el (Tipo) de la 1ª entidad del Nivel_1	 
	ld c,(hl)													

	ret 										 

; ----------------------
;
;	4/3/25
;

Situa_en_Caja_Master

    call Calcula_salto_en_BC
    ld hl,Indice_de_cajas_master
    and a
    adc hl,bc
  	ld (Puntero_indice_master),hl
	call Extrae_address
	ret

; -----------------------------------------------------------
;
;	7/3/25

;	INPUTS: A contiene el (Tipo) de la entidad que estamos iniciando.

Situa_en_Tabla_Random

    call Calcula_salto_en_BC
	ld hl,Indice_de_tablas_Random
    and a
    adc hl,bc
  	ld (Puntero_tabla_Random),hl
	call Extrae_address
	ret

; -----------------------------------------------------------
;
;	6/3/25

Situa_Puntero_indice_mov 

	ld a,(Tipo)     	 						; Cargamos A con el (Tipo) de la entidad del Nivel.       
    call Calcula_salto_en_BC
    ld hl,Indice_de_mov_segun_tipo_de_entidad
    and a
    adc hl,bc
    call Extrae_address

; La entidad que estamos iniciando es de Tipo 1, (BadSat)??
; Si es así, hay que seleccionar una "danza izq. o derecha", dependiendo del lado de la pantalla desde_
; _el que se inicia la entidad.

	ld a,(Tipo)
	and %01111111
	dec a
	jr nz,1F

; Seleccionamos Danza.

	ld a,(Posicion_inicio)
	cp $10
	jr c,1F

	inc l
	inc l

1 call Extrae_address
	ld (Puntero_indice_mov),hl
 
    ret

;---------------------------------------------------------------------------------------------------------------
;
;   13/11/24
;
;	Esta rutina se encarga de prepara todas las cajas de entidades. Cuando comienza un nivel han de estar todas completas.


Prepara_Cajas_de_Entidades

; Preparamos los punteros de las cajas de entidades:

	call Inicia_punteros_de_cajas								; Situa (Puntero_store_caja) en el 1er .db de la 1ª caja del índice de entidades.
;																; Situa (Puntero_restore_caja) en el 1er .db de la 2ª caja del índice de cajas de entidades.
	call Inicializa_Numero_parcial_de_entidades					; Actualiza (Numero_de_entidades) y (Numero_parcial_de_entidades).
	ld hl,(Datos_de_nivel)										; Tipo de la 1ª entidad del Nivel.

; En este punto:
;
; HL está situado en el 1er .db del Nivel que indica el `tipo´ de entidad a volcar en la 1ª caja de entidades.
; B contiene (Numero_parcial_de_entidades).

1 push bc 														; Push (Numero_parcial_de_entidades).

	ld a,(hl)

	call Situa_en_Caja_Master									; HL apunta al 1er .db, (Tipo) de la "Caja Master" correspondiente al (Tipo) de entidad.

	ld de,(Puntero_store_caja)									; DE apunta al 1er .db de la "Caja de entidades" en curso. 								

	push de
	pop ix 														;! A partir de ahora IX apunta al 1er .db (Tipo) de la entidad, (caja de entidades correspondiente).

	ld bc,13
	ldir														; Caja de entidades completa. HL apuntará ahora al 1er .db de la siguiente caja "Master".

;																; DE apunta ahora al 1er .db de la siguiente caja de entidades.

; En este punto debemos generar coordenadas y puntero de impresión.:
;
; ------------------------------------------------------ IX
; ------------------------------------------------------ IX
; ------------------------------------------------------ IX
; ------------------------------------------------------ IX

	push ix														; Push 1er .db (Tipo) de la entidad, (caja de entidades correspondiente).

	call Obtenemos_puntero_de_impresion

	ld l,(ix+5)
	ld h,(ix+6)													; (Puntero_de_impresion) en HL.

	push de														; Push (Puntero_objeto). 
	push hl														; Push (Puntero_de_impresion).

	call Genera_coordenadas

	ld bc,(Coordenada_X)

	ld (ix+1),c
	ld (ix+2),b													; (Coordenada_X) y (Coordenada_Y) en caja de entidad.

 	call Entidad_a_Tabla_de_pintado								; Almacena la (Coordenada_Y) y dirección dentro de (Scanlines_album_SP) de la entidad en curso.

 	pop ix														; Pop (Puntero_de_impresion) en IX.
	pop de														; Pop (Puntero_objeto) en DE.

	call Genera_datos_de_impresion

	pop ix														; Pop 1er .db (Tipo) de la entidad, (caja de entidades correspondiente).

; Actualizamos (Contador_de_mov_masticados) tras la foto.	

	call Decrementa_Contador_de_mov_masticados
	call Limpiamos_bandeja_DRAW									
	call Incrementa_punteros_de_cajas

; Siguiente entidad del Nivel.

	ld hl,(Datos_de_nivel)										; Nos situamos en el .db que define el (Tipo) de la siguiente_
	inc hl 														; _ entidad del Nivel.

	pop bc 														; Recuperamos (Numero_parcial_de_entidades), (nº de cajas que vamos a rellenar)

	djnz 1B

	ret

; -------------------------------------------------------------------------------------------------------------------
;
;	27/5/24
;
;	Inicia,genera mov. masticados y sitúa en el centro de la pantalla a Amadeus.
;

; 	Cargamos la definición de Amadeus en DRAW.
;	Nos situamos en el 1er .db, (Tipo), de la definición de Amadeus.

Inicia_Amadeus ld hl,Definicion_Amadeus
	call Definicion_de_entidad_a_bandeja_DRAW				; Vuelca los datos de la definición de Amadeus en DRAW.

	
Construye_movimientos_masticados_Amadeus

	ld hl,(Puntero_de_almacen_de_mov_masticados)			; Guardamos en la pila la dirección inicial del puntero, (para reiniciarlo más tarde).
	call Actualiza_Puntero_de_almacen_de_mov_masticados 	; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;															; _ el (Contador_de_mov_masticados).    
	call Inicia_Puntero_objeto								; Inicializa (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq).
;															; Inicializa (Puntero_objeto) en función de la (Posicion_inicio) de la entidad.	

; Generamos movimientos masticados de Amadeus.

	ld b,121												; $0079, 121d.

1 push bc
	call Draw
	call Guarda_movimiento_masticado

	call Mov_right
	call Mov_right											; Amadeus se mueve x2 pixel.

	pop bc
	djnz 1B

; Todos los movimientos masticados de Amadeus se han creado. 

;	(Contador_de_mov_masticados) de Amadeus ="$0079", 121d movimientos en total. Amadeus se encuentra ahora en el extremo derecho de la pantalla.
;	Ahora hay que modificar la posición del (Puntero_de_almacen_de_mov_masticados), (está 4 posiciones de memoria adelantado para seguir creando desplazamientos).

	ld hl,(Puntero_de_almacen_de_mov_masticados)
	ld bc,8
	and a
	sbc hl,bc
	ld (Puntero_de_almacen_de_mov_masticados),hl

	ret

; ---------------------------------------------------------------------
;
;	10/02/24
;
;	Nos situamos en el 1er .db de datos de la definición de este tipo de entidad.
;
;	INPUT: A contiene el TIPO de ENTIDAD que almacenaremos en la caja. 

Definicion_segun_tipo 											

	call Calcula_salto_en_BC									; Calcula el salto para situarnos en la definición de entidad correcta de indice de [Indice_de_definiciones_de_entidades].
	ld hl,Indice_de_definiciones_de_entidades
	call Situa_en_datos_de_definicion							; Sitúa HL en el 1er .db de la definición de entidad tipo que tenemos que volcar en DRAW.
	ret

; ---------------------------------------------------------------------
;
;	6/7/24


Store_Restore_cajas	

	ld de,(Puntero_store_caja) 								
	call Parametros_de_bandeja_DRAW_a_caja	 					; Caja de entidades completa.
	call Incrementa_punteros_de_cajas
	ret

; ---------------------------------------------------------------------
;
;	23/6/24
;
;	Limpiamos lo más rápido posible la Bandeja DRAW.
;
;	MODIFY: HL

Limpiamos_bandeja_DRAW 

	ld (Stack),sp
	ld sp,Vel_left 
	
	xor a
	ld h,a
	ld l,a

	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl

	inc sp

	push hl
	ld sp,(Stack)

	ret

; ---------------------------------------------------------------------
;
;	23/11/24
;
;	Actualiza el (Contador_de_mov_masticados) de la entidad.

Decrementa_Contador_de_mov_masticados 

	ld l,(ix+9)
	ld h,(ix+10)

	dec hl

	ld (ix+9),l
	ld (ix+10),h

	ret

; ---------------------------------------------------------------------
;
;	24/11/24

Reinicia_entidad_maliciosa 

;	En 1er lugar actualizamos el (Contador_de_mov_masticados).

	call Situa_en_contador_general_de_mov_masticados					; [[Movimiento]]
	call Transfiere_datos_de_contadores

; 	En 2º lugar hay que inicializar el (Puntero_de_almacen_de_mov_masticados).

	ld a,(ix+0)															; ld a,(Tipo)

	call Situa_en_Caja_Master

; HL apunta al 1er .db de la Caja_Master_correspondiente a este (Tipo) de entidad.

	ld a,l
	add 7
	ld l,a 																; Situamos en el .defw (Almacen_de_movimientos_masticados) de la Caja_Master correspondiente_ 
; 																			; _a este (Tipo) de entidad.
	call Extrae_address

	ld (ix+7),l
	ld (ix+8),h

	call Obtenemos_puntero_de_impresion

;	El formato: FBPPPIII (Flash, Brillo, Papel, Tinta).
;
;	COLORES: 0 ..... NEGRO
;    		 1 ..... AZUL 
; 			 2 ..... ROJO  ..... "20".
;			 3 ..... MAGENTA .... "10".
; 			 4 ..... VERDE ..... 
; 			 5 ..... CIAN ..... "8".
;			 6 ..... AMARILLO ..... "4".
; 			 7 ..... BLANCO
;

; Incrementa (Contador_de_vueltas)x2. 
; (Velocidad) de la entidad será: (Contador_de_vueltas)/4.

;	1ª vuelta: (Contador_de_vueltas)="$02" --- (Velocidad)="0".
;	2ª vuelta: 	""	""	""	""	""  ="$04" ---   ""	 ""	  ="1".
;	3ª vuelta: 	""	""	""	""	""  ="$08" ---   ""	 ""	  ="2".
;	4ª vuelta: 	""	""	""	""	""  ="$10" ---   ""	 ""	  ="4".
;	5ª vuelta: 	""	""	""	""	""  ="$20" ---   ""	 ""	  ="8".   

	sla (ix+3)									; sla x2 (Contador_de_vueltas). Inicialmente es "1".

	ld a,(ix+3)   								; ld a,(Contador_de_vueltas)	
	sra a
	sra a

	ld (ix+11),a 								; ld (Velocidad),a

; Attr. 

; A contiene (Velocidad).

	call nz, Define_attr 						; No modificamos attr. si no hay cambio de velocidad.

; Límitador. 

	ld a,$40
	cp (ix+3)
	ret nz

;	Limita el valor de (Contador_de_vueltas) a "$20" y de (Velocidad) a "$04". 

	sra (ix+3)
	sra (ix+11)

	ret

; ----- ----- ----- ----- -----
;
;	27/3/25
;
;	Define (Attr) en función de la (Velocidad).
;

Define_attr	

	dec a
	jr z,Amarillo
	inc a

	cp 2
	jr z,Blanco

	cp 4
	jr z,Magenta

Rojo ld a,%01000010	
	jr 2F

Magenta ld a,%01000011
	jr 2F

Blanco ld a,%01000111
	jr 2F

Amarillo ld a,%01000110
2 ld (ix+12),a

	ret

;	------------------------------------------------------------------------------------
;
;	09/11/24
;
;	INPUTS:	A contiene el (Tipo) de entidad. 
;
;	Esta pequeña sub-rutina carga BC con 0,2,4,6,8 ... en función del tipo de entidad: (1,2,3,4,...). 
;	Calcula "el salto" para situarnos en los DATOS de la ENTIDAD correcta del índice de entidades según el tipo de entidad.

Calcula_salto_en_BC and a
	jr z,1F
	sla a										
	sub 2										; ("Tipo_de_entidad")*2-2.
1 ld c,a
	ld b,0 										
	ret

; ------------------------------------------------------------------
;
;	19/1/24
;
;	Sitúa HL en el 1er .db de la definición de la entidad que tenemos que volcar en la bandeja DRAW.
;	Actualiza (Datos_de_entidad) con esa dirección.

Situa_en_datos_de_definicion and a
	adc hl,bc
	call Extrae_address   
    ld (Datos_de_entidad),hl					
	ret

; ----------------------------------------------------------------------------------------------------------
;
;	26/3/25
;
;	Introduce una definición de entidad en la bandeja DRAW para generar los "movimientos masticados" de este tipo_
;	_ de entidad.
;
;	INPUTS: HL apunta al 1er .db de datos de la definición de la entidad.
;			
; 
;	MODIFICA: HL,DE y BC


Definicion_de_entidad_a_bandeja_DRAW 	

	ld de,Bandeja_DRAW	 						; DE apunta al 1er .db de la bandeja_DRAW, (Tipo).
	ld a,(hl) 									; Volcamos Tipo.
	ld (de),a
	inc hl
;												
	ld de,Filas									; Volcamos (Filas) y (Columns).
	ld bc,2
	ldir										; Hemos volcado (Contador_de_vueltas), (Indice_Sprite_der) y (Indice_Sprite_izq).
;												; HL, (origen), apunta ahora al .db (Posicion_inicio), hay que situar DE.
	ld de,Contador_de_vueltas 
	ld a,(hl)
	ld (de),a
	inc hl										; Hemos volcado (Posicion_inicio) y (Cuad_objeto).

	ld de,Indice_Sprite_der
	ld bc,4
	ldir 										; Hemos volcado (Puntero_de_almacen_de_mov_masticados).

	ld de,Posicion_inicio
	ld bc,3										; 3 FRAMES de explosión.!!!!!!!!!!!!!!
	ldir 										; Vuelco (Frames_explosion).

	ld de,Puntero_de_almacen_de_mov_masticados
	ld bc,2
	ldir

	ld de,Attr
	ld a,(hl) 									; Volcamos (Attr).
	ld (de),a

	ret

; ----------------------------------------------------------------------------------------------------------
;
;	26/3/25
;

Parametros_de_bandeja_DRAW_a_caja 

	ld hl,Bandeja_DRAW
	ld bc,13
	ldir													 
	ret

;---------------------------------------------------------------------------------------------------------------
;
;	13/11/24
;
;	INICIALIZA (Numero_parcial_de_entidades).
;
;	Si el nº total de entidades del nivel, (Numero_de_entidades) > 6, (Numero_parcial_de_entidades)="6".
;	Si el nº total de entidades del nivel, (Numero_de_entidades) < 6, (Numero_parcial_de_entidades)=(Numero_de_entidades).

;	OUTPUT: B contiene (Numero_parcial_de_entidades). Nº de cajas que vamos a preparar o rellenar.
;			- Actualiza (Numero_de_entidades).

;	MODIFICA: A y B. 


Inicializa_Numero_parcial_de_entidades 

	ld a,(Numero_de_entidades)							 ; Nº TOTAL de las entidades del NIVEL.
	cp 5												 ; "4" es el nº total de cajas de entidades de las que disponemos.
	jr c,1F
	jr z,1F

; El nº de entidades es superior al que cabe en las cajas DRAW.
; Actualizamos variables.

	sub 5
	ld (Numero_de_entidades),a
	ld a,5
	ld (Numero_parcial_de_entidades),a
	ld b,a
	ret

; El nº total de entidades no supera el nº de cajas de entidades. 
; (Numero_de_entidades)="0".

1 ld (Numero_parcial_de_entidades),a
	ld b,a
	xor a
	ld (Numero_de_entidades),a
	ret

