; ----------------------------------------------------------
;
;   10/6/26
;

Print_new_best_score:

	call Cartel_Best_Score                     ; Imprime Cartel.

    ret

; ----------------------------------------------------------
;
;   20/5/26
;

Print_New_Record:

    call Mide_msg

;   Centramos el msg. en función del nº de dígitos.

    ld de,Line_12 + 14
    call Centra_New_Record_msg

;   Print msg.

    ld a,%01000111
    ld b,0
    ld hl,Score_max_msg                                            
    call Print_text_msg

    ret

; ----------------------------------------------------------
;
;   20/5/26
;
;   INPUTS: C contiene el nº de dígitos que tiene el msg a centrar.
;           E nº de columna, (dirección de pantalla).


Centra_New_Record_msg:

    ld a,5
    cp c
    ret z

    dec a

    cp c
    ret z

    inc e

    dec a
    cp c
    ret z

    dec a
    cp c
    ret z

    inc e

    ret

; ----------------------------------------------------------
;
;   21/05/26
;
;   MODIFY: A,C y HL
;   OUTPUT: C contiene el nº de dígitos, (chars) que tiene el msg. de la máx. puntuación.

Mide_msg:

    ld hl,Score_max_msg-1
    ld c,$ff

1 inc hl
    inc c

    ld a,(hl)
    and a
    jr nz,1B

    ret

; ----------------------------------------------------------
;
;   13/5/26
;

New_best_msg:

    ld hl,a8                                                ; "New Best Score!.".
    ld de,Line_9 + 9
    ld a,%01000101                                          ; attrs. black paper, cyan ink.
    ld b,0
    call Print_text_msg

    call Make_Score_max_msg                                 ; Construye un mensaje de texto con la puntuación máx. obtenida.

    call Print_New_Record

    ld hl,a9                                                ; "Enter your name".
    ld de,Line_16 + 4
    ld a,%01000110                                          ; attrs. black paper, yellow ink.
    ld b,0
    call Print_text_msg

;   Attrs. en la zona del nombre.

    ld hl,Line_20 + 14

Flash:

    ld h,$5a                                                ; Siempre FLASH en el 3er tercio de pantalla.

    ld a,%11000111                                          ; FLASH, (next to char. printed).
    ld (hl),a

    ld a,(Ctrl_6)
    bit 4,a                                                 ; FLAG. Indica DELETE a subrutina FLASH.
    ret z

;    jr $

    res 4,a
    ld (Ctrl_6),a

    xor a
    ld (hl),a

    dec de
    ld (de),a
    ld (Puntero_del_nombre_del_campeon),de                  ; Actualizamos puntero.

    inc c

    dec l
    jr Flash

; ------------------------------------------------------------------------
;
;	15/5/26
;
;	Construye un mensaje de texto con la puntuación obtenida, (Score_hex_max). Este es el nuevo máximo.


Make_Score_max_msg:

;   Non_authorized_KEY_CODES db $18,$23,$24,$1c,$14,$0c,$04,$03,$0b,$13,$1b     

;   Necesito fabricar un msg. con la máxima puntuación.
;   Para ello necesitamos el ASCII CODE de cada dígito del marcador SCORE.

    ld bc,$0500                              ; El marcador SCORE consta de 5 dígitos decimales.
    ld hl,Score_BCD_decenas_de_millar        ; Para evitar imprimir "0", crearemos el mensaje de izquierda a derecha.
;                                            ; Inicialmente (Score_BCD_decenas_de_millar).
    ld de,Score_max_msg

KEY_CODE_de_BCD:

1 ld a,(hl)
    and a 
    jr nz,3F

;   El dígito es "0".

    inc c
    dec c
    jr nz,3F

    dec de                                   ; No queremos "0"´s delante de la cantidad.
    jr Next_digit                            ; Aún no hemos impreso ningún dígito de mayor peso.

3 push de                                    ; PUSH Score_max_msg.

    ld de,Non_authorized_KEY_CODES+2         ; KEY_CODE numbers list.

    and a
    jr z,4F

2 inc de
    dec a
    jr nz,2B                                 ; Nos situamos en el KEY_CODE correspondiente a este dígito.

4 ld a,(de)                                  ; KEY_CODE en A.

    pop de                                   ; Score_max_msg en DE.

    call ASCII_CODE_de_KEYCODE

    inc c                                    ; Indica que a partir de ahora se imprimen todos los "0".

Next_digit:

    inc de                                   ; Siguiente char del msg. que estamos creando.
    dec hl                                   ; Siguiente díguito decimal a traducir, (centenas, decenas, ...).
                                  
    djnz 1B                                  ; Digit counter.

 	ret

; ---------------------------------------

ASCII_CODE_de_KEYCODE:

;   A contiene el código ASCII.  
;   DE apunta al msg, (Score_max_msg).

    push hl
    push bc

    ld c,a
    ld b,0

    ld hl,Tabla_de_conversion_KEYCODE_ASCII_CODE
    add hl,bc

    ld a,(hl)                                               
    ld (de),a                                                 ; ASCII_code almacenado. 

    pop bc
    pop hl

    ret

; ----------------------------------------------------------
;
;   6/5/26
;
;   Limpia la pantalla fijando el negro y pinta el logo de Amadeus.


Clean_and_logo:

    xor a
    out ($fe),a                                             ; BORDER NEGRO.

    ld a,%01000101                                          ; Fondo NEGRO, tinta Cyan + bright.
    call Cls

;   Construimos LOGO.

    call Imprime_Logo_principal

    ret

; ----------------------------------------------------------
;
;   25/3/26
;

Print_level_msg:

    ld hl,(Puntero_de_mensajes_de_niveles)

    call Extrae_address

;   Actualiza (Puntero_de_mensajes_de_niveles).

    inc de
    inc de

    ld (Puntero_de_mensajes_de_niveles),de

;   HL apunta al 1er .db del mensaje de niveles, (centrado en pantalla del msg).

    ld de,Fila_msg_de_nivel                                     ; Línea de impresión.

    ld b,(hl) 
    ld c,b                                                      ; Incremento del carro de impresión en B y C.

1 inc e
    djnz 1B                                                     ; DE contiene la dirección donde imprimiremos el 1er char.

    inc hl                                                      ; HL apunta al 2º .db del mensaje de niveles, (nº de caracteres que tiene el msg).

    ld b,(hl)
    ld (Desplazamiento_level_msg),bc                            ; Guarda el desplazamiento del carro, (para centrar el mensage) y el nº de chars.  
;                                                               ; Estos datos son necesarios para borrar el mensaje más adelante.
    inc hl

;   HL apunta al "msg" a imprimir. Asignamos attrs. y temporización. 

    ld a,%01000111                                              ; attrs. Paper white, black ink.
;    ld b,150                                                    ; Activa temporizador.
    ld b,1

    call Print_text_msg

    ret

; -------------------------------------------------------
;
;   27/03/26   

Clear_level_msg:

    ld hl,Fila_msg_de_nivel

    ld a,(Desplazamiento_level_msg)
    ld b,a

1 inc l
    djnz 1B

    ld a,(Counter_msg_char)
    dec a
    ld b,a

2 inc l
    djnz 2B                                                     ; HL está situado en el último char. a borrar.

    inc a

    ld b,a

;   Estamos en el último char. del mensaje de nivel. 

5 ld e,%11111110                                              ; Utilizaremos esta máscara para ir borrando. Comenzamos con el último bit.

    push bc                                                   ; PUSH nº de chars -1.

    ld b,8                                                    ; 8 bits. 8 interacciones para borrar un byte.
4 push bc                                                     

    ld b,8

    push hl

3 ld a,(hl)
    and e
    ld (hl),a
    inc h
    djnz 3B

    ld bc,$0600                                               ; Velocidad del borrado del mensaje.
    call DELAY

    pop hl

    sla e

    pop bc
    djnz 4B
 
    dec l
    pop bc
    djnz 5B

    ret
    
; ----------------------------------------------------------
;
;   11/3/26
;

Define_menu:

;   Borramos el menú principal.

    call Clean_main_menu

;   Imprime DEFINE MENU:

;   Title.

    ld hl,b0                                                ; "DEFINE CONTROLS KEYS:".
    ld de,Line_8 + 9
    ld a,%01000110                                          ; attrs. Yellow ink.
    ld b,0
    call Print_text_msg

;   LEFT. -----------------------------------------------------------------------------------------------------------------

    ld hl,b1                                                ; "LEFT".
    ld de,Line_12 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    ld b,0
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga la tecla "D".

    ld bc,$ffff
    call DELAY

    push de                                                 ; Guardo la posición del carro de impresión.

    ld hl,Move_LEFT
    ld de,Move_LEFT_ASCII_CODE
    call Define_key                                         ; Almacena Key_code y ASCII_code en sus respectivas variables.

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
    ld b,0
    call Print_text_msg

;   RIGHT. -----------------------------------------------------------------------------------------------------------------

    ld hl,b2                                                ; "RIGHT".
    ld de,Line_14 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    ld b,0
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga (Move LEFT).

    ld bc,$ffff
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
    ld b,0
    call Print_text_msg

;   FIRE. -----------------------------------------------------------------------------------------------------------------

    ld hl,b3                                                ; "FIRE".
    ld de,Line_16 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    ld b,0
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga (Move_RIGHT).

    ld bc,$ffff
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
    ld b,0
    call Print_text_msg

;   SHIELD. -----------------------------------------------------------------------------------------------------------------

    ld hl,b4                                                ; "SHIELD".
    ld de,Line_18 + 12
    ld a,%11000111                                          ; attrs. Flash White.
    ld b,0
    call Print_text_msg

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga (Move_FIRE).

    ld bc,$ffff
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
    ld b,0
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

    ld (No_repeat_key_code),a

    ret

; -----------------------------------------------------------------------------------------------------------
;
;   10/04/26
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
4 ld a,(hl)                                                 ; KEY_CODE de Move_LEFT en A.
    cp e                                                    ; Comparo con el Key_code recién adquirido.
    jr z,3B                                                 ; Esta tecla ya se definió anteriormente. Volvemos a escanear el teclado.

    inc hl                                                  ; Next key_code to compare.

    djnz 4B

2 ld a,e                                                    ; KEY_code en A.

    pop de
    pop hl

    ld (hl),a                                               ; Key_code almacenado.

;   Sonido, (BEEP) de la pulsación de las teclas, (cuando está autorizada). No se ejecuta [BEEP] si la tecla ya está definida.

    call BEEP

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
    ld b,0
    ld a,%01000110                                          ; attrs.
    call Print_text_msg                                     ; Print "Controls:".

    ld hl,Move_LEFT
    ld de,Line_12 + 6                                       ; Posición de inicio de línea.

    call Corrige_inicio_de_linea

    inc hl                                                  

    call Corrige_inicio_de_linea                            ; Hemos corregido el carro de impresión, (si hemos pulsado teclas especiales).

    ld hl,a0                                                ; "Press ".
    ld a,%01000111                                          ; attrs.
    ld b,0
    call Print_text_msg                                     ; Print "Press ".

    inc e

;   Next msn

    ld hl,Move_LEFT_ASCII_CODE                              ; Move_LEFT_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (LEFT_ASCII_CODE).

    inc e

;   Next msn

    ld hl,a1                                                ; "or ".
    ld a,%01000111                                          ; attrs.
    ld b,0
    call Print_text_msg                                     ; Print "or ".

    inc e

;   Next msn

    ld hl,Move_RIGHT_ASCII_CODE                             ; Move_RIGHT_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (RIGHT_ASCII_CODE).

    inc e

;   Next msn

    ld hl,a2                                                ; " to move ".
    ld a,%01000111                                          ; attrs.
    ld b,0
    call Print_text_msg                                     ; Print " to move".

    inc e

;   Next msn

    ld hl,a3                                                ; " LEFT and RIGHT.".
    ld de,Line_14 + 8
    ld a,%01000111                                          ; attrs.
    ld b,0
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
    ld b,0
    call Print_text_msg

    inc e                                                   ; Print "Press ".

;   Next msn

    ld hl,Move_FIRE_ASCII_CODE                              ; Move_FIRE_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (FIRE_ASCII_CODE).

    inc e

;   Next msn

    ld hl,a4                                                ; " to FIRE and ".
    ld a,%01000111                                          ; attrs.
    ld b,0
    call Print_text_msg                                     ; Print " to FIRE and ".

    inc e

;   Next msn

    ld hl,Move_SHIELD_ASCII_CODE                            ; Move_SHIELD_ASCII_CODE -----
    call Print_ctrl_key                                     ; Print (SHIELD_ASCII_CODE).

;   Next msn

    ld hl,a5                                                ; "SHIELD".
    ld de,Line_18 + 11
    ld a,%01000111                                          ; attrs.
    ld b,0
    call Print_text_msg                                     ; Print " to FIRE and ".

;   Next msn

    ld hl,a6                                                ; "Press FIRE to START"
    ld de,Line_22 + 7
    ld a,%11000101                                          ; attrs.
    ld b,0
    call Print_text_msg                                     ; Print "Press FIRE to START".

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

    ld hl,Line_9
    call CLean_file

    ld hl,Line_11
    call CLean_file

    ld hl,Line_13
    call CLean_file

    ld hl,Line_15
    call CLean_file

    ld hl,Line_22
    call CLean_file

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

Corrige_inicio_de_linea:

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
;   Print MAIN MENU.
;
;       KEYBOARD
;       KEMPSTON
;       SINCLAIR
;       DEFINE


Print_Main_menu:

    ld hl,Keyboard                                          ; HL contiene el mensaje.
    ld b,0                                                  ; NO TEMPORIZADOR.
    ld de,Line_9 + 12                                       ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01010000                                          ; Red bright.
    call Modify_first_char_attr

    ld hl,Kempstom                                          ; msg.
    ld bc,0                                                 ; NO TEMPORIZADOR.
    ld de,Line_11 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    inc l

    ld b,%01110000                                          ; Yellow bright.
    call Modify_first_char_attr

    ld hl,Interface                                         ; msg.
    ld bc,0                                                 ; NO TEMPORIZADOR.
    ld de,Line_13 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01100000                                          ; Verde bright.
    call Modify_first_char_attr

    ld hl,Define                                            ; msg.
    ld bc,0                                                 ; NO TEMPORIZADOR.
    ld de,Line_15 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01001000                                          ; Azul bright._
    call Modify_first_char_attr

    ret

; ----------------------------------------------------------
;
;   31/3/26
;

Print_DONE:

;   BC entra con valor "0" en la rutina.

    ld hl,Done                                              ; msg.
    ld de,Line_11 + 14                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%11100000                                          ; attrs.
    call Print_text_msg
    ret

Clean_DONE

    ld hl,b0-5
    ld de,Line_11 + 14
    ld b,0
    ld a,%01000000

    call Print_text_msg

    xor a
    inc a                                                   ; Fuerza NZ a la salida.

    ret

; ----------------------------------------------------------
;
;   29/4/26
;

Print_Game_Over:

    ld hl,Game_Over                                         ; msg.
    ld de,Line_11 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01010000                                          ; attrs.
    ld b,0

    call Print_text_msg

    ret

; ----------------------------------------------------------

Modify_first_char_attr:

    call Calcula_direccion_atributos
    ld (hl),b

    ret

; ----------------------------------------------------------
;
;   18/2/26
;
;   INPUTS: HL apunta al mensage a imprimir, (msg).
;           DE indica la fila de pantalla donde queremos imprimir el msg.
;            A contiene los attrs. del msg.
;            B Actúa como temporizador, ralentiza la impresión de caracteres. No actúa cuando es "0".


;
;           % FBPPPIII

Print_text_msg:

    push bc                                 ;   PUSH temporizador.

    ex af,af                                ;   Attr. en A´.

    push hl
    push de

    call Find_address

    ex de,hl                                ;   BIN en DE - Fila en HL.

    call Print_BIN                          ;   Imprime caracter con atributos.

    pop de
    pop hl

;   Suiguiente char.

    inc hl

    inc (hl)
    dec (hl)

    jr z,Exit_01                            ;   RET, fin de msg.

    inc e

;   TEMPORIZADOR.

    pop bc                                  ;   Carga el temporizador en B.

    inc b
    dec b

    jr z,Print_text_msg                     ;   Mensaje NO TEMPORIZADO. Siguiente char.

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

;    pop bc

    ld b,1                                  ;   Activa retardo RND en el próximo char. a imprimir.

    ex af,af                                ;   Recupera attrs. en A.

    jr Print_text_msg


Exit_01

    pop bc

    ret

; -----------------------------------------------------

;   Find char. data.

Find_address

    ld bc,ROM_ASCII

    ld l,(hl)
    ld h,0

    add hl,hl
    add hl,hl
    add hl,hl                               ;   ASCII * 8

    xor a

    adc hl,bc

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
