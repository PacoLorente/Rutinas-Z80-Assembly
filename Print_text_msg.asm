; ----------------------------------------------------------
;
;   19/2/26
;
Show_controls_keys:

	ld hl,a0                                                ; "Press   or   to move"
    ld de,Line_9 + 6
    ld a,%01000111                                          ; attrs.

    call Print_text_msg

; LEFT

    inc e

    ld hl,Move_LEFT_ASCII_CODE

    call Comprueba_SPACE_o_ENTER





    ld a,%01110000                                          ; attrs.

    call Print_text_msg

;;    ld hl,a2                                                ; "Press   to FIRE and"
;;    ld de,Line_13 + 6
;;    ld a,%01000111                                          ; attrs.

;;    call Print_text_msg

;;    ld hl,a3                                                ; "to SHIELD."
;;    ld de,Line_15 + 12
;;    ld a,%01000111                                          ; attrs.

;;    call Print_text_msg

;;    ld hl,a4                                                ; "FIRE to START"
;;    ld de,Line_22 + 10
;;    ld a,%11110000                                          ; attrs.

;;    call Print_text_msg


;    ld hl,a5                                                ; Mensaje vacío, (lo utilizamos para borrae BEST SCORE).
;    ld de,Line_19+9
;    ld a,%00000000

;    call Print_text_msg

    jr $
















	ret

Comprueba_SPACE_o_ENTER:

    jr $

    ld a,(hl)



    ret










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
