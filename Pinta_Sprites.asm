; -----------------------------------------------------------------------------
;
;   1/4/25
;
;   INPUT: A contiene (Columnas).
;          C contiene (Attr).

Pinta_Sprites

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