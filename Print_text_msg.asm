; ----------------------------------------------------------
;
;   19/2/26
;

Show_controls_keys:

;   Hay que corregir la posición donde escribiremos la primera línea de texto si hemos definido "SPACE" o "Enter"_
;   _como alguna de las teclas de movimiento de Amadeus

    ld hl,Move_LEFT_ASCII_CODE
    ld de,Line_9 + 6                                        ; Posición de inicio de línea.

    call Corrige_inicio_de_linea

    inc hl
    inc hl                                                  ; HL ahora apunta a Move_LEFT_ASCII_CODE

    call Corrige_inicio_de_linea

    ld hl,a0                                                ; "Press ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg
    inc e

;   Next msn

    ld hl,Move_LEFT_ASCII_CODE                              ; Move_LEFT_ASCII_CODE -----
    call Print_ctrl_key
    inc e

;   Next msn

    ld hl,a1                                                ; "or ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg
    inc e

;   Next msn

    ld hl,Move_RIGHT_ASCII_CODE                             ; Move_RIGHT_ASCII_CODE -----
    call Print_ctrl_key
    inc e

;   Next msn

    ld hl,a2                                                ; " to move ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg
    inc e

;   Next msn

    ld hl,a3                                                ; "or ".
    ld de,Line_11 + 8
    ld a,%01000111                                          ; attrs.
    call Print_text_msg
    inc e


;;    ld hl,a2                                              ; "Press   to FIRE and"
;;    ld de,Line_13 + 6
;;    ld a,%01000111                                        ; attrs.

;;    call Print_text_msg

;;    ld hl,a3                                              ; "to SHIELD."
;;    ld de,Line_15 + 12
;;    ld a,%01000111                                        ; attrs.

;;    call Print_text_msg

;;    ld hl,a4                                              ; "FIRE to START"
;;    ld de,Line_22 + 10
;;    ld a,%11110000                                        ; attrs.

;;    call Print_text_msg


;    ld hl,a5                                               ; Mensaje vacío, (lo utilizamos para borrae BEST SCORE).
;    ld de,Line_19+9
;    ld a,%00000000

;    call Print_text_msg

    jr $

	ret

; ----------------------------------------------------------
;
;   28/2/26
;

Corrige_inicio_de_linea

;  Comprueba Move_LEFT_ASCII_CODE:

    ld a,$20                                                ; "SPACE" ascii code.
    cp (hl)
    jr z,Retrocede_carro

    ld a,$0d                                                ; "ENTER" ascii code.
    cp (hl)
    jr z,Retrocede_carro

    ret

; --------------------------------

Retrocede_carro

    dec e
    dec e

    ret

; -----------------------------------------------

Print_ctrl_key:

    ld a,(hl)
    cp $0d                                                  ; ENTER ascii code.
    jr z,Enter_ascii_code
    cp $20
    jr z,SPACE_ascii_code                                   ; SPACE ascii code.

1 ld a,%01110000                                            ; attrs.
    call Print_text_msg

    ret

Enter_ascii_code

    ld hl,Enter_key
    jr 1B

SPACE_ascii_code

    ld hl,Space_key
    jr 1B

; ----------------------------------------------------------
;
;   19/2/26
;

Print_Main_menu:

    ld hl,Keyboard                                          ; msg.
    ld de,Line_9 + 12                                       ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000110                                          ; attrs.

    push de
    call Print_text_msg
    pop hl

    ld b,%01101000
    call Modify_first_char_attr

    ld hl,Kempstom                                          ; msg.
    ld de,Line_11 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000110                                          ; attrs.

    push de
    call Print_text_msg
    pop hl

    inc l

    ld b,%01101000
    call Modify_first_char_attr

    ld hl,Define                                            ; msg.
    ld de,Line_13 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000110                                          ; attrs.

    push de
    call Print_text_msg
    pop hl

    ld b,%01101000
    call Modify_first_char_attr

    ld hl,Top_score                                         ; msg.
    ld de,Line_19 + 9                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000101                                          ; attrs.

    push de
    call Print_text_msg
    pop hl

    ret

; ----------------------------------------------------------
;
;   21/2/26
;

Print_DONE:

    ld hl,Done                                              ; msg.
    ld de,Line_11 + 14                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%11000100                                          ; attrs.

    push de
    call Print_text_msg
    pop hl

    ret

; ----------------------------------------------------------
;
;   21/2/26
;

Print_Game_Over:

    ld hl,Game_Over                                         ; msg.
    ld de,Line_11 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%11000011                                          ; attrs.

    push de
    call Print_text_msg
    pop hl

    ret

    ; ----------------------------------------------------------

Modify_first_char_attr call Calcula_direccion_atributos
    ld (hl),b
    ret

; ----------------------------------------------------------
;
;   18/2/26
;
;   INPUTS: HL apunta al mensage a imprimir, (msg).
;           DE indica la fila de pantalla donde queremos imprimir el msg.
;            A contiene los attrs. del msg.
;
;           % FBPPPIII

Print_text_msg:

    ex af,af                                ;   Attr. en A´.

    push hl
    push de

    call Find_address

    ex de,hl                                ;   BIN en DE - Fila en HL.

    call Print_BIN

    pop de
    pop hl

;   Suiguiente char.

    inc hl

    inc (hl)
    dec (hl)

    ret z                                   ;   RET, fin de msg.

    inc e

    jr Print_text_msg

;   Find char. data.

Find_address

    ld bc,ROM_ASCII

    ld l,(hl)
    ld h,0

    add hl,hl
    add hl,hl
    add hl,hl                               ;   ASCII * 8

    add hl,bc

    ret

Print_BIN

    ld b,8                                  ;   Nº de lineas que forman el caracter.

    push hl

1 ld a,(de)
    ld (hl),a                               ;   Print

    inc h                                   ;   INC scanline.
    inc e                                   ;   INC data address

    djnz 1B

    pop hl

    call Calcula_direccion_atributos

    ex af,af
    ld (hl),a

    ret
