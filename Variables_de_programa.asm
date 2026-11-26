; --------------------------------------------------------------------------------
;
; 05/05/26
;
; Parámetros DRAW. 	
;

Variables: 	; ---------------------------------------------------------------------------------------------------------------------------

Clase db 0  												; A cada entidad se le asigna un nº o (Clase) para poder asignarle una de las 3 Cajas_Master.
; 															; En cada (Nivel) sólo puede haber 3 (Clases) diferentes de entidad pués sólo dispondremos de_
; 															; _tres almacenes de Mov_masticados y 3 Cajas_Master.
; 															; Las entidades de (Clase) 1, 2 y 3 son de (Tipo) 1, (BadSat).

Tipo db 0													; Cada `tipo? de Entidad tiene unas características únicas que lo distinguen de otros tipos.
; 															; Las entidades del mismo (Tipo) comparte el MISMO PATRÓN DE MOVIMIENTO. 															

Contador_de_vueltas db 0									; Contador de vueltas de entidades. Inicialmente su valor es "1". El bit se desplaza una posición_
; 															  _a la izquierda cada vez que la entidaddesaparece por la parte baja de la pantalla.
;															  Esta variable se utiliza para incrementar el perfil de velocidad de las entidades.

; Incrementa el contador de vueltas, (el contador cuenta 4 vueltas máximo).
; El perfil de velocidad de la entidad será: (Contador_de_vueltas)/8.

; Ejemplos:

;	1ª vuelta: (Contador_de_vueltas)="$02" --- (Velocidad)="0".
;	2ª vuelta: 	""	""	""	""	""  ="$04" ---   ""	 ""	  ="1".
;	3ª vuelta: 	""	""	""	""	""  ="$08" ---   ""	 ""	  ="2".
;	4ª vuelta: 	""	""	""	""	""  ="$10" ---   ""	 ""	  ="4".
;	5ª vuelta: 	""	""	""	""	""  ="$20" ---   ""	 ""	  ="8".   

Impacto db 0												; Si después del movimiento de la entidad, (Impacto) se coloca a "1", existen muchas posibilidades de_
;															  _ que esta entidad haya colisionado con Amadeus.
; 																Hay que comprobar la posible colisión después de mover Amadeus. En este caso, (Impacto2)="3".

Puntero_de_impresion defw 0									; Esta variable tiene dos funciones, la primera:
;
;															; Es utilizada por la rutina [Define_menu] para almacenar el puntero indicial: Define_menu_index_parameters.
;
;															; Contiene el puntero de impresión, (calculado por DRAW). Esta dirección la utilizará la rutina_
;															; _ [Guarda_coordenadas_X] y [Compara_coordenadas_X] para detectar la colisión ENTIDAD-AMADEUS.

Puntero_de_almacen_de_mov_masticados defw Line_0















;															; Almacén donde la entidad guía va guardando comportamiento ya calculado, (rutinas DRAW).

Contador_de_mov_masticados defw 0							; Contador de 16 bits. La "Entidad_guía" lo aumenta en una unidad cada vez que hace el "pushado" de las tres_
;															  _palabras que componen el "movimiento_masticado".

; Variables de funcionamiento de las rutinas de movimiento. (Mov_left), (Mov_right), (Mov_up), (Mov_down).

Velocidad db 0 												; 5 vueltas max. 5 vueltas       1 - 0 (1ª vuelta - velocidad 0)
;																					 		 2 - 0 (2ª vuelta - velocidad 0)
;																					 		 4 - 1 (3ª vuelta - velocidad 1)
;																							 8 - 2 (4ª vuelta - velocidad 2)
;																				 		   $10 - 4 (5ª vuelta - velocidad 3)

Attr db 0 													; Atributos de la entidad.

; ----- ----- De aquí para arriba son los datos que se trasfieren a las cajas de entidades. ¡¡¡¡¡



Ctrl_2 db 0
;															BIT 0, Los sprites se inician con un `sprite vacío', (sprite formado por "ceros"), cuando la rutina_
;															_ [Genera_datos_de_impresion] guarda su 1ª imagen.
;															_ Más adelante las rutinas [Mov_left] y [Mov_right] restauraran (Puntero_objeto). Si el 1er movimiento
; 															_ que hace la entidad después de iniciarse es hacia arriba/abajo no se restaurará (Puntero_objeto), pués_
; 															_ las rutinas [Mov_up] y [Mov_down] no necesitan modificar el sprite.
;															_ El bit5 a "1" nos indica que el sprite se inicia por arriba o por abajo y por lo tanto hay que restaurar_
;															_ (Puntero_objeto) con (Repone_puntero_objeto) una vez iniciado y realizada su 1ª `foto'.
;														
;															BIT 1, ???
;															BIT 2, Este bit es activado por [Movimiento]. Indica que hemos `iniciado un desplazamiento'._
;															_ Evita que volvamos a iniciar el desplazamiento cada vez que ejecutemos [Movimiento].
;															BIT 3, ???
;															BIT 4, ???
;															BIT 5, ???
;															BIT 6, Habilita la transición: "Salida de Amadeus" por la parte baja de la pantalla cuando completamos un nivel.
;																   La rutina [Dispara_salida_de_amadeus] pone este bit a "1" tras imprimir el msg. "DONE".
;															BIT 7, "1" Detecta que hemos pulsado "SHIELD". ; "El reloj de juego, (IM2)", borrara un escudo siempre que este FLAG esté a "1".
;															- La rutina [Borra_escudo], inicializará el FLAG.

Ctrl_0 db 0 												; Byte de control. A través de este byte de control. Las rutinas de desplazamiento: [Mov_right], [Mov_left], [Mov_up] y [Mov_down],_
;															; _indican a las subrutinas de recolocación del objeto de la rutina [DRAW]: [Comprueba_limite_horizontal] y [Comprueba_Sprite_completo],_
; 															; _que desaparecemos por un extremo de la pantalla y hemos de `reaparecer? por el contrario.
; 															; Este dato es necesario debido a que las rutinas de recolocación, están ideadas para recolocar el puntero (Posicion_actual), cuando pasamos_
; 															; _de un cuadrante a otro de la pantalla pero no preveen la `desaparición? por un extremo del cuadrante y la `reaparición? por el otro.
;
; 															DESCRIPCIÖN:
;
; 															SET 0, [Reaparece_derecha]. El bit 0 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_left] detecta que el objeto ha `desaparecido? por el_
; 															_lado izquierdo de la pantalla y ha de `reaparecer? por el derecho. ([Comprueba_Sprite_completo]).
; 															SET 1, [Reaparece_izquierda]. El bit 1 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_right] detecta que el objeto ha `desaparecido? por el_
; 															_lado derecho de la pantalla y ha de `reaparecer? por el izquierdo. ([Comprueba_Sprite_completo]).
; 															SET 2, [Reaparece_abajo]. El bit 2 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_up] detecta que el objeto ha `desaparecido? por la_
; 															_parte superior de la pantalla y ha de `reaparecer? por el inferior. ([Comprueba_limite_horizontal]).
; 															SET 3, [Reaparece_arriba]. El bit 3 de (Ctrl_0) se coloca a "1" cuando la rutina [Mov_down] detecta que el objeto ha `desaparecido? por la_
; 															_parte inferior de la pantalla y ha de `reaparecer? por la superior. ([Comprueba_limite_horizontal]).
; 															SET 4, El Bit4 a "1", indica que hubo movimiento de la entidad. Necesitamos esta información
;												            _para "NO BORRAR/PINTAR" en objeto si NO hubo MOVIMIENTO.
;															SET 5, La rutina [Inicializacion] de Draw_XOR.asm, pone este bit a "1". Con esta información evitamos ejecutar las
;															_rutinas: (Comprueba_limite_horizontal) y (Comprueba_Sprite_completo) justo después de `inicializar? un objeto.
; 															SET 6, Está a "1" si el Sprite que tenemos cargado en el `Engine? es AMADEUS.
;
; 															SET 7, El bit 7 se encuentra alto, ("1"), cuando el último movimiento horizontal se ha producido a la "DERECHA".
; 															_ Utilizo la información que proporciona este BIT para modificar (CTRL_DESPLZ) si el siguiente movimiento_
; 															_ se va a producir a la izquierda. "1" DERECHA - "0" IZQUIERDA.

Filas db 0												    ; Filas. [DRAW]. - 2ª Funcion tras haber generado los movimientos masticados: 
;															; Almacena un bit que iremos alternando: "0" a "1" mediante una función XOR. Se utiliza para cambiar los attr. de la explosión de las entidades,_ 
;															; _rojo - amarillo. 

Columns db 0 												; Nº de columnas. [DRAW]. - 2ª Funcion tras haber generado los movimientos masticados: 
;															; Almacena un bit que iremos alternando: "0" a "1" mediante una función XOR. Se utiliza para cambiar los attr. de la explosión de Amadeus, (rojo - amarillo). 														

Coordenada_X db 0 											; Coordenada X del objeto. (En chars.)
Coordenada_y db 0 											; Coordenada Y del objeto. (En chars.)

Posicion_actual defw 0										; Dirección actual del Sprite. [DRAW]
Puntero_objeto defw 0										; Donde están los datos para pintar el Sprite.

; ---------- ---------- ---------- ---------;      ;--------- ---------- ---------- ---------- 

CTRL_DESPLZ db 0											; Este byte nos indica la posición que tiene el Sprite dentro del mapa de desplazamientos.
;															; Una vez construidos los movimientos masticados del nivel esta variable:
;
;															; Almacena un contador de scanlines que se utiliza para hacer desaparecer Amadeus por la parte baja de la pantalla.

; ---------- ---------- ---------- ---------;      ;--------- ---------- ---------- ---------- 

Indice_Sprite_der defw 0
Indice_Sprite_izq defw 0
Puntero_DESPLZ_der defw 0
Puntero_DESPLZ_izq defw 0
Posicion_inicio defw 0										; Dirección de pantalla donde aparece el objeto. [DRAW]. 

Cuad_objeto db 0											; Almacena el cuadrante de pantalla donde se encuentra el objeto, (1,2,3,4). [DRAW]
;															; 2ª FUNCIÓN: Temporizador, define la velocidad de la animación de Amadeus por la parte_
;															; _baja de la pantalla cuando hemos superado el nivel.

Columnas db 0

;	DRIVE

Sprite_completo db 0

; Variables de control general.

Frames_explosion db 0 										; Nº de Frames que tiene la explosión.

; Variables de funcionamiento, (No incluidas en base de datos de entidades), a partir de aquí!!!!!

Perfiles_de_velocidad:

Vel_left db 0 												; Velocidad izquierda. Nº de píxeles que desplazamos el objeto a izquierda. 1, 2, 4 u 8 px.
Vel_right db 0 												; Velocidad derecha. Nº de píxeles que desplazamos el objeto a derecha. 1, 2, 4 u 8 px.
Vel_up db 0 												; Velocidad subida. Nº de píxeles que desplazamos el objeto hacia arriba. (De 1 a 7px).
Vel_down db 0 												; Velocidad bajada. Nº de píxeles que desplazamos el objeto hacia abajo. (De 1 a 7px).

; Movimiento. ------------------------------------------------------------------------------------------------------

Puntero_tabla_Random defw 0
Puntero_indice_mov defw 0									; Puntero índice del patrón de movimiento de la entidad. "0" No hay movimiento.
Puntero_mov defw 0											; Guarda la posición de memoria en la que nos encontramos dentro de la cadena de movimiento.
Puntero_indice_mov_bucle defw 0							 
;														
;                   									
Incrementa_puntero db 0										; Byte que iremos sumando a (Puntero_indice_mov) para ir escalando por las_
;															; _ distintas cadenas de movimiento del índice de movimiento de la entidad._
;															; Va aumentando su valor en saltos de 2 uds, (0,2,4,6,8).

Incrementa_puntero_backup db 0
Repetimos_desplazamiento db 0								; El nibble bajo del 3er byte que compone un desplazamiento, indica el nº de veces que_
;															; repetimos dicho desplazamiento. Ese valor se almacena en esta variable, ($1-$f). NUNCA SERÁ "0".

Repetimos_desplazamiento_backup db 0	   					; Restaura (Repetimos_desplazamiento) cuando este llega a "0".
Repetimos_movimiento db 0									; Byte que indica el nº de veces que repetimos el último MOVIMIENTO.
Cola_de_desplazamiento db 0									; Este byte indica:

;
;															;	"$00" ..... Hemos finalizado la cadena de movimiento.
;															;				En este caso hemos de incrementar (Puntero_indice_mov)_
;															;				_ y pasar a la siguiente cadena de movimiento del índice.
;
;															;	"$01 - "$fe" ..... Repetición del movimiento.
;															;						Nº de veces que vamos a repetir el movimiento completo.
;															;						En este caso, volveremos a inicializar (Puntero_mov),_
;															;						_ con (Puntero_indice_mov) y decrementaremos (Cola_de_desplazamiento).
;				
;															;	"$ff" ..... Bucle infinito de repetición.
;															;				Nunca vamos a saltar a la siguiente cadena de movimiento del índice,_
;															;				,_ (si es que la hay). Volvemos a inicializar (Puntero_mov) con (Puntero_indice_mov).

Ctrl_1 db 0 												; Byte de control de propósito general.

;																DESCRIPCIÓN:
;
;															BIT 0, "1" Habilita la impresión del msg. DONE en pantalla. La llamada a [Print_DONE] se efectúa desde el Reloj del juego,_
; 															_ Rutina de interrupciones IM2.

Repone_puntero_objeto defw 0								; Almacena (Puntero_objeto). Cuando el Sprite se inicia por arriba o por abajo,_
; 															; _ hay que sustituirlo por un `sprite vacío' para que no se vea el 1er o último scanline.
; 															; _ Cuando hemos terminado de iniciarlo y guardado su foto, hemos de recuperar su (Puntero_objeto).
;															; (Repone_puntero_objeto) es una copia de respaldo de (Puntero_objeto) y su función es restaurarlo.
;
;															; 2ª Función:
;
;															; La rutina [Genera_cabecera] almacena la dirección del álbum de scanlines donde se inicia la cabecera para posteriormente_
;															; _guardar esta dirección en la (Tabla_de_pintado).

Gestion_de_ENTIDADES_y_CAJAS:

Puntero_store_caja defw 0
Puntero_restore_caja defw 0
Indice_restore_caja defw 0
Puntero_indice_master defw 0

Numero_de_entidades db 0									; Nº total de entidades que contiene el nivel.
Numero_parcial_de_entidades db 0							; Nº de cajas que contiene un bloque de entidades. (7 Cajas).
Entidades_en_curso db 0										; Entidades en pantalla.

Puntero_indice_ENTIDADES defw 0 							; Se desplazará por el índice de entidades para `meterlas' en cajas.
Datos_de_entidad defw 0										; Contiene los bytes de información de la entidad hacia la que apunta el
;															; _ puntero (Indice_entidades).

;---------------------------------------------------------------------------------------------------------------
;
;	13/10/24
;
;	Álbumes.

Stack defw 0 												; Variable destinada a almacenar la dirección a la que apunta el vector (SP).
; 															; Necesitamos guardar esta dirección antes de poder utilizar el puntero de pila para otros menesteres.
Stack_2 defw 0												; 2º variable destinada a almacenar el puntero de pila, SP.

; Impresión. ----------------------------------------------------------------------------------------------------

Album_de_pintado defw Scanlines_album 											; Puntero. Apunta a la caja de scanlines de entidades que contiene los datos de PINTADO.
Scanlines_album_SP defw Scanlines_album
Album_de_borrado defw Scanlines_album_2 										; Puntero. Apunta a la caja de scanlines de entidades que contiene los datos de BORRADO.

Album_de_pintado_Amadeus defw Amadeus_scanlines_album 							; Puntero. Apunta a la caja de scanlines de Amadeus que contiene los datos de PINTADO.
Album_de_borrado_Amadeus defw Amadeus_scanlines_album_2							; Puntero. Apunta a la caja de scanlines de Amadeus que contiene los datos de BORRADO.

Album_de_pintado_disparos_Amadeus defw Amadeus_disparos_scanlines_album			; Puntero. Apunta a la caja de scanlines de los disparos de Amadeus que contiene los datos de PINTADO.
Album_de_borrado_disparos_Amadeus defw Amadeus_disparos_scanlines_album_2		; Puntero. Apunta a la caja de scanlines de los disparos de Amadeus que contiene los datos de BORRADO.

Album_de_pintado_disparos_Entidades defw Entidades_disparos_scanlines_album 	; Puntero. Apunta a la caja de scanlines de los disparos de ENTIDADES que contiene los datos de PINTADO.
Nivel_scan_disparos_album_de_pintado defw Entidades_disparos_scanlines_album
Album_de_borrado_disparos_Entidades defw Entidades_disparos_scanlines_album_2	; Puntero. Apunta a la caja de scanlines de los disparos de Amadeus que contiene los datos de BORRADO.


Num_de_bytes_album_de_disparos db 0
Num_de_bytes_album_de_disparos_borrado db 0

Numero_de_disparos_de_entidades db 7

Permiso_de_disparo_Amadeus db 0								; "0" Permite disparo.
Permiso_de_disparo_Entidades db 0							; A "1", se puede generar disparo.

Techo_Scanlines_album defw 0
Techo_Scanlines_album_2 defw 0
Switch db 0
Techo defw 0

India_SP defw Tabla_de_pintado 
India_2_SP defw 0
India_3_SP defw Tabla_de_borrado

Ctrl_3 db 0													; 2º Byte de Ctrl. general, (no específico) a una única entidad.
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
;															BIT 6, "1" Indica que Amadeus ha sido destruido. Este bit lo activa la rutina [Genera_explosion_Amadeus] despues de pintar_
; 																_ el último frame de la explosión de nuestra nave.
;															BIT 7, "1" Indica que se ha iniciado el proceso de explosión en Amadeus.
;																_ Mientras este bit este activo, no se generarán dos explosiones de entidades a la vez.

Ctrl_4 db 0													; 4º Byte de Ctrl. general, (no específico) a una única entidad.
;
;															BIT 0, "1" Cada vez que se incrementan las entidades en curso, este bit se pone a "1". Esto hará que una entidad pase de "dormida" a "activa".
;															BIT 1, (INVESTIGAR !!!)
;															BIT 2, -------------------------------------------
;															BIT 3, "1" Indica que se ha asignado un color RND a la entidad. 
; 																   _evita que se vuelva a asignar un nuevo color en la `segunda vuelta lenta?.
; 															BIT 4, "1" Indica que necesitamos 3 Filas de atributos para colorear esta entidad.
;															BIT 5, "1" Indica que ha terminado la transición de salida de Amadeus por la parte baja de la pantalla.
;															BIT 6, [Genera_explosion_Amadeus] coloca este bit a "1". Indica aL reloj IM2 que ha de borrar una vida de la pantalla.
; 																   [Borra_vida] RES el bit a "0" antes de borrar la vida.
; 															BIT 7, !!! Used !!!. Averiguar para qué.

Ctrl_5 db 0

;															BIT 1, "1" Indica que la entidad en curso es la alcanzada por nuestro disparo. La comparativa entre coordenadas ha sido satisfactoria.
;															BIT	2, "1" Indica que tras consecutivos desplazamientos del disparo hay que modificar el (Puntero_de_impresión) dos posiciones a la derecha.
;															BIT	3, "1" Indica que tras consecutivos desplazamientos del disparo hay que modificar el (Puntero_de_impresión) dos posiciones a la izquierda.								
;															BIT 4, ?????
;															BIT 5, "1" Indica: NIVEL SUPERADO !!!.
;															BIT 6, "1" Indica: GAME OVER !!!.
;															BIT 7, "1" Indica a la rutina de sonido que hemos de generar un efecto ascendente; (estamos pintando el rayo de entrada de la transición de entrada). 

Ctrl_6 db 0 												

;															BIT 0, "1" Activa el inhibidor de efectos de sonido. No se ejecutará [Play_burst_sound_effect], tampoco [Play_shot_sound_effect]_
; 																   _si está señal está activa.	
; 															BIT 1, "1" Este bit es activado por la rutina [Press_START] cuando el temporizador (Start_counter) llega a "0".
; 																   El bit indica a la rutina principal START: que ha de volver a mostrar el menú principal.
; 																   El submenú CONTROLS se muestra en pantalla un tiempo definido por (Start_counter), pasado este tiempo_
;																   _la rutina activa `este bit´ y sale de la rutina. El menú está así diseñado para poder DEFINIR los controles si los
; 																   _actuales no nos agradan. 
; 															BIT 2, -----------------------------------
; 															BIT 3, "1" Indica que salimos de la rutina de IM nada más entrar. Este bit lo activa la rutina [Carrusell] tras habilitar las interrupciones.
; 																   Necesitamos leer el teclado cada 20ms para facilitar que no se produzca la repetición de una misma tecla.
; 															BIT 4, "1" Indica DELETE a la subrutina FLASH. Lo activa la subrutina [Enter_name] cuando pulsamos CAPS SHIFT.

Puntero_DESPLZ_DISPARO_ENTIDADES defw 0
Puntero_de_impresion_disparo_de_entidad defw 0				; Guardaremos aquí la dirección de pantalla del último scanline de la entidad en curso.
Impacto2 db 0												; Byte de control de impactos.

;
;															; bit_2. La rutina [Genera_coordenadas_X] coloca este bit a "1" para indicar que hay una posible colisión entre una entidad y Amadeus.
;															; Una de la entidades ha entrado en zona de Amadeus y alguna de sus columnas coincide con las de nuestra nave.
;															; El bit indica que hay que ejecutar [Detecta_colision_nave_entidad] al principio de [Main], (Construcción del frame).
;															; bit_3. La rutina [Genera_coordenadas_de_disparo_Amadeus] pone este bit a "1" para indicar que un disparo de Amadeus ha alcanzado a una entidad.

Entidad_sospechosa_de_colision defw 0						; Almacena la dirección de memoria donde se encuentra el .db_
;															; _(Impacto) de la entidad que ocupa el mismo espacio que Amadeus.
;															; Necesitaremos poner a "0" este .db en el caso de que finalmente no se produzca colisión.

Coordenadas_disparo_certero ds 2							; Almacenamos aquí las coordenadas del disparo que alcanza a una entidad, (Fila, Columna).
;											           		; (Coordenadas_disparo_certero)=Y ..... (Coordenadas_disparo_certero +1)=X.
Coordenadas_X_Entidad ds 3  								; 3 Bytes reservados para almacenar las 3 posibles columnas_
;															; _ que puede ocupar el sprite de una entidad. (Colisión).
Coordenadas_X_Amadeus ds 3									; 3 Bytes reservados para almacenar las 3 posibles columnas_
;															; _ que puede ocupar el sprite de Amadeus. (Colisión).

;---------------------------------------------------------------------------------------------------------------

; Relojes y temporizaciones.

Clock_explosion db 4										; Temporización de las explosiones, (velocidad de la explosión).
Clock_explosion_Amadeus db 5
Temp_new_live db 100										; Tiempo que tarda en aparecer una nueva nave Amadeus tras ser destruida.

RND_SP defw Numeros_aleatorios								; Puntero que se irá desplazando por el SET de nº aleatorios. Inicialmente apunta al 1°.

Numero_rnd_disparos db 0

Clock_next_entity db 0										; Transcurrido este tiempo aparece una nueva entidad.
Repone_CLOCK_disparos db 0									; Repone a su valor inicial el contador (CLOCK_disparos_de_entidades) cuando llega a "0". 
CLOCK_disparos_de_entidades db 0 							; Habilita el permiso de disparo a las entidades cuando este contador llega a "0".

Start_counter defw 0 										; Temporizador. Espera la pulsación de "FIRE" en los menús KEYBOARD y KEMPSTON. 
Start_counter_2 db $05 										; 2º Temporizador, (3 bytes counter). Espera la pulsación "FIRE" en el menú KEMPSTON.

;---------------------------------------------------------------------------------------------------------------

; Gestión de NIVELES.



Puntero_indice_de_almacenes defw Almacen_de_movimientos_masticados_1					
																				
Puntero_de_entidades defw 0									; Este puntero se va desplazando por los distintos bytes_
; 															; _ que definen el NIVEL.


; ---------------------------------------------------------------------------------------------------------------

; Temporizaciones Shield.


; Temporizaciones Shield.

Datos_Shield db 4,1,4,1										; Tiempos. (Frecuencia del parpadeo de Amadeus).
Puntero_datos_shield defw 0									; Señala distintos tiempos para introducirlos en (Shield_2).
Shield db 100												; Temporización principal. Indica el tiempo que el escudo está activo. No hay escudo cuando (Shield)="0".
Shield_2 db 0 												; Estado Shield, (tiempo encendido - tiempo apagado - tiempo encendido - tiempo apagado). 4,1,4,1.
Shield_3 db 0

; HUB




; Sounds:

Sound defw 0												; Esta variable almacenará el efecto de sonido a reproducir, (disparo, explosión, etc).
Laser_sound defw Laser_sound_init_value
Shot_sound defw 0
Burst_sound db 0 											; Byte que define la duración de una explosión.
Shield_sound defw 0

Puntero_game_over_noise defw Game_over_noise_index 			; (Puntero_game_over_noise) situado en la 1a nota del índice.

; Varios:

Max_time_to_appear_entities db 0 							; Valor máximo que tarda una entidad en aparecer en pantalla.
Decrease_top_time_entities db 0 							; Cada vez que aparece una nueva entidad decrementa (Max_time_to_appear_entities) con el valor de esta variable.
Min_time_to_appear_entities db 0							;   ""  mínimo  "	 "	  "		"	 "		"	 "	    "   .

Temp_Amadeus_exit db 80										; Temporiza la secuencia de: "SALIDA DE AMADEUS", NIVEL SUPERADO.

Variables_DRAW1: 											; Estas variables no se inicializan si avanzamos de nivel.

Nivel db 1													; Nivel actual del juego.

Puntero_indice_NIVELES defw Indice_de_niveles				; Inicialmente situado en el 1er puntero del índice de niveles, (defw Nivel_1).

Puntero_de_mensajes_de_niveles defw Msg_level_index 		; Inicialmente apunta al mensaje del nivel 1.
Lives db 3
Shields db 3 												; Nº de Shields

Puntero_de_escudos defw Tabla_marcador_de_escudos			; Ambos punteros se inician al comienzo de su respectivas tablas. Estas variables las utilizan_
Puntero_de_vidas defw Tabla_marcador_de_vidas 				; _ las rutinas que pintan y borran las vidas y escudos en la parte sup. izq. de la pantalla.

UNIDADES_Marcador_decimal_de_entidades db 0 				; Unidades del contador decimal de entidades que quedan por eliminar.
DECENAS_Marcador_decimal_de_entidades db 0 					; Decenas del contador decimal de entidades   "     "    "      "
Puntero_unidades_grandes defw 0								; Almacena dirección de memoria donde se encuentran los datos del numero grandote, UNIDADES.
Puntero_decenas_grandes defw 0 								;      "       "           "      "           "      "    "          "       "   , DECENAS.

; SCORE PANEL:

Score_hex defw 0

Score_BCD_unidades db 0
Score_BCD_decenas db 0
Score_BCD_centenas db 0
Score_BCD_unidades_de_millar db 0
Score_BCD_decenas_de_millar db 0

Puntero_de_unidades_Score defw Cero_Score
Puntero_de_decenas_Score defw Cero_Score
Puntero_de_centenas_Score defw Cero_Score
Puntero_de_um_Score defw Cero_Score
Puntero_de_dm_Score defw Cero_Score

Score_Ctrl db 0 											; Byte de control. Se utiliza para no mostrar todos los dígitos de Score.
; 															; Se irán imprimiendo dñigitos conforme la puntuación vaya creciendo.

Variables_DRAW2:

; --------------------------------------------------
;
;	Estas variables no se inicializan:

Semilla db 0 																			; La semilla inicial adquirida del regstro R irá mutando, ([Derivando_RND]). Esta variable almacenará nuestra semilla.

Ctrl_7 db 0 																			; Variable de Control que no se inicializa al superar nivel.
;
; 																						; BIT 0, "1" Hay que imprimir la puntuación máxima en el menú principal. También indica que hemos terminado de introducir el nombre.
; 																						; BIT 1, "1" JOYSTICK KEMPSTON activado.
Score_hex_max defw 0
Score_max_msg ds 6

; Name NEW RECORD.!!!!!

Nombre_del_campeon ds 6
Puntero_del_nombre_del_campeon defw Nombre_del_campeon
Contador_de_caracteres_del_nombre_del_campeon db 5 										; El nombre del ganador tiene 5 caracteres.

Non_authorized_KEY_CODES db $27,$18,$23,$24,$1c,$14,$0c,$04,$03,$0b,$13,$1b

Desplazamiento_level_msg db 0
Counter_msg_char db 0

; Control de Amadeus, (KEY CODES).

Numero_de_teclas_definidas db 0								; Contiene el n° de teclas definidas (0-3). [Define_menu] y [Define_key].
; 															; Compararemos el KEYCODE de la nueva key definida con las definidas anteriormente_
; 															; _ , (Move_LEFT), (Move_RIGHT), ..., tantas veces como indique el contenido de (Numero_de_teclas_definidas).

Move_LEFT db $24
Move_RIGHT db $1c
Move_FIRE db $04
Move_SHIELD db $20
