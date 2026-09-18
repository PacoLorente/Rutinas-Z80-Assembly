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

; ----------------------------------------------------------
;
;   17/7/26
;
;   Asigna atributos de pantalla a un caracter en concreto.
;
;   INPUT: (HL) contiene la dirección de pantalla del caracter al que queremos asignar attrs.
;           (B) contiene los Attrs.
 
;   MODIFY: AF y H.

Modify_first_char_attr:

    call Calcula_direccion_atributos
    ld (hl),b

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

Down_File:

    push bc

    ld b,8
1 call NextScan
    djnz 1B

    pop bc

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

Up_File:

    push bc

    ld b,8
1 call PreviousScan
    djnz 1B

    pop bc

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
;   16/9/26
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
;   MODIFICA: AF, AF´, HL, DE y BC.

;   Notas:  Utiliza esta rutina para ir borrando vidas. Por eso utilizamos la función XOR.

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
;   16/9/26
;
;   Pinta cualquier imagen en pantalla, (XOR). Esta rutina se utiliza para imágenes estáticas, (NO SPRITES).
;
;   INPUTS: HL contiene la dirección de memoria depantalla donde queremos imprimir la imagen, (esquina superior izquierda).
;           DE contiene la dirección del 1er .db que conforman los datos de la imagen.
;            A contiene los Attr.
;            B contiene el nº de Columnas.
;            C contiene el nº de Filas.
;
;   MODIFICA: A,HL,DE y BC.

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

Next_file:

    pop bc
    pop hl

    dec c
    ret z

    call NextScan

    jr Imprime_imagen

; ----------------------------------------------------------
;
;   16/9/26
;
;   Imprime TEXTO usando el CHARSET de la ROM.
;
;   Si el registro (B) es distinto de "0", la rutina usará ese valor para TEMPORIZAR la impresión de caracteres,_
;   _como si fuera una máquina de escribir.

;   INPUTS: HL apunta al mensage a imprimir, (msg).
;           DE indica la fila de pantalla donde queremos imprimir el msg.
;            A contiene los attrs. del msg.
;            B Actúa como temporizador, ralentiza la impresión de caracteres, (simula una máquina de escribir).
;              No actua cuando su valor es "0".
;
;   MODIFY: HL y DE.

Print_text_msg:

    push bc                                 ;   PUSH temporizador.

    ex af,af                                ;   Attr. en A´.

    push hl
    push de

    call Find_address

    ex de,hl                                ;   BIN en DE - Fila en HL.

    call Print_BIN                          ;   Imprime caracter.

    call Calcula_direccion_atributos

    ex af,af
    ld (hl),a                               ;   Asigna attrs. al caracter impreso.

    pop de                                  ;   Fila de pantalla.
    pop hl                                  ;   Mensaje de texto.

;   Suiguiente char.

    inc hl                                  ;   Siguiente caracter a imprimir.

    inc (hl)
    dec (hl)

    jr z,Exit_01                            ;   RET, fin de msg.

    inc e                                   ;   Siguiente columna de pantalla.

    pop bc                                  ;   Carga el temporizador en B.

    inc b
    dec b

    jr z,Print_text_msg                     ;   Mensaje NO TEMPORIZADO. Siguiente char.

;  Temporización del caracter.

    ex af,af                                ;   attrs. del msg en AF´.

    ld a,r
    srl a

    bit 0,a
    jr z,3F

    ld b,90
    jr 1F

3 ld b,130

1 ld c,$ff

2 dec c
    jr nz,2B

    djnz 1B                                 ;   Aplica temporización.

    call BEEP

    ld b,1                                  ;   Activa retardo RND en el próximo char. a imprimir.

    ex af,af                                ;   Recupera attrs. en A.

    jr Print_text_msg


Exit_01:

    pop bc

    ret

; -----------------------------------------------------

;   Find char. data.
;
;   INPUT: (HL) contiene el código ASCII del char. a imprimir.
;
;   MODIFY: HL y BC.

;   OUTPUT: HL contendrá la dirección de memoria ROM donde se encuentran los 8 bytes que forman el caracter.


Find_address:

    ld bc,ROM_ASCII

    ld l,(hl)
    ld h,0                                  ;   Código ASCII del caracter a imprimir en HL.

    add hl,hl
    add hl,hl
    add hl,hl                               ;   ASCII * 8

    add hl,bc

    ret

Print_BIN:

    ld b,8                                  ;   Nº de lineas que forman el caracter.

    push hl

1 ld a,(de)
    ld (hl),a                               ;   Print

    inc h                                   ;   INC scanline.
    inc e                                   ;   INC data address

    djnz 1B

    pop hl

    ret

; ----------------------------------------------------------------------------------------------
;
;   17/9/26
;
;   Herramienta para construir melodías y ruido con el SPEAKER.

Sound_Generator:

;   INPUTS: C contiene el nº de veces que vamos a generar la onda del sonido.
;           D Indica si el sonido es ascendente, "1" o descendente, "0".
;           E Indica el nº de incrementos/decrementos que sumeremos/restaremos al delay inicial.
;           B = "1". Indica que vamos a generar un efecto de ruido, (pseudo RND).
;        (HL) = Contiene el sonido, (duración del semiciclo), NOTA.
;

;   MODIFY: A,HL,BC y DE.

;   Exclusión:

    ld hl,(Sound)
    ld a,h
    or l
    ret z                   ; Salimos de la rutina si no hay sonido a ejecutar.

    inc b
    dec b
    jr nz,Noise_efect

Loop_2

;   %xxxabccc

;   %a ... Salida SPEAKER.
;   %b ... MIC/EAR.
;   %c ... BORDER Colour.


    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Semiciclo POSITIVO de la onda, BEEPER ON.

Delay_5 

    dec hl                  ; 26 tstates mide el bucle Delay_5
    ld a,h
    or l
    jr nz,Delay_5

    ld hl,(Sound)           ; Recupera duración del semiciclo, 16 tstates.

    xor a                   ; Borde negro.    ---     4 tstates
    out ($fe),a             ; Semiciclo NEGATIVO de la onda, BEEPER OFF.

Delay_6 

    dec hl
    ld a,h
    or l
    jr nz,Delay_6

; Hemos generado una onda sonora.
; Averiguamos si existe incremento/decremento del delay; (variación del tono).

    ld hl,(Sound)

    inc e
    dec e
    jr z,1F                 ; E Indica el nº de incrementos/decrementos que sumeremos/restaremos al delay inicial.
;                           ; (E)="0" indica que no hay variación en el tono.

    ld b,e                  ; (B) contiene ahora el nº de incrementos/decrementos.
    ld a,d                  ; (A) contiene ahora "1", si el sonido es ascendente y "0" si es descendente. 

; Rayo de entrada o de salida ???

    and a 
    jr nz,Incrementa_delay

Decrementa_delay

    dec hl
    djnz Decrementa_delay

    jr 1F

Incrementa_delay

    inc hl
    djnz Incrementa_delay

; Descontamos la onda generada del total de ondas que tiene el efecto, (Sound).

1 dec c                     ; Decrementa nº de ondas.

    ld (Sound),hl

    jr nz,Loop_2

    ret

;   Efecto de ruido, se puede utilizar, (entre otras cosas) para generar explosiones, disparos, etc.
;   Este tipo de onda NO ES SIMÉTRICA, el semiciclo positivo y el negativo tienen una duración distinta. 
;   Cada onda completa que compone el sonido es distinta a la anterior siendo el registro (C) el que contiene el_
;   _nº de ondas que vamos a ejecutar.
;   El registro R proporciona el nº pseudo aleatorio que construye los dos semiciclos de la onda.

Noise_efect:

Loop

    ld a,r
    ld b,a                  ; (B) contiene un nº pseudo aleatorio ($00 - $ff).

    ld a,%00010000          ; Borde negro.
    out ($fe),a             ; Semiciclo POSITIVO de la onda, BEEPER ON.

Delay_1 djnz Delay_1        ; Aplica Delay.

    xor a
    out ($fe),a             ; Semiciclo NEGATIVO de la onda, BEEPER OFF.    

    ld a,r
    ld b,a                  ; (B) contiene un nº pseudo aleatorio ($00 - $ff).

Delay_2 djnz Delay_2        ; Aplica Delay.

    dec h

    dec c                   ; Decrementa ondas completas generadas.

    jr nz,Loop

    ld (Sound),hl

    ret