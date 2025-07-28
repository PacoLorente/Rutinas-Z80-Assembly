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

Modifica_puntero_objeto jr $

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


;   IX y HL contienen (Puntero_de_impresion). DE contiene (Puntero_objeto).

Posiblemente_completo

    call Calcula_numero_de_scans
    call Genera_cabecera

    jr $

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

;   Vamos a guardar esta dirección de VRAM por si hay que generar un disparo, así no habra que hacer_
;   _ 16 o 17 llamadas a Nextscan. Una entidad con "permiso de disparo" siempre utiliza esta rutina para_
;   _ generar sus scanlines.

;    ld (Puntero_de_impresion_disparo),de

    ld (hl),e
    inc hl
    ld (hl),d
    inc hl

; Todos los scanlines generados. actualizamos el puntero (Scanlines_album_SP).

    ld (Scanlines_album_SP),hl

    ex de,hl

; El disparo aparecerá dos líneas por debajo de la entidad.

;    call NextScan
;    call NextScan

    ld (Puntero_de_impresion_disparo_de_entidad),hl

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
;   28/7/25
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

    ld a,h
    cp $50
    jr c,1F                                         ; No hemos llegado a la parte baja de la pantalla. Nos encontramos en el 1er o 2º tercio de la pantalla.

    jr nz,2F

    ld a,l
    cp $e0
    jr c,1F                                         ; El 1er scanline está en una dirección $50xx. Si estamos en la FILA $C0-$DF, podemos imprimir todos los scanlines del sprite.

2 ld a,l
    cp $c0
    jr nc,Calcula_scans_lentos                      ; En las 2 últimas líneas el Sprite sólo se imprime completo cuando el primer scanline está en una dirección $50xx.

1 ld b,16
    ld c,0
    ret

Calcula_scans_lentos

    ld a,$57
    sub h
    ld b,a

    ld a,$df
    cp l
    ret c

    ld a,b
    add 8
    ld b,a
    ld c,0

    ret
