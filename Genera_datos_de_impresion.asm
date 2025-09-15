; ---------------------------------------------------------------------------------------------------------------------------------------
;
;	9/8/25
;
;	Scanlines_generator.
;
;	Obtiene el (Puntero_de_impresion) codificado del álbum de movimientos masticados. Lo decodifica y genera sus coordenadas X e Y.
;	Tanto el puntero decodificado como las coordenadas son actualizadas en su correspondiente `Caja_de_entidades'.
;	Cuando que el objeto es `visible' en pantalla, (no esté situado en zona ROM ni en marcador), generará la cabecera de impresión y los scanlines correspondientes en el (Album_de_pintado).
;	En este caso, anotará además la correspondiente línea informativa en la (Tabla_de_pintado).
;
;		Estructura de cada línea en la (Tabla_de_pintado):
;
;		(Columna_Y), (Attr), (Columnas) y .defw (Album_de_pintado).
;		.db, .db, .db, .defw
;
;	Por último; decrementa el contador (Contador_de_mov_masticados).
;
;	INPUTS: IX apunta al 1er .db de la `Caja_de_entidades' correspondiente.
;
;	MODIFY: A,BC,DE y HL

Scanlines_generator:

	call Take_movement

    ld a,d
    add e
    ret z                                                           ; Movimiento NO VÁLIDO. Reiniciamos danza.

    call Decodifica_Puntero_de_impresion

    push bc
    pop hl

;	Nota: En este punto: BC y HL contienen el (Puntero_de_impresion).
;						 IX contiene (1er_db_caja_de_entidades).
;						 DE contiene (Puntero_objeto).

Explosion_scanlines_generator

    push ix								                            ; Push 1er .db (Clase) de la entidad, (caja de entidades correspondiente).

	push hl
	pop ix 															; HL e IX han de contener (Puntero_de_impresion) antes de call [Genera_datos_de_impresion].

    push de                                                         ; PUSH (Puntero_objeto).
    call Genera_datos_de_impresion									; No se generan datos de impresión si el objeto está por detrás del panel marcador del juego.
	call Genera_coordenadas
	pop de                                                          ; POP (Puntero_objeto).

	pop ix 															; POP 1er .db (Clase) de la entidad, (caja de entidades correspondiente).

	ld bc,(Coordenada_X)

	ld (ix+2),c
	ld (ix+3),b														; (Coordenada_X) y (Coordenada_Y) en caja de entidad.

	ld a,(Ctrl_4)
    push af

    bit 7,a
	jr nz,1F

	call Entidad_a_Tabla_de_pintado									; Almacena la (Coordenada_Y) y dirección dentro de (Scanlines_album_SP) de la entidad en curso.

1 pop af
    res 7,a
	ld (Ctrl_4),a

;	call Decrementa_Contador_de_mov_masticados                     ; Actualizamos (Contador_de_mov_masticados) tras la foto.

	ret

; ---------------------------------------------------------------------------------------------------------------------
;
;   07/08/25
;
;   Genera la coordenada X de Amadeus y los datos de impresión de la nave en su (Album_de_pintado_Amadeus).

Genera_datos_de_impresion_Amadeus 

    ld a,(Impacto_Amadeus)
    and a
    jr nz,1F

; Si existe impacto en Amadeus ya tendremos modificados los registros DE con (Puntero_objeto)_
; _apuntando a la correspondiente explosión.

    call Cargamos_registros_con_mov_masticado_Amadeus   

;   DE contiene (Puntero_objeto) de Amadeus.
;   IX contiene (Puntero-de_impresion).

1 ld a,ixl
    and $1f
    ld (CX_Amadeus),a                                       ; Coordenada X del Amadeus, (0-$1f). Columnas.

    ld hl,(Scanlines_album_SP)
    push hl

;   Posicionamos (Scanlines_album_SP) en el álbum de líneas de Amadeus.

    ld hl,(Album_de_pintado_Amadeus)
    ld (Scanlines_album_SP),hl

    push ix
    pop hl                                                  ; HL e IX han de contener (Puntero_de_impresion) antes de call [Genera_datos_de_impresion].

    call Genera_datos_de_impresion

    pop hl
    ld (Scanlines_album_SP),hl  

    ret

; --------------------------------------------------------------------------------------------------------------
;
;   17/06/24
;
;   Cargamos los registros DE e IX, (Puntero_de_almacen_de_mov_masticados) de Amadeus. 
;   
;   IX contiene el puntero de impresión.
;   DE contiene (Puntero_objeto).
 

Cargamos_registros_con_mov_masticado_Amadeus

    ld (Stack),sp
    ld sp,(Pamm_Amadeus)                                    ; (Puntero_de_almacen_de_mov_masticados_Amadeus) en su correspondiente caja.
    pop de                                                  ; DE contiene Puntero_objeto
    pop ix                                                  ; IX contiene Puntero_de_impresion
    ld (p.imp.amadeus),ix                                   ; (Puntero_de_impresion_Amadeus) en su correspondiente caja.

    ld sp,(Stack)

;   Estamos desapareciendo ???

    ld a,(Ctrl_2)
    bit 6,a
    ret z                                                   ; RET, Amadeus no hemos terminado el NIVEL.

    call Transicion_de_salida

    ret

; ------------------------------------------------------
;
;   12/8/25
;
;   MODIFY: HL,DE e IX.
;
;   OUTPUT: HL y DE contienen (Puntero_objeto) de la explosión de Amadeus.
;           IX contiene el (Puntero_de_impresion) de Amadeus.


Cargamos_registros_con_explosion_Amadeus

    ld hl,(Pamm_Amadeus)
    call Extrae_address

    ld e,l
    ld d,h  

    ld ix,(p.imp.amadeus)

    ret

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	6/8/25
;
;   INPUTS:
;
;   DE contiene (Puntero_objeto).
;   HL e IX contienen (Puntero_de_impresion).
;
;   MODIFY: A,IX,HL,BC y DE.

Genera_datos_de_impresion:

;   En 1er lugar analizamos la posición del (Puntero_de_impresion).
;   No se han de generar scanlines cuando la entidad se imprima en zona de ROM o completamente en zona de MARCADOR de pantalla, (3 primeras líneas).
;   Cuando el (Puntero_de_imprersion) se genera en la 2ª o 3ª línea de pantalla hay que calcular el nº de scanlines que pintamos del Sprite. Como el Sprite está apareciendo_
;   _ por la parte alta de la pantalla hay que sitúar (Puntero_objeto) en la línea de datos correspondiente.

    call calcula_tercio                             ; HL contiene (Puntero_de_impresion).
    and a
    jr nz,Completo_o_desapareciendo

;   1er Tercio de pantalla !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    ld a,l
    cp $20
    jr c,No_scanlines                               ; Empezamos a generar scanlines a partir del segundo scanline de la 2ª fila de pantalla. (En la dirección $4120 se generaría 1 scan.).

    ld a,l
    cp $60
    jr nc,Completo_o_desapareciendo

;   La entidad no se imprimirá entera. Va a ir apareciendo por la parte baja del marcador.
;   Calculamos el nº de scanlines que vamos a imprimir.
;   (Puntero_de_impresion) se encuentra en la 2ª o 3ª Fila de la pantalla.

    ld a,h
    sub $40
    ld b,a                                          ; Nº de scanlines en B. Si el 1er scanline es $40XX, siendo XX la segunda fila de pantalla: [No_scanlines].
    jr nz,2F

;   Estamos en una línea $40 y apareciendo.

    ld a,l
    cp $40
    jr c,No_scanlines                               ; Si estamos en la 2ª Fila la entidad quedaría oculta, jr [No_scanlines].

2 ld a,l
    add $40
    ld l,a

    cp $80
    jr c,Modifica_puntero_objeto

    ld a,l
    sub $20
    ld l,a

    ld a,8
    add b
    ld b,a

Modifica_puntero_objeto

    ld h,$40

    push hl
    pop ix

    ld c,b                                          ; Posiciona HL en el 1er scan.

;   Modificamos ahora (Puntero_objeto).

    ld a,16
    sub b
    ld b,a

    ld a,e

    add b
    add b
    add b

    ld e,a

    ld b,c
    ld c,0

;   En este punto DE contiene (Puntero_objeto)
;   HL y IX contienen (Puntero_de_impresion)
;   BC contiene Nº de scanlines a generar.

    call Genera_cabecera
    call Genera_scanlines
    ret

; -------------------------------------------------------------------

No_scanlines

    ld hl,Ctrl_4
    set 7,(hl)                                       ; Indica que esta unidad no se imprime. NO SE AÑADE A LA TABLA DE PINTADO.

    push ix
    pop hl                                           ; RET con el (Puntero_de_impresion) en HL e IX.

    ret

; -------------------------------------------------------------------

;   IX y HL contienen (Puntero_de_impresion). DE contiene (Puntero_objeto).

Completo_o_desapareciendo

    call Calcula_numero_de_scans
    call Genera_cabecera
    call Genera_scanlines
    ret

; ------------------------------------------------------------------------------------
;
;   2/8/25
;
;   INPUTS: HL (Scanlines_album).
;           DE (Puntero_objeto).
;           BC (Nº de scanlines).

Genera_scanlines:

    ex de,hl

    push ix
    pop hl                                          ; (Puntero_de_impresion) en HL.

    dec b
    ret z

;   HL contiene el 1er scanline, (Puntero_de_impresion).
;   DE contiene (Scanlines_album_SP).
;   B contiene el nº de scanlines (-1) a generar.

1 call NextScan

    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    djnz 1B

; Todos los scanlines generados. actualizamos el puntero (Scanlines_album_SP).

    ld (Scanlines_album_SP),de
    ld (Puntero_de_impresion_disparo_de_entidad),hl

    push ix                                          ; RET con el (Puntero_de_impresion) en HL e IX.
    pop hl

    ret

; ------------------------------------------------------------------------------------
;
;   6/8/25
;

Genera_cabecera:

;   Genera cabecera, y actualiza (Scanlines_album_SP) situándolo en el movimiento de la siguiente entidad.
;   BC contendrá el nº de scanlines que vamos a imprimir.

    ld (Stack),sp                                   ; Guardo SP en (Stack).

    ld hl,(Scanlines_album_SP)
    ld (Repone_puntero_objeto),hl                   ; Copia de respaldo de (Scanlines_album_SP). Se utilizará más adelante en la tabla de pintado.

    ld a,l
    add 5
    ld l,a

    ld sp,hl
    ld (Scanlines_album_SP),hl                      ; Actualiza (Scanlines_album_SP). Lo sitúa en el siguiente movimiento.

    ld hl,0
    adc hl,sp                                       ; HL posicionado para ir generando líneas tras la CABECERA.

    push ix                                         ; (Puntero_de_impresion) al álbum de líneas.
    push bc                                         ; Nº de scanlines al álbum de líneas.
    inc sp
    push de                                         ; (Puntero_objeto) al álbum de líneas.

; Recuperamos SP.

    ld sp,(Stack)

    ret

; ------------------------------------------------------------------------------------
;
;   6/8/25
;
;   Calcula el nº de scanlines que vamos a generar, (cuando la entidad no está apareciendo).
;
;   INPUTS: IX y HL contienen (Puntero_de_impresion).
;           DE contiene (Puntero_objeto).
;
;   OUTPUTS: BC contiene nº de scanlines a generar.
;
;   MODIFICA: A,HL y BC.

Calcula_numero_de_scans:

    ld c,0

    ld a,h
    cp $50
    jr c,1F                                         ; No hemos llegado a la parte baja de la pantalla. Nos encontramos en el 1er o 2º tercio de la pantalla.

;   En el último tercio de pantalla...

    jr nz,2F

;   Situación: Último tercio de pantalla y 1er scan de la Fila.

    ld a,l
    cp $e0
    jr c,1F                                         ; Siempre que no estemos en la última Fila de pantalla se generarán 16 scanlines, (entidad completa).

    ld b,8

    ret

;   Situación: Último tercio de pantalla, (del 2º scan. en adelante de la Fila).

2 ld a,l
    cp $c0
    jr nc,Calcula_scans_desapareciendo              ; En las 2 últimas líneas el Sprite sólo se imprime completo cuando el primer scanline está en una dirección $50xx.


;   Entidad completa. Se generan 16 scanlines para imprimir.

1 ld b,16

    ret

Calcula_scans_desapareciendo

    ld a,$58
    sub h
    ld b,a

    ld a,l
    cp $e0

    ret nc

    ld a,b
    add 8
    ld b,a

    ret

; --------------------------------------------------------------------------------------
;
;   12/10/24
;

Genera_datos_de_impresion_disparos_Entidades

    ld a,7
    ex af,af                                                  ;? 7 Disparos como 7 amores.

; ---------------

;   En 1er lugar nos situamos en la 1ª caja de disparos de entidades.

    ld hl,Indice_de_disparos_entidades

1 call Extrae_address
 
    inc de
    inc de

    ld (Puntero_DESPLZ_DISPARO_ENTIDADES),de 

    dec l
    ld a,(hl)
    and a                                                     ;? Si el byte alto de control es "0" significa que la caja está vacía.
    jr z,Situa_en_siguiente_caja                              ;? Avanzamos a la siguiente caja en ese caso.

; ----- ----- ----- -----   

    dec l
    call Extrae_address
    push hl                                                   

    dec e

    ex de,hl

    ld c,(hl)                                                 ;? 3er byte del disparo de C.
    dec l
    ld b,(hl)                                                 ;? 2º byte del disparo de B.
    dec l
    ld e,(hl)                                                 ;? 1er byte del disparo de E.

    pop hl                                                    ;? Puntero de impresión en HL.                                                   

Genera_scanlines_de_los_disparos_de_entidades.

    ld iy,(Nivel_scan_disparos_album_de_pintado)
    ld (iy+0),e
    ld (iy+1),b
    ld (iy+2),c

    ld (iy+3),l
    ld (iy+4),h

    call NextScan

    ld (iy+5),l
    ld (iy+6),h

    push iy
    pop hl

    ld a,7
    add l
    ld l,a

    ld (Nivel_scan_disparos_album_de_pintado),hl

; ----- ----- ----- -----   

Situa_en_siguiente_caja

    ex af,af                                                  ;? Actualiza contador de cajas y RET si "Z".
    dec a
    ret z

    ex af,af
    ld hl,(Puntero_DESPLZ_DISPARO_ENTIDADES)
    jr 1B
