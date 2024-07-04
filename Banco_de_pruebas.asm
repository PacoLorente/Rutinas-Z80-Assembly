;	9/1/24

	DEVICE ZXSPECTRUM48

;	IM_2 *************************************************************************************************************************************************************************
;
;	20/6/24

	org $a9ff

	defw $aa01

;	Incrementa FRAMES. (ROM).

	push af
	push hl

; -------------------
	ld hl,Ctrl_3	;	STOP si no hemos terminado de construir el FRAME.
	bit 0,(hl)
	jr z,$
; -------------------

	ld hl,(FRAMES)
	inc hl
	ld (FRAMES),hl

	ld a,h
	or l
	jr nz,1F

	ld hl,FRAMES_3
	inc (hl)

1 push de
	push bc

	call Actualiza_pantalla

	pop bc
	pop de
	pop hl
	pop af

	ei

	ret

; --------------------------------------------------------------------------------

	include "Sprites_e_indices.asm"
	include "Cajas_y_disparos.asm"
	include "Patrones_de_mov.asm"
	include "Niveles.asm"

; ******************************************************************************************************************************************************************************************
; Constantes. 
; ****************************************************************************************************************************************************************************************** 
;
; 09/03/24

;
; Constantes.
;
 
;Variables ROM. FRAMES y KEYBOARD. Rutina Interrupción mascarable $0038.

FRAMES equ $5c78										; Variable de 24 bits. Almacena el nº de cuadros, (frames) que llevamos construidos. Reloj en tiempo real.
FRAMES_3 equ $5c7a

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Sprite_vacio equ $eae0									; ($eae0 - $eb10) 48 Bytes de "0".

Centro_arriba equ $0160 								; Emplearemos estas constantes en la rutina de `recolocación´ del objeto:_
Centro_abajo equ $0180 									; _[Comprueba_limite_horizontal]. El byte alto en las dos primeras constantes_
Centro_izquierda equ $0f 								; _indica el tercio de pantalla, (línea $60 y $80 del 2º tercio de pantalla).
Centro_derecha equ $10 									; Las constantes (Centro_izquierda) y (Centro_derecha) indican la columna $0f y $10 de pantalla.

Almacen_de_movimientos_masticados_Entidad_1 equ $eb20	; $eb20 - $f87b ..... 3419 bytes. Guardaremos los movimientos masticados que ha hido generando la entidad guía.
Almacen_de_movimientos_masticados_Amadeus equ $e000		; ($e000 - $e1e3), 483 bytes. Movimientos masticados de Amadeus.

Scanlines_album equ $8000	;	($8000 - $8118) 		; Inicialmente 280 bytes. 
Scanlines_album_2 equ $9000    ;    ($9000 - $9118)
Amadeus_scanlines_album equ $8120	;	($8120 - $8142)
Amadeus_scanlines_album_2 equ $8143	;	($8143 - $8166)

;                                                       ; 35 bytes por entidad. 
;														; 1. 2 Bytes ..... .defw  Puntero_objeto, (mem. address donde se encuentran los .db que forman los distintos sprites).
;                                                       ; 2. 1 Byte ..... .db  Indica el nº de scanlines que vamos a imprimir del sprite. Generalmente 16 scanlines.
;														; El nº de scanlines será menor cuando estemos `desapareciendo´ por la parte baja de la pantalla.					 	
; 														; 3. 32 Bytes, (como máximo). Screen mem. address de cada uno de los scanlines que forman el sprite.


; ******************************************************************************************************************************************************************************************
; Variables. 
; ****************************************************************************************************************************************************************************************** 

;
; 12/05/24
;
; Variables de DRAW. (Motor principal).	44 Bytes.	
;

Bandeja_DRAW ; -----------------------------------------------------------------------------------------------

Tipo db 0												; Clase de la entidad. Cada `tipo´ de Entidad tiene unas características únicas que lo distinguen de otros tipos: 
;															- Patrón de movimiento.
Coordenada_X db 0 										; Coordenada X del objeto. (En chars.)
Coordenada_y db 0 										; Coordenada Y del objeto. (En chars.)

Contador_de_vueltas db 0								; Contador de vueltas de entidades. Inicialmente su valor es "1". El bit se desplaza una posición a la izquierda cada vez que la entidad_
;														; _desaparece por la parte baja de la pantalla. Esta variable se utiliza para incrementar el perfil de velocidad de las entidades.

; Incrementa el contador de vueltas, (el contador cuenta 4 vueltas máximo).
; El perfil de velocidad de la entidad será: (Contador_de_vueltas)/8.
; Ejemplos.

;	1ª vuelta: (Contador_de_vueltas)="$02" --- (Velocidad)="0".
;	2ª vuelta: 	""	""	""	""	""  ="$04" ---   ""	 ""	  ="1".
;	3ª vuelta: 	""	""	""	""	""  ="$08" ---   ""	 ""	  ="2".
;	4ª vuelta: 	""	""	""	""	""  ="$10" ---   ""	 ""	  ="4".
;	5ª vuelta: 	""	""	""	""	""  ="$20" ---   ""	 ""	  ="8".   

Impacto db 0											; Si después del movimiento de la entidad, (Impacto) se coloca a "1",_
;														; _ existen muchas posibilidades de que esta entidad haya colisionado con Amadeus. 
; 														; Hay que comprobar la posible colisión después de mover Amadeus. En este caso, (Impacto2)="3".

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

Ctrl_2 db 0 											
;														BIT 0, Los sprites se inician con un `sprite vacío', (sprite formado por "ceros"), cuando la rutina_
;															_ [Genera_datos_de_impresion] guarda su 1ª imagen.
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

Velocidad db 0 											; 5 vueltas max. 5 vueltas       1 - 0 (1ª vuelta - velocidad 0)
;																						 2 - 0 (2ª vuelta - velocidad 0)
;																						 4 - 1 (3ª vuelta - velocidad 1)
;																						 8 - 2 (4ª vuelta - velocidad 2)
;																					   $10 - 4 (5ª vuelta - velocidad 3) 																		

; ----- ----- De aquí para arriba son los datos que se trasfieren a las cajas de entidades. ¡¡¡¡¡

Filas db 0												; Filas. [DRAW]
Columns db 0 	  										; Nº de columnas. [DRAW]
Posicion_actual defw 0									; Dirección actual del Sprite. [DRAW]
Puntero_objeto defw 0									; Donde están los datos para pintar el Sprite.

; ---------- ---------- ---------- ---------;      ;--------- ---------- ---------- ---------- 

CTRL_DESPLZ db 0										; Este byte nos indica la posición que tiene el Sprite dentro del mapa de desplazamientos.
; 														; El hecho de que este byte sea distinto de "0", indica que se ha modificado el nº de columnas del objeto.
; 														; Cuando vamos a imprimir un Sprite en pantalla, la rutina de pintado consultará este byte para situar (Puntero_objeto). [Mov_left]. 

; ---------- ---------- ---------- ---------;      ;--------- ---------- ---------- ---------- 

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

; Variables_de_borrado ds 6 							


; Variables de funcionamiento. [DRAW].

Columnas db 0
Limite_horizontal defw 0 								; Dirección de pantalla, (scanline), calculado en función del tamaño del Sprite. Si el objeto llega a esta línea se modifica_    
; 														; _(Posicion_actual) para poder asignar un nuevo (Cuad_objeto).
Limite_vertical db 0 									; Nº de columna. Si el objeto llega a esta columna se modifica (Posicion_actual) para poder asignar un nuevo (Cuad_objeto).

; variables de control general.

Frames_explosion db 0 									; Nº de Frames que tiene la explosión.

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

Ctrl_1 db 0 											; Byte de control de propósito general.

;														DESCRIPCIÓN:
;
;														BIT 0, La rutina de generación de disparos, [Genera_disparo], pone este bit a "1" para indicar a la_
;															_ rutina [Genera_datos_de_impresion] que los datos a guardar pertenecen a un disparo y no a una entidad,_
;															_ por lo tanto hemos de almacenarlos en `Scanlines_album_disparos´ en lugar de `Scanlines_album´.
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
;														; Esta variable es utilizada por la rutina [Genera_datos_de_impresion]_
;														; _ para actualizar el puntero (Scanlines_album_SP) o reiniciarlo cuando_
;														; _ (Numero_de_malotes)="0".
Puntero_indice_ENTIDADES defw 0 						; Se desplazará por el índice de entidades para `meterlas' en cajas.
Datos_de_entidad defw 0									; Contiene los bytes de información de la entidad hacia la que apunta el 
;														; _ puntero (Indice_entidades).

;---------------------------------------------------------------------------------------------------------------
;
;	02/07/24
;
;	Álbumes.

Stack defw 0 											; La rutinas de pintado, utilizan esta_
;														; _variable para almacenar lo posición del puntero_
; 														; _de pila, SP.
Stack_2 defw 0											; 2º variable destinada a almacenar el puntero de pila, SP.
;														; La utiliza la rutina [Extrae_foto_registros].

; Impresión. ----------------------------------------------------------------------------------------------------

Album_de_pintado defw 0
Album_de_borrado defw 0
Album_de_pintado_Amadeus defw 0
Album_de_borrado_Amadeus defw 0
Techo_Scanlines_album defw 0
Techo_Scanlines_album_2 defw 0
Switch db 0
Techo defw 0
Scanlines_album_SP defw 0
India_SP defw Tabla_de_pintado 
India_2_SP defw Tabla_de_pintado+3

Ctrl_3 db 0												; 2º Byte de Ctrl. general, (no específico) a una única entidad.
;
;															BIT 0, "1" Indica que el FRAME está completo, (hemos podido hacer la foto de todas las entidades).
;															BIT 1, "1" Indica que hemos completado todo el patrón de movimientos de este tipo de entidad.
;																_ El almacén de movimientos masticados de este tipo de entidad quedará completo. ([Inicia_entidad]).
;															BIT 2, "1" Indica que se produce movimiento en alguna entidad, (modificamos el último FRAME impreso en pantalla).
;																Habilita el borrado/pintado de sprites.
;															BIT 3, "1" Este bit lo coloca a "1" la rutina [Borra_diferencia] para indicar que hemos actualizado el (Techo_de_pintado)_
;																_ a la baja. 
; 															BIT 4, "1" Indica que hemos terminado de ordenar la Tabla_de_pintado. Podremos salir así de la rutina [Ordena_tabla_de_impresion].
;															BIT 5, "1" Indica que existe movimiento de Amadeus.


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

;Numero_de_disparotes db 0	
;Puntero_DESPLZ_DISPARO_ENTIDADES defw 0
;Puntero_DESPLZ_DISPARO_AMADEUS defw 0
Impacto2 db 0											; Este byte indica que se ha producido impacto:
; 														; (Impacto)="1". El impacto se produce en una entidad.
;														; (Impacto)="2". El impacto se produce en Amadeus.
;
;														; bit_2. La rutina [Genera_coordenadas_X] coloca este bit a "1" para indicar que hay una posible colisión entre una entidad y Amadeus.
;																 Una de la entidades ha entrado en zona de Amadeus y alguna de sus columnas coincide con las de nuestra nave.
;																 El bit indica que hay que ejecutar [Detecta_colision_nave_entidad] al principio de [Main], (Construcción del frame).


Entidad_sospechosa_de_colision defw 0					; Almacena la dirección de memoria donde se encuentra el .db_
;														; _(Impacto) de la entidad que ocupa el mismo espacio que Amadeus.
;														; Necesitaremos poner a "0" este .db en el caso de que finalmente no se produzca colisión.

;Coordenadas_disparo_certero ds 2						; Almacenamos aquí las coordenadas del disparo que ha alcanzado a Amadeus.
;											            ; (Coordenadas_disparo_certero)=Y ..... (Coordenadas_disparo_certero +1)=X.
Coordenadas_X_Entidad ds 3  							; 3 Bytes reservados para almacenar las 3 posibles columnas_
;														; _ que puede ocupar el sprite de una entidad. (Colisión).
Coordenadas_X_Amadeus ds 3								; 3 Bytes reservados para almacenar las 3 posibles columnas_
;														; _ que puede ocupar el sprite de Amadeus. (Colisión).
;Velocidad_disparo_entidades db 2	  					; Nº de scanlines, (NextScan) que avanza el disparo de las entidades.

;---------------------------------------------------------------------------------------------------------------

; Relojes y temporizaciones.

Clock_explosion db 4									; Temporización de las explosiones, (velocidad de la explosión).

RND_SP defw Numeros_aleatorios							; Puntero que se irá desplazando por el SET de nº aleatorios.

Clock_next_entity defw 0								; Transcurrido este tiempo aparece una nueva entidad.
Activa_recarga_cajas db 0								; Esta señal espera (Secundero)+X para habilitar el Loop.
;														; Repite la oleada de entidades.
Disparo_Amadeus db 1									; A "1", se puede generar disparo.
;CLOCK_repone_disparo_Amadeus_BACKUP db 30				; Restaura (CLOCK_repone_disparo_Amadeus). 
;CLOCK_repone_disparo_Amadeus db 30 						; Reloj, decreciente.

;Disparo_entidad db 1									; A "1", se puede generar disparo.
;CLOCK_repone_disparo_entidad_BACKUP db 20				; Restaura (CLOCK_repone_disparo_entidad). 
;CLOCK_repone_disparo_entidad db 20						; Reloj, decreciente.

;---------------------------------------------------------------------------------------------------------------

; Gestión de NIVELES.

Nivel db 0												; Nivel actual del juego.
Puntero_indice_NIVELES defw 0
Datos_de_nivel defw 0									; Este puntero se va desplazando por los distintos bytes_
; 														; _ que definen el NIVEL.

; 	INICIO  *************************************************************************************************************************************************************************
;
;	5/1/24

START 

	ld sp,0												; Situamos el inicio de Stack.
	ld a,$a9 											; Habilitamos el modo 2 de interrupciones y fijamos el salto a $a9ff
	ld i,a 												; Byte alto de la dirección donde se encuentra nuestro vector de interrupciones en el registro I. ($a9). El byte bajo será siempre $ff.
	IM 2 											    ; Habilitamos el modo 2 de INTERRUPCIONES.
	DI 					

; Limpiamos pantalla.

	ld a,%00000111
;	call Cls
	call Pulsa_ENTER									 ; PULSA ENTER para disparar el programa.

; INICIALIZACIÓN.

	ld b,7   											 ; Generamos 7 nº aleatorios.
	call Derivando_RND 									 ; Rutina de generación de nº aleatorios.
	call Extrae_numero_aleatorio_y_avanza

	ld l,a
	ld h,0
	ld (Clock_next_entity),hl 							 ; El 1er nº aleatorio define cuando aparece la 1ª entidad en pantalla. 

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

	call Inicia_albumes_de_lineas						 ; (Album_de_pintado) contiene $8000
;														 ; (Album_de_borrado) contiene $9000

4 call Inicia_Entidades						 
	call Inicia_Amadeus

;														 ; La rutina [Genera_datos_de_impresion] habilita las interrupciones antes del RET. 
;														 ; DI nos asegura que no vamos a ejecutar FRAME hasta que no tengamos todas las entidades iniciadas.
;														 ; La rutina [Genera_datos_de_impresion] activa las interrupciones antes del RET.

	ld de,Amadeus_BOX
	call Parametros_de_bandeja_DRAW_a_caja	 			 ; Volcamos Amadeus en (Amadeus_BOX).
	call Limpiamos_bandeja_DRAW

; 	Situamos a Amadeus en el centro de la pantalla y pintamos.

	ld b,60
2 call Amadeus_a_izquierda
	djnz 2B

	call Genera_datos_de_impresion_Amadeus

;! ---------------------------------------------------------------------------------------------------------------------------------------------------------

	call Inicia_punteros_de_cajas						 ; Situa (Puntero_store_caja) en el 1er .db de la 1ª caja del índice de entidades.
;														 ; Situa (Puntero_restore_caja) en el 1er .db de la 2ª caja del índice de cajas de entidades.
; Si Amadeus ya está iniciado, saltamos a [Inicia_punteros_de_cajas] y [Restore_entidad].
; (Esto se dá cuando se inicia una nueva oleada).

;	ld a,(Ctrl_1)
;	bit 3,a
;	jr nz,5F											 ; Loop

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

; Damos por concluida la construcción del FRAME. 
; 

6 ld hl,(Scanlines_album_SP)
	ld (Techo_Scanlines_album),hl

	ld hl,(Album_de_borrado)
	ld (Scanlines_album_SP),hl

	ld hl,Tabla_de_pintado
	ld (India_SP),hl

	ld hl,Ctrl_3
	set 0,(hl) 											; Indica Frame completo. 
	set 2,(hl)
	set 5,(hl)											; Imprimimos Amadeus.

	ei 													; Ha de apuntar a $5c3a.

	halt 

; ------------------------------------

Main 
;
; 13/05/24

; En el FRAME que acabamos de pintar puede existir una posible colisión entre alguna entidad y Amadeus. 
; Si alguna de las coordenadas_X de alguna entidad que esté en zona de Amadeus coincide con alguna de las coordenadas_X de Amadeus, habrá que comprobar si existe colisión.
; Este hecho lo indica el bit2 de (Impacto2).

	call Detecta_colision_nave_entidad 					; La rutina verifica la colisión entre una entidad y Amadeus, (SET 3 Impacto2 - RES 2 Impacto2).

16 ld hl,(Clock_next_entity)
	ld bc,(FRAMES)
	and a
	sbc hl,bc
	jr nz,13F

; Si aún quedan entidades por aparecer del bloque de entidades, (7 cajas), incrementaremos (Entidades_en_curso) y calcularemos_ 
; _ (Clock_next_entity) para la siguiente entidad.

21 ld a,(Numero_parcial_de_entidades)
	ld b,a
	ld a,(Entidades_en_curso)
	cp b
	jr z,13F
	jr nc,13F

	inc a
	ld (Entidades_en_curso),a

; - Define el tiempo que ha de transcurrir para que aparezca la siguiente entidad. ----------------------------

	call Extrae_numero_aleatorio_y_avanza 				; A contiene un nº aleatorio (0-255). De 0 a 5 segundos, aproximadamente.
	call Define_Clock_next_entity

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

;10 ld a,(Numero_parcial_de_entidades)
;    ld b,a
;	and a
;	jr nz,11F

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
	jr z,Gestion_de_Amadeus								; Si no hay entidades en curso saltamos a [Avanza_puntero_de_Scanlines_album_de_entidades].
	ld b,a												; No hay entidades que gestionar.

; ( Código que ejecutamos con cada entidad: ).

;	--------------------------------------- GESTIÓN DE ENTIDADES. !!!!!!!!!!
;
;	Se produce MOVIMIENTO. Intercambio de Álbumes, (borrado-pintado).

	ld hl,Tabla_de_pintado
	ld (India_SP),hl

	ld hl,Ctrl_3
	set 2,(hl)
	call Change

15 push bc 												; Nº de entidades en curso.

	call Restore_entidad								; Vuelca en la BANDEJA_DRAW la "Caja_de_Entidades" hacia la que apunta (Puntero_store_caja).
	ld de,(Scanlines_album_SP)

; Datos de la entidad en curso en la bandeja DRAW y puntero (Scanlines_album_SP) en DE.

; En 1er lugar, ... existe (Impacto) en esta entidad ???

;! ------------------------------------------------------------------------------------------------------------------------ 3/7/24 EXPLOSIÓN DE ENTIDAD.
; Hay Impacto en esta entidad.

;	ld hl,Clock_explosion								
;	dec (hl)
;	jr nz,17F											; Gestionamos la siguiente entidad.
	
	ld a,(Impacto)										 
	and a
	jr z,8F

	di
	jr $
	ei

;	ld (hl),4 											; Reiniciamos (Clock_explosion), (velocidad de la explosión).

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

;	ld a,(Ctrl_1)
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

;7 call Mov_obj											; MOVEMOS y decrementamos (Numero_de_malotes)

;	ld a,(Ctrl_0)
;	bit 4,a
;	jr z,17F                                       	    ; Si no ha habido movimiento, NO HEMOS BORRADO, NI VAMOS A PINTAR NADA.!!!

; Voy a utilizar una rutina de lectura de teclado para disparar con cualquier entidad.
; [[[
;	call Detecta_disparo_entidad
; ]]]

;	dec a
;	ld (Impacto),a

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




; -------------------------------------------

8 call Recauda_informacion_de_entidad_en_curso					; Almacena la Coordenada_Y y (Scanlines_album_SP) de la entidad en curso en la TABLA_DE_PINTADO.
	call Ajusta_velocidad_entidad								; Ajusta el perfil de velocidad de la entidad en función de (Contader_de_vueltas).
	call Cargamos_registros_con_mov_masticado					; Cargamos los registros con el movimiento actual y `saltamos' al movimiento siguiente.
	call Genera_datos_de_impresion
;																; La rutina [Genera_datos_de_impresion] habilita las interrupciones antes del RET. 
;																; DI nos asegura que no vamos a ejecutar FRAME hasta que no tengamos todas las entidades iniciadas.
;																; La rutina [Genera_datos_de_impresion] activa las interrupciones antes del RET.
; Actualizamos (Contador_de_mov_masticados) tras la foto.	

	call Decrementa_Contador_de_mov_masticados

; -------------------------------------------

;	Generamos las coordenadas de la entidad que hemos iniciado o desplazado.

	ld hl,(Puntero_de_impresion)
	call Genera_coordenadas

	call Colision_Entidad_Amadeus											; Si hay posibilidad de COLISION, set 2,(Impacto2) y (Impacto) de entidad en curso a "1".

;	ld hl,Ctrl_0
; 	res 4,(hl)																; Inicializamos el FLAG de movimiento de la entidad.

17 call Store_Restore_cajas

	pop bc
	
	djnz 15B

	call Inicializa_India_y_limpia_Tabla_de_impresion 						; Inicializa el puntero (India_SP) y sanea la (Tabla_para_ordenar_entidades_antes_de_pintar).
	call Ordena_tabla_de_impresion
	call Inicia_punteros_de_cajas 											; Hemos terminado de mover todas las entidades. Nos situamos al principio del índice de entidades.

;! Activando estas líneas podemos habilitar 2 explosiones en el mismo FRAME.
; Hemos gestionado todas las unidades.
; Desactivamos el flag de impacto en entidad por disparo de amadeus.

;	ld hl,Ctrl_1
;	res 2,(hl)

	call Borra_diferencia

	ld a,(Ctrl_3)
	bit 3,a
	jr nz,Gestion_de_Amadeus

	ex de,hl
	ld (hl),c
	inc l
	ld (hl),b																; Nuevo techo, mayor que el anterior.


;! GESTIONA AMADEUS !!!!!!!!!!

Gestion_de_Amadeus
 
; Existe movimiento???, Disparamos???, Pausamos el juego???

	call Teclado

	ld hl,Ctrl_3
	bit 5,(hl)
	jr z,End_frame

; Existe movimiento de Amadeus, Cambiamos álbum borrado-pintado y generamos los datos de impresión.

	call Change_Amadeus
	call Genera_datos_de_impresion_Amadeus

End_frame 

	ld hl,(Album_de_borrado)
	ld (Scanlines_album_SP),hl

;	ld hl,Impacto2
;	res 3,(hl)

	ld hl,Ctrl_3
	set 0,(hl) 											; Indica Frame completo. 
	res 3,(hl)
	res 4,(hl)

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
;	ld (Clock_next_entity),a

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

; -----------------------------
;
;	Prepara los registros HL' y B para ejecutar la rutina Borra_sprites.
;
;	INPUTS: B a de estar a "0".

;Prepara_Borra_sprites 

;	ld hl,(Puntero_de_scanlines_masticados_a_borrar)
;	ld a,l
;	ret z

;	srl a

;2 sub 16
;	jr z,1F
;	inc b
;	jr 2B

;1 inc b

;	exx
;	ld hl,Semaforo_de_rutinas_de_impresion_utilizadas
;	exx	

;	ld hl,Almacen_de_scanlines_masticados_a_borrar
;	ld (Puntero_de_scanlines_masticados_a_borrar),hl

;	ret

; --------------------------------------------------------------------------------------------------------------
;
;	15/12/23

;Mov_obj 

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
;	call Repone_datos_de_borrado 								; ! BORRAMOS !!!. Guardamos la foto de las {Variables_de_borrado} en Scanlines_album.
;	call Limpia_Variables_de_borrado

;3 ret													

; --------------------------------------------------------------------------------------------------------------
;
;	12/05/24

Ajusta_velocidad_entidad ld a,(Velocidad)
	sla a 
	ld (Velocidad),a
	and $10
	ret z
	
; Restaura (Velocidad) a razón del nº de vueltas. 	

	ld a,(Contador_de_vueltas)
	sra a
	sra a
	ld (Velocidad),a	

	ld hl,(Puntero_de_almacen_de_mov_masticados)
	inc hl
	inc hl
	inc hl
	inc hl
	ld (Puntero_de_almacen_de_mov_masticados),hl

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	18/06/24

Change 

	ld a,(Switch)
	xor 1
	ld (Switch),a
	ld hl,(Album_de_pintado)
	ld de,(Album_de_borrado)
	ex de,hl
	ld (Album_de_pintado),hl
	ld (Scanlines_album_SP),hl
	ld (Album_de_borrado),de
	ret

Change_Amadeus

	ld hl,(Album_de_pintado_Amadeus)
	ld de,(Album_de_borrado_Amadeus)
	ex de,hl
	ld (Album_de_pintado_Amadeus),hl
	ld (Album_de_borrado_Amadeus),de
	ret

; ------------------------------------
;
; 1/05/24

; Fija en A un nº aleatorio comprendido entre 0-255 y desplaza el puntero (RND_SP) al siguiente nº.
; Si el puntero está situado en el último nº, lo volvemos a situar al principio.

;	DESTRUYE: HL,DE,A
;	OUTPUTS: A contiene un Nº aleatorio. Actualizamos (RND_SP).

;	Variables implicadas: (RND_SP).

Extrae_numero_aleatorio_y_avanza 

	ld hl,Tabla_de_pintado
	ex de,hl
	ld hl,(RND_SP)
	ex de,hl
	and a
	sbc hl,de

	ld hl,(RND_SP)
	jr nz,1F

; Sitúa HL al principio de la tabla de nº aleatorios.

	ld hl,Numeros_aleatorios
	ld (RND_SP),HL

; Coloca el nº aleatorio en A y mueve el puntero al siguiente nº.

1 ld a,(hl)
	inc hl
	ld (RND_SP),hl
	ret

; ------------------------------------
;
; 1/05/24

; Hacemos que el nº contenido en el registro A tenga un valor comprendido entre ($32 y $c8).
; (1 a 4 segundos).
; Actualizamos (Clock_next_entity) con A.

;	DESTRUYE: A y B.
;	OUTPUTS: A contiene un Nº aleatorio comprendido entre ($32 y $c8).
;			 Actualiza (Clock_next_entity) con A.

;	Variables implicadas: (Clock_next_entity).

; Notas:

; 	$32 1 seg.
; 	$64 2 seg.
; 	$96 3 seg.
; 	$c8 4 seg.
; 	$fa 5 seg.

; $ffff 1310,7 seg, 22 minutos.

;	$0100  5 seg. aproximadamente.
;	$0200 10 seg. aproximadamente.
;	$0300 15 seg. aproximadamente.
;	$0400 20 seg. aproximadamente.
;	$0500 25 seg. aproximadamente.
;	$0600 30 seg. aproximadamente.

Define_Clock_next_entity 

	cp $34
	jr c,1F  						; nº demasiado bajo, < 1 seg.

; En función de los minutos que llevemos de juego las entidades irán apareciendo más lentamente.

3 ld c,a
	ld b,0							; BC contendrá un valor entre 5-10 segundos.
	ld hl,(FRAMES)
	and a
	adc hl,bc
	ld (Clock_next_entity),hl  		; Actualizamos variable.
	ret

1 ld a,$34
	jr 3B

; ------------------------------------
;
; 18/03/24

Borra_diferencia 

	ld bc,(Scanlines_album_SP)

	ld a,(Switch)
	and a
	jr z,2F

	ld hl,(Techo_Scanlines_album_2)
	ld de,Techo_Scanlines_album_2
	jr 3F

2 ld hl,(Techo_Scanlines_album)
	ld de,Techo_Scanlines_album

; Diferencia. 

3 sbc hl,bc

	ret z
	ret c

; Nuevo techo, (más bajo que el anterior). 
; Fijamos nuevo techo y borramos bytes sobrantes.

	ex de,hl

	ld (hl),c
	inc l
	ld (hl),b

	xor a
	ld b,e

	ld hl,(Scanlines_album_SP)

1 ld (hl),a
	inc hl
	djnz 1B

; Indicamos que tenemos nuevo techo más bajo con el FLAG:

	ld hl,Ctrl_3
	set 3,(hl)

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	26/3/24

Recauda_informacion_de_entidad_en_curso

; Almacena la Coordenada Y de la entidad en curso.

; El 1er .db de la tabla almacena (Columna_Y) de la entidad en curso.

	ld a,(Coordenada_y)
	ld hl,(India_SP)
	ld (hl),a
	inc l

; Almacena la dirección de memoria, (dentro del album de scanlines), de la entidad en curso.

;	ld de,(Scanlines_album_SP)

	ld (hl),e
	inc l
	ld (hl),d
	inc l

	ld (India_SP),hl

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	27/03/24
;

Inicializa_India_y_limpia_Tabla_de_impresion 

	ld hl,(India_SP)
	ld bc,Tabla_de_pintado+24							; Bytes de (Tabla_de_pintado)-1.

	ld a,c
	sub l
	jr z,2F
	ld b,a												; Nº de bytes a limpiar de la tabla. Si la Tabla está completa, omitimos limpiar_
;														; _ y pasamos a inicializar (India_SP).
	xor a

1 ld (hl),a
	inc l
	djnz 1B												; Limpia Tabla.

2 ld hl,Tabla_de_pintado								; Inicializa (India_SP).
	ld (India_SP),hl

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	31/3/24

Ordena_tabla_de_impresion

; 5794 T/states.
; 6278 T/states.
; 5310 T/states.

; Inicializamos punteros (India_SP) e (India_2_SP).
; Inicializamos contador de comparaciones, [C].
; Cargamos los registros A y B para efectuar comparación.

	ld iyl,0

	ld a,(Entidades_en_curso)
	cp 4 	;	4
	ret c 										; Tiene que haber 4 (Entidades_en_curso) en pantalla para poder ejecutar esta rutina.

	dec a
	ld c,a 										; (Entidades_en_curso)-1 en C. Puede haber menos de 7 ebtidades.
	ld d,c 										; Copia de respaldo.

	ld a,(hl)									; Nº de Fila de la 1ª entidad, (1er byte de la tabla).

	ld hl,Tabla_de_pintado+3
	ld b,(hl)
	ld (India_2_SP),hl

1 cp b  				 						; Compara filas, (entidad X & entidad X).
	call c, Avanza_India_2_SP
	call z, Avanza_India_2_SP

	dec iyl
	jr z,2F


; --------------------------------------------------------------------------------------------------------------
;
;	7/4/24

Trueque 

; INPUTS:   B contiene el nº de fila de (India_2_SP).
;  			A contiene en nº de fila de (India_SP).
;			HL contiene (India_2_SP). 

	push de 									; Preservo DE pues D contiene una copia de respaldo.
	push hl										; Preservo (India_2_SP).

	ld de,(India_SP)
	ex de,hl
	ld (hl),b
	ld (de),a									; (Flia) de (India_SP) ---- NTERCAMBIADA ---- (Flia) de (India_2_SP).

	call Intercambia_1_byte
	call Intercambia_1_byte


; Volvemos a iniciar A. Vuelve a contener `el nuevo contenido, (Fila), de (India_SP).
; Recuperamos (India_2_SP) en HL.

	ld hl,(India_SP)
	ld a,(hl)

	pop hl
	pop de

; --------------------------------------------------------------------------------------------------------------
 
	call Avanza_India_2_SP

2 inc d
	dec d
	ret z 										; Todas las (Entidades_en_curso) ordenadas.
	jr 1B

	ret

; ----- ----- ----- ----- -----

Avanza_India_2_SP

	dec c
	jr z,Avanza_punteros_indios

	inc iyl

	inc l
	inc l
	inc l

	ld b,(hl)
	ld (India_2_SP),hl 							; Siguiente entidad en la Tabla.

	ret

; ----- ----- ----- ----- -----

Avanza_punteros_indios 

	dec d
	jr z,Prepara_salida 

	ld c,d

	ld hl,(India_SP)
	inc l
	inc l
	inc l
	ld a,(hl)
	ld (India_SP),hl

	inc l
	inc l
	inc l
	ld b,(hl)
	ld (India_2_SP),hl

	inc iyl

	ret

Prepara_salida 

	ld hl,Tabla_de_pintado
	ld (India_SP),hl
	ret


Intercambia_1_byte inc l
	inc e
	ld b,(hl)
	ld a,(de)
	ex de,hl
	ld (hl),b
	ld (de),a												; Byte de menor peso de las dos direcciones de memoria, ----- INTERCAMBIADAS -----.
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

    push ix 												; Pushea el Puntero_de_impresión, (1er scanline).
    push iy 												; Pushea Puntero_objeto.
 
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
	ld bc,4
	and a
	adc hl,bc
	ld (Puntero_de_almacen_de_mov_masticados),hl
	ret

; --------------------------------------------------------------------------------------------------------------
;
;	24/03/24
;
;	Cargamos los registros DE e IX y actualizamos (Puntero_de_almacen_de_mov_masticados). 
;	
;	IX contiene el puntero de impresión.
;	DE contiene (Puntero_objeto).
 

Cargamos_registros_con_mov_masticado 

	ld (Stack),sp
	ld sp,(Puntero_de_almacen_de_mov_masticados)

	pop de 															; DE contiene Puntero_objeto
	pop ix 															; IX contiene Puntero_de_impresion

	ld (Puntero_de_almacen_de_mov_masticados),sp 					; Actualiza (Puntero_de_almacen_de_mov_masticados).
	ld sp,(Stack)

	ld a,e
	add d															; Comprueba si ya no hay datos en el almacén.

	call z,Reinicia_entidad_maliciosa

	ret

; --------------------------------------------------------------------------------------------------------------
;
;	17/06/24
;
;	Cargamos los registros DE e IX, (Puntero_de_almacen_de_mov_masticados) de Amadeus. 
;	
;	IX contiene el puntero de impresión.
;	DE contiene (Puntero_objeto).
 

Cargamos_registros_con_mov_masticado_Amadeus

	ld (Stack),sp
	ld sp,(Pamm_Amadeus)											; (Puntero_de_almacen_de_mov_masticados_Amadeus) en su correspondiente caja.
	pop de 															; DE contiene Puntero_objeto
	pop ix 															; IX contiene Puntero_de_impresion
	ld (p.imp.amadeus),ix											; (Puntero_de_impresion_Amadeus) en su correspondiente caja.									
	ld sp,(Stack)
	ret

; ---------------------------------------------------------------------------------------------------------------------
;
;	18/6/24
;
;	Genera la coordenada X de Amadeus y los datos de impresión en la nave en su (Album_de_pintado_Amadeus).

Genera_datos_de_impresion_Amadeus 

	call Cargamos_registros_con_mov_masticado_Amadeus			
														
	ld a,ixl
	and $1f
	ld (CX_Amadeus),a 													; Coordenada X del Amadeus, (0-$1f). Columnas.

	ld hl,(Scanlines_album_SP)
	push hl

	ld hl,(Album_de_pintado_Amadeus)
	ld (Scanlines_album_SP),hl

	call Genera_datos_de_impresion

	pop hl
	ld (Scanlines_album_SP),hl	

	ret
	
; ---------------------------------------------------------------------------------------------------------------------
;
;	13/03/24
;

Inicia_albumes_de_lineas

;	Entidades.

	ld hl,Scanlines_album
	ld (Album_de_pintado),hl
	ld (Scanlines_album_SP),hl

	ld hl,Scanlines_album_2
	ld (Album_de_borrado),hl

;	Amadeus.

	ld hl,Amadeus_scanlines_album
	ld (Album_de_pintado_Amadeus),hl
	ld hl,Amadeus_scanlines_album_2
	ld (Album_de_borrado_Amadeus),hl

	ret



; ---------------------------------------------------------------------------------------------------------------------
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

;Inicia_Puntero_Disparo_Entidades ld hl,Indice_de_disparos_entidades
;	ld (Puntero_DESPLZ_DISPARO_ENTIDADES),hl
;	ret
;Inicia_Puntero_Disparo_Amadeus ld hl,Indice_de_disparos_Amadeus
;	ld (Puntero_DESPLZ_DISPARO_AMADEUS),hl
;	ret

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
;	24/6/24
;
;	Cargamos los datos de la caja de entidades señalada por el puntero (Puntero_store_caja) a la BANDEJA_DRAW.

Restore_entidad 

	ld hl,(Puntero_store_caja)						; 369 t/states.
	ld de,Bandeja_DRAW
	ld bc,14
	ldir											; Transferimos (Ctrl_2) y (Velocidad).
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

; -----------------------------------------------------------
;
;	21/12/23
;
; 	Limpia los datos del almacén de entidades de DRAW, (donde se encuentra la "entidad impactada").
;
;	Destruye: HL,BC,DE,A

;Borra_datos_entidad ld hl,Bandeja_DRAW
;	ld bc,41
;	xor a
;	ld (hl),a;
;	ld de,Bandeja_DRAW+1
;	ldir
;	ret

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

DELAY LD BC,$0900							;$0320 ..... Delay mínimo
wait DEC BC  								;Sumaremos $0045 por FILA a esta cantidad inicial. Ejempl: si el Sprite ocupa la 1ª y 2ª_				
	LD A,B 										
	AND A
	JR NZ,wait
	RET

; ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
;
;	4/6/24
;
;	Es la 1ª rutina que se ejcuta tras la rutina de interrupciones.
; 	
;	ACTUALIZA LA PANTALLA siempre que se haya producido algún movimiento, (entidades, Amadeus).
;

Actualiza_pantalla 

	ld a,2	
	out ($fe),a												

	ld a,(Ctrl_3)
	bit 0,a
	jr z,Borrando_Amadeus												; No pintamos si el FRAME no se ha completado.
	bit 2,a
	jr z,Borrando_Amadeus                                               ; No pintamos si no hay movimiento. El último FRAME impreso NO SE HA MODIFICADO!!.

Borrando_entidades

	ld hl,(Scanlines_album_SP)
	call Extrae_address
	inc h
	dec h
	jr z,Pintando_entidades
	call Pinta_Sprites
	jr Borrando_entidades
	
Pintando_entidades

	ld hl,(India_SP)
	inc l
	call Extrae_address
	inc h
	dec h
	jr z,Borrando_Amadeus
	inc e
	inc e
	ld (India_SP),de
	call Extrae_address
	call Pinta_Sprites
	jr Pintando_entidades

Borrando_Amadeus

	ld hl,Ctrl_3
	bit 5,(hl)
	jr z,1F												; No pintamos. No hay movimiento.

	ld hl,(Album_de_borrado_Amadeus)
	call Extrae_address
	inc h
	dec h
	jr z,Pintando_Amadeus
	call Pinta_Sprites

Pintando_Amadeus

	ld hl,(Album_de_pintado_Amadeus)
	call Extrae_address
	inc h
	dec h
	jr z,1F
	call Pinta_Sprites

1 ld hl,Ctrl_3
	res 0,(hl)											; Reinicia el flag de FRAME completo.
	res 2,(hl)											; Reinicia el flag DETECTA MOVIMIENTO.
	res 5,(hl)

	ld a,1												; Borde azul.
	out ($fe),a

	ret									 

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	19/6/24
;
	
Teclado

; Examina_disparo 

	ld a,(Disparo_Amadeus)
	dec a
	jr nz,1F

	ld a,$f7													; "5" para disparar.
	in a,($fe)
	and $10

;	push af
;	call z,Genera_disparo
;	pop af

	jr nz,1F

	ld a,(Disparo_Amadeus)
	xor 1
	ld (Disparo_Amadeus),a

	di
	jr $
	ei

1 ld a,$f7		  											; Rutina de TECLADO. Detecta cuando se pulsan las teclas "1" y "2"  y llama a las rutinas de "Mov_izq" y "Mov_der". $f7  detecta fila de teclas: (5,4,3,2,1).
	in a,($fe)												; Carga en A la información proveniente del puerto $FE, teclado.
	and $01													; Detecta cuando la tecla (1) está actuada. "1" no pulsada "0" pulsada. Cuando la operación AND $01 resulta "0"  llama a la rutina "Mov_izq".
    call z,Amadeus_a_izquierda							

	ld a,$f7
	in a,($fe)
	and $01
	ret z

	ld a,$f7
	in a,($fe)												; Carga en A la información proveniente del puerto $FE, teclado.
	and $02													; Detecta cuando la tecla (1) está actuada. "1" no pulsada "0" pulsada. Cuando la operación AND $02 resulta "0"  llama a la rutina "Mov_der".
	call z,Amadeus_a_derecha

	ret	

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	Rutina provisional para que los malotes cagen balas.

;Detecta_disparo_entidad 

;	ld a,(Disparo_entidad)
;	and a
;	ret z

;! Aquí hemos de implementar la rutina/s que generan disparo...

;	ld a,$7f				; Detecta SPACE.
;	in a,($fe)
;	and 1
;	ret nz

;	call Genera_disparo
;	ret

; ---------------------------------------------------------------

	org $aa7f

	include "RND_Derivando.asm"
	include "Rutinas_de_inicio_y_niveles.asm"
	include "calcula_tercio.asm"
	include "Cls.asm"
	include "Genera_coordenadas.asm"
	include "Relojes_y_temporizaciones.asm"
	include "Genera_datos_de_impresion.asm"

	include "Pinta_Sprites.asm"
	include "Draw_XOR.asm"
	include "Direcciones.asm"
	include "Movimiento.asm"
	include "Disparo_2.asm"


	SAVESNA "Pruebas.sna", START




