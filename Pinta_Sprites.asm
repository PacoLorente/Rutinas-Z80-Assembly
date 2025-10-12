Print_Score_Counter:

; Attr.

    ld hl,Unidades_Score
    call Calcula_direccion_atributos

    ld a,%01000111
    ld b,5

1 ld (hl),a
    dec l
    djnz 1B

;   Utilizamos la pila.

    ld (Stack),sp

;   Unidades.

    ld sp,(Puntero_de_unidades_Score)

    pop hl

    ld a,l
    ld (Unidades_Score),a

    ld a,h
    ld (Unidades_Score_1),a

    pop hl

    ld a,l
    ld (Unidades_Score_2),a

    ld a,h
    ld (Unidades_Score_3),a

    pop hl

    ld a,l
    ld (Unidades_Score_4),a

    ld a,h
    ld (Unidades_Score_5),a

    pop hl

    ld a,l
    ld (Unidades_Score_6),a

    ld a,h
    ld (Unidades_Score_7),a

; Consulta dígito de Ctrl.

    ld a,(Score_Ctrl)
    and a
    jp z,Exit_1

;   Decenas.

2 ld sp,(Puntero_de_decenas_Score)

    pop hl

    ld a,l
    ld (Decenas_Score),a

    ld a,h
    ld (Decenas_Score_1),a

    pop hl

    ld a,l
    ld (Decenas_Score_2),a

    ld a,h
    ld (Decenas_Score_3),a

    pop hl

    ld a,l
    ld (Decenas_Score_4),a

    ld a,h
    ld (Decenas_Score_5),a

    pop hl

    ld a,l
    ld (Decenas_Score_6),a

    ld a,h
    ld (Decenas_Score_7),a

;   Centenas.

    ld sp,(Puntero_de_centenas_Score)

    pop hl

    ld a,l
    ld (Centenas_Score),a

    ld a,h
    ld (Centenas_Score_1),a

    pop hl

    ld a,l
    ld (Centenas_Score_2),a

    ld a,h
    ld (Centenas_Score_3),a

    pop hl

    ld a,l
    ld (Centenas_Score_4),a

    ld a,h
    ld (Centenas_Score_5),a

    pop hl

    ld a,l
    ld (Centenas_Score_6),a

    ld a,h
    ld (Centenas_Score_7),a

;   Unidades_de_millar.

    ld sp,(Puntero_de_um_Score)

    pop hl

    ld a,l
    ld (Unidades_de_millar_Score),a

    ld a,h
    ld (Unidades_de_millar_Score_1),a

    pop hl

    ld a,l
    ld (Unidades_de_millar_Score_2),a

    ld a,h
    ld (Unidades_de_millar_Score_3),a

    pop hl

    ld a,l
    ld (Unidades_de_millar_Score_4),a

    ld a,h
    ld (Unidades_de_millar_Score_5),a

    pop hl

    ld a,l
    ld (Unidades_de_millar_Score_6),a

    ld a,h
    ld (Unidades_de_millar_Score_7),a

;   Decenas_de_millar.

    ld sp,(Puntero_de_dm_Score)

    pop hl

    ld a,l
    ld (Decenas_de_millar_Score),a

    ld a,h
    ld (Decenas_de_millar_Score_1),a

    pop hl

    ld a,l
    ld (Decenas_de_millar_Score_2),a

    ld a,h
    ld (Decenas_de_millar_Score_3),a

    pop hl

    ld a,l
    ld (Decenas_de_millar_Score_4),a

    ld a,h
    ld (Decenas_de_millar_Score_5),a

    pop hl

    ld a,l
    ld (Decenas_de_millar_Score_6),a

    ld a,h
    ld (Decenas_de_millar_Score_7),a

Exit_1 ld sp,(Stack)

    ret

;---------------------------------------------------------------------
;   Imprime el cartel SCORE:
;
;   10/10/25
;
;
;

Imprime_SCORE:

    ld hl,$4019
    ld de,_Sc
    call bp

    ld de,_or
    call bp

    ld de,_e
    call bp

    ret

bp push hl
    ld bc,$0202
    ld a,%01000101
    call Pinta_imagen
    pop hl

    inc l
    inc l

    ret

;---------------------------------------------------------------------
;   Imprime el contador: ENEMIGOS RESTANTES.
;
;   4/10/25
;
;   MODIFY:HL
;

;   Decenas.

Print_enemy_counter:

    ld (Stack),sp
    ld sp,(Puntero_decenas_grandes)

    pop hl
    ld (Decenas_cont_ent),hl

    pop hl
    ld (Decenas_cont_ent_1),hl

    pop hl
    ld (Decenas_cont_ent_2),hl

    pop hl
    ld (Decenas_cont_ent_3),hl

    pop hl
    ld (Decenas_cont_ent_4),hl

    pop hl
    ld (Decenas_cont_ent_5),hl

    pop hl
    ld (Decenas_cont_ent_6),hl

    pop hl
    ld (Decenas_cont_ent_7),hl

    pop hl
    ld (Decenas_cont_ent_8),hl

    pop hl
    ld (Decenas_cont_ent_9),hl

    pop hl
    ld (Decenas_cont_ent_10),hl

    pop hl
    ld (Decenas_cont_ent_11),hl

    pop hl
    ld (Decenas_cont_ent_12),hl

    pop hl
    ld (Decenas_cont_ent_13),hl

    pop hl
    ld (Decenas_cont_ent_14),hl

    pop hl
    ld (Decenas_cont_ent_15),hl

    pop hl
    ld (Decenas_cont_ent_16),hl

    pop hl
    ld (Decenas_cont_ent_17),hl

    pop hl
    ld (Decenas_cont_ent_18),hl

    pop hl
    ld (Decenas_cont_ent_19),hl

    pop hl
    ld (Decenas_cont_ent_20),hl

    pop hl
    ld (Decenas_cont_ent_21),hl

    pop hl
    ld (Decenas_cont_ent_22),hl

    pop hl
    ld (Decenas_cont_ent_23),hl

;   Unidades.

    ld sp,(Puntero_unidades_grandes)

    pop hl
    ld (Unidades_cont_ent),hl

    pop hl
    ld (Unidades_cont_ent_1),hl

    pop hl
    ld (Unidades_cont_ent_2),hl

    pop hl
    ld (Unidades_cont_ent_3),hl

    pop hl
    ld (Unidades_cont_ent_4),hl

    pop hl
    ld (Unidades_cont_ent_5),hl

    pop hl
    ld (Unidades_cont_ent_6),hl

    pop hl
    ld (Unidades_cont_ent_7),hl

    pop hl
    ld (Unidades_cont_ent_8),hl

     pop hl
    ld (Unidades_cont_ent_9),hl

    pop hl
    ld (Unidades_cont_ent_10),hl

    pop hl
    ld (Unidades_cont_ent_11),hl

    pop hl
    ld (Unidades_cont_ent_12),hl

    pop hl
    ld (Unidades_cont_ent_13),hl

    pop hl
    ld (Unidades_cont_ent_14),hl

    pop hl
    ld (Unidades_cont_ent_15),hl

    pop hl
    ld (Unidades_cont_ent_16),hl

    pop hl
    ld (Unidades_cont_ent_17),hl

    pop hl
    ld (Unidades_cont_ent_18),hl

    pop hl
    ld (Unidades_cont_ent_19),hl

    pop hl
    ld (Unidades_cont_ent_20),hl

    pop hl
    ld (Unidades_cont_ent_21),hl

    pop hl
    ld (Unidades_cont_ent_22),hl

    pop hl
    ld (Unidades_cont_ent_23),hl

    ld sp,(Stack)

;   Attrs.

    ld hl,Decenas_cont_ent
    call Calcula_direccion_atributos

    ld a, (Attr_big_counter)
    ld sp,(Stack)
    call Pintor:

    ld hl,Decenas_cont_ent_8
    call Calcula_direccion_atributos

    ld a, (Attr_big_counter)
    ld sp,(Stack)
    call Pintor:

    ld hl,Decenas_cont_ent_16
    call Calcula_direccion_atributos

    ld a, (Attr_big_counter)
    ld sp,(Stack)
    call Pintor:

Pintor:

    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a


    ret

; ------------------------------------------------------------------------
;
;   26/9/25
;
;   Pinta un sprite de Amadeus en la parte superior izquierda de la pantalla.
;
;   MODIFY: A,HL,BC y DE


Pinta_Vida:

    ld (Stack),sp
    ld sp,(Puntero_de_vidas)

    pop hl
    pop de
    pop bc

    ld (Puntero_de_vidas),sp

    ld sp,(Stack)

    ld a,%01000101                                                  ; Cyan.

    call Pinta_imagen

    ret

Borra_vida:

    ld hl,Ctrl_4
    res 6,(hl)                                                      ; Inicializa FLAG, para poder seguir borrando vidas.

;   Situamos (Puntero_de_vidas) en la posición correcta y actualizamos (Puntero_de_vidas).

    ld bc,6

    ld hl,(Puntero_de_vidas)
    sbc hl,bc
    ld (Puntero_de_vidas),hl

    push hl

    call Pinta_Vida

    pop hl

    ld (Puntero_de_vidas),hl

    ret

Pinta_Escudo:

    ld (Stack),sp
    ld sp,(Puntero_de_escudos)

    pop hl
    pop de
    pop bc

    ld (Puntero_de_escudos),sp

    ld sp,(Stack)

    ld a,%01000111                                                  ; White.

    call Pinta_imagen

    ret

Borra_escudo:

    ld hl,Ctrl_2
    res 7,(hl)                                                      ; Inicializa FLAG, para poder seguir borrando escudos.

    ld bc,6

    ld hl,(Puntero_de_escudos)
    sbc hl,bc
    ld (Puntero_de_escudos),hl

    push hl

    call Pinta_Escudo

    pop hl

    ld (Puntero_de_escudos),hl

    ret

; ------------------------------------------------------------------------
;
;	24/7/25
;
;	Restaura_attr_vida
;
;   Esta función evita que cambie el color del icono de vida que hay en el interior del escudo cuando lo eliminamos.
;
;   MODIFICA: A.

;Restaura_attr_vida:

;    call Calcula_direccion_atributos

;    inc l

;    ld a,l
;    add $20
;    ld l,a                                                          ; Dirección de attr de pantalla, (centro del escudo) donde se encuentra el icono de VIDA.

;    ld a,%01000101                                                  ; Attr. de la vida.
;    ld (hl),a

;    ret

; ------------------------------------------------------------------------
;
;	26/9/25
;
;	Pinta_imagen.
;
;	Pinta cualquier imagen en pantalla, (XOR). Esta rutina se utiliza para imágenes estáticas, (NO SPRITES).
;
;	INPUTS: HL contiene la dirección de memoria depantalla donde queremos imprimir la imagen, (esquina superior izquierda).
;			DE contiene la dirección del 1er .db que conforman los datos de la imagen.
;            A contiene los Attr.
;            B contiene el nº de Columnas.
;			 C contiene el nº de Filas.
;
;	MODIFICA: AF,HL,DE y BC.

Pinta_imagen:

    push bc
    push hl                                                         ; Guardamos datos para pintar más adelante.

;   Attrs.

2 push bc
    push hl

    ex af,af                                                        ; Salvo Attrs. [Calcula_direccion_atributos] destruye A.
    call Calcula_direccion_atributos
    ex af,af

1 ld (hl),a
    inc l
    djnz 1B

    pop hl
    ex af,af

;   Siguiente Fila de Attrs.

    ld a,l
    add $20
    ld l,a

    ex af,af

    pop bc
    dec c
    jr nz,2B

;   Imagen.

    pop hl
    pop bc

;   Generamos scanlines

    dec c

    ld a,8

4 add 8
    dec c
    jr nz,4B

    ld c,a                                                          ; Scanlines en C.

5 push bc
    push hl

3 ld a,(de)
    xor (hl)
    ld (hl),a

    inc l
    inc e

    djnz 3B

    pop hl
    pop bc

    dec c
    ret z

    call NextScan

    jr 5B

; --------------------------------------------------------------------------------------
;
;   2/4/25
;

;   Estructura de un disparo de entidades.

;   Disparo_1 defw 0                                ; Puntero objeto.
;   defw 0                                          ; Puntero de impresión.
;   defw 0                                          ; Control.

;   El byte bajo de Control indica la velocidad a la que fué lanzado el disparo, (Velocidad)_
;   _de la entidad en el momento de disparar.

;   El byte de control muestra la siguiente información:

;   Nibble alto    ..... Bits (6) y (7) ..... Indican si el disparo va hacia la derecha o hacia la izquierda.
;
;                        10xx ..... Izquierda.
;                        01xx ..... Derecha.
;                        00xx ..... Recto.

Pinta_disparos_Entidades:

    ld (Stack),sp 
    ld sp,(Album_de_borrado_disparos_Entidades)

    ld a,2
    ex af,af

    ld c,%01000111         ; (Attr). de los disparos.

3 ld b,7                           ; Nº máximo de disparos. Fuerza la salida del album cuando hemos pintado 7 veces_
;                                      _ aunque IYL+IYH+E no sea "0". (No hay separacíon entre el álbum de borrado y el de pintado).
;                                      _ No encontraría "0".


4 pop iy
    pop de                              ; 1er .db IYL
;                                      ; 2º  .db IYH
;                                      ; 3er .db E.
;                                      ; .db que pintan el disparo, ej.: $18 $00 $00, (Puntero_objeto) del disparo, 3 .db's.

;   Album vacío ???

    ld a,iyl
    add iyh
    add e
    jr z,1F                          ; Álbum vacío salta a 1F.

;   Imprime album, (contiene datos).   

    dec sp

    pop hl                          ; Puntero de impresión del 1er scanline en HL.
    push hl

; Atributos.

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    dec l
    dec l
    ld (hl),c                                           
    inc l
    ld (hl),c
    inc l
    ld (hl),c
    inc l
    ld (hl),c
    inc l
    ld (hl),c

; Imprime el 1er scanline del disparo.

    pop hl

    ld a,iyl    
    xor (hl)
    ld (hl),a

    inc l

    ld a,iyh
    xor (hl)
    ld (hl),a

    inc l

    ld a,e
    xor (hl)
    ld (hl),a

; Imprime el 2º scanline del disparo.

    pop hl                          ; Puntero de impresión del 2º scanline en HL.

    ld a,iyl    
    xor (hl)
    ld (hl),a

    inc l

    ld a,iyh
    xor (hl)
    ld (hl),a

    inc l

    ld a,e
    xor (hl)
    ld (hl),a    

    djnz 4B

1 ex af,af
    dec a
    jr nz,2F

    ld sp,(Stack)
    ret    

2 ld sp,(Album_de_pintado_disparos_Entidades) 
    ex af,af
    jr 3B

; --------------------------------------------------------------------------------------
;
;   2/4/25
;
;   Pinta los dos scanlines y char. de atributos del disparo de Amadeus.

Pinta_disparos_Amadeus:

    ld b,2                                                        ; 2 Albumes, (borrado y pintado).

    ld c,%01000111                                                 ; Attr del disparo Blanco.                    

    ld (Stack),sp 
    ld sp,(Album_de_borrado_disparos_Amadeus)

3 pop de

    inc d
    dec d
    jr z,1F                                                       ; Álbum vacío salta a 1F.

; Existen disparos en alguno de los 2 albumes.

    pop hl                                                      ; (Puntero de impresion) del disparo en HL.
    push hl

; Atributos.

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    dec l
    ld (hl),c                                           
    inc l
    ld (hl),c
    inc l
    ld (hl),c

Imprime_scanlines_en_pantalla

; (Puntero_objeto) del disparo en DE.
; (Puntero_de_impresion) en HL.

; 1er scanline

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a

    inc e
    inc l

    ld a,(de)
    xor (hl)
    ld (hl),a

    dec e
    pop hl

; 2º scanline

    ld a,(de)
    xor (hl)
    ld (hl),a

    inc e
    inc l

    ld a,(de)
    xor (hl)
    ld (hl),a

    dec e

    jr 1F

2 ld sp,(Album_de_pintado_disparos_Amadeus) 
    jr 3B

1 djnz 2B

    ld sp,(Stack)

    ret    

; -----------------------------------------------------------------------------
;
;   1/4/25
;
;   INPUT: A contiene (Columnas).
;          C contiene (Attr).

Pinta_Sprites:

    ld (Stack),sp
 
    ex de,hl                            ; HL se encuentra en el álbum de líneas.
;                                       ; DE se encuentra en los datos del sprite.
    inc l
    inc l

    ld b,(hl)                           ; B contiene el nº de scanlines a imprimir.

    inc l
    ld sp,hl                            ; El SP irá extrayendo scanlines en HL.

;   Seleccionamos rutina de impresión:

    ex af,af                            ; (Columnas) en AF´.

    ld a,16
    cp b
    jp nz,Pinta_lento                   ; Si el sprite no se imprime completo utilizamos la 2ª rutina de pintado.
 
;   Rutinas:

Pinta_rapido                            ;   1520 t/states.

    ld a,(Columnas)
    dec a
    jp z,Pinta_rapido_1_Columna
    dec a
    jp z,Pinta_rapido_2_Columnas

Pinta_rapido_3_Columnas

; Attr. 3 (Columnas).

    pop hl
    push hl

; Comprobamos si necesitamos 3 o 2 (Filas) de Attrs.

    ld a,h
    cp $48
    jr z,4F              ; Si H = "$48" sólo se aplican 2 Filas de Attrs. 

    and $0f    
    jr z,4F              ; Si H = "$40" o "$50" sólo se aplican 2 Filas de Attrs. 

; Indica 3 Filas de attr.

    ld a,(Ctrl_4)
    set 4,a
    ld (Ctrl_4),a

4 ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    ld (hl),c
    inc l
    ld (hl),c
    inc l
    ld (hl),c

; ----- ----- -----

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

; Attr. 3 (Columnas).

    pop hl
    push hl

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

6 ld (hl),c
    inc l
    ld (hl),c
    inc l
    ld (hl),c

    ld a,(Ctrl_4)
    bit 4,a
    jr z,5F

; 3ª Fila de Atributos.

    res 4,a
    ld (Ctrl_4),a           ; Inicializa FLAG, (indica 3 Filas de attrs.).

    dec l
    dec l

    ld a,l
    add 32
    ld l,a

    jr nc,6B

    inc h
    jr 6B

; ----- ----- -----
 
5 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)

    ret

Pinta_rapido_2_Columnas

; Attr. 2 (Columnas).

    pop hl
    push hl

; Comprobamos si necesitamos 3 o 2 (Filas) de Attrs.

    ld a,h
    cp $48
    jr z,7F              ; Si H = "$48" sólo se aplican 2 Filas de Attrs. 

    and $0f    
    jr z,7F              ; Si H = "$40" o "$50" sólo se aplican 2 Filas de Attrs. 

; Indica 3 Filas de attr.

    ld a,(Ctrl_4)
    set 4,a
    ld (Ctrl_4),a

7 ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    ld (hl),c
    inc l
    ld (hl),c

; ----- ----- -----

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

; Attr. 2 (Columnas).

    pop hl
    push hl

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

8 ld (hl),c
    inc l
    ld (hl),c

    ld a,(Ctrl_4)
    bit 4,a
    jr z,9F

; 3ª Fila de Atributos.

    res 4,a
    ld (Ctrl_4),a           ; Inicializa FLAG, (indica 3 Filas de attrs.).

    dec l

    ld a,l
    add 32
    ld l,a

    jr nc,8B

    inc h
    jr 8B

; ----- ----- -----

9 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)

    ret

Pinta_rapido_1_Columna

; Attr. 1 (Columnas).

    pop hl
    push hl

; Comprobamos si necesitamos 3 o 2 (Filas) de Attrs.

    ld a,h
    cp $48
    jr z,10F              ; Si H = "$48" sólo se aplican 2 Filas de Attrs. 

    and $0f    
    jr z,10F              ; Si H = "$40" o "$50" sólo se aplican 2 Filas de Attrs. 

; Indica 3 Filas de attr.

    ld a,(Ctrl_4)
    set 4,a
    ld (Ctrl_4),a

10 ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    ld (hl),c

; ----- ----- -----

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

; Attr. 1 (Columnas).

    pop hl
    push hl

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

11 ld (hl),c

    ld a,(Ctrl_4)
    bit 4,a
    jr z,12F

; 3ª Fila de Atributos.

    res 4,a
    ld (Ctrl_4),a           ; Inicializa FLAG, (indica 3 Filas de attrs.).

    ld a,l
    add 32
    ld l,a

    jr nc,11B
    inc h

    jr 11B

; ----- ----- -----

12 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e
    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)

    ret

Pinta_lento

    ld a,(Columnas)
    dec a
    jr z,Pinta_lento_1_Columna
    dec a
    jr z,Pinta_lento_2_Columnas

Pinta_lento_3_Columnas

; La entidad está desapareciendo por la parte baja de la pantalla. 1 o 2 Filas de Attrs.
; Attr. 3 (Columnas).

    pop hl
    push hl

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    ld (hl),c
    inc l
    ld (hl),c
    inc l
    ld (hl),c

    dec l
    dec l

; Averiguamos si la entidad ocupa 1 o 2 Filas en pantalla.

    ld a,l
    cp $e0
    jr nc,1F

    add 32
    ld l,a

    ld (hl),c
    inc l
    ld (hl),c
    inc l
    ld (hl),c

; ----- ----- -----

1 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc de

    djnz 1B

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

Pinta_lento_2_Columnas

; La entidad está desapareciendo por la parte baja de la pantalla. Sólo 1 Fila de Attr.
; Attr. 2 (Columnas).

    pop hl
    push hl

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    ld (hl),c
    inc l
    ld (hl),c

    dec l
 
; Averiguamos si la entidad ocupa 1 o 2 Filas en pantalla.

    ld a,l
    cp $e0
    jr nc,2F

    add 32
    ld l,a

    ld (hl),c
    inc l
    ld (hl),c

2 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc l
    inc e
    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e

    djnz 2B

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret

Pinta_lento_1_Columna


; La entidad está desapareciendo por la parte baja de la pantalla. Sólo 1 Fila de Attr.
; Attr. 1 (Columnas).

    pop hl
    push hl

    ld a,h                                  
    and $18
    sra a
    sra a
    sra a
    add $58
    ld h,a

    ld (hl),c

 ; Averiguamos si la entidad ocupa 1 o 2 Filas en pantalla.

    ld a,l
    cp $e0
    jr nc,3F

    add 32
    ld l,a

    ld (hl),c

3 pop hl

    ld a,(de)
    xor (hl)
    ld (hl),a
    inc e
    inc e
    inc e

    djnz 3B

    ld (Scanlines_album_SP),sp
    ld sp,(Stack)
    ret
