;	9/1/24

	DEVICE ZXSPECTRUM48

	org $a9ff 	
	
;	Vector de interrupciones.

 	defw $aa01											; $9000. Rutina de interrupciones.

	org $aa01		

; Guardamos SP.

FRAME ld (Stack_3),sp

;! debuggg

	ex af,af'	
	push af	;af'
	exx
	push hl	;hl'
	push de	;de'
	push bc	;bc'
	exx
	push hl	;hl
	push de	;de
	push bc	;bc
	ex af,af'
	push af	;af
	push ix
	push iy

; Pintamos entidades/Amadeus y gestionamos álbumes de fotos de entidades.

	ld a,2	
	out ($fe),a												

	call Pinta_entidades									; Borde rojo.

;	ld a,6	
;	out ($fe),a												
;	call Pinta_Amadeus										; Borde amarillo.

; En 1er lugar guardamos los 67 bytes de la entidad alojada en DRAW para restaurarlos antes de salir de la_
; _ rutina de interrupción. (Para gestionar Amadeus hemos de introducir sus datos en DRAW).

;	ld a,7	
;	out ($fe),a												; Borde blanco.
;	call Guarda_parametros_DRAW
;	call Restore_Amadeus

; Posible colisión Entidad-Amadeus ???

;	ld a,(Impacto2)	
;	bit 2,a
;	jr z,1F

;	call Detecta_colision_nave_entidad 

;1 ld a,4	
;	out ($fe),a												
;	call Gestiona_Amadeus

;	ld a,7	
;	out ($fe),a											; Borde blanco.
;	ld de,Amadeus_db 									; Antes de llamar a [Store_Amadeus], debemos cargar en DE_
;	call Store_Amadeus 									; _la dirección de memoria de la base de datos donde vamos a volcar.

; Restauramos los parámetros de la entidad que había alojada en DRAW "antes de gestionar AMADEUS".

;	call Recupera_parametros_DRAW
	call Actualiza_relojes

	ld hl,Ctrl_3
	res 0,(hl)											; Reinicia el flag de FRAME completo.

	pop iy
	pop ix
	pop af
	pop bc
	pop de
	pop hl
	exx
	pop bc
	pop de
	pop hl
	ex af,af'
	pop af
	ex af,af'
	exx

	ld sp,(Stack_3)

	ei

	ld a,1												; Borde azul.
	out ($fe),a

	ret									 

; ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

	include "Sprites_e_indices.asm"
	include "Cajas_y_disparos.asm"
	include "Patrones_de_mov.asm"
	include "Niveles.asm"

; ******************************************************************************************************************************************************************************************
; Constantes. 
; ****************************************************************************************************************************************************************************************** 
;
; 25/12/23

;
; Constantes.
;
 
Sprite_vacio equ $eae0
Centro_arriba equ $0160 								; Emplearemos estas constantes en la rutina de `recolocación´ del objeto:_
Centro_abajo equ $0180 									; _[Comprueba_limite_horizontal]. El byte alto en las dos primeras constantes_
Centro_izquierda equ $0f 								; _indica el tercio de pantalla, (línea $60 y $80 del 2º tercio de pantalla).
Centro_derecha equ $10 									; Las constantes (Centro_izquierda) y (Centro_derecha) indican la columna $0f y $10 de pantalla.

Almacen_de_movimientos_masticados_Entidad_1 equ $eb00	; $eb00 - $ff09 ..... $1409 / 5129 bytes. Guardaremos los movimientos masticados que ha hido generando la entidad guía.

Almacen_de_movimientos_masticados_Amadeus equ $e700		
;
Album_de_fotos equ $8000	;	(8000h - 8055h).		; En (Album_de_fotos) vamos a ir almacenando los valores_
;                                   				    ; _de los registros y las llamadas a las rutinas de impresión.   
;                               				        ; De momento situamos este almacén en $7000. La capacidad del album será de 7 entidades.  
Album_de_fotos_disparos equ $8056 ; (8056h - 80abh).		; En (Album_de_fotos_disparos) vamos a ir almacenando los valores_
;                                   				    ; _de los registros y llamadas a las distintas rutinas de impresión para poder pintar `disparos´. 
;														; 55 Bytes.

Album_de_fotos_Amadeus equ $80ac ; (80ach - 80b8h) ; 12 bytes.
;Almacen_de_parametros_DRAW equ $80b9 ; ($80b9 - $80fb) ; 66 bytes.

; 54h es el espacio necesario en (Album_de_fotos) para 7 entidades/disparos en pantalla.

; ******************************************************************************************************************************************************************************************
; Variables. 
; ****************************************************************************************************************************************************************************************** 
;
; 18/01/24
;
; Variables de DRAW. (Motor principal).	42 Bytes.	
;

Bandeja_DRAW ; -----------------------------------------------------------------------------------------------

Tipo db 0												; Clase de la entidad. Cada `tipo´ de Entidad tiene unas características únicas que lo distinguen de otros tipos: 
;															- Patrón de movimiento.
;															- Aspecto
Filas db 0												; Filas. [DRAW]
Columns db 0 	  										; Nº de columnas. [DRAW]
Posicion_actual defw 0									; Dirección actual del Sprite. [DRAW]
Puntero_objeto defw 0									; Donde están los datos para pintar el Sprite.
Coordenada_X db 0 										; Coordenada X del objeto. (En chars.)
Coordenada_y db 0 										; Coordenada Y del objeto. (En chars.)

; ---------- ---------- ---------- ---------;      ;--------- ---------- ---------- ---------- 

CTRL_DESPLZ db 0										; Este byte nos indica la posición que tiene el Sprite dentro del mapa de desplazamientos.
; 														; El hecho de que este byte sea distinto de "0", indica que se ha modificado el nº de columnas del objeto.
; 														; Cuando vamos a imprimir un Sprite en pantalla, la rutina de pintado consultará este byte para situar (Puntero_objeto). [Mov_left]. 
Attr db 0												; Atributos de la entidad:

;	El formato: FBPPPIII (Flash, Brillo, Papel, Tinta).
;
;	COLORES: 0 ..... NEGRO
;    		 1 ..... AZUL
; 			 2 ..... ROJO
;			 3 ..... MAGENTA
; 			 4 ..... VERDE
; 			 5 ..... CIAN
;			 6 ..... AMARILLO
; 			 7 ..... BLANCO

Indice_Sprite_der defw 0
Indice_Sprite_izq defw 0
Puntero_DESPLZ_der defw 0
Puntero_DESPLZ_izq defw 0

Posicion_inicio defw 0									; Dirección de pantalla donde aparece el objeto. [DRAW].
Cuad_objeto db 0										; Almacena el cuadrante de pantalla donde se encuentra el objeto, (1,2,3,4). [DRAW]

; Variables de objeto. (Características).

Impacto db 0											; Si después del movimiento de la entidad, (Impacto) se coloca a "1",_
;														; _ existen muchas posibilidades de que esta entidad haya colisionado con Amadeus. 
; 														; Hay que comprobar la posible colisión después de mover Amadeus. En este caso, (Impacto2)="3".
Variables_de_borrado ds 6 							

Puntero_de_impresion defw 0								; Contiene el puntero de impresión, (calculado por DRAW). Esta dirección la utilizará la rutina_
;														; _ [Guarda_coordenadas_X] y [Compara_coordenadas_X] para detectar la colisión ENTIDAD-AMADEUS.

Puntero_de_almacen_de_mov_masticados defw 0

;	Almacén donde la entidad guía va guardando comportamiento ya calculado, (rutinas DRAW).
;	Almacén donde una entidad "sombra" recoge el siguiente desplazamiento ya masticado, (para imprimir).

Contador_de_mov_masticados defw 0						; Contador de 16bits. La "Entidad_guía" lo aumenta en una unidad cada vez que hace el "pushado" de las tres_
;														; _palabras que componen el "movimiento_masticado".  

; Variables de funcionamiento de las rutinas de movimiento. (Mov_left), (Mov_right), (Mov_up), (Mov_down).

Ctrl_0 db 0 											; Byte de control. A través de este byte de control. Las rutinas de desplazamiento: [Mov_right], [Mov_left], [Mov_up] y [Mov_down],_
;														; _indican a las subrutinas de recolocación del objeto de la rutina [DRAW]: [Comprueba_limite_horizontal] y [Comprueba_limite_vertical],_
; 														; _que desaparecemos por un extremo de la pantalla y hemos de `reaparecer´ por el contrario. 
; 														; Este dato es necesario debido a que las rutinas de recolocación, están ideadas para recolocar el puntero (Posicion_actual), cuando pasamos_
; 														; _de un cuadrante a otro de la pantalla pero no preveen la `desaparición´ por un extremo del cuadrante y la `reaparición´ por el otro.
;
; 														DESCRIPCIÖN:
;
; 														SET 0, [Reaparece_derecha]. El bit 0 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_left] detecta que el objeto ha `desaparecido´ por el_
; 																_lado izquierdo de la pantalla y ha de `reaparecer´ por el derecho. ([Comprueba_limite_vertical]).
; 														SET 1, [Reaparece_izquierda]. El bit 1 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_right] detecta que el objeto ha `desaparecido´ por el_
; 																_lado derecho de la pantalla y ha de `reaparecer´ por el izquierdo. ([Comprueba_limite_vertical]).
; 														SET 2, [Reaparece_abajo]. El bit 2 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_up] detecta que el objeto ha `desaparecido´ por la_
; 																_parte superior de la pantalla y ha de `reaparecer´ por el inferior. ([Comprueba_limite_horizontal]).
; 														SET 3, [Reaparece_arriba]. El bit 3 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_down] detecta que el objeto ha `desaparecido´ por la_
; 																_parte inferior de la pantalla y ha de `reaparecer´ por la superior. ([Comprueba_limite_horizontal]).
; 														SET 4, El Bit4 a "1", indica que hubo movimiento de la entidad. Necesitamos esta información
;												                _para "NO BORRAR/PINTAR" en objeto si NO hubo MOVIMIENTO. 
;														SET 5, La rutina [Inicializacion] de Draw_XOR.asm, pone este bit a "1". Con esta información evitamos ejecutar las
;																_rutinas: (Comprueba_limite_horizontal) y (Comprueba_limite_vertical) justo después de `inicializar´ un objeto.
; 														SET 6, Está a "1" si el Sprite que tenemos cargado en el `Engine´ es AMADEUS.
;
; 														SET 7, El bit 7 se encuentra alto, ("1"), cuando el último movimiento horizontal se ha producido a la "DERECHA".
; 															   _ Utilizo la información que proporciona este BIT para modificar (CTRL_DESPLZ) si el siguiente movimiento_
; 															   _ se va a producir a la izquierda. "1" DERECHA - "0" IZQUIERDA.

; Variables de funcionamiento. [DRAW].

Columnas db 0
Limite_horizontal defw 0 								; Dirección de pantalla, (scanline), calculado en función del tamaño del Sprite. Si el objeto llega a esta línea se modifica_    
; 														; _(Posicion_actual) para poder asignar un nuevo (Cuad_objeto).
Limite_vertical db 0 									; Nº de columna. Si el objeto llega a esta columna se modifica (Posicion_actual) para poder asignar un nuevo (Cuad_objeto).

; variables de control general.

Ctrl_2 db 0 											
;														BIT 0, Los sprites se inician con un `sprite vacío', (sprite formado por "ceros"), cuando la rutina_
;															_ [Guarda_foto_registros] guarda su 1ª imagen.
;															_ Más adelante las rutinas [Mov_left] y [Mov_right] restauraran (Puntero_objeto). Si el 1er movimiento
; 															_ que hace la entidad después de iniciarse es hacia arriba/abajo no se restaurará (Puntero_objeto), pués_
; 															_ las rutinas [Mov_up] y [Mov_down] no necesitan modificar el sprite.
;															_ El bit5 a "1" nos indica que el sprite se inicia por arriba o por abajo y por lo tanto hay que restaurar_
;															_ (Puntero_objeto) con (Repone_puntero_objeto) una vez iniciado y realizada su 1ª `foto'.
;														
;														BIT 1, Este bit a "1" indica que se ha iniciado el proceso de EXPLOSIÓN en una entidad.
;														BIT 2, Este bit es activado por [Movimiento]. Indica que hemos `iniciado un desplazamiento'._
;															_ Evita que volvamos a iniciar el desplazamiento cada vez que ejecutemos [Movimiento].
;														BIT 3, Indica que (Cola_de_desplazamiento)="254". Esto quiere decir que repetiremos (1-255 veces),_
;															_ el último MOVIMIENTO que hayamos ejecutado.
;														BIT 4, ???
;														BIT 5, Este bit a "1" indica que esta entidad es una "Entidad_guía".

Frames_explosion db 0 									; Nº de Frames que tiene la explosión.

; ----- ----- De aquí para arriba son datos que hemos de guardar en los almacenes de entidades.

;					         		---------;      ;---------

; Variables de funcionamiento, (No incluidas en base de datos de entidades), a partir de aquí!!!!!

Perfiles_de_velocidad

Vel_left db 0 											; Velocidad izquierda. Nº de píxeles que desplazamos el objeto a izquierda. 1, 2, 4 u 8 px.
Vel_right db 0 											; Velocidad derecha. Nº de píxeles que desplazamos el objeto a derecha. 1, 2, 4 u 8 px.
Vel_up db 0 											; Velocidad subida. Nº de píxeles que desplazamos el objeto hacia arriba. (De 1 a 7px).
Vel_down db 0 											; Velocidad bajada. Nº de píxeles que desplazamos el objeto hacia abajo. (De 1 a 7px).

; Contadores de 16 bits.

Contador_general_de_mov_masticados_Entidad_1 defw 0  	
Contador_general_de_mov_masticados_Entidad_2 defw 0
Contador_general_de_mov_masticados_Entidad_3 defw 0
Contador_general_de_mov_masticados_Entidad_4 defw 0

; Movimiento. ------------------------------------------------------------------------------------------------------

Puntero_indice_mov defw 0							    ; Puntero índice del patrón de movimiento de la entidad. "0" No hay movimiento.
Puntero_mov defw 0										; Guarda la posición de memoria en la que nos encontramos dentro de la cadena de movimiento.
Puntero_indice_mov_bucle defw 0							; 
;														
;                   									
Incrementa_puntero db 0									; Byte que iremos sumando a (Puntero_indice_mov) para ir escalando por las_
;														; _ distintas cadenas de movimiento del índice de movimiento de la entidad._
;														; Va aumentando su valor en saltos de 2 uds, (0,2,4,6,8).
Incrementa_puntero_backup db 0
Repetimos_desplazamiento db 0							; El nibble bajo del 3er byte que compone un desplazamiento, indica el nº de veces que_
;														; repetimos dicho desplazamiento. Ese valor se almacena en esta variable, ($1-$f). NUNCA SERÁ "0".
Repetimos_desplazamiento_backup db 0					; Restaura (Repetimos_desplazamiento) cuando este llega a "0".
Repetimos_movimiento db 0								; Byte que indica el nº de veces que repetimos el último MOVIMIENTO.
Cola_de_desplazamiento db 0								; Este byte indica:
;
;														;	"$00" ..... Hemos finalizado la cadena de movimiento.
;														;				En este caso hemos de incrementar (Puntero_indice_mov)_
;														;				_ y pasar a la siguiente cadena de movimiento del índice.
;
;														;	"$01 - "$fe" ..... Repetición del movimiento. 
;														;						Nº de veces que vamos a repetir el movimiento completo.
;														;						En este caso, volveremos a inicializar (Puntero_mov),_	
;														;						_ con (Puntero_indice_mov) y decrementaremos (Cola_de_desplazamiento).
;				
;														;	"$ff" ..... Bucle infinito de repetición. 
;														;				Nunca vamos a saltar a la siguiente cadena de movimiento del índice,_	
;														;				,_ (si es que la hay). Volvemos a inicializar (Puntero_mov) con (Puntero_indice_mov).	
; Contador_general_de_mov_masticados_Entidad_1 defw 0		; Contador general de "movimientos masticados" de la Entidad_1.

Ctrl_1 db 0 											; Byte de control de propósito general.

;														DESCRIPCIÓN:
;
;														BIT 0, La rutina de generación de disparos, [Genera_disparo], pone este bit a "1" para indicar a la_
;															_ rutina [Guarda_foto_registros] que los datos a guardar pertenecen a un disparo y no a una entidad,_
;															_ por lo tanto hemos de almacenarlos en `Album_de_fotos_disparos´ en lugar de `Album_de_fotos´.
;														BIT 1, Este bit indica que el disparo sale de la pantalla, ($4000-$57ff).
;														BIT 2, Este bit a "1" indica que un disparo de Amadeus ha alcanzado a una entidad. Como no sabemos cual,_
;															_ hemos de comparar las coordenadas de (Coordenadas_disparo_certero) con las de cada entidad.

;														BIT 3, Recarga de nueva oleada.
;														BIT 4, Recarga de nueva oleada.
;														BIT 5, FREEEEEEEEE !!!!!!!!!!!!!!!!!
;														BIT 6, **** Frame completo.
;														BIT 7, Indica que ya está tomada la foto de Amadeus. No tomaremos otra hasta el próximo FRAME.

Repone_puntero_objeto defw 0							; Almacena (Puntero_objeto). Cuando el Sprite se inicia por arriba o por abajo,_
; 														; _ hay que sustituirlo por un `sprite vacío' para que no se vea el 1er o último scanline.
; 														; _ Cuando hemos terminado de iniciarlo y guardado su foto, hemos de recuperar su (Puntero_objeto).
;														; (Repone_puntero_objeto) es una copia de respaldo de (Puntero_objeto) y su función es restaurarlo.

; Gestión de ENTIDADES y CAJAS.

Puntero_store_caja defw 0
Puntero_restore_caja defw 0
Indice_restore_caja defw 0
Numero_de_entidades db 0								; Nº total de entidades maliciosas que contiene el nivel.
Numero_parcial_de_entidades db 7						; Nº de cajas que contiene un bloque de entidades. (7 Cajas).
Entidades_en_curso db 0									; ..... ..... .....
Numero_de_malotes db 0									; Inicialmente, (Numero_de_malotes)=(Numero_de_entidades).
;														; Esta variable es utilizada por la rutina [Guarda_foto_registros]_
;														; _ para actualizar el puntero (Stack_snapshot) o reiniciarlo cuando_
;														; _ (Numero_de_malotes)="0".
Puntero_indice_ENTIDADES defw 0 						; Se desplazará por el índice de entidades para `meterlas' en cajas.
Datos_de_entidad defw 0									; Contiene los bytes de información de la entidad hacia la que apunta el 
;														; _ puntero (Indice_entidades).

;---------------------------------------------------------------------------------------------------------------
;
;	11/01/24
;
;	Álbumes.

Stack defw 0 											; La rutinas de pintado, utilizan esta_
;														; _variable para almacenar lo posición del puntero_
; 														; _de pila, SP.
Stack_2 defw 0											; 2º variable destinada a almacenar el puntero de pila, SP.
;														; La utiliza la rutina [Extrae_foto_registros].
Stack_3 defw 0											; Almacena el SP antes de ejecutar FRAME.
Stack_snapshot defw Album_de_fotos
Stack_snapshot_disparos defw Album_de_fotos_disparos

;End_Snapshot defw Album_de_fotos										
;														; Inicialmente está situado el la posición $7000, Album_de_fotos.
End_Snapshot_disparos defw Album_de_fotos_disparos							; Puntero que indica la posición de memoria donde vamos a guardar_
;														; _el snapshot de los registros del siguiente disparo.
;														; Inicialmente está situado en la posición $7060, Album_de_fotos_disparos.
End_Snapshot_Amadeus defw Album_de_fotos_Amadeus

Ctrl_3 db 0												; 2º Byte de Ctrl. general, (no específico) a una única entidad.
;
;															BIT 0, "1" Indica que el FRAME está completo, (hemos podido hacer la foto de todas las entidades).
;															BIT 1, "1" Indica que hemos completado todo el patrón de movimientos de este tipo de entidad.
;																_ El almacén de movimientos masticados de este tipo de entidad quedará completo. ([Inicia_entidad]).

Ctrl_4 db 0 											; 3er Byte de Ctrl. general, (no específico) a una única entidad. Lo utiliza la rutina [Inicia_entidad].
;
;                                                           Los bits (0-3) indican el (Tipo) de entidad que estamos iniciando.
;
;                                                          	BIT 0 (Ctrl_4) ..... Entidad de (Tipo)_1.
;															BIT 1 (Ctrl_4) ..... Entidad de (Tipo)_2.
;	                                                        BIT 2 (Ctrl_4) ..... Entidad de (Tipo)_3.
;	                                                        BIT 3 (Ctrl_4) ..... Entidad de (Tipo)_4.
;
;															Los bits (4-7) indican que (Tipo) de entidad tiene todos sus movimientos_
;															_ masticados ya generados.
;
;															BIT 4 (Ctrl_4) ..... MOV_MASTICADOS GENERADOS. Entidad de (Tipo)_1.
;															BIT 5 (Ctrl_4) ..... MOV_MASTICADOS GENERADOS. Entidad de (Tipo)_2.
;	                                                        BIT 6 (Ctrl_4) ..... MOV_MASTICADOS GENERADOS. Entidad de (Tipo)_3.
;	                                                        BIT 7 (Ctrl_4) ..... MOV_MASTICADOS GENERADOS. Entidad de (Tipo)_4.


; Gestión de Disparos.

Numero_de_disparotes db 0	
Puntero_DESPLZ_DISPARO_ENTIDADES defw 0
Puntero_DESPLZ_DISPARO_AMADEUS defw 0
Impacto2 db 0											; Este byte indica que se ha producido impacto:
; 														; (Impacto)="1". El impacto se produce en una entidad.
;														; (Impacto)="2". El impacto se produce en Amadeus.
Entidad_sospechosa_de_colision defw 0					; Almacena la dirección de memoria donde se encuentra el .db_
;														; _(Impacto) de la entidad que ocupa el mismo espacio que Amadeus.
;														; Necesitaremos poner a "0" este .db en el caso de que finalmente no se_
;														; _produzca colisión.
Coordenadas_disparo_certero ds 2						; Almacenamos aquí las coordenadas del disparo que ha alcanzado a Amadeus.
;											            ; (Coordenadas_disparo_certero)=Y ..... (Coordenadas_disparo_certero +1)=X.
Coordenadas_X_Amadeus ds 3								; 3 Bytes reservados para almacenar las 3 posibles columnas_
;														; _ que puede ocupar el sprite de Amadeus. (Colisión).
Coordenadas_X_Entidad ds 3  							; 3 Bytes reservados para almacenar las 3 posibles columnas_
;														; _ que puede ocupar el sprite de una entidad. (Colisión).
Velocidad_disparo_entidades db 2	  					; Nº de scanlines, (NextScan) que avanza el disparo de las entidades.

;---------------------------------------------------------------------------------------------------------------

; Relojes y temporizaciones.

Contador_de_frames db 0	 								
Contador_de_frames_2 db 0	 

Clock_explosion db 4
Clock_Entidades_en_curso db 20
Activa_recarga_cajas db 0								; Esta señal espera (Secundero)+X para habilitar el Loop.
;														; Repite la oleada de entidades.
Disparo_Amadeus db 1									; A "1", se puede generar disparo.
CLOCK_repone_disparo_Amadeus_BACKUP db 30				; Restaura (CLOCK_repone_disparo_Amadeus). 
CLOCK_repone_disparo_Amadeus db 30 						; Reloj, decreciente.

Disparo_entidad db 1									; A "1", se puede generar disparo.
CLOCK_repone_disparo_entidad_BACKUP db 20				; Restaura (CLOCK_repone_disparo_entidad). 
CLOCK_repone_disparo_entidad db 20						; Reloj, decreciente.

;---------------------------------------------------------------------------------------------------------------

; Gestión de NIVELES.

Nivel db 0												; Nivel actual del juego.
Puntero_indice_NIVELES defw 0
Datos_de_nivel defw 0									; Este puntero se va desplazando por los distintos bytes_
; 														; _ que definen el NIVEL.
; Y todo comienza aquí .....
;
; 	INICIO  *************************************************************************************************************************************************************************
;
;	5/1/24

START 

	ld sp,0												; Situamos el inicio de Stack.
	ld a,$a9 											; Habilitamos el modo 2 de interrupciones y fijamos el salto a $a9ff
	ld i,a 												; Byte alto de la dirección donde se encuentra nuestro vector de interrupciones en el registro I. ($a9). El byte bajo será siempre $ff.
	IM 2 											    ; Habilitamos el modo 2 de INTERRUPCIONES.
	DI 													 										 

	ld a,%00000111
	call Cls
	call Pulsa_ENTER									 ; PULSA ENTER para disparar el programa.

; INICIALIZACIÓN.

;	Inicializa 1er Nivel.

	ld hl,Indice_de_niveles
	ld (Puntero_indice_NIVELES),hl						 ; Situamos (Puntero_indice_NIVELES) en el 1er Nivel del índice.
	call Inicializa_Nivel								 ; Prepara el 1er Nivel del juego.

;														 ; Situa (Puntero_indice_NIVELES) el el primer defw., (nivel) del índice de niveles.
;														 ; Inicializa (Numero_de_entidades) con el nº total de malotes del nivel.
;														 ; Inicializa (Datos_de_nivel) con el `tipo´ de la 1ª entidad del nivel. 
	
;	Provisional, (para desarrollo).

	;-
;	ld hl,Numero_parcial_de_entidades
;	ld b,(hl)
;	inc b
;	dec b
;	jr z,3F	;-									   		 ; Si no hay entidades, cargamos AMADEUS.

4 call Inicia_Entidades						 

	call Inicia_punteros_de_cajas						 ; Situa (Puntero_store_caja) en el 1er .db de la 1ª caja del índice de entidades.

;														 ; Situa (Puntero_restore_caja) en el 1er .db de la 2ª caja del índice de cajas de entidades.
; Si Amadeus ya está iniciado, saltamos a [Inicia_punteros_de_cajas] y [Restore_entidad].
; (Esto se dá cuando se inicia una nueva oleada).

;	ld a,(Ctrl_1)
;	bit 3,a
;	jr nz,5F											; Loop

; 	INICIA AMADEUS !!!!!

;3 call Restore_Amadeus
;	call Inicia_Puntero_objeto
;	call Draw

;	call Guarda_movimiento_masticado	;! Provisional

;	call Guarda_foto_registros
;	call Guarda_datos_de_borrado_Amadeus

;	ld de,Amadeus_db
;	call Store_Amadeus

; 	INICIA DISPAROS !!!!!

;	call Inicia_Puntero_Disparo_Entidades
;	call Inicia_Puntero_Disparo_Amadeus

; Una vez inicializadas las entidades y Amadeus, Cargamos la 1ª entidad en DRAW.

;5 call Inicia_punteros_de_cajas 
;	call Restore_entidad

;	ld a,(Ctrl_1)
;	bit 3,a
;	jr z,6F

; Se ha producido `RECARGA' de las cajas DRAW, RES 3(HL).

;	ld hl,Ctrl_1
;	res 3,(hl)
;	jr Main

; Entidades y Amadeus iniciados. Esperamos a [FRAME].

6 ld hl,Ctrl_3
	set 0,(hl)											; Frame completo. 
	ei
	halt 

; ------------------------------------

Main 
;
;	11/12/23

; Aparece nueva entidad ???

; 														; Inicialmente, (Clock_Entidades_en_curso)="30".
;														; (Clock_Entidades_en_curso) define cuando aparecen las entidades en pantalla.
;														; Todas las entidades contenidas en un "bloque", (7 cajas), se inicializan en [START].
;														; Si (Numero_de_entidades) > "7", cuando el bloque de 7 cajas esté a "0" se inicializaráa _
;														; _un 2º bloque.

;	ld a,1
;	out ($fe),a

	ld a,(Clock_Entidades_en_curso)	
	ld b,a
	ld a,(Contador_de_frames)
	cp b
	jr nz,13F

; Si aún quedan entidades por aparecer del bloque de entidades, (7 cajas), incrementaremos (Entidades_en_curso) y calcularemos_ 
; _ (Clock_Entidades_en_curso) para la siguiente entidad.

21 ld a,(Numero_parcial_de_entidades)
	ld b,a
	ld a,(Entidades_en_curso)
	cp b
	jr z,13F
	jr nc,13F

	inc a
	ld (Entidades_en_curso),a

; - Define el tiempo que ha de transcurrir para que aparezca la siguiente entidad. ----------------------------

	ld a,(Clock_Entidades_en_curso)
;! Este valor ha de ser pseudo-aleatorio. El tiempo de aparición de cada entidad ha de ser parecido, pero_
;! _ IMPREDECIBLE !!!!
	add 100
	ld (Clock_Entidades_en_curso),a

; -------------------------------------------------------------------------------------------------------------

; Habilita disparos.

13 

;	ld hl,Disparo_Amadeus
;	ld de,CLOCK_repone_disparo_Amadeus
;	call Habilita_disparos 								; 30 Frames como mínimo entre cada disparo de Amadeus.

;	ld hl,Disparo_entidad 								; El nº de frames mínimo entre disparos de entidad será_
;	ld de,CLOCK_repone_disparo_entidad 					; _ variable y variará en función de la dificultad.
;	call Habilita_disparos 								

; COLISIONES.

;	call Selector_de_impactos							; Analizamos el contenido de (Impacto2).

; Bit 0 a "1" Impacto en entidad por disparo. ($01)
; Bit 1 a "1" Impacto en Amadeus por disparo. ($02)
; Bit 2 a "1" Colisión de Amadeus con entidad, (sin disparo). ($04)

;	xor a
;	ld (Impacto2),a										; Flag (Impacto2) a "0".

;	call Inicia_punteros_de_cajas 
;12 call Restore_entidad 								; Vuelca los datos de la entidad, hacia la que apunta (Puntero_store_caja),_
; 														; _ en DRAW.

;	ld a,(Filas)
;	and a
;	jr nz,10F 											; Nos situamos en la 1ª entidad NO VACÍA del índice de ENTIDADES.
;	call Incrementa_punteros_de_cajas
;	jr 12B

; ---------------------------------------------------------------------------------------

10 ld a,(Numero_parcial_de_entidades)
    ld b,a
	and a
	jr nz,11F

;	ld hl,Ctrl_1;
;	bit 4,(hl)
;	jp nz,16F

;! Cuando hemos destruido a todas las entidades del bloque preparamos una NUEVA OLEADA !!!!!

;	ld hl,Ctrl_1
;	set 3,(hl)											; Señal de RECARGA de las cajas DRAW activada. NUEVA OLEADA !!!!!!!!

;	ld a,(Contador_de_frames)
;	inc a
;	ld (Activa_recarga_cajas),a

; ----- ----- ----- ----- ----- ---------- ----- ----- ----- ----- ----- ---------- ----- 

11 ld a,(Entidades_en_curso)
	and a
	jr z,16F											; Si no hay entidades en curso saltamos a [Avanza_puntero_de_album_de_fotos_de_entidades].
	ld b,a												; No hay entidades que gestionar.

; ( Código que ejecutamos con cada entidad: ).

;	--------------------------------------- GESTIÓN DE ENTIDADES. !!!!!!!!!!

15 push bc 												; Nº de entidades en curso.

	call Restore_entidad								; Vuelca en la BANDEJA_DRAW la "Caja_de_Entidades" hacia la que apunta (Puntero_store_caja).


	ld a,(Ctrl_3)
	bit 2,a
	di
	jr nz,$
	ei




; Existe "Entidad_guía" ???.
; Si la Entidad_guía ha sido fulminada hemos de reemplazarla.

;	ld a,(Ctrl_3)
;	bit 1,a
;	jr nz,22F

; Almacén de "Movimientos_masticados" lleno ???
; Una "Entidad_guía" a dejado de serlo ???, (Reinicio??).
; En ese caso NO SE ACTIVA UNA NUEVA "ENTIDAD_GUÍA".

;;	ld a,(Ctrl_3)
;;	bit 3,a
;;	jr nz,22F

; Activa "Entidad_guía" siempre que no esté ya completo el almacén de productos_masticados.

;	ld hl,Ctrl_2
;	set 5,(hl)
;	ld hl,Ctrl_3
;	set 1,(hl)

; Impacto ???

;22 ld a,(Impacto)										 
;	and a
;	jr z,8F

; Hay Impacto en esta entidad.

;	ld hl,Clock_explosion								; _ a gestionar la siguiente entidad, JR 6F.
;	dec (hl)
;	jp nz,17F

;! Velocidad de la animación de la explosión.

;	ld (hl),4 											; Reiniciamos el temporizador de la explosión,_
;														; _,(velocidad de la explosión).
; !!!!!!!! Explosiónnnnnnnnn 20/9/23

;	call Repone_datos_de_borrado
;	call Limpia_Variables_de_borrado					; Guarda los datos de la entidad `impactada´ para borrarla.

;!!!!!! Desintegración/Explosión!!!!!!!!!!!

;	ld a,(Ctrl_2)
;	bit 1,a
;	jr nz,7F											; Se han iniciado los punteros de explosión???									

; Inicialización del proceso de explosión. Omitimos si ya hemos imprimido el 1er FRAME de la explosión.

;	ld a,(CTRL_DESPLZ)
;	and a
;	jr nz,18F

;	ld hl,Indice_Explosion_2x2-2
;	ld (Puntero_DESPLZ_der),hl
;	jr 19F

;18 ld hl,Indice_Explosion_2x3-2
;	ld (Puntero_DESPLZ_der),hl

;19 ld hl,Ctrl_2											; Activamos el proceso de explosión.
;	set 1,(hl)
;	jr 7F

; Si el bit2 de (Ctrl_1) está alzado, "1", hemos de comparar (Coordenadas_disparo_certero)_
; _con las coordenadas de la entidad almacenada en DRAW.

;8 ld a,(Ctrl_1)
;	bit 2,a
;	jr z,7F	

;	ld hl,(Coordenadas_disparo_certero)
;	ex de,hl 											; D contiene la coordenada_y del disparo.
;														; E contiene la coordenada_X del disparo.	
;	ld hl,(Coordenada_X) 								; L COLUMNA (Coordenada_x de la entidad).
;														; H FILA, (Coordenada_y de la entidad).	
;	and a
;	sbc hl,de

;	call Determina_resultado_comparativa

;	ld a,b
;	and a
;	jr z,7F												; B="0" significa que esta entidad no es la impactada.

; ----- ----- -----

;	ld a,1												; Esta entidad ha sido alcanzada por un disparo_
;	ld (Impacto),a 										; _de Amadeus. Lo indicamos activando su .db (Impacto).

;	ld hl,Ctrl_1
;	res 2,(hl)

7 call Mov_obj											; MOVEMOS y decrementamos (Numero_de_malotes)

;	ld a,(Ctrl_0)
;	bit 4,a
;	jr z,17F                                       	    ; Si no ha habido movimiento, NO HEMOS BORRADO, NI VAMOS A PINTAR NADA.!!!

; Voy a utilizar una rutina de lectura de teclado para disparar con cualquier entidad.
; [[[
;	call Detecta_disparo_entidad
; ]]]

	call Guarda_foto_de_mov_masticado					; PINTAMOS !!!!!!!!!!!!!!!!!!

;	ld hl,Ctrl_0
;    res 4,(hl)											; Inicializamos el FLAG de movimiento de la entidad.

17 call Store_Restore_cajas

	pop bc
	
	djnz 15B
	
	call Inicia_punteros_de_cajas 						; Hemos terminado de mover todas las entidades. Nos situamos al principio del índice de entidades.

;! Activando estas líneas podemos habilitar 2 explosiones en el mismo FRAME.
; Hemos gestionado todas las unidades.
; Desactivamos el flag de impacto en entidad por disparo de amadeus.

;	ld hl,Ctrl_1
;	res 2,(hl)

16 ld hl,Ctrl_3
	set 0,(hl)											; Frame completo. 

	xor a
	out ($fe),a

	halt 

; ----------------------------------------

;	ld a,(Ctrl_1) 										; Existe Loop?
;	bit 3,a												; Si este bit es "1". Hay recarga de nueva oleada.
	jp z,Main

; RECARGA DE NUEVA OLEADA.

;	ld a,(Contador_de_frames)
;	ld b,a
;	ld a,(Activa_recarga_cajas)
;	cp b
;	jr z,20F

;	ld hl,Ctrl_1
;	set 4,(hl)
;	jp Main

;20 ld hl,Ctrl_1
;	res 4,(hl)

;	ld a,(Contador_de_frames)

;! Este valor ha de ser pseudo-aleatorio. El tiempo de aparición de cada entidad ha de ser parecido, pero_
;! _ IMPREDECIBLE !!!!

;	add 10
;	ld (Clock_Entidades_en_curso),a

;	jp 4B

	ret

; ----- ----- ----- ----- ----- ---------- ----- ----- ----- ----- ----- ---------- ----- 
;
;	16/11/23

;;Gestiona_Amadeus

;! Activa/desactiva impacto con Amadeus.

;	ld a,(Impacto) 
;	and a
;	jr nz,2F

;;	call Mov_Amadeus

;;2 ld a,(Ctrl_0)
;;	bit 4,a
;;	jr z,1F                                            ; Omitimos BORRAR/PINTAR si no hay movimiento.

;;	call Guarda_foto_entidad_a_pintar
;;	call Guarda_datos_de_borrado_Amadeus

;;1 ld hl,Ctrl_0	
;;    res 4,(hl)											; Inicializamos el FLAG de movimiento de la entidad.

;;	call Motor_de_disparos								; Borra/mueve/pinta cada uno de los disparos y crea un nuevo album de fotos.

; Calculamos el nº de malotes y de disparotes para pintarlos nada más comenzar el siguiente FRAME.

;	call Calcula_numero_de_disparotes

;;	ret

; --------------------------------------------------------------------------------------------------------------
;
;	15/12/23

Mov_obj 

;	ld a,(Ctrl_2)
;	bit 1,a
;	jr z,2F											; Se ha iniciado la EXPLOSIÓN???									

; Explosión:

;	ld a,(Frames_explosion)
;	and a
;	jr nz,4F

;!  Una alimaña menos!!!!!!!!!1

; Se trataba de una Entidad_guía ???

;	ld a,(Ctrl_2)
;	bit 5,a 										; El bit5 de (Ctrl_2) indica si se trata de una Entidad_guía.
;	jr z,5F

;	ld hl,Ctrl_3
;	res 1,(hl) 										; FLAG (Existencia de Entidad_guía) a "0".

;!! Cuando se elimina a una entidad_guía tenemos que limpiar el almacen_de_mov_masticados de esta entidad. Así el siguiente movimiento_
;!! _generado puede ser distinto, (aletoriedad).

;5 call Borra_datos_entidad							; Borramos todos los datos de la entidad.
;	ld hl,Numero_parcial_de_entidades				; Una alimaña menos.
;	dec (hl)
;	ld hl,Entidades_en_curso
;	dec (hl)
;	ld hl,Numero_de_entidades
;	dec (hl)
;	jr 3F
	
; -----

;	`Movemos´ la explosión.

;4 ld hl,(Puntero_DESPLZ_der)
;	inc hl
;	inc hl
;	call Extrae_address
;;	ld (Puntero_objeto),hl

;;	ld hl,Frames_explosion
;;	dec (hl)

;;	ld hl,Ctrl_0
;;	set 4,(hl);;

;;	jr 3F

;	NO HAY EXPLOSIÓN ----- ----- ----- ----- -----

;2 xor a
;	ld (Ctrl_0),a 										; El bit4 de (Ctrl_0) puede estar alzado debido al movimiento de Amadeus. Inicializamos.

; Movemos Entidades malignas.
; Se trata de una "Entidad_guía" ???. Si es así ejecutamos la rutina que construye el patrón de movimiento.

;	ld a,(Ctrl_2)
;	bit 5,a
;	jr nz,8F

;	ld hl,Ctrl_0										; Movemos una entidad "FANTASMA". Activamos el FLAG de movimiento y evitamos_
;	set 4,(hl)											; _ ejecutar la rutina de Movimiento.
;	jr 7F

;8 call Movimiento										; Desplazamos el objeto. MOVEMOS !!!!!

;	ld a,(Ctrl_0) 										; Salimos de la rutina SI NO HA HABIDO MOVIMIENTO !!!!!
;	bit 4,a
;	ret z

; Ha habido desplazamiento de la entidad maligna.
; Ha llegado a zona de AMADEUS ???

;7 ld a,(Coordenada_y)
;	cp $14
;	jr c,1F						

; --------- 

;	Si la entidad en curso entra en zona de Amadeus, generamos y guardamos las 2 o 3 columnas que ocupa la entidad_ 
;	_ y las 2 o 3 columnas que ocupa Amadeus y las comparamos por si hubiera coincidencia. 

;	di
;	call Genera_coordenadas_X
;	call Compara_coordenadas_X 
;	ei

;	En el caso de existir coincidencia colocamos a "1" el .db (Impacto) de la entidad en curso y el bit2 del flag (Impacto2).

; ---------

;1 call Prepara_var_pintado	 			                		; HEMOS DESPLAZADO LA ENTIDAD!!!. Almaceno las `VARIABLES DE PINTADO´en su {Variables_de_pintado}.      
	call Repone_datos_de_borrado 								; ! BORRAMOS !!!. Guardamos la foto de las {Variables_de_borrado} en Album_de_fotos.
	call Limpia_Variables_de_borrado

3 ret													

; --------------------------------------------------------------------------------------------------------------
;
;	29/1/23

Mov_Amadeus 

;	call Movimiento_Amadeus 							; MOVEMOS AMADEUS.

	call Mov_right

	ld a,(Ctrl_0) 										; Salimos de la rutina SI NO HA HABIDO MOVIMIENTO !!!!!
	bit 4,a
	ret z

; ---------

;    call Prepara_var_pintado			                ; HEMOS DESPLAZADO AMADEUS.!!!. Almaceno las `VARIABLES DE PINTADO´.         
	call Repone_datos_de_borrado_Amadeus
	call Limpia_Variables_de_borrado

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
	call Guarda_movimiento_masticado

	call Movimiento

	ld a,(Ctrl_3)											; El bit1 de (Ctrl_3) a "1" indica que hemos completado todo el patrón de movimiento_
	bit 1,a 												; _ que corresponde a esta entidad.
	jr z,1B

;	Hemos completado el almacén de movimientos masticados de la entidad.
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

	push hl
    push ix
    push iy
 
    ld sp,(Stack)

   	ld hl,(Contador_de_mov_masticados)						; Incrementa en una unidad el (Contador_de_mov_masticados).
	inc hl
	ld (Contador_de_mov_masticados),hl

    call Actualiza_Puntero_de_almacen_de_mov_masticados 	; Actualizamos (Puntero_de_almacen_de_mov_masticados) e incrementa_
;															; _ el (Contador_de_mov_masticados).    
    ret

; --------------------------------------------------------------------------------------------------------------
;
;	12/1/24
;
;	INPUTS: HL a de contener (Puntero_de_almacen_de_mov_masticados).

Actualiza_Puntero_de_almacen_de_mov_masticados 

	ld hl,(Puntero_de_almacen_de_mov_masticados)
	ld bc,6
	and a
	adc hl,bc
	ld (Puntero_de_almacen_de_mov_masticados),hl
	ret

; --------------------------------------------------------------------------------------------------------------
;
;	15/01/24
;
;	Cargamos los registros_
;	_ HL,IX e IY con las 3 palabras que componen el movimiento masticado a ejecutar.
;	
;	HL contiene la dirección de la rutina de impresión.
;	IX contiene el puntero de impresión.
;	IY contiene (Puntero_objeto).
 

Cargamos_registros_con_mov_masticado ld (Stack),sp
	ld sp,(Puntero_de_almacen_de_mov_masticados)

	pop iy
	pop ix
	pop hl

	ld (Puntero_de_almacen_de_mov_masticados),sp 					; Actualiza (Puntero_de_almacen_de_mov_masticados).

	ld sp,(Stack)

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	28/12/23
;
;	(Guardo la foto de la entidad ejecutando DRAW, pues ha habido movimiento del Sprite y una posible_
;   _recolocación. Guarda la IMÁGEN DE LA ENTIDAD A PINTAR. 

Guarda_foto_entidad_a_pintar 

	ld a,(Ctrl_0)
	bit 6,a
	jr z,5F

;	Guarda la foto de Amadeus.

;	call Draw
;	call Guarda_movimiento_masticado	;! Provisional
	call Guarda_foto_registros
	ret

; ENTIDADES!
; Está lleno el {Almacen_de_movimientos_masticados_Entidad_1}. ?

5 ld a,(Ctrl_3)
	bit 3,a
	jr z,1F
	
; {Almacen_de_movimientos_masticados_Entidad_1} lleno. Se trata de una "ENTIDAD_FANTASMA".

4
;	call Prepara_registros_con_mov_masticados	; (Tb Guarda_foto_registros).
	ret

; Hemos completado el último movimiento del patrón de movimientos ???, se ha aplicado REINICIO ???

1 ld a,(Ctrl_3)
	bit 2,a
	jr nz,6F

; Entidad guía o fantasma ???

	ld a,(Ctrl_2)
	bit 5,a
	jr nz,3F

; ENTIDAD_FANTASMA, preparo los "movimientos_masticados" y guardo_foto.

	jr 4B

; ENTIDAD_GUÍA:
; Se acaba de llenar el almacén ???. Si no es así seguimos ejecutando [DRAW] y continuaremos_
; _guardando "movimientos_masticados". 

2 ld a,(Ctrl_3)
	bit 2,a
	jr z,3F

; Hemos completado todos los movimientos masticados. Se trata de una "Entidad_fantasma" recién creada.
; Vamos a `generar el último "movimiento_masticado". A partir de este momento esta "Entidad_fantasma", (recién creada), pasa a guardar fotos de movimientos masticaditos.

6 res 2,a
	set 3,a
	ld (Ctrl_3),a


;	Esto sólo lo ejecuta una entidad guía.

3 	call Draw 											
	call Guarda_movimiento_masticado
	call Guarda_foto_registros							; Hemos modificado (Stack_snapshot), +6.

; Este ha sido el último "movimiento_masticado" que hemos guardado ???
; Si es así, hemos de reinicializar el (Puntero_de_mov_masticados) y el (Contador_de_mov_masticados) de la entidad.

;	call Convierte_guia_en_fantasma
	ret	

; *************************************************************************************************************************************************************
;
; 8/1/23
;
; (Puntero_store_caja) contendrá la dirección donde se encuentran los parámetros de la 1ª entidad del índice.
; (Indice_restore_caja) se sitúa en la 2ª entidad del índice. 	
; (Puntero_restore_caja) contendrá la dirección donde se encuentran los parámetros de la 2ª entidad del índice.

; Destruye HL y DE !!!!!
 
Inicia_punteros_de_cajas 

	ld hl,Indice_de_cajas_de_entidades
    call Extrae_address
    ld (Puntero_store_caja),hl
	ld hl,Indice_de_cajas_de_entidades+2
	ld (Indice_restore_caja),hl
	call Extrae_address
	ld (Puntero_restore_caja),hl
    ret

; *************************************************************************************************************************************************************
;
; 8/1/23
;
;	Inicializamos los punteros de selección de los 2 índices de disparo, Amadeus y Entidades.

Inicia_Puntero_Disparo_Entidades ld hl,Indice_de_disparos_entidades
	ld (Puntero_DESPLZ_DISPARO_ENTIDADES),hl
	ret
Inicia_Puntero_Disparo_Amadeus ld hl,Indice_de_disparos_Amadeus
	ld (Puntero_DESPLZ_DISPARO_AMADEUS),hl
	ret

; -------------------------------------------------------------------------------------------------------------
;
; 21/9/23 
;

; Album_de_fotos_Amadeus equ $72a0 ; (72a0h - 72ach).

Limpia_album_Amadeus 

	ld hl,Album_de_fotos_Amadeus
	ld a,(hl)
	and a
	ret z

	ld hl,Album_de_fotos_Amadeus
	ld de,Album_de_fotos_Amadeus+1
	ld bc,11
	xor a
	ld (hl),a
	ldir

	ld hl,Album_de_fotos_Amadeus
	ld (End_Snapshot_Amadeus),hl

	ret

Limpia_Variables_de_borrado ld hl,Variables_de_borrado 
	ld de,Variables_de_borrado+1
	ld bc,5
	xor a
	ld (hl),a
	ldir
	ret

; -------------------------------------------------------------------------------------------------------------
;
; 8/9/23 
;

; (Numero_de_malotes) lo utiliza la rutina [Extrae_foto_entidades] para borrar/pintar entidades en pantalla.
; Se calcula dividiendo entre 6 el nº de bytes que contiene el Album_de_fotos.

Calcula_numero_de_malotes 

	ld hl,Album_de_fotos
	ex de,hl
	ld hl,(Stack_snapshot)

	ld b,0
	ld a,l
	sub e
	jr z,1F

; Nº de malotes no es "0".

2 sub 6
	inc b
	and a
	jr nz,2B
	ld a,b

1 ld (Numero_de_malotes),a					
	ret

; -------------------------------------------------------------------------------------------------------------
;
; 8/9/23 
;

; (Numero_de_malotes_Amadeus) lo utiliza la rutina [Extrae_foto_Amadeus] para borrar/pintar la nave en pantalla.
; Se calcula dividiendo entre 6 el nº de bytes que contiene el Album_de_fotos.

Calcula_malotes_Amadeus 

	ld hl,Album_de_fotos_Amadeus
	ex de,hl
	ld hl,(End_Snapshot_Amadeus)

	ld a,h
	and a
	jr z,1F										; (End_Snapshot_Amadeus) = "$0000" significa que el álbum está vacío.

	ld b,0
	ld a,l
	sub e
	jr z,1F

; Nº de malotes no es "0".

2 sub 6
	inc b
	and a
	jr nz,2B
	ld a,b

1 ld (Numero_de_malotes),a					
	ret

; -------------------------------------------------------------------------------------------------------------
;
; 28/2/23 
;

Calcula_numero_de_disparotes 

	ld hl,Album_de_fotos_disparos
	ex de,hl
	ld hl,(End_Snapshot_disparos)

	ld b,0
	ld a,l
	sub e
	jr z,1F

; Nº de malotes no es "0".

2 sub 6
	inc b
	and a
	jr nz,2B
	ld a,b

1 ld (Numero_de_disparotes),a
	ret

; *************************************************************************************************************************************************************
;
; 20/10/22
;
; Extrae la direccioń que contiene un puntero, (HL), también en HL.
;
; Destruye el puntero y DE !!!!!

Extrae_address ld e,(hl)
	inc hl
	ld d,(hl)
	dec hl
	ex de,hl
	ret

; *************************************************************************************************************************************************************
;
;	20/1/24
;
;	Iniciamos (Puntero_DESPLZ_der) y (Puntero_DESPLZ_izq). 
;	Sitúa (Puntero_objeto) en el Sprite correspondiente en función de su (Posicion_inicio).
;
;   Destruye HL y BC !!!!!, 
;
;	BIT 7 (Ctrl_0). "1" ..... Derecha.
;					"0" ..... Izquierda.

Inicia_Puntero_objeto 

	ld a,(Cuad_objeto)
	and 1
	push af
	call z,Inicia_puntero_objeto_izq
	pop af
	ret z
	call Inicia_puntero_objeto_der
	ret

; Arrancamos desde la parte izquierda de la pantalla.
; Iniciamos (Indice_Sprite_der).  

Inicia_puntero_objeto_der ld hl,(Indice_Sprite_der)			
	ld (Puntero_DESPLZ_der),hl
	call Extrae_address
	ld (Puntero_objeto),hl

	ld hl,(Indice_Sprite_izq)							; Cuando "Iniciamos el Sprite a derecha",_					
	ld (Puntero_DESPLZ_izq),hl
	ret

; Arrancamos desde la parte derecha de la pantalla.
; Iniciamos (Indice_Sprite_izq).  

Inicia_puntero_objeto_izq ld hl,(Indice_Sprite_izq)			
	ld (Puntero_DESPLZ_izq),hl
	call Extrae_address
	ld (Puntero_objeto),hl

	ld hl,(Indice_Sprite_der)							; Cuando "Iniciamos el Sprite a izquierda",_					
	ld (Puntero_DESPLZ_der),hl							; _situamos (Puntero_DESPLZ_der) en el último defw_
	ret

; **************************************************************************************************
;
;	31/01/24
;
;	Cargamos los datos de la caja de entidades señalada por el puntero (Puntero_store_caja) a la BANDEJA_DRAW.

Restore_entidad 

	ld hl,(Puntero_store_caja)						
	ld de,Bandeja_DRAW
	ld a,(hl)
	ld (de),a
	inc hl 											; (Tipo).

	ld de,Coordenada_X								; Nos situamos en (Coordenada_X) de la bandeja DRAW. 										
	ld bc,2
	ldir 											; Hemos transferido (Coordenada_X) y (Coordenada_Y) a la bandeja.

	inc de
	ld a,(hl)
	ld (de),a 										; Transferimos (Attr).
	inc hl

	ld de,Impacto

	ld a,(hl)
	ld (de),a 										; Transferimos (Impacto).					
	inc hl

	inc de

	ld bc,6
	ldir

	ld bc,7
	ldir 											; Transferimos (Puntero_de_impresion), (Puntero_de_almacen_de_mov_masticados),_
; 													; _ (Contador_de_mov_masticados) y (Ctrl_0).	
	ld de,Ctrl_2

	ld a,(hl)
	ld (de),a 										; Transferimos (Ctrl_2).

	ret

; **************************************************************************************************
;
;	08/05/23
;
;	Incrementamos los dos punteros de entidades. (+1).

Incrementa_punteros_de_cajas 

	ld hl,(Puntero_restore_caja)
	ld (Puntero_store_caja),hl 				
	ld hl,(Indice_restore_caja)
	inc hl
	inc hl
	ld (Indice_restore_caja),hl
    call Extrae_address
    ld (Puntero_restore_caja),hl
    ret

; **************************************************************************************************
;
;	21/12/23
;
;	Restore_Amadeus
;
;	Cargamos en DRAW los parámetros de Amadeus.
;	

Restore_Amadeus	push hl 
	push de
 	push bc
	ld hl,Amadeus_db									; Cargamos en DRAW los parámetros de Amadeus.
	ld de,Bandeja_DRAW
	ld bc,42
	ldir
	pop bc
	pop de
	pop hl
	ret

; *************************************************************************************************************************************************************
;
;	21/12/23
;
;	Store_Amadeus
;
;	Almacena los datos de la entidad alojada en DRAW, (incl. Amadeus), en su respectiva base de datos.
;	
;	INPUT: DE contiene la dirección del 1er byte de la base de datos donde vamos a guardar los datos de la entidad.
;
;	DESTRUYE: HL y BC y DE.

Store_Amadeus ld hl,Bandeja_DRAW											; Cargamos en DRAW los parámetros de Amadeus.
	ld bc,42
	ldir
	ret

; -----------------------------------------------------------
;
;	21/12/23
;
; 	Limpia los datos del almacén de entidades de DRAW, (donde se encuentra la "entidad impactada").
;
;	Destruye: HL,BC,DE,A

Borra_datos_entidad ld hl,Bandeja_DRAW
	ld bc,41
	xor a
	ld (hl),a
	ld de,Bandeja_DRAW+1
	ldir
	ret

; -----------------------------------------------------------

; Teclado.

Pulsa_ENTER ld a,$bf 									; Esperamos la pulsación de la tecla "ENTER".
	in a,($fe)
	and $01
	jr z,1f
	jr Pulsa_ENTER
1 ret

; **************************************************************************************************
;
; Temporización.

; $0320 ..... El RASTER va a empezar a pintar el 1er scanline de la primera FILA de la pantalla.
;       ..... (14175 T/States) + 71 es lo que tarda el RASTER en llegar al 1er SCANLINE de la 1ª FILA.
; $00ff ..... Es lo que tarda el RASTER en pintar 1 SCANLINE. (31 T/States) + 71. ..... 102 T/States aprox. 
;		..... 224 T/States es lo que tarda el raster en pintar 1 scanline.

; $0045 ..... Es lo que tardamos en pintar 1 FILA completa, (8 Scanlines). (1794 T/States) + 71 ..... 1 FILA.
;       ..... (14920 T/States) + 71  ..... Es lo que tarda el RASTER en pintar 1 TERCIO.
; $0365 ..... Llegamos al final de la 1ª FILA, (8 Scanlines).

; A partir de $4f61 no hace falta DELAY.

;	!!!!!!!! DESTRUYE BC !!!!!!!!!!!

DELAY LD BC,$0320							;$0320 ..... Delay mínimo
wait DEC BC  								;Sumaremos $0045 por FILA a esta cantidad inicial. Ejempl: si el Sprite ocupa la 1ª y 2ª_				
	LD A,B 										
	AND A
	JR NZ,wait
	RET

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	5/3/23
;
;	En 1er lugar detectamos disparo (5), seguido de los movimientos a izq. / derecha.

Movimiento_Amadeus 

; Disparo.

	ld a,(Disparo_Amadeus)
	and a
	jr nz,1F
	jr 2F

1 ld a,$f7													; "5" para disparar.
	in a,($fe)
	and $10

	push af
	call z,Genera_disparo
	pop af
	jr nz,2F

	ld a,(Disparo_Amadeus)
	xor 1
	ld (Disparo_Amadeus),a
2 ld a,$f7		  											; Rutina de TECLADO. Detecta cuando se pulsan las teclas "1" y "2"  y llama a las rutinas de "Mov_izq" y "Mov_der". $f7  detecta fila de teclas: (5,4,3,2,1).
	in a,($fe)												; Carga en A la información proveniente del puerto $FE, teclado.
	and $01													; Detecta cuando la tecla (1) está actuada. "1" no pulsada "0" pulsada. Cuando la operación AND $01 resulta "0"  llama a la rutina "Mov_izq".
    call z,Mov_left											;			"			"			"			"			"			"			"			"

	ld a,$f7
	in a,($fe)
	and $01
	ret z

	ld a,$f7
	in a,($fe)												; Carga en A la información proveniente del puerto $FE, teclado.
	and $02													; Detecta cuando la tecla (1) está actuada. "1" no pulsada "0" pulsada. Cuando la operación AND $02 resulta "0"  llama a la rutina "Mov_der".
	call z,Mov_right										;			"			"			"			"			"			"			"			"
	ret	

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	Rutina provisional para que los malotes cagen balas.

Detecta_disparo_entidad 

	ld a,(Disparo_entidad)
	and a
	ret z

;! Aquí hemos de implementar la rutina/s que generan disparo...

;	ld a,$7f				; Detecta SPACE.
;	in a,($fe)
;	and 1
;	ret nz

	call Genera_disparo
	ret

; ----------------------------------------------------------------------
;
;	8/9/23

Guarda_datos_de_borrado_Amadeus	ld hl,(End_Snapshot_Amadeus)
 	dec hl
	ld a,(hl)
	and a
	ret z										; Salimos si es álbum está vacío.

	ld de,Variables_de_borrado+5
	ld bc,6
	lddr
	ret

; ----------------------------------------------------------------------
;
;	9/9/23

Repone_datos_de_borrado_Amadeus

	ld hl,Variables_de_borrado
	ld de,Album_de_fotos_Amadeus
	ld bc,6
	ldir

	ex de,hl
	ld (End_Snapshot_Amadeus),hl

	ret

; ----------------------------------------------------------------------
;
;	27/10/23
;

;	Si se ha producido movimiento de la entidad en curso, esta rutina vuelca las `Variables_de_borrado´ en el_
;	_ Album_de_fotos correspondiente.

;	El proceso de "escritura en los álbumes de fotos" no puede verse interrumpido por la rutina FRAME, (di/ei)_
;	_ durante el proceso de escritura.

Repone_datos_de_borrado

	ld de,(Stack_snapshot)
	ld hl,Variables_de_borrado
	ld bc,6
	ldir

	ex de,hl
	ld (Stack_snapshot),hl

	ret

; --------------------------------------------------------------------------------------

Pinta_Amadeus 

   	call Calcula_malotes_Amadeus 
	call Extrae_foto_Amadeus
	call Limpia_album_Amadeus

	ret

Pinta_entidades

;	Salimos de la rutina si la foto con todas las entidades a pintar no está completa.		

	ld a,(Ctrl_3)
	bit 0,a
	ret z

	ld a,(Ctrl_3)
	bit 2,a
	jr z,1F
	
;	Sólo queremos borrar. Estamos reiniciando la entidad. Hemos de modificar (Stack_snapshot) para que la rutina [Extrae_foto_entidades] calcule el nº de malotes correctamente. 	

	ld hl,(Stack_snapshot)
	ld bc,6
	and a
	sbc hl,bc
	ld (Stack_snapshot),hl

1 call Calcula_numero_de_malotes
	call Extrae_foto_entidades 						
	call Limpia_y_reinicia_Stack_Snapshot 

	ret

; -----------------------------------------------------------------------------------
;
;	10/12/23
;
;	Incrementa los relojes cada vez que se ejecuta un FRAME completo, (se ha completado la foto de todas las entidades).

Actualiza_relojes 

	ld a,(Ctrl_3)
	bit 0,a
	ret z 						;	Salimos si no hemos pintado unidades.

	ld hl,Contador_de_frames	;	20 ms. (Contador_de_frames)=$ff ..... 5.1 segunados aprox.
	inc (hl)
	
	inc (hl)
	dec (hl)
	ret nz

	ld hl,Contador_de_frames_2	;	5.1 segundos. (Contador_de_frames_2)=$ff ..... 1300.5 segundos, 21.675 minutos.  
	inc (hl)
	ret

; ---------------------------------------------------------------

	include "Rutinas_de_inicio_y_niveles.asm"
	include "Draw_XOR.asm"
	include "Rutinas_de_impresion_sprites.asm" 
	include "Direcciones.asm"
	include "Movimiento.asm"
	include "Disparo.asm"
	include "Relojes_y_temporizaciones.asm"
	include "calcula_tercio.asm"
	include "Cls.asm"
	include "Genera_coordenadas.asm"
	include "Guarda_foto_registros.asm"

	SAVESNA "Pruebas.sna", START




