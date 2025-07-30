; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	28/7/25
;
;   (Scanlines_album_SP) se sitúa inicialmente al comienzo de Scanlines_album.
;   DE contiene Puntero_objeto.
;   IX contiene el Puntero de impresión.

Genera_datos_de_impresion:

;   En 1er lugar analizamos la posición del (Puntero_de_impresion).
;   No se han de generar scanlines cuando la entidad se imprima en zona de ROM o completamente en zona de MARCADOR de pantalla, (3 primeras líneas).
;   Cuando el (Puntero_de_impresion) se genera en la 2ª o 3ª línea de pantalla hay que calcular el nº de scanlines que pintamos del Sprite. Como el Sprite está apareciendo_
;   _ por la parte alta de la pantalla hay que sitúar (Puntero_objeto) en la línea de datos correspondiente.

    push ix
    pop hl                                          ; (Puntero_de_impresion) en HL.

    ld a,h
    cp $40
    jr c,Zona_ROM                                   ; La entidad se comienza a pintar en la ROM. No se generarán scanlines.

;   El objeto se imprime dentro de la pantalla, (NO ROM).

    call calcula_tercio                             ; HL contiene (Puntero_de_impresion).
    and a
    jr nz,Posiblemente_completo

;   La entidad se imprime en el 1er tercio de la pantalla. "0" scans. si (Puntero_de_impresion) se encuentra en la 1ª Fila de la pantalla.

    ld a,l
    cp $20
    jr c,Zona_ROM                                   ; Empezamos a generar scanlines a partir del segundo scanline de la 2ª fila de pantalla. (En la dirección $4120 se generaría 1 scan.).

    ld a,l
    cp $60
    jr nc,Posiblemente_completo

; La entidad no se imprimirá entera. Va a ir apareciendo por la parte baja del marcador.
; Calculamos el nº de scanlines que vamos a imprimir.
; (Puntero_de_impresion) se encuentra en la 2ª o 3ª Fila de la pantalla.

    ld a,h
    sub $40
    ld b,a                                          ; Nº de scanlines en B.

    ld a,l
    add $40
    ld l,a

    cp $80
    jr c,Modifica_puntero_objeto

    ld a,8
    add b
    ld b,a

Modifica_puntero_objeto jr Posiblemente_completo

; Salimos si no hay scanlines que imprimir.

;    inc b
;    dec b
;    jr z,Cero_scans

;    ld h,$40                                       ; (Puntero_de_impresion) en HL.

;    di
;    jr $
;    ei

; -------------------------------------------------------------------

Zona_ROM

;   No se generarán scanlines. B="0", generamos cabecera, actualizamos (Scanlines_album_SP) y RET.

    ld b,0
    ld c,b                                          ; Cuando no se generan scans., BC siempre será "0".

    call Genera_cabecera

    ret
; -------------------------------------------------------------------

;   IX y HL contienen (Puntero_de_impresion). DE contiene (Puntero_objeto).

Posiblemente_completo

    call Calcula_numero_de_scans
    call Genera_cabecera

;   En este punto HL contiene (Scanlines_album_SP) y DE (Puntero_objeto).

    ex de,hl

    push ix
    pop hl                                          ; (Puntero_de_impresion) en HL.

    dec b
    jr nz,Genera_scanlines

    inc b                                           ; El nº de scanlines no puede ser "0".

Genera_scanlines:

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

    ret

; ------------------------------------------------------------------------------------
;
;   28/7/25
;

Genera_cabecera:

;   Genera cabecera, y actualiza (Scanlines_album_SP) situándolo en el movimiento de la siguiente entidad.
;   BC contendrá el nº de scanlines que vamos a imprimir.

    ld (Stack),sp                                   ; Guardo SP en (Stack).

    ld hl,(Scanlines_album_SP)

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
;   30/7/25
;
;   Calcula el nº de scanlines que vamos a generar, (cuando la entidad no está apareciendo).
;
;   INPUTS: IX y HL contienen (Puntero_de_impresion).
;           DE contiene (Puntero_objeto).
;
;   OUTPUTS: BC contiene nº de scanlines a generar.
;
;   MODIFICA: A,HL y BC.

Calcula_numero_de_scans

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

;   Situación: Último tercio de pantalla, (del 2º scan. en adelante de la Fila).

2 ld a,l
    cp $c0
    jr nc,Calcula_scans_desapareciendo              ; En las 2 últimas líneas el Sprite sólo se imprime completo cuando el primer scanline está en una dirección $50xx.


;   Entidad completa. Se generan 16 scanlines para imprimir.

1 ld b,16

    ret

Calcula_scans_desapareciendo

    ld a,$57
    sub h
    ld b,a

    inc b

    ld a,$e0
    cp l

    ret c

    ld a,b
    add 8
    ld b,a

    ret
