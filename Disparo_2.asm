; -------------------------------------------------------------------------------------------------------------
;
;   04/12/23
;   
;   La entidad se encuentra en la fila $14,$15 o $16 de pantalla.
;   Vamos a comprobar si la entidad ocupa alguna de las columnas ocupadas por Amadeus y por lo_
;   _ tanto, existe riesgo alto de colisión entre ambas. 
;
;   MODIFICA: HL,DE,B y A.

Genera_coordenadas_X

;   Guardamos las coordenadas_X de la entidad y Amadeus en sus correspondientes almacenes.
;   DRAW tiene almacenados, en este momento, los datos de la última ENTIDAD que hemos desplazado.

    di
    jr $
    ei
    
;   Limpiamos almacenes.

    call Limpia_Coordenadas_X

;   Almacenamos coordenadas X.

;   Almacenamos las coordenadas X de la entidad peligrosa, (en curso).

    ld hl,(Puntero_de_impresion)
    ld de,Coordenadas_X_Entidad
    ld b,2

    ld a,(CTRL_DESPLZ)
    and a
    jr z,1F
    inc b

1 call Guarda_coordenadas_X

;   Almacenamos las coordenadas X de Amadeus.

    ld hl,(p.imp.amadeus)
    ld de,Coordenadas_X_Amadeus
    ld b,2

;    ld a,(ctrl_desplz_amadeus)
    and a
    jr z,2F
    inc b

2 call Guarda_coordenadas_X

;   Comparamos las coordenadas X de la entidad en curso con las de Amadeus.

    ret

; ----- ----- ----- ----- -----

Guarda_coordenadas_X  ld a,l
    and $1f
1 ld (de),a
    inc a
    inc de
    djnz 1B
    ret

Limpia_Coordenadas_X xor a
    ld b,6
    ld hl,Coordenadas_X_Amadeus
1 ld (hl),a
    inc hl
    djnz 1B
    ret

; ----- ----- ----- ----- -----

Compara_coordenadas_X 

    ld b,3
    ld de,Coordenadas_X_Entidad+2

    ld a,(de)
    and a
    jr nz,2F
    dec b

2 dec de
    dec de
    ld hl,Coordenadas_X_Amadeus

1 push de
    push hl
    push bc

    call Comparando

    pop bc
    pop hl
    pop de

    inc de
    djnz 1B
    
    ret

; ----- ----- ----- ----- -----
;
;   4/12/23
;
;   Sub. de [Compara_coordenadas_X]. Deja de comparar cuando encuentra coincidencia.

Comparando ld b,3
    ld a,(de)
2 ld c,(hl)
    cp c
    jr z,1F
    inc hl
    djnz 2B
    ret

1 ld a,1                                                ; El .db (Impacto)="1" indica que es altamente probable que esta_
    ld (Impacto),a                                      ; _ entidad colisione con Amadeus, (ha superado, o está en la fila $14) y 
    ld hl,Impacto2                                      ; _ alguna de las columnas_X que ocupa coinciden con las de Amadeus.
    set 2,(hl)
    ret
