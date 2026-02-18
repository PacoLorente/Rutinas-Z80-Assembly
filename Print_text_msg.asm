; ----------------------------------------------------------
;
;   18/2/26
;
;   INPUTS: HL apunta al mensage a imprimir, (msg).
;           DE indica la fila de pantalla donde queremos imprimir el msg.
;            C contiene los attrs. del msg.
;
;           % FBPPPIII

Print_text_msg:

    push hl

    ld b,8

;   Find char. data.

Find_address


    ld bc,ROM_ASCII

    ld l,(hl)
    ld h,0

    add hl,hl
    add hl,hl
    add hl,hl                               ;   ASCII * 8

    add hl,bc

    ex de,hl                                ;   BIN en DE - Fila en HL.

    push hl

    ld b,8
    ld c,a

Print_BIN

    ld a,(de)
    ld (hl),a                               ;   Print

    inc h                                   ;   INC scanline.
    inc e                                   ;   INC data address

    djnz Print_BIN

    pop hl

    call Calcula_direccion_atributos

    ld (hl),c

    jr $


    ret
