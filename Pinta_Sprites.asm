; ------------------------------------------------------------------------
;
;   23/7/25
;
;   Imprime_escudo

Imprime_escudo ld hl,(Puntero_de_escudos)
    call Extrae_address

    ld bc,Ultimo_escudo                                             ; No incrementamos el Puntero_de_escudos si estamos al final del índice.

    ld a,c
    sub e
    jr z,1F

    inc de
    inc de

1 call Pinta_escudo

    ret

Borra_escudo 

    ld hl,Ctrl_2
    res 7,(hl)                                                      ; Inicializa FLAG, para poder seguir borrando escudos.

    ld hl,(Puntero_de_escudos)
    call Extrae_address

    push hl

    ld bc,Indice_de_escudos                                         ; No incrementamos el Puntero_de_escudos si estamos al final del índice.

    ld a,e
    sub c
    jr z,1F

    dec de
    dec de

1 call Pinta_escudo

    pop hl

    call Restaura_attr_vida

    ret

; ----- ----- ----- ----- -----

Pinta_escudo 

    ld (Puntero_de_escudos),de

    ld de,Escudo
    ld bc,$0303
    ld a,%01000110

    call Pinta_imagen

    ret

; --------------------------------------------------

Imprime_vida ld hl,(Puntero_de_vidas)
    call Extrae_address

    ld bc,Ultima_vida                                               ; No incrementamos el Puntero_de_escudos si estamos al final del índice.

    ld a,c
    sub e
    jr z,1F

    inc de
    inc de

1 call Pinta_vida

    ret

Borra_vida 

    ld hl,Ctrl_4
    res 6,(hl)                                                      ; Inicializa FLAG, para poder seguir borrando vidas.

    ld hl,(Puntero_de_vidas)
    call Extrae_address

    ld bc,Indice_de_vidas                                           ; No incrementamos el Puntero_de_escudos si estamos al final del índice.

    ld a,e
    sub c
    jr z,1F

    dec de
    dec de

1 call Pinta_vida

    ret

Pinta_vida

    ld (Puntero_de_vidas),de

    ld de,Vida
    ld bc,$0101
    ld a,%01000101

    call Pinta_imagen

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

Restaura_attr_vida:

    call Calcula_direccion_atributos

    inc l

    ld a,l
    add $20
    ld l,a                                                          ; Dirección de attr de pantalla, (centro del escudo) donde se encuentra el icono de VIDA.

    ld a,%01000101                                                  ; Attr. de la vida.
    ld (hl),a

    ret

; ------------------------------------------------------------------------
;
;	19/7/25
;
;	Pinta_imagen.
;
;	Pinta cualquier imagen en pantalla sin máscara. Esta rutina se utiliza para imágenes estáticas, (NO SPRITES).
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
    pop de                        ; 1er .db IYL
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


 ;   jr $

    ld (Stack),sp
 
    ex de,hl                            ; HL se encuentra en el álbum de líneas.
;                                       ; DE se encuentra en los datos del sprite.
    inc l
    inc l

    ld b,(hl)                           ; B contiene el nº de scanlines a imprimir.

    inc b
    dec b
    jr nz,13F

    ld sp,(Stack)
    ret

13 inc l
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
