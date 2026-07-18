; -----------------------------------------------------------------------
;
;	27/06/26
;

Actualiza_punteros_de_Nivel:


	ld hl,Nivel
	inc (hl)

	ld hl,(Puntero_de_mensajes_de_niveles)
	inc hl
	inc hl
	ld (Puntero_de_mensajes_de_niveles),hl

	ld hl,(Puntero_indice_NIVELES)
	inc hl
	inc hl
    ld (Puntero_indice_NIVELES),hl

    inc hl
    inc (hl)
	dec (hl)
	ret nz

	ld hl,Indice_de_niveles
	ld (Puntero_indice_NIVELES),hl

	ld hl,Msg_level_index
	ld (Puntero_de_mensajes_de_niveles),hl

	ret

; -----------------------------------------------------------------------
;
;	27/06/26
;

Clean_and_initcialize_Draw1:

	ld hl,Variables_DRAW1
	ld bc,(Variables_DRAW2-Variables_DRAW1)-1
	call Clean_mem

	call Inicializa_Variables_DRAW1

	ret

; -----------------------------------------------------------------------------------------
;
;	27/06/26
;
;	Inicializa las variables DRAW. Nueva partida/nuevo nivel.
;

Inicializa_Variables_DRAW:

	ld a,7
	ld (Numero_de_disparos_de_entidades),a

	ld hl,Tabla_de_pintado
	ld (India_SP),hl
	ld hl,Tabla_de_borrado
	ld (India_3_SP),hl

	ld hl,Clock_explosion 									; (Clock_explosion)="4", (Clock_explosion_Amadeus)="5", (Temp_new_live)="100".
	ld (hl),4
	inc hl
	ld (hl),5
	inc hl
	ld (hl),100

	ld hl,Numeros_aleatorios
	ld (RND_SP),hl
	ld (Puntero_num_aleatorios_disparos),hl

	ld a,$a0
	ld hl,Repone_CLOCK_disparos 							; (Repone_CLOCK_disparos) y (CLOCK_disparos_de_entidades) con "$a0".
	ld (hl),a
	inc hl
	ld (hl),a

	inc hl
	inc hl
	inc hl

	ld (hl),5 												; (Start_counter_2) con "$05".

	ld hl,Almacen_de_movimientos_masticados_1
	ld (Puntero_indice_de_almacenes),hl

	ld hl,Datos_Shield
	ld (hl),4
	inc hl
	ld (hl),1
	inc hl
	ld (hl),4
	inc hl
	ld (hl),1

	inc hl
	inc hl
	inc hl

	ld (hl),100

	ld hl,Laser_sound_init_value
	ld (Laser_sound),hl

	ld a,80
	ld (Temp_Amadeus_exit),a

    xor a

    ret

;	Inicializa Variables de nivel DRAW1, (GAME OVER only).

Inicializa_Variables_DRAW1:

	ld hl,Nivel
	ld (hl),1

	ld hl,Indice_de_niveles
	ld (Puntero_indice_NIVELES),hl

	ld hl,Msg_level_index
	ld (Puntero_de_mensajes_de_niveles),hl

	ld hl,Lives
	ld (hl),3
	inc hl
	ld (hl),3

	ld hl,Indice_de_escudos
	ld (Puntero_de_escudos),hl
	ld hl,Indice_de_vidas
	ld (Puntero_de_vidas),hl

	ld a,%01000110
	ld (Attr_big_counter),a

	ld hl,Cero_Score

	ld (Puntero_de_unidades_Score),hl
	ld (Puntero_de_decenas_Score),hl
	ld (Puntero_de_centenas_Score),hl
	ld (Puntero_de_um_Score),hl
	ld (Puntero_de_dm_Score),hl

	ret

; -----------------------------------------------------------------------------------------
;
;	25/06/26
;
;	Reiniciamos partida.
;
;	Limpia Scanlines albums, cajas de disparos y de entidades, tablas de pintado/borrado y_
;	_nº aleatorios y almacenes de movimientos masticados.
;
;	También limpia la bandeja DRAW.

Clean_boxes_and_albums:

;	En 1er lugar limpiamos ((Scanlines_album)) y ((Scanlines_album_2)).

	ld hl,Scanlines_album
	ld bc,562
	call Clean_mem

;	Limpiamos el álbum de disparos de las entidades.

	ld hl,Entidades_disparos_scanlines_album
	ld bc,100
	call Clean_mem

;	Limpiamos todas las cajas de disparos de las entidades.

	ld hl,Disparo_7-5
	ld bc,41
	call Clean_mem

;	Cajas 1 y 2 de Entidades.

	ld hl,Caja_1
	ld bc,27
	call Clean_mem

;	Cajas 3,4 y 5

	ld hl,Caja_3
	ld bc,41
	call Clean_mem

; --------------------------------------------------------------------------------------------

;	Limpiamos:

;	Numeros_aleatorios ds 7
;	Numeros_aleatorios_baile ds 7

;	Tabla_de_pintado ds 30
;	Tabla_de_borrado ds 24

	ld hl,Numeros_aleatorios
	ld bc,67
	call Clean_mem

	ld hl,Almacen_de_movimientos_masticados_2
	ld bc,(Contador_general_de_mov_masticados_3-Almacen_de_movimientos_masticados_2)+1
	call Clean_mem

;	Limpiamos las 3 cajas Master.

	ld hl,Caja_master_1
	ld bc,41
	call Clean_mem

;	Limpiamos la caja de Amadeus.

	ld hl,Amadeus_BOX
	push hl
	ld bc,13
	call Clean_mem
	pop hl

	inc hl
	inc hl
	inc hl

	ld (hl),15

;	Limpiamos Almacenes de movimientos masticados, (Amadeus y entidades).

	ld hl,Almacen_de_movimientos_masticados_Amadeus
	ld bc,$36fe
	call Clean_mem

	ld hl,Amadeus_scanlines_album
	call Inicializa_Amadeus_scanline_album

	ld hl,Amadeus_scanlines_album_2
	call Inicializa_Amadeus_scanline_album

	ld hl,Bandeja_DRAW
	ld bc,(Variables_DRAW1-Bandeja_DRAW)-1
	call Clean_mem

	ret

; ------------------------------------
;
; 	18/11/25

; 	Fija en A un nº aleatorio comprendido entre 0-255 y desplaza el puntero (RND_SP) al siguiente nº.
; 	Si el puntero está situado en el último nº, lo volvemos a situar al principio.

;	DESTRUYE: HL,DE,A
;	OUTPUTS: A contiene un Nº aleatorio. Actualiza el puntero de nº aleatorios (RND_SP).

;	Variables implicadas: (RND_SP).

Extrae_numero_aleatorio_y_avanza:

	ld hl,Numeros_aleatorios+7
	ex de,hl
	ld hl,(RND_SP)

	ld a,e
	sub l
	jr nz,1F

; Sitúa HL al principio de la tabla de nº aleatorios.

	ld hl,Numeros_aleatorios
	ld (RND_SP),HL

; Coloca el nº aleatorio en A y mueve el puntero al siguiente nº.

1 ld a,(hl)
	inc l
	ld (RND_SP),hl

	ret

Inicializa_Amadeus_scanline_album:

;	Nota: No cambia el byte alto.

; 	Amadeus_scanlines_album equ $8234	            ;	($8234 - $8256) 	; Inicialmente 34 bytes, $22.
; 	Amadeus_scanlines_album_2 equ $8258	            ;	($8258 - $827a)

;	Encabezado:

	xor a

	ld (hl),a
	inc l
	ld (hl),a
	inc l
	ld (hl),$10

;	Scanlines:

	ld a,2

2 ld de,$5000
	ld b,8

1 inc l
	ld (hl),e
	inc l
	ld (hl),d 

	inc d

	djnz 1B

	dec a

	jr nz,2B

	ret

; ---------------------------------------------------------------------------------------------------------------------
;
;	13/03/24
;
;	Inicialización de los álbumes de líneas, (pintado/borrado).

Inicia_albumes_de_lineas:

	ld hl,Scanlines_album
	ld (Album_de_pintado),hl
	ld (Scanlines_album_SP),hl

	ld hl,Scanlines_album_2
	ld (Album_de_borrado),hl

	ret

Inicia_albumes_de_lineas_Amadeus:

	ld hl,Amadeus_scanlines_album
	ld (Album_de_pintado_Amadeus),hl
	ld hl,Amadeus_scanlines_album_2
	ld (Album_de_borrado_Amadeus),hl

	ret

Inicia_albumes_de_disparos:

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
;   23/6/25
;
;	Prepara las CAJAS MASTER y genera los movimientos masticados de todos los (Tipo)s de entidades que conforman el nivel.
;
;	INPUTS:		B contiene (Numero_de_entidades).
;				C contiene la (Clase) de la 1ª entidad del nivel.
; 				HL contiene (Puntero_de_entidades).

Prepara_Cajas_Master:

	push hl															; Push (Puntero_de_entidades).
	push bc															; Push (Numero_de_entidades)/(Clase).

;	Preparamos el puntero_master para que apunte al .defw correspondiente del índice según el (Tipo) de entidad.

	ld a,c														
	ex af,af
	ld a,c 															; (Clase) de la entidad en A y A´.

	call Situa_en_Caja_Master										; A="0" Indica que hemos de generar los movimientos masticados de esta (Clase) de entidad.
; 																	; A=NZ indica que esta (Clase) de entidad ya tiene generados los mov_masticados.
; 																	; Saltaremos a la siguiente entidad del nivel.
	and a
	jr nz, Avanza_siguiente_entidad_del_nivel

; Generamos movimientos masticados.

;	En 1er lugar cargaremos la bandeja DRAW con la definición de esta (Clase) de entidad para poder generar todos los movimientos masticados.

	ld a,c 															; (A) = (Clase).

	call Definicion_segun_tipo										; HL apunta al 1er .db que define la entidad.
	call Definicion_de_entidad_a_bandeja_DRAW						; Vuelca los datos de la definición de entidad en DRAW.

;	Antes de fabricar los movimientos masticados de una entidad generaremos un set de 7 nº aleatorios.
;	Así nos aseguramos de que dos entidades `del mismo (Tipo)', (que comparten PATRÓN_DE_MOV) tengan_
;	coreografías distintas.

	ld b,7   											 						
	ld hl,Numeros_aleatorios_baile 							
	call Derivando_RND 										 		; Generamos 7 nº RND para construir los mov. masticados.

	ld a,(Tipo)
	call Situa_en_Tabla_Random 										; Sitúa HL en el 1er .db de la `Tabla_Random´ del (Tipo) de entidad correspondiente.

	call Aplica_rnd_al_baile 										; Esta rutina es la encargada de aplicar aleatoriedad a la danza de esta (Clase) de enemigo.;

	pop bc
	pop hl

	push hl															; Push (Puntero_de_entidades).
	push bc															; Push (Numero_de_entidades)/(Clase).

; 	Antes de empezar a generar los "movimientos masticados" de esta entidad necesitamos determinar su (Posicion_inicio).

	call Determina_posicion_de_inicio 								; $941e ($78),($76),($72)

	ld a,(Tipo)
	call Situa_Puntero_indice_mov			 	 					; Sitúa (Puntero_indice_mov) según el (Tipo) de entidad en el 1er .defw del índice de su coreogradía.

;	Ya disponemos de una (Posicion_inicio) aleatoria y la definición de la entidad en la "Bandeja DRAW". 
;	Generamos "Movimientos masticados" de la entidad.

	call Construye_movimientos_masticados_entidad

Movimientos_masticados_construidos:

	ld hl,(Puntero_indice_master)
	call Extrae_address

	ld e,l
	ld d,h

	call Parametros_de_bandeja_DRAW_a_Caja_Master	 				; Caja de entidades Master completa.

;	Limpiamos la bandeja_DRAW y las variables de movimiento para poder generar los mov. masticados_
;	_de otro (Tipo) de entidad.
;
;	Limpiamos bandeja y variables.

	xor a
	ld (Ctrl_3),a 													; (Ctrl_3) ha de inicializarse pués lo utilizamos para indicar_
;																	; _, (entre otras cosas) cuando finalizamos de generar los mov. masticados.
	ld hl,Clase
	ld bc,Gestion_de_ENTIDADES_y_CAJAS-Bandeja_DRAW

	dec bc

	call Clean_mem

; 	Avanza a la siguiente entidad del nivel.

Avanza_siguiente_entidad_del_nivel:

	pop bc															; Pop (Numero_de_entidades)/(Tipo).
	pop hl															; Pop (Puntero_de_entidades).

	inc hl															; Puntero_de_entidades +1 en HL.
	ld (Puntero_de_entidades),hl 									; Actualizamos (Puntero_de_entidades).

	ld c,(hl)														; (Tipo) de la siguiente entidad en C.
	djnz Prepara_Cajas_Master 										; dec (Numero_de_entidades).

; Una vez terminados los movimientos masticados de los distintos TIPOS de entidades, 
; _ inicializamos el puntero (Puntero_de_entidades), situándolo en la 1ª entidad.

	ld hl,(Puntero_indice_NIVELES)
	call Extrae_address

	inc hl
	inc hl
	inc hl
	inc hl

	ld (Puntero_de_entidades),hl

	ret

; -----------------------------------------------------------------------------------
;
;	14/06/26
;
;	Asigna una columna de inicio aleatoria y distinta a cada una de las 3 Clases como máximo que pueden aparecer en un nivel.

Determina_posicion_de_inicio:

;	jr $

	ld hl,Numeros_aleatorios_baile+3
	ld a,(hl)
	and $1f															; Define el nº de columna por el que va a aparecer la entidad.

;	Tenemos un nº aleatorio, (Columna de inicio) en A.
; 	No queremos que se repita la posición de inicio en dos clases distintas de entidades.

	ld d,a 															; $08,$12,$0c --- $08,$02,$12 --- $18,$1c,$18 --- $1e,$1c,$18

	call No_repeat

	ld a,(Tipo)														; (Tipo) $81 Badsat, $82 Badplate.
	and 2
	ld a,d
	jr z,1F

; 	Entidad tipo Badplate. Si nuestro nº RND es "<= $0f" aparecerá por la izquierda. Si es superior iniciará por la derecha.

	cp $0f
	jr c,2F

	ld a,$1f
	jr 1F

2 xor a

;	Entidad (Tipo)="$81", BadSat. Puede iniciar su baile desde cualquier columna.

1 ld hl,Posicion_inicio
	add (hl)
	ld (hl),a

	ret

; -------------------------------------------------------------------
;
;	14/07/26
;

No_repeat:

	jr $

	ld e,0 													; Necesitamos retornar con "Z" de la rutina.

1 ld hl, Almacen_de_movimientos_masticados_Amadeus        	; Utilizamos el almacén de mov. de Amadeus pués aún no está inicializado.

2 cp (hl)
	call z, Posicion_rep
	jr z,1B

	inc (hl)

	call z, Almacena_pos
	ret z

	dec (hl)

;	Siguiente posición almacenada.

	inc hl

	jr 2B

; ------------------------------------------------

Posicion_rep:

;	Si el nº aleatorio es "0" y (hl) no contiene datos se tomará como nº aleatorio repetido.

	cp $10
	jr c,1F

	dec a
	dec a

	jr 2F

1 inc a
	inc a

2 inc e
	dec e

	ret

; ------------------------------------------------

Almacena_pos:

; Siempre que entramos en esta rutina tenemos activado el flag C debido a la comparación $xx con $ff.

	and a 				; Indica si A es "0" y pone NC.
	jr z,3F

1 cp $1e
	jr nc,3F

	ld (hl),a

	inc a
	inc hl

3 ld (hl),a

	inc a
	inc hl

	ld (hl),a

	xor a

	ret

; -------------------------------------------------------------------------------------------------------y
;
;	16/07/26
;
;	INPUTS: A y D contienen el nº aleatorio ($00 - $1f).
;			HL apunta a Almacen_de_movimientos_masticados_Amadeus 
;
;	MODIFY: HL y BC.
;
;			Vamos a sustituir los "0" de los nueve primeros .db del almacén por $ff.
;			Evitamos así que cuando el nº aleatorio sea "0" y el byte del almacén también se detecte como_
;			_repetición y no se almacene la posición "0".

No_zeros:

	ld hl,Almacen_de_movimientos_masticados_Amadeus + 2

	dec (hl)
	dec hl
	dec (hl)
	dec hl
	dec (hl)

	ret

; **********************************************************************************************************************************************************
;
;   15/06/26
;
;	Recompone_posicion_inicio
;
; 	La rutina hace una llamada a [Mov_right] o [Mov_left] según su posición de inicio.
;	Así conseguimios que la entidad esté completamente oculta a la hora de aparecer por la izquierda_
;	_ o derecha. Tomaremos la columna de (Posicion_inicio) como referencia para hacer la llamada_
;	_ a una u otra rutina.

Recompone_posicion_inicio:

	ld a,1

	ld hl,Vel_left
	ld (hl),a

	inc hl

	ld (hl),a 														; (Vel_left) y (Vel_right) a "1".

;	El primer Sprite que se imprime en pantalla en cualquier patrón de movimientos será un "sprite vacío".
;	El objeto "SIEMPRE" ha de aparecer `oculto'. Tanto si aparece de arriba a abajo como si lo hace por los extremos de la pantalla.

	ld hl,Ctrl_2
	set 0,(hl)														; Indica que fijamos un "sprite vacío" en (Puntero_objeto).

	ld hl,(Posicion_inicio)
	ld (Posicion_actual),hl 										; (Posicion_actual) no puede contener "0" para poder ejecutar (Mov_lef) o (Mov_right).

	ld a,l
	and $1f
	jr z,1F

	cp $1f
	jr nz,2F

;	Vamos a aparecer por la parte derecha de la pantalla.

	call Mov_left

; No vamos a aparecer por ningún extremo. Cargamos Sprite vacío pues vamos a ir apareciendo por la_
; _parte alta de la pantalla.

2 ld hl,(Puntero_objeto)
	ld (Repone_puntero_objeto),hl

	ld hl,Sprite_vacio
	ld (Puntero_objeto),hl

; Colocamos (Posicion_actual) a "$00" para que la rutina DRAW inicialice esta entidad.

	ld hl,0
	ld (Posicion_actual),hl

	ret

; Vamos a aparecer por la parte izquierda de la pantalla.

1 call Mov_right

	jr 2B

; *************************************************************************************************************************************************************
;
;	14/6/26
;
;	Iniciamos (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq).
;	Sitúa (Puntero_objeto) en el Sprite correspondiente en función de su (Posicion_inicio).
;
;   Destruye HL y BC !!!!!,
;
;	BIT 7 (Ctrl_0). "1" ..... Derecha.
;					"0" ..... Izquierda.

Inicia_Puntero_objeto:

	ld a,(Posicion_inicio)
	and $1f
	cp $10
	jr c,Inicia_puntero_objeto_der

; Arrancamos desde la parte derecha de la pantalla.
; Iniciamos (Indice_Sprite_izq).

Inicia_puntero_objeto_izq:

	ld hl,(Indice_Sprite_izq) 								; La definición de la entidad asigna .defw a (Indice_Sprite_izq) cuando iniciamos la Bandeja_DRAW.
	ld (Puntero_DESPLZ_izq),hl

	call Extrae_address

	ld (Puntero_objeto),hl

	ld hl,(Indice_Sprite_der) 								; La definición de la entidad asigna .defw a (Indice_Sprite_der) cuando iniciamos la Bandeja_DRAW.
	ld (Puntero_DESPLZ_der),hl

	ret

; Arrancamos desde la parte izquierda de la pantalla.
; Iniciamos (Indice_Sprite_der).

Inicia_puntero_objeto_der:

	ld hl,(Indice_Sprite_der)
	ld (Puntero_DESPLZ_der),hl 								; La definición de la entidad asigna .defw a (Indice_Sprite_der) cuando iniciamos la Bandeja_DRAW.

	call Extrae_address

	ld (Puntero_objeto),hl

	ld hl,(Indice_Sprite_izq)								; La definición de la entidad asigna .defw a (Indice_Sprite_izq) cuando iniciamos la Bandeja_DRAW.
	ld (Puntero_DESPLZ_izq),hl

	ret

; -----------------------------------------------------------------------------------
;
;	20/01/24
;
;

Construye_movimientos_masticados_entidad:


	ld hl,(Puntero_indice_de_almacenes) 							; Inicialmente situado en el 1er .defw del índice, Almacen_de_movimientos_masticados_1.
	call Extrae_address

	ld (Puntero_de_almacen_de_mov_masticados),hl 					; $c9e6 es la dirección del 1er almacén de mov. masticados. (Puntero_de_almacen_de_mov_masticados) es el puntero que se irá desplazando por el almacén de movimientos masticados_
; 																	; _para ir creando la coreografía de este (Tipo) de entidad.
	push hl


	call Actualiza_Puntero_de_almacen_de_mov_masticados 			; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;																	; _ el (Contador_de_mov_masticados).

	call Inicia_Puntero_objeto										; Inicializa (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq).
;																	; Inicializa (Puntero_objeto) en función de la (Posicion_inicio) de la entidad.

	call Recompone_posicion_inicio


1 call Draw

















;	jr $	;	15/06/26




















; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************

;	Depurador_de_danzas_v01	;	--- macro ---

; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************


	call Codifica_Puntero_de_impresion
	call Guarda_movimiento_masticado
	call Movimiento

	ld a,(Ctrl_3)													; El bit1 de (Ctrl_3) a "1" indica que hemos completado todo el patrón de movimiento_
	bit 1,a 														; _ que corresponde a esta entidad.
	jr z,1B

; Hemos completado un ^ Almacén_de_mov_masticados ^.
; Vamos a asignar una dirección de comienzo al almacén siguiente.

	call Prepara_nuevo_almacen 										; DE contiene (Puntero_de_almacen_de_mov_masticados).

;	Hemos completado el almacén de movimientos masticados de la entidad. 
;	Reinicializamos (Puntero_de_almacen_de_mov_masticados).

	pop hl 															; Recuperamos la dirección inicial de (Puntero_de_almacen_de_mov_masticados).

	ld (Puntero_de_almacen_de_mov_masticados),hl

; Guardamos el nº total de movimientos masticados de esta entidad en su (Contador_general_de_mov_masticados). 

	call Situa_en_contador_general_de_mov_masticados

; HL apunta al 1er byte del 1er (Contador_general_de_mov_masticados) vacío.
; Guardamos (Contador_de_mov_masticados) en el (Contador_general_de_mov_masticados) de esta entidad.

	ld bc,(Contador_de_mov_masticados)

	ld (hl),c
	inc hl
	ld (hl),b

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	14/6/26
;
;	INPUTS: HL a de contener (Puntero_de_almacen_de_mov_masticados).

Actualiza_Puntero_de_almacen_de_mov_masticados:

	ld hl,(Puntero_de_almacen_de_mov_masticados)
	ld bc,4
	and a
	adc hl,bc
	ld (Puntero_de_almacen_de_mov_masticados),hl

	ret

; -----------------------------------------------------------------------------------
;
;	28/12/23
;
;	Guarda el "movimiento_masticado" en el {Almacen_de_movimientos_masticados} de la entidad.
;	Actualiza el (Puntero_de_almacen_de_mov_masticados) tras el guardado.

Guarda_movimiento_masticado:

	ld (Stack),sp
	ld sp,(Puntero_de_almacen_de_mov_masticados)					; Guardamos el movimiento masticado en el almacén.

	push ix 														; Pushea el Puntero_de_impresión, (1er scanline).
	push iy 														; Pushea Puntero_objeto.

	ld sp,(Stack)

	ld hl,(Contador_de_mov_masticados)								; Incrementa en una unidad el (Contador_de_mov_masticados).
	inc hl
	ld (Contador_de_mov_masticados),hl

	call Actualiza_Puntero_de_almacen_de_mov_masticados 			; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;																	; _ el (Contador_de_mov_masticados).
	ret

; ---------------------------------------------------------------------
;
;	15/4/25

Prepara_nuevo_almacen:

	ld hl,(Puntero_de_almacen_de_mov_masticados)

	dec hl
	dec hl

	ex de,hl

	ld hl,(Puntero_indice_de_almacenes)
	inc hl
	inc hl
	ld (Puntero_indice_de_almacenes),hl

	ld (hl),e
	inc hl
	ld (hl),d

	ret

; ----------------------------------------------------------------------
;
;   14/4/25
;
;   Sitúa HL en el .defw del 1er (Contador_general_de_mov_masticados) vacío.
;

Situa_en_contador_general_de_mov_masticados:

;   Sitúa en la 1ª de las tres variables.

	ld hl,Contador_general_de_mov_masticados_1
1 ld a,(hl)
	and a
	ret z

;	Avanzamos a la siguiente si esta ya contiene una cantidad.

	inc hl
	inc hl

	jr 1B

; --------------------------------------------------------------------------------------------------------------
;
;	2/7/26
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

;	db 0,1
;	defw $0f01
;	defw Random_3_1_15	;	Igual
;	defw Random_4_1_15	;	Igual

;	defw 0

Aplica_rnd_al_baile:

	call RND_ini

	xor a

2 ex af,af 															; Digito de control en A'. Inicialmente "0".

; 	digit ctrl ??
;   Yes if "$00".
;	HL se encuentra en el 1er .db de la Tabla_Random de la entidad correspondiente.	

	ld a,(hl)
	and a
	jr nz,1F 														; NZ indica que este .defw contiene límites. El próximo nº RND que vamos a obtener sólo se introducirá en una unica dirección de memoria.

; Almacenamos en A' el nº de direcciones que compartiran nº RND y sitúamos HL en el .defw que indica los límites.

	inc hl

	ld a,(hl)
	and a
	ret z

	ex af,af

	inc hl 															; Sitúa HL en el defw que define los límites.
	ld a,(hl)

1 call Load_limits_and_place_registers
	call Get_RND
	call Filtra_RND

;	Introducimos nº rnd filtrado.

3 ld (hl),a

	ex de,hl 														; Siguiente .defw de la Tabla_Random en HL.

;	Consulta dígito de control. Z pasamos a otro nº y otra dirección de memoria.

	ex af,af
	jr z,2B

;	Siguiente dirección con el mismo nº RND.

	dec a
	ex af,af

	call Extrae_address

	inc de
	inc de

	jr 3B

; ----- ----- -----
;
;	HL' será el puntero que se irá desplazando por los distintos nº aleatorios.
;	Comenzamos por el último, (Numeros_aleatorios+6).
;	B actúa como contador, (7 nº aleatorios).	

RND_ini:

	exx

	ld hl,Numeros_aleatorios_baile+6                        		; HL apunta al 7° n° aleatorio de baile.
	ld b,7

	exx

	ret

; ----- ----- -----
;
;	Extrae el nº aleatorio, decrementa el contador de nº RND, (B) y actualiza el puntero HL' situándolo en el siguiente nº.
;	Inicializamos HL y B cuando hemos terminado de introducir todos los nº., (call RND_ini).
;		

Get_RND:

	exx

	ld a,(hl)
	djnz 1F

	exx

	call RND_ini

	ret

1 dec hl

	exx

	ret

Filtra_RND:

	and %00111100													; Convertimos el byte, (RND), en Nibble, valores comprendidos entre (0-15).

	srl a
	srl a  															; % 00001111, nº RND (0-15).

	cp b
	ret z 															; RET, nºrnd = Límite sup.

	jr c,1F 														; Estamos por debajo del límite sup. Hemos de comprobar el límite inf.

;	El n° aleatorio está por encima del límite superior. El n° RND adoptará el valor del límite sup.

	ld a,b 															; RET, nº rnd = Límite sup.

	ret

;	Comprobamos el límite inferior.

1 cp c
	ret z 															; RET, nº rnd = Límite inf.

	ret nc 															; RET, nº rnd dentro de los límites.

	ld a,c 															; RET, nº rnd = Límite inf.

	ret

; ----- ----- -----
;
;	2/7/26
;
;	OUTPUT:
;
;	Límites que tendrá este nº RND en BC.
;	B contiene lím.sup. y C contiene límite inf.
;
;	Sitúa HL en la dirección de memoria donde introduciremos el nº aleatorio, (que estará acotado por los límites).
;	DE apunta al siguiente .defw de la Tabla_RANDOM del tipo de entidad correspondiente.

Load_limits_and_place_registers:

	ld c,a

	inc hl
	ld b,(hl)

	inc hl

	call Extrae_address

	inc de
	inc de

	ret

;---------------------------------------------------------------------------------------------------------------
;
;   4/4/26
;
;	Inicializa Nivel del juego.
;	
;	OUTPUT:	Inicializa: (Puntero_indice_NIVELES) ... Situado en el 1er Nivel del Índice de Niveles, (.defw).
;									(Numero_de_entidades) ... Contiene el nº de entidades del nivel, (.db).
;									(Puntero_de_entidades) ... Puntero,  (.defw). Define el (Tipo) de las distintas entidades que componen el nivel.
; 									(Puntero_indice_master)	... Se sitúa en la 1ª de las 3 Cajas_Master.
;
;					B contiene (Numero_de_entidades).
;					C contiene el (Tipo) de la 1ª entidad del nivel.
;
;	MODIFY: A,HL,BC y DE.

Inicializa_Nivel:

; Actualiza (Puntero_indice_NIVELES).


	ld hl,(Puntero_indice_NIVELES) 									; Inicialmente situado en el 1er nivel del índice.
	call Extrae_address   						 					; Sitúa HL en el 1er byte que define: (Max_time_to_appear_entities).

	ld a,(hl)
	ld (Max_time_to_appear_entities),a

	inc hl

	ld a,(hl)
	ld (Decrease_top_time_entities),a

	inc hl

	ld a,(hl)
	ld (Min_time_to_appear_entities),a

	inc hl

	ld a,(hl)
	ld (Numero_de_entidades),a					 					; Inicializa (Numero_de_entidades).

	ld b,a

;	Codificamos (Numero_de_entidades) en BCD para poder pintar en cada FRAME el marcador de entidades.

	call M_entidades_a_BCD											; Inicializa:	Entidades_BCD_unidades db 0
;																					Entidades_BCD_decenas db 0
	inc hl

	ld (Puntero_de_entidades),hl									; Inicializa (Puntero_de_entidades), .defw que define el (Tipo) de la 1ª entidad del Nivel_1
	ld c,(hl)													

	ret 										 

; ----------------------
;
;	7/7/26
;
;	INPUT: A, A' y C contienen la (Clase) de la entidad.
;		   (B) contiene el nº de entidades que tiene el nivel.
;    	   (C) contiene la clase de la entidad en curso.

;	OUTPUT: Flag Z activo:
;				   (A) = "0"     .....   Indica que tenemos que generar los movimientos masticados de esta (Clase) de entidad.
;	 			   (A) = "1,2,3, ..... " Indica que esta Caja_Master ya está iniciada con esta (Clase) de entidad.

Situa_en_Caja_Master:

	ld hl,Indice_de_cajas_master
	ld (Puntero_indice_master),hl 									; Sitúa (Puntero_indice_master) en la 1ª caja del índice.

1 call Extrae_address
	cp (hl) 																							
	ret z 															; RET Z. Indica que esta Caja_Master ya está iniciada con una entidad de esta (Clase).

; 	Esta Caja_Master no contiene una entidad de esta misma (Clase). RET si está vacía.

	xor a

	inc (hl)
	dec (hl)

	ret z 															; RET. Flag Z y A="$00". Indica que esta Caja_Master está vacía. Hay que generar los movimientos_
; 																	; _masticados de esta (Clase) de entidad.

; Caja_Master iniciada con otra (Clase) de entidad.
; Saltamos a la siguiente:

	ld a,c 		

	inc de
	inc de 	

	ld (Puntero_indice_master),de

	ex de,hl 														; Esta caja está iniciada con otra (Clase) de entidad.

	jr 1B

; -------------------------------------------------------------------------------------------------
;
;	17/4/25
;
;	Busca en las tres Cajas_Master una entidad de la (Clase) que contiene el registro A_
;	_para completar las Cajas_de_entidades.
;
;	INPUT: A contiene la (Clase) de entidad.

Obtiene_datos_de_Caja_Master

	ld hl,Indice_de_cajas_master	
	ld (Puntero_indice_master),hl

1 call Extrae_address
	cp (hl) 																							
	ret z 															; RET pues esta Caja_Master es de la (Clase) que necesitamos.

	inc e
	inc e

	ld (Puntero_indice_master),de
	ex de,hl 																						

	jr 1B

; -----------------------------------------------------------
;
;	7/3/25

;	INPUTS: A contiene el (Tipo) de la entidad que estamos iniciando.

Situa_en_Tabla_Random:

	call Calcula_salto_en_BC

	ld hl,Indice_de_tablas_Random
	and a
	adc hl,bc
	ld (Puntero_tabla_Random),hl

	call Extrae_address

	ret

; -----------------------------------------------------------
;
;	7/7/26

Situa_Puntero_indice_mov:

	call Calcula_salto_en_BC
	ld hl,Indice_de_mov_segun_tipo_de_entidad
	and a
	adc hl,bc
	call Extrae_address

; 	Hay que seleccionar una "danza izq. o derecha", dependiendo del lado de la pantalla desde el que se inicia la entidad.

; 	Seleccionamos Danza.

	ld a,(Posicion_inicio)
	and $1f
	cp $10
	jr c,1F

	inc hl
	inc hl

1 call Extrae_address
	ld (Puntero_indice_mov),hl

	ret

;---------------------------------------------------------------------------------------------------------------
;
;   23/6/25
;
;	Esta rutina se encarga de prepara todas las cajas de entidades. Cuando comienza un nivel han de estar todas completas.


Prepara_Cajas_de_Entidades:

; Preparamos los punteros de las cajas de entidades:

	call Inicia_punteros_de_cajas									; Situa (Puntero_store_caja) en el 1er .db de la 1ª caja del índice de entidades.
;																	; Situa (Puntero_restore_caja) en el 1er .db de la 2ª caja del índice de cajas de entidades.
	call Inicializa_Numero_parcial_de_entidades						; Actualiza (Numero_de_entidades) y (Numero_parcial_de_entidades).

	ld hl,(Puntero_de_entidades)									; (Puntero_de_entidades) contiene la dirección de mem. donde se encuentra la (Clase) de la 1ª entidad del nivel.

; En este punto:

;
; HL está situado en el 1er .db del Nivel que indica la `Clase´ de entidad a volcar en la 1ª caja de entidades.
; B contiene (Numero_parcial_de_entidades).

1 push bc 															; Push (Numero_parcial_de_entidades).

	ld a,(hl)

	call Obtiene_datos_de_Caja_Master								; HL apunta al 1er .db, (Tipo) de la "Caja Master" correspondiente al (Tipo) de entidad.

	ld de,(Puntero_store_caja)										; DE apunta al 1er .db de la "Caja de entidades" en curso.

	push de
	pop ix 															; ! A partir de ahora IX apunta al 1er .db (Tipo) de la entidad, (caja de entidades correspondiente).

	ld bc,14
	ldir															; Caja de entidades completa. HL apuntará ahora al 1er .db de la siguiente caja "Master".

;																	; DE apunta ahora al 1er .db de la siguiente caja de entidades.

	call Scanlines_generator

;	Borramos las variables DRAW que hemos utilizado para preparar la Tabla_de_pintado y los scanlines_
;	_en el álbum_de_pintado.

; Variables DRAW utilizadas:

;	(Columnas).
;	(Puntero_de_impresion).
;	(Coordenada_X).
;	(Coordenada_Y).

	ld hl,0
	ld (Coordenada_X),hl
	ld (Puntero_de_impresion),hl
	ld (Columnas),hl

	call Incrementa_punteros_de_cajas

; Siguiente entidad del Nivel.

	ld hl,(Puntero_de_entidades)									; (Clase) de la siguiente entidad del nivel.
	inc hl
	ld (Puntero_de_entidades),hl

	pop bc 															; Recuperamos (Numero_parcial_de_entidades), (nº de cajas que vamos a rellenar)

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

Inicia_Amadeus 

	ld hl,Definicion_Amadeus
	call Definicion_de_entidad_a_bandeja_DRAW						; Vuelca los datos de la definición de Amadeus en DRAW.

;	Inicializamos los perfiles de velocidad antes de crear la danza de Amadeus.
;	(Vel_left), (Vel_right), (Vel_up) y (Vel_down) a "1".

	ld hl,257
	ld (Vel_left),hl
	ld (Vel_up),hl

Construye_movimientos_masticados_Amadeus

	ld hl,(Puntero_de_almacen_de_mov_masticados)					; Guardamos en la pila la dirección inicial del puntero, (para reiniciarlo más tarde).
	call Actualiza_Puntero_de_almacen_de_mov_masticados 			; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;																	; _ el (Contador_de_mov_masticados).
	call Inicia_Puntero_objeto										; Inicializa (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq).
;																	; Inicializa (Puntero_objeto) en función de la (Posicion_inicio) de la entidad.

; Generamos movimientos masticados de Amadeus.

	ld b,121														; $0079, 121d.

1 push bc
	call Draw
	call Guarda_movimiento_masticado

	call Mov_right
	call Mov_right													; Amadeus se mueve x2 pixel.

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

Definicion_segun_tipo: 											

	call Calcula_salto_en_BC										; Calcula el salto para situarnos en la definición de entidad correcta de indice de [Indice_de_definiciones_de_entidades].

	ld hl,Indice_de_definiciones_de_entidades

	call Situa_en_datos_de_definicion								; Sitúa HL en el 1er .db de la definición de entidad tipo que tenemos que volcar en DRAW.

	ret

; ---------------------------------------------------------------------
;
;	23/11/24
;
;	Actualiza el (Contador_de_mov_masticados) de la entidad.

Decrementa_Contador_de_mov_masticados 

	ld l,(ix+10)
	ld h,(ix+11)

	dec hl

	ld (ix+10),l
	ld (ix+11),h

	ret

; ---------------------------------------------------------------------
;
;	7/9/25

Reinicia_entidad_maliciosa 

	ld a,(ix)

;	(Clase) de la entidad en A.
;	Hemos completado todos los movimientos masticados de la entidad.
;	Inicializamos el contador de mov_masticados de la Caja_Master correspondiente.

	call Obtiene_datos_de_Caja_Master

;	En este punto:
;
;	HL apunta al 1er .db de la CAJA MASTER correspondiente.
;	IX apunta al 1er .db de la CAJA DE ENTIDADES correspondiente.

;	Inicializamos (Puntero_de_almacen_de_mov_masticados) y (Contador_de_mov_masticados).

	ld a,l
	add 8
	ld l,a

	call Extrae_address

	ld (ix+8),l
	ld (ix+9),h

	inc e
	inc e

	ex de,hl

	call Extrae_address

	inc hl 																		;	(Contador_de_mov_masticados)+1. Cuando regresemos, [Take_movement] le restará una unidad.

	ld (ix+10),l
	ld (ix+11),h

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

	sla (ix+4)														; sla x2 (Contador_de_vueltas). Inicialmente es "1".

	ld a,(ix+4)   													; ld a,(Contador_de_vueltas)
	sra a
	sra a

	ld (ix+12),a 													; ld (Velocidad),a
	and a

; Attr. 

; A contiene (Velocidad).

	call nz, Define_attr 											; No modificamos attr. si no hay cambio de velocidad.

; Límitador. 

	ld a,$40
	cp (ix+4)
	jr z,1F

	xor a															; Siempre salimos de esta rutina con un "Z".
	ret


;	Limita el valor de (Contador_de_vueltas) a "$40" y de (Velocidad) a "$08".

1 sra (ix+4)
	sra (ix+12)

	xor a															; Siempre salimos de esta rutina con un "Z".
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

2 ld (ix+13),a

	ret

;	------------------------------------------------------------------------------------
;
;	14/06/26
;
;	INPUTS:	A contiene el (Tipo) de entidad. 
;
;	Esta pequeña sub-rutina carga BC con 0,2,4,6,8 ... en función del tipo de entidad: (1,2,3,4,...). 
;	Calcula "el salto" para situarnos en los DATOS de la ENTIDAD correcta del índice de entidades según el tipo de entidad.

Calcula_salto_en_BC:

	and a
	jr z,1F

	sla a										
	sub 2															; ("Tipo_de_entidad")*2-2.

1 ld c,a
	ld b,0 										

	ret

; ------------------------------------------------------------------
;
;	12/06/26
;
;	Sitúa HL en el 1er .db de la definición de la entidad que tenemos que volcar en la bandeja DRAW.
;	Actualiza (Datos_de_entidad) con esa dirección.

Situa_en_datos_de_definicion: 

	and a
	adc hl,bc
	call Extrae_address   
	ld (Datos_de_entidad),hl

	ret

; ----------------------------------------------------------------------------------------------------------
;
;	15/4/25
;
;	Introduce una definición de entidad en la bandeja DRAW para generar sus "movimientos masticados".
;
;	INPUTS: HL apunta al 1er .db de datos de la definición de la entidad.
;			
; 
;	MODIFICA: HL,DE y BC


Definicion_de_entidad_a_bandeja_DRAW 	

	ld de,Bandeja_DRAW   	 										; DE apunta al 1er .db de la bandeja_DRAW, (Clase).
	ld bc,2
	ldir 															; Volcamos (Clase) y (Tipo).

	ld de,Filas														; Volcamos (Filas) y (Columns).
	ld bc,2
	ldir															; Hemos volcado (Contador_de_vueltas), (Indice_Sprite_der) y (Indice_Sprite_izq).
;																	; HL, (origen), apunta ahora al .db (Posicion_inicio), hay que situar DE.
	ld de,Contador_de_vueltas 
	ld a,(hl)
	ld (de),a
	inc hl															; Hemos volcado (Posicion_inicio) y (Cuad_objeto).

	ld de,Indice_Sprite_der
	ld bc,4
	ldir 															; Hemos volcado (Puntero_de_almacen_de_mov_masticados).

	ld de,Posicion_inicio
	ld bc,3															; 3 FRAMES de explosión.!!!!!!!!!!!!!!
	ldir 															; Vuelco (Frames_explosion).

	ld de,Puntero_de_almacen_de_mov_masticados
	ld bc,2
	ldir

	ld de,Attr
	ld a,(hl) 														; Volcamos (Attr).
	ld (de),a

	ret

; ----------------------------------------------------------------------------------------------------------
;
;	7/7/26
;

Parametros_de_bandeja_DRAW_a_Caja_Master:

	ld hl,Bandeja_DRAW
	ld bc,14
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

;> Aumentaremos el nº de entidades en pantalla !!!!!!!!!!!!!!!!!!!!!!!!!!
;> !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Inicializa_Numero_parcial_de_entidades 

	ld a,(Numero_de_entidades)										; Nº TOTAL de las entidades del NIVEL.
	cp 4												 			; "5" es el nº total de cajas de entidades de las que disponemos.
	jr c,1F
	jr z,1F

; El nº de entidades es superior al que cabe en las cajas DRAW.
; Actualizamos variables.

	sub 4
	ld (Numero_de_entidades),a
	ld a,4
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

;---------------------------------------------------------------------------------------------------------------
;
;	04/10/25
;
;	Convierte el valor hexadecimal de (Numero_de_entidades) a dos valores BCD que guardarán las variables:
;
;   Entidades_BCD_unidades
;	Entidades_BCD_decenas
;
;	Utilizaremos estas variables para construir el marcador de dos dígitos digital que muestra el nº de entidades del nivel.

M_entidades_a_BCD:

	push hl
	push bc

	ld hl,Entidades_BCD_unidades
	ld b,9
	ld c,0

2 cp b

	jr z,1F
	jr c,1F

	sub 10

	inc c

	jr 2B

1 ld (hl),a
	inc hl
	ld (hl),c

;	Inicializa los punteros de dígitos.

;	Unidades:

	ld a,(Entidades_BCD_unidades)
	call Situa_en_indice_de_digitos_grandes
	call Extrae_address
	ld (Puntero_unidades_grandes),hl

;	Decenas:

	ld a,(Entidades_BCD_decenas)
	call Situa_en_indice_de_digitos_grandes
	call Extrae_address
	ld (Puntero_decenas_grandes),hl

	pop bc
	pop hl

	ret

; -----------------------------------------------

Situa_en_indice_de_digitos_grandes:

	and a 												; Identifica si el dígito BCD es "0".

	ld b,a

	ld hl,Index_big_numbers

	ret z

1 inc hl
	inc hl

	djnz 1B

	ret

;---------------------------------------------------------------------------------------------------------------
;
;	25/06/26
;
;	Convierte el valor hexadecimal de (Score_hex) a 5 valores BCD que guardarán las variables:
;
;	Score_BCD_unidades
;	Score_BCD_decenas
;	Score_BCD_centenas
;	Score_BCD_unidades_de_millar
;	Score_BCD_decenas_de_millar
;
;	10000d ..... $2710 ..... set (4) (Score_Ctrl)
;	 1000d ..... $03e8 .....  "  (3)
;	  100d ..... $0064 .....     (2)
;	   10d ..... $000a .....     (1)
;
;	Utilizaremos estas variables para construir el marcador de 5 dígitos digital que muestra nuestra puntuación.
;

Score_a_BCD:

; En 1er lugar inicializamos la variable de Ctrl, (Score_hex) y todos los dígitos BCD del marcador SCORE.

	xor a

	ld (Score_BCD_unidades),a
	ld (Score_BCD_decenas),a
	ld (Score_BCD_centenas),a 
	ld (Score_BCD_unidades_de_millar),a
	ld (Score_BCD_decenas_de_millar),a

	ld hl,(Score_hex)
	ld de,Score_Ctrl 								; DE apunta al byte de control de Score, (Score_Ctrl).

	ld bc,$2710 									; 10000d.

;	Averigua cuantas decenas de millar contiene (Score_hex).

	and a
1 sbc hl,bc

	jr c, No_decenas_de_millar

	push hl

	ld hl, Score_BCD_decenas_de_millar
	inc (hl)

	pop hl

; Activamos FLAG. Permiso para imprimir todos los dígitos BCD de Score.

	ex de,hl
	set 4,(hl)
	ex de,hl

	jr 1B

No_decenas_de_millar

	and a                                           ; Elimina la suma del Carry a ADC.
	adc hl,bc 										; Recupera valor de HL.

	ld bc,$03e8 									; 1000d

	and a
2 sbc hl,bc

	jr c, No_unidades_de_millar

	push hl

	ld hl, Score_BCD_unidades_de_millar
	inc (hl)

	pop hl

; Activamos FLAG. Permiso para imprimir los 4 últimos dígitos BCD de Score.

	ex de,hl
	set 3,(hl)
	ex de,hl

	jr 2B

No_unidades_de_millar

	and a
	adc hl,bc

	ld bc,$0064 									; 100d

	and a
3 sbc hl,bc

	jr c, No_centenas

	push hl

	ld hl, Score_BCD_centenas
	inc (hl)

	pop hl

; Activamos FLAG. Permiso para imprimir los 3 últimos dígitos BCD de Score.

	ex de,hl
	set 2,(hl)
	ex de,hl

	jr 3B

No_centenas

	and a
	adc hl,bc

	ld bc,$000a										; 10d

	and a
4 sbc hl,bc

	jr c, No_decenas

	push hl

	ld hl, Score_BCD_decenas
	inc (hl)

	pop hl

; Activamos FLAG. Permiso para imprimir los 2 últimos dígitos BCD de Score.

	ex de,hl
	set 1,(hl)
	ex de,hl

	jr 4B

No_decenas

	and a
	adc hl,bc 										; Recupera valor de HL.

	ld a,l
	ld (Score_BCD_unidades),a

	ex de,hl
	set 0,(hl)
	ex de,hl

	ret

; -------------------------------------------------------------------
;
;	25/06/26
;

Actualiza_Punteros_Score:

;	Exclusiones:

	ld a,(Score_Ctrl)
	and a
	ret z 														; RET si no hay incremento en el marcador.

	call Init_Score_Pointers 									; Inicializa los Punteros_Score.

	ld de,Score_BCD_unidades
	ld b,5

; ---------------------

1 ld a,(de)

	exx

	ld hl, Indice_de_digitos_score

	and a
	call nz, Actualiza_puntero_score

; ---------------------

Next_Pointer

	exx

	inc de 														; Siguiente byte BCD de Score.

	inc hl
	inc hl 														; Siguiente puntero.

	djnz 1B

	exx

	ret

; ---------------------

Actualiza_puntero_score

	ld b,a

1 inc hl
	inc hl

	djnz 1B

	call Extrae_address

	push hl
	pop iy

	exx

	ld a,iyl
	ld (hl),a	                                            	; Actualiza la dirección hacia la que debe apuntar el puntero correspondiente.

	inc hl

	ld a,iyh
	ld (hl),a

	dec hl

	exx

	ret

; ----------------------------------------------------
;
;	25/06/26
;
;	Inicializa los cinco (Punteros_Score) con "Cero_Score", ($3d80).
;
;	MODIFY: A, HL
;
;	OUTPUT: (A)="0".
;			HL = Puntero_de_unidades_Score

Init_Score_Pointers:

	ld hl,Cero_Score
	ld (Stack),sp
	ld sp,Score_Ctrl

	push hl
	push hl
	push hl
	push hl
	push hl

	xor a
	ld l,a
	ld h,l

	add hl,sp

	ld sp,(Stack)

	ret




