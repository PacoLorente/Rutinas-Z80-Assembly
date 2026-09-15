; ******************************************* Indica el tercio de pantalla en el que nos encontramos según el valor del registro H ********************************************************
; 
;   NOTA: Entrega "0", "1" o "2" en A en función del tercio en el que nos encontremos.
;
; *****************************************************************************************************************************************************************************************
; 010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  

calcula_tercio:

    ld a,h
    and $18
    sra a
    sra a
    sra a

    ret

; -----------------------------------------------------------------------------------------
;
;   04/11/22
;
;   Entrega una dirección de ATRIBUTOS de pantalla en HL a partir de una dirección de pantalla, dada en HL.
;
;   INPUT: HL contiene la dirección de memoria de pantalla.
;   OUTPUT: HL contiene la dirección de ATRIBUTOS de pantalla de la dirección que contenía HL.
;
;   DESTRUYE: HL y A. !!!!! 

Calcula_direccion_atributos:

    call calcula_tercio

    ld h,$58
    add h
    ld h,a

    ret

; ---------------------------------------------------
;
;   15/9/26
;
;   Limpia la memoria de pantalla. Clean screen.
;
;   INPUT: (A) contiene attrs de pantalla.
;
;   MODIFY: HL,DE y BC.
;
;   El formato: FBPPPIII (Flash, Brillo, Papel, Tinta).
;
;   COLORES: 0 ..... NEGRO
;            1 ..... AZUL    
;            2 ..... ROJO
;            3 ..... MAGENTA
;            4 ..... VERDE
;            5 ..... CIAN
;            6 ..... AMARILLO
;            7 ..... BLANCO

Cls:

    ld hl,$4000                                         ; HL => Comienzo de pantalla.
    ld de,$4001
    ld bc,6144                                          ; Tamaño de la pantalla, $17ff
    ld (hl),0                                           ; Ponemos a "0" todos los pixels de la pantalla.
    ldir

;   Attrs.

    ld bc,767
    ld (hl),a                                           ; Atributos de pantalla, % 00 xxx xxx en [A].
    ldir

    xor a

    ret

;----------------------------------------------------------------------------------------------------------------
;
;	5/08/22
;
;   NextScan. 
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el siguiente scanline. (Inc H, línea abajo).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el siguiente scanline.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

NextScan:

	inc h          							        ; Incrementamos el scanline.
    ld a,h
    and 7
    ret nz              							; Salimos de la rutina si el scanline se encuentra entre (1-7).

	ld a,l              							; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           							; Vamos a comprobarlo...
    ld l,a
    ret c               							; Salimos si se produce el cambio de tercio.

    ld a,h              							; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               							; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a
    ret

NextScan_15:

	ld b,15
1 call NextScan
	djnz 1B

	ret

;----------------------------------------------------------------------------------------------------------------     
;
;	5/08/22
;
;   PreviousScan.
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el scanline anterior. (Dec H, línea arriba).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el scanline anterior.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

PreviousScan:

	ld a,h
    dec h               							; Dec H.
    and 7
    ret nz              							; Salimos de la rutina si el scanline se encuentra entre (1-7).

    ld a,l              							; Estabamos en el scanline "0" y al decrementar nos situamos en el "7" y cambiamos de tercio.
    sub $20             							; Vamos a comprobarlo...
    ld l,a
    ret c               							; Salimos si estábamos en la primera línea y se produce el cambio de tercio.

    ld a,h              							; No estamos en la primera línea del tercio, por lo que inicializamos H sumando una_
    add a,8             							; _unidad a los bits que definen el tercio TT, (add a,$08).
    ld h,a
    ret

PreviousScan_15:

	ld b,15
1 call PreviousScan
	djnz 1B

	ret

; -----------------------------------------------------------------
;
;	4/4/25
;
;	Limpia un espacio de la memoria.
;
;	INPUTS:  HL apunta al 1er byte del espacio de memoria que queremos limpiar.
;				   BC indica el nº de bytes que vamos a poner a "0".
;
;	MODIFY: HL,DE,BC

Clean_mem:

	ld (hl),0

	push hl
	pop de

	inc de

	ldir

	ret

; ------------------------------------------------------------------------
;
;   7/6/26
;
;   Pinta_imagen.
;
;   Pinta cualquier imagen en pantalla, (XOR). Esta rutina se utiliza para imágenes estáticas, (NO SPRITES).
;
;   INPUTS: HL contiene la dirección de memoria depantalla donde queremos imprimir la imagen, (esquina superior izquierda).
;           DE contiene la dirección del 1er .db que conforman los datos de la imagen.
;            A contiene los Attr.
;            B contiene el nº de Columnas.
;            C contiene el nº de Filas.
;
;   MODIFICA: AF,HL,DE y BC.

;   Notas:  Utiliza esta rutina para ir borrando vidas. Por eso utilizamos la función XOR.

;   6643, 6683, 6516, 6659, 6516  t/states. ..... 6603 t/states.


Pinta_imagen:

    push hl
    push bc

;   Fija attrs.

    ex af,af                                                        ; Salvo Attrs. [Calcula_direccion_atributos] destruye A.
    call Calcula_direccion_atributos
    ex af,af

;   Dirección de attrs. en (HL), char. arriba-izq.

    call Fija_attrs

    pop bc
    pop hl 

    call Imprime_imagen

    ret

; -----------------------------------------------------------------
;
;   15/9/26
;
;   Fija los atributos de una imagen en pantalla, (NO SPRITES).
;
;   INPUTS: (HL) contiene la dirección de attrs. del 1er char. de la imagen, (arriba-izq).
;            (A) contiene los atributos.
;            (B) contiene el nº de Columnas.
;            (C) contiene el nº de Filas.
;
;   MODIFY: (HL), contendrá la dirección de attrs. del último char. de la imagen, (abajo-izq) + 1
;            (C), contiene "0".
;

Fija_attrs:

    push bc

1 ld (hl),a
    inc l
    djnz 1B                                                         ; (B) contiene las columnas que tiene la imagen.

    pop bc

    dec c                                                           ; Decrementa Filas. RET si (Filas)="0".
    ret z

; Next attrs. file.

    ex af,af

    ld a,l
    sub b
    ld l,a

    push bc

;   Sumamos con adc por si la imagen se encuentra situada entre dos tercios de pantalla.

    ld bc,$20
    and a
    adc hl,bc                                                       ; HL situado en la siguiente Fila.

    pop bc
                                                   
    ex af,af

    jr Fija_attrs

; ----------------------------------------------------------------
;
;   15/9/26
;
;   Pinta cualquier imagen en pantalla, (XOR). Esta rutina se utiliza para imágenes estáticas, (NO SPRITES).
;
;   INPUTS: HL contiene la dirección de memoria depantalla donde queremos imprimir la imagen, (esquina superior izquierda).
;           DE contiene la dirección del 1er .db que conforman los datos de la imagen.
;            A contiene los Attr.
;            B contiene el nº de Columnas.
;            C contiene el nº de Filas.
;
;   MODIFICA: AF,HL,DE y BC.

;   Notas:  Utiliza esta rutina para ir borrando vidas. Por eso utilizamos la función XOR.

Imprime_imagen:

    ld a,8
    ex af,af                                                         ; (A´) contendrá el contador de scanlines que tiene un char.

1 push hl
    push bc

;   Generamos scanlines.

;   La secuencia es la siguiente:
;
;   Byte (XOR) del 1er char. de la imagen.
;   Byte (XOR) del 2º char. de la imagen.
;   Byte (XOR) del 3er char. de la imagen., etc.

;   Decrementa el contador de scanlines, (A´).

;   Nos situamos en el siguiente scan, (call NextScan).

;   Byte (XOR) del 1er char. de la imagen.
;   Byte (XOR) del 2º char. de la imagen.
;   Byte (XOR) del 3er char. de la imagen., etc.

;   Decrementa el contador de scanlines, (A´).

2 ld a,(de)
    xor (hl)
    ld (hl),a

    inc l
    inc de

    djnz 2B

    ex af,af
    dec a
    jr z,Next_file

    ex af,af

    pop bc
    pop hl

    call NextScan

    jr 1B

Next_file

    pop bc
    pop hl

    dec c
    ret z

    call NextScan

    jr Imprime_imagen