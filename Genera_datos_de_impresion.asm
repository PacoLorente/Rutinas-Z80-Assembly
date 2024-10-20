; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	11/03/24
;
;   (Scanlines_album_SP) se sitúa inicialmente al comienzo de Scanlines_album.
;   DE contiene Puntero_objeto.
;   IX contiene el Puntero de impresión.

Genera_datos_de_impresion 

    ld (Stack),sp                                 ; Guardo SP en (Stack).
    ld sp,Puntero_de_impresion+2                  ; Almacenamos el (Puntero_de_impresion) actual de la entidad.
    push ix                                       ; Utilizaremos este dato para generar las coordenadas_X que ocupa la entidad y compararlas_

    ld hl,(Scanlines_album_SP)

    ld a,5
    add l
    ld l,a

    ld sp,hl
    ld (Scanlines_album_SP),hl

    ld hl,0

    push ix
    dec sp
    adc hl,sp
    push de

; Recuperamos SP.

    ld sp,(Stack)

    push hl
    pop af
    ex af,af'                                       ; AF´ almacena la casilla donde vamos a almacenar el nº de scanlines que vamos a generar a continuación. 
    
; Tenemos el encabezado listo.
; Preparamos registros para generar los scanlines.

    push ix
    pop hl                                          ; 1er scanline en HL.

    ld de,(Scanlines_album_SP)

; Voy a utilizar 2 rutinas para generar las líneas. Una será rápida y otra lenta. La lenta sólo se empleará cuando el sprite esté desapareciendo o apareciendo_
; _por la parte baja de la pantalla, en este caso no se podrán imprimir las 16 líneas pues entramos en attr. mem. 

    ld a,h
    cp $50
    jr c,Genera_scanlines_rapidos                   ; No hemos llegado a la parte baja de la pantalla. 

    jr nz,2F

    ld a,l
    cp $e0
    jr c,Genera_scanlines_rapidos                   ; El 1er scanline está en una dirección $50xx. Si estamos en la FILA $C0-$DF, podemos imprimir todos los scanlines del sprite.

2 ld a,l
    cp $c0
    jp nc,Genera_scanlines_lentos                   ; En las 2 últimas líneas el Sprite sólo se imprime completo cuando el primer scanline está en una dirección $50xx.

Genera_scanlines_rapidos ; -------------------------------------------------------------------------------------------------------------------------------------

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    
    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    
    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    
    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    
    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    
    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    
    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    
    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl

    call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

; Todos los scanlines generados. actualizamos el puntero (Scanlines_album_SP).

    ld (Scanlines_album_SP),hl

; Completamos la casilla pendiente, (define el nº total de scanlines). 

    ex af,af

    push af
    pop hl

    ld (hl),16

    ret

Genera_scanlines_lentos ; -------------------------------------------------------------------------------------------------------------------------------------

; En 1er lugar calculamos el nº de scanlines que podemos imprimir.

    ld a,$57
    sub h
    ld b,a

    ld a,$df
    cp l 
    jr c,1F 

    ld a,8
    add b
    ld b,a

; Tenemos en el registro B el nº de scanlines que podemos imprimir del sprite. 
; Generamos scanlines de objeto que desaparece por la parte baja de la pantalla.

1 ld c,b
    inc c

    inc b
    dec b
    jr nz,3F

    jr 6F

3 call NextScan
    ex de,hl

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

    ex de,hl
    djnz 3B

6 ld (Scanlines_album_SP),de

5 ex af,af
    push af
    pop hl    

    ld (hl),c

    ret

