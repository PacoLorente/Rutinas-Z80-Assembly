; ----------------------------------------------------------
;
;   10/3/26
;

Define_menu:

;   Borramos el menú principal.

    call Clean_main_menu

;   Imprime DEFINE MENU:

;   Title.

    ld hl,b0                                                ; "DEFINE CONTROLS KEYS:".
    ld de,Line_8 + 9
    ld a,%01000110                                          ; attrs. Yellow ink.
    call Print_text_msg

;   LEFT. -----------------------------------------------------------------------------------------------------------------

    ld hl,b1                                                ; "LEFT".
    ld de,Line_12 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga la tecla "D".

    ld bc,$ffff
    call DELAY
    ld bc,$2fff
    call DELAY

    push de                                                 ; Guardo la posición del carro de impresión.

    ld hl,Move_LEFT
    ld de,Move_LEFT_ASCII_CODE
    call Define_key                                         ; Almacena Key_code y ASCII_codeen sus respectivas variables.

    ld hl,No_repeat_key_code
    inc (hl)

    ld hl,Line_12+12
    ld b,4
    call Modifica_atributos                                 ; Cambia atributos de la función a definir, NO FLASH.

; Imprime tecla pulsada, (LEFT).

    ld hl,Move_LEFT_ASCII_CODE
    pop de                                                  ; Recupera posición del carro de impresión.

    inc e
    inc e
    inc e
    inc e

    ld a,%01101000
    call Print_text_msg

;   RIGHT. -----------------------------------------------------------------------------------------------------------------

    ld hl,b2                                                ; "RIGHT".
    ld de,Line_14 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga (Move LEFT).

    ld bc,$ffff
    call DELAY
    ld bc,$2fff
    call DELAY

    push de                                                 ; Guardo la posición del carro de impresión.

    ld hl,Move_RIGHT
    ld de,Move_RIGHT_ASCII_CODE
    call Define_key                                         ; Almacena Key_code y ASCII_codeen sus respectivas variables.

    ld hl,No_repeat_key_code
    inc (hl)

    ld hl,Line_14+12
    ld b,5
    call Modifica_atributos                                 ; Cambia atributos de la función a definir, NO FLASH.

; Imprime tecla pulsada, (RIGHT).

    ld hl,Move_RIGHT_ASCII_CODE
    pop de                                                  ; Recupera posición del carro de impresión.

    inc e
    inc e
    inc e

    ld a,%01101000
    call Print_text_msg

;   FIRE. -----------------------------------------------------------------------------------------------------------------

    ld hl,b3                                                ; "FIRE".
    ld de,Line_16 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga (Move_RIGHT).

    ld bc,$ffff
    call DELAY
    ld bc,$2fff
    call DELAY

    push de                                                 ; Guardo la posición del carro de impresión.

    ld hl,Move_FIRE
    ld de,Move_FIRE_ASCII_CODE
    call Define_key                                         ; Almacena Key_code y ASCII_codeen sus respectivas variables.

    ld hl,No_repeat_key_code
    inc (hl)

    ld hl,Line_16+12
    ld b,4
    call Modifica_atributos                                 ; Cambia atributos de la función a definir, NO FLASH.

; Imprime tecla pulsada, (FIRE).

    ld hl,Move_FIRE_ASCII_CODE
    pop de                                                  ; Recupera posición del carro de impresión.

    inc e
    inc e
    inc e
    inc e

    ld a,%01101000
    call Print_text_msg

;   SHIELD. -----------------------------------------------------------------------------------------------------------------

    ld hl,b4                                                ; "SHIELD".
    ld de,Line_18 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga (Move_FIRE).

    ld bc,$ffff
    call DELAY
    ld bc,$2fff
    call DELAY

    push de                                                 ; Guardo la posición del carro de impresión.

    ld hl,Move_SHIELD
    ld de,Move_SHIELD_ASCII_CODE
    call Define_key                                         ; Almacena Key_code y ASCII_codeen sus respectivas variables.

    ld hl,Line_18+12
    ld b,6
    call Modifica_atributos                                 ; Cambia atributos de la función a definir, NO FLASH.

; Imprime tecla pulsada, (FIRE).

    ld hl,Move_SHIELD_ASCII_CODE
    pop de                                                  ; Recupera posición del carro de impresión.

    inc e
    inc e

    ld a,%01101000
    call Print_text_msg

; Teclas definidas.

    ld bc,$ffff
    call DELAY
    ld bc,$ffff
    call DELAY                                              
    ld bc,$ffff
    call DELAY
    ld bc,$ffff
    call DELAY                                              ; DELAY before exit to Main menu.
    ld bc,$ffff
    call DELAY
    ld bc,$ffff
    call DELAY                                              ; DELAY before exit to Main menu.

; Clean Define menu.

    call Clean_Define_menu

    ld hl,Ctrl_6
    set 1,(hl)                                              ; Bit 1 "1", means: Return to Main menu.

    xor a

    ret

; ----------------------------------------------------------
;
;   11/3/26
;
;   INPUTS: HL apunta a la variable que almacenará el correspondiente (KEY_CODE), ej: Move_LEFT.
;           DE apunta a la variable que almacenará el correspondiente (ASCII_CODE), ej: Move_LEFT_ASCII_CODE.


Define_key:

    push hl
    push de

3 call ROM_Key_Scan                                         ; Scan keyboard.

;   Guarda el correspondiente KEY CODE / KEY ASCII CODE.

;    ld a,e                                                  ; Key code en A.

;   Hay que evitar que se "defina" la misma tecla para realizar distintas funciones.

    ld a,(No_repeat_key_code)
    and a
    jr z,2F                                                 ; (A)="0" Indica que estamos definiendo Move_LEFT.

    ld b,a                                                  ; B contiene el nº de teclas definidas-1. 

    ld hl,Move_LEFT
    ld a,(hl)                                               ; KEY_CODE de Move_LEFT en A.
    cp e                                                    ; Comparo con el Key_code recién adquirido.
    jr z,3B                                                 ; Esta tecla ya se definió anteriormente. Volvemos a escanear el teclado.

    jr $

2 ld a,e                                                    ; KEY_code en A.

    pop de
    pop hl

    ld (hl),a                                               ; Key_code almacenado.

;   Special Key_code ???

    cp $18
    jr z,Print_SYMB
    cp $20
    jr z,Print_SPACE
    cp $21
    jr z,Print_ENTER
    cp $27
    jr z,Print_CAPS

;   No special key_code.

;   Seleccionamos el ASCII_code correspondiente y lo almacenamos.

    ld c,a
    ld b,0

    ld hl,Tabla_de_conversion_KEYCODE_ASCII_CODE

    add hl,bc

    ld b,4                                                  ; Contador de "0" para limpiar .db después de almacenar el ASCII_code.

    ld a,(hl)                                               
1 ld (de),a                                                 ; ASCII_code almacenado. 
    xor a                                                   ; Ahora almacenamos "0"´s.    
    inc de
    djnz 1B 

    ret

Print_SYMB

    ld hl,Symbol_key
    call Get_ascii_message
    ret z

Print_SPACE

    ld hl,Space_key
    call Get_ascii_message
    ret z

Print_ENTER

    ld hl,Enter_key
    call Get_ascii_message
    ret z

Print_CAPS

    ld hl,Caps_key
    call Get_ascii_message
    ret z

Get_ascii_message:

    ld a,(hl)
    ld (de),a

    and a
    ret z

    inc hl
    inc de

    jr Get_ascii_message

; Modifica attrs. de left. NO FLASH NOW. Key pressed.

Modifica_atributos:

    call Calcula_direccion_atributos
    ld a,%01000111

1 ld (hl),a
    inc l
    djnz 1B

    ret

; ----------------------------------------------------------
;
;   10/3/26
;

Show_controls_keys:

;   Hay que corregir la posición donde escribiremos la primera línea de texto si hemos definido "SPACE" o "Enter"_
;   _como alguna de las teclas de movimiento de Amadeus

;   Borramos el menú principal.

    call Clean_main_menu

;   Imprimimos CONTROLES.

    ld hl,a7                                                ; "Controls:".
    ld de,Line_8 + 12
    ld a,%01000110                                          ; attrs.
    call Print_text_msg                                     ; Print "Controls:".

    ld hl,Move_LEFT
    ld de,Line_12 + 6                                       ; Posición de inicio de línea.

    call Corrige_inicio_de_linea

    inc hl                                                  

    call Corrige_inicio_de_linea                            ; Hemos corregido el carro de impresión, (si hemos pulsado teclas especiales).

    ld hl,a0                                                ; "Press ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg                                     ; Print "Press ".

    inc e

;   Next msn

    ld hl,Move_LEFT_ASCII_CODE                              ; Move_LEFT_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (LEFT_ASCII_CODE).

    inc e

;   Next msn

    ld hl,a1                                                ; "or ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg                                     ; Print "or ".

    inc e

;   Next msn

    ld hl,Move_RIGHT_ASCII_CODE                             ; Move_RIGHT_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (RIGHT_ASCII_CODE).

    inc e

;   Next msn

    ld hl,a2                                                ; " to move ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg                                     ; Print " to move".

    inc e

;   Next msn

    ld hl,a3                                                ; " LEFT and RIGHT.".
    ld de,Line_14 + 8
    ld a,%01000111                                          ; attrs.
    call Print_text_msg                                     ; Print " LEFT and RIGHT.".

    inc e

;   Hay que corregir la posición donde escribiremos la tercera línea de texto si hemos definido "SPACE" o "Enter"_
;   _como alguna de las teclas de disparo o shield.

    ld hl,Move_FIRE
    ld de,Line_16 + 6                                       ; Posición de inicio de línea.

    call Corrige_inicio_de_linea

    inc hl
                                                    
    call Corrige_inicio_de_linea                            ; Hemos corregido el carro de impresión, (si hemos pulsado teclas especiales). 

;   Next msn

    ld hl,a0                                                ; "Press ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg

    inc e                                                   ; Print "Press ".

;   Next msn

    ld hl,Move_FIRE_ASCII_CODE                              ; Move_FIRE_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (FIRE_ASCII_CODE).

    inc e

;   Next msn

    ld hl,a4                                                ; " to FIRE and ".
    ld a,%01000111                                          ; attrs.
    call Print_text_msg                                     ; Print " to FIRE and ".

    inc e

;   Next msn

    ld hl,Move_SHIELD_ASCII_CODE                            ; Move_SHIELD_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (SHIELD_ASCII_CODE).

;   Next msn

    ld hl,a5                                                ; " to FIRE and ".
    ld de,Line_18 + 11
    ld a,%01000111                                          ; attrs.
    call Print_text_msg                                     ; Print " to FIRE and ".

;   Next msn

    ld hl,a6                                                ; "SHIELD."
    ld de,Line_22 + 7
    ld a,%11000101                                          ; attrs.
    call Print_text_msg                                     ; Print "SHIELD".

;   Scan KEYBOARD to START GAME.

    call Press_START

	ret

; ----------------------------------------------------------
;
;   9/3/26
;
;   CLEAN MENUS ROUTINES.

Clean_Define_menu:

    ld hl,Line_8
    call CLean_file

    ld hl,Line_12
    call CLean_file

    ld hl,Line_14
    call CLean_file

    ld hl,Line_16
    call CLean_file 

    ld hl,Line_18
    call CLean_file

    ret

Clean_main_menu: 

    ld hl,a8
    ld a,%01000000
    ld de,Line_9 + 6
    call Print_text_msg

    ld hl,a8
    ld a,%01000000
    ld de,Line_11 + 6
    call Print_text_msg

    ld hl,a8
    ld a,%01000000
    ld de,Line_13 + 6
    call Print_text_msg

    ret

Clean_Show_controls_menu:

    ld hl,Line_8
    call CLean_file 

    ld hl,Line_12
    call CLean_file

    ld hl,Line_14
    call CLean_file

    ld hl,Line_16
    call CLean_file 

    ld hl,Line_18
    call CLean_file

    ld hl,Line_22
    call CLean_file

    ret

CLean_file

    call Calcula_direccion_atributos

    ld b,32
    xor a

1 ld (hl),a
    inc hl
    djnz 1B

    ret

; ----------------------------------------------------------
;
;   28/2/26
;

Corrige_inicio_de_linea

;  Comprueba Move_LEFT_ASCII_CODE:

    ld a,$18                                                ; "SYMBOL SHIFT" ascii code.
    cp (hl)
    jr z,Retrocede_carro

    ld a,$20                                                ; "SPACE" ascii code.
    cp (hl)
    jr z,Retrocede_carro

    ld a,$21                                                ; "ENTER" ascii code.
    cp (hl)
    jr z,Retrocede_carro

    ld a,$27                                                ; "CAPS SHIFT" ascii code.
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

    ld a,1
    out ($fe),a                                             ; BORDER AZUL.

    ld hl,Keyboard                                          ; msg.
    ld de,Line_9 + 12                                       ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01110000                                          ; Yellow
    call Modify_first_char_attr

    ld hl,Kempstom                                          ; msg.
    ld de,Line_11 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    inc l

    ld b,%01101000
    call Modify_first_char_attr

    ld hl,Define                                            ; msg.
    ld de,Line_13 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01110000
    call Modify_first_char_attr

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
