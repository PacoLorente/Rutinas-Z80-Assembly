; ----------------------------------------------------------
;
;   16/6/26
;
;   Imprime el cartel "Best_Score", el nombre del campeón y la nueva puntuación máxima en la esquina inferior izquierda del _
;   _Menú Principal.
;
;   MODIFY: AF, HL, DE y BC.

Print_new_best_score:

	call Cartel_Best_Score ; v2. Ok.            ; Imprime el Cartel "Best Score" en la esquina inferior izquierda de la pantalla_
;                                               ; _del menú principal.

;   Imprime el nombre del campeón y la nueva puntuación máxima justo debajo del cartel Best_Score.
;   La rutina [Print_text_msg] requiere de los siguientes parámetros para imprimir texto:

;           HL apunta al mensage a imprimir, (msg).
;           DE indica la fila de pantalla donde queremos imprimir el msg.
;            A contiene los attrs. del msg.
;            B Actúa como temporizador, ralentiza la impresión de caracteres, (simula una máquina de escribir).
;              No actua cuando su valor es "0".

    ld de,Line_22+1

    ld a,%01000111
    ld b,0
    ld hl,Nombre_del_campeon
    call Print_text_msg ; v2. Ok.

    inc e
    inc e

    ld a,%01000111
    ld b,0
    ld hl,a10                           ; a10 defm "--",0
    call Print_text_msg

    inc e
    inc e

    ld a,%11000101
    ld b,0
    ld hl,Score_max_msg
    call Print_text_msg

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
;   25/3/26
;

Print_level_msg:

    ld hl,(Puntero_de_mensajes_de_niveles)
    call Extrae_address

;   HL apunta al 1er .db del mensaje de niveles, (centrado en pantalla del msg).

    ld de,Fila_msg_de_nivel                                     ; Línea de impresión de los mensajes de nivel $4826.

    ld b,(hl) 
    ld c,b                                                      ; Columnas a incrementar el carro de impresión en B y C.

1 inc e
    djnz 1B                                                     ; DE contiene la dirección donde imprimiremos el 1er char.

    inc hl                                                      ; HL apunta al 2º .db del mensaje de niveles, (nº de caracteres que tiene el msg).

    ld b,(hl)
    ld (Desplazamiento_level_msg),bc                            ; Guarda el desplazamiento del carro, (para centrar el mensage) y el nº de chars.  
;                                                               ; Estos datos son necesarios para borrar el mensaje más adelante.
;                                                               ; (B) contiene la longitud del msg.
;                                                               ; (C) contiene el n° de columnas a sumar a $4826.
    inc hl

;   HL apunta al "msg" a imprimir. Asignamos attrs. y temporización. 

    ld a,%01000111                                              ; attrs. Paper white, black ink.
;    ld b,150                                                   ; TEMPORIZADOR DE CARACTERES ON !!!
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
;   22/10/26
;
;   Esta función nos permite cambiar las teclas asignadas a los controles de Amadeus.
;   Por defecto las teclas que controlan nuestra nave son:
;
;   Move_LEFT db $24
;   Move_RIGHT db $1c
;   Move_FIRE db $04
;   Move_SHIELD db $20

;   Move_LEFT_ASCII_CODE db "1"
;   ds 5
;   Move_RIGHT_ASCII_CODE db "2"
;   ds 5
;   Move_FIRE_ASCII_CODE db "5"
;   ds 5
;   Move_SHIELD_ASCII_CODE db "SPACE"
;   ds 1
;
;   Hemos creado una tabla de punteros con los .defw que contienen los datos necesarios para definir e imprimir_
;   _ cada uno de los 4 controles.
;
;   Los datos son los siguientes:
;
;   Left_key_parameters: defw b1                                ; Cadena de texto: "LEFT".
;       defw Line_12 + 12                                       ; Dirección de pantalla, Fila 12, columna 12.
;       defw Move_LEFT
;       defw Move_LEFT_ASCII_CODE
;       db 4                                                    ; N° de chars. que forman la cadena de texto "LEFT".
;       db 4                                                    ; N° de espacios que separan en pantalla la cadena de texto de la tecla definida.
;
;   Utilizaremos la variable: (Puntero_de_impresion) para guardar la posición del puntero indicial, (hl).
;   Nota: Antes de salir de la función restauraremos su valor a "$0000".
;
;   MODIFY: AF, HL, HL´, DE, DE´, BC, IX
;   OUTPUT: (Z), Set_1 (Ctrl_6).  Indica regreso al Menú Principal.

Define_menu:

;   Borramos el menú principal.

    call Clean_main_menu    ; v2. Ok.

;   Imprime el título: "DEFINE MENU:".

    ld hl,b0                                                ; Cadena de texto: "DEFINE CONTROLS KEYS:".
    ld de,Line_8 + 9                                        ; Dirección de pantalla, Fila 8, columna 9.
    ld a,%01000110                                          ; Attrs.: BRIGHT, BLACK PAPER, YELLOW INK.
    ld b,0                                                  ; No efecto "Máquina de escribir".

    call Print_text_msg ; v2. Ok.                           ; PRINT "DEFINE CONTROLS KEYS:"

;   Para guardar el puntero del índice: `Define_menu_index_parameters´, (array con los parámetros que forman los 4 campos_
;   _ que construyen el menú DEFINE), utilizaremos la variable: (Puntero_de_impresion).

;   Inicializamos (Puntero_de_impresion), situándolo en el primer campo del índice.

    ld hl,Define_menu_index_parameters
    ld (Puntero_de_impresion),hl

Abastecimiento:

    call Extrae_address                                     ; HL apunta ahora al 1er parámetro del campo correspondiente, 

    ld a,h
    or l
    jr z, All_keys_defined

;   Utilizamos la pila para abastecer registros con los datos de la tabla.

    ld (Stack),sp

    ld sp,hl

    exx

    pop hl                                                  ; HL' apunta a la cadena de texto a imprimir, "LEFT", "RIGHT", "FIRE", "SHIELD".
    pop de                                                  ; DE' contiene la dirección de pantalla donde se imprime el primer char. del msg. de texto.

    ld b,0                                                  ; No efecto "Máquina de escribir".

    exx

    pop hl                                                  ; HL apunta a la variable de sistema que almacenará el KEYCODE de la tecla pulsada.
    pop de                                                  ; DE apunta a la variable de sistema que almacenará el ASCII_CODE de la tecla pulsada.
    pop bc                                                  ; (BC) contiene: (N° de chars / n° de spaces).

    ld a,%11000111                                          ; Attrs.: FLASH, BRIGHT, BLACK PAPER, WHITE INK.

    ld sp,(Stack)

;    jr $

;    ret

 ;   LEFT. -----------------------------------------------------------------------------------------------------------------

;    ld hl,b1                                                ; Cadena de texto: "LEFT".
;    ld de,Line_12 + 12                                      ; Dirección de pantalla, Fila 12, columna 12.

;    ld a,%11000111                                          ; Attrs.: FLASH, BRIGHT, BLACK PAPER, WHITE INK.
;    ld b,0                                                  ; No efecto "Máquina de escribir".


    exx

    push de                                                 ; PUSH Carro de impresión.

    call Print_text_msg

    push de
    pop ix                                                  ; IX contiene la posición actualizada del carro de impresión tras imprimir la cadena de texto.

;   Retardo antes de leer el teclado. Evita que la rutina de escaneo recoga la tecla "D".

    ld bc,$ffff
    call DELAY

    exx

;    ld hl,Move_LEFT
;    ld de,Move_LEFT_ASCII_CODE

    push bc
    push hl
    push de

    call Define_key ; v2. Ok.                               ; Almacena Key_code y ASCII_code en sus respectivas variables.

    pop de
    pop hl
    pop bc

    ld a,(Numero_de_teclas_definidas)
    inc a
    ld (Numero_de_teclas_definidas),a

;   Hemos definido (Move_LEFT). Este hecho lo indicamos "quitando" el FLASH de la palabra "LEFT" e imprimiento el char. o chars. ASCII del KEYCODE asignado.

    ld a,b                                                  ; N° de chars de la cadena de texto en A.

    exx

    pop de                                                 ; PUSH Carro de impresión.

    ld b,a

    ex de,hl


;    ld hl,Line_12+12                                        ; Dirección de video del 1er char. al que vamos a asignar attrs.

;    ld b,4                                                  ; N° de chars. consecutivos a los que vamos asignar attrs.

    ld a,%01000111                                          ; Attrs.: BRIGHT, BLACK PAPER, WHITE INK.

    call Asigna_B_Attr  ; v2. Ok.                           ; Cambia atributos de la función a definir, NO FLASH.

    exx

    ex de,hl



;   Imprime tecla pulsada, (LEFT). (Move_LEFT_ASCII_CODE).

;    ld hl,Move_LEFT_ASCII_CODE
;    pop de                                                  ; POP Carro de impresión.

;    jr $

    push ix
    pop de

    ld b,c                                                  ; N° de espacios en B.

1 inc e
    djnz 1B

    ld a,%01101000                                          ; Attrs.: BRIGHT, CYAN PAPER, BLACK INK.

    call Print_text_msg                                     ; Print DEFINED KEY to (Move_LEFT_ASCII_CODE).

Incrementa_puntero_de_parametros:


    ld hl,(Puntero_de_impresion)

    inc hl
    inc hl

    ld (Puntero_de_impresion),hl

    jr Abastecimiento

All_keys_defined:

;   All keys are defined.

;   Guardamos los nuevos KEYCODE de las teclas definidas en ((Keyboard_db_box)).

    call Store_CONTROLS_in_Keyboard_db_box                  ; Almacena los actuales controles, (KEYBOARD KEYCODES) en la caja de teclado_
;                                                           ; _ y reemplaza los antiguos.

;   DELAY before EXIT to Main menu.

    ld bc,$ffff
    call DELAY
    ld bc,$ffff
    call DELAY                                              
    ld bc,$ffff
    call DELAY
    ld bc,$ffff
    call DELAY                                              ; DELAY before EXIT to Main menu.
    ld bc,$ffff
    call DELAY

; Clean Define menu.

    call Clean_Define_menu

    ld hl,Ctrl_6
    set 1,(hl)                                              ; Bit 1 "1", means: Return to Main menu.

    xor a
    ld (Numero_de_teclas_definidas),a

    ld h,a
    ld l,h

    ld (Puntero_de_impresion),hl

    ret

; -----------------------------------------------------------------------------------------------------------
;
;   17/10/26
;
;   Asigna un nuevo KEYCODE y sustituye al contenido en la variable MOVE_xxx, (al que apunta H)L.
;   Nueva tecla para la función de movimiento, (KEYBOARD) a la que apunta HL.
;
;   Move_LEFT db $24
;   Move_RIGHT db $1c
;   Move_FIRE db $04
;   Move_SHIELD db $20
;
;   El nuevo KEYCODE también modificará el msg. de texto contenido en la correspondiente caja ASCII.
;
;   El msg. de texto será de un char. si es una tecla normal, "q", "s", "2", ..., etc.
;   El msg. de texto será de 5 chars. si es una tecla especial.
;
;   Special keys:
;
;   Symbol_key defm "SYMB.",0
;   Space_key defm "SPACE",0
;   Enter_key defm "ENTER",0
;   Caps_key defm "CAPS.",0
;
;   INPUTS: HL apunta a la variable que almacenará el correspondiente (KEY_CODE), ej: Move_LEFT.
;           DE apunta a la variable que almacenará el correspondiente (ASCII_CODE), ej: Move_LEFT_ASCII_CODE.
;
;           (Numero_de_teclas_definidas) contiene el n° de teclas YA DEFINIDAS.
;
;   MODIFY: AF, HL, BC y DE.
;
;   OUTPUT: (A) = "0".

Define_key:

    push hl                                                 ; PUSH Puntero KEYCODE.
    push de                                                 ; PUSH Puntero ASCII_CODE.

3 call ROM_Key_Scan ; v2. Ok.                               ; Scan keyboard.

;   Tras ejecutar[ROM_Key_Scan], (E) contiene el KEYCODE de la tecla pulsada.

    ld a,(Numero_de_teclas_definidas)                       ; N° de teclas ya definidas.
    and a
    jr z,2F                                                 ; (Numero_de_teclas_definidas)="0" Indica que estamos definiendo Move_LEFT.
;                                                           ; (Numero_de_teclas_definidas) se incrementa en una unidad cada vez que se define una tecla:
;
;                                                           ; Ej.: Si estamos definiendo Move_RIGHT, (Numero_de_teclas_definidas)="1"
;                                                           ;      Si estamos definiendo Move_FIRE, (Numero_de_teclas_definidas)="2"
;                                                           ;      Si estamos definiendo Move_SHIELD, (Numero_de_teclas_definidas)="3"

    ld b,a                                                  ; Así, (B) contiene el nº de teclas definidas -1.

;   (Numero_de_teclas_definidas) contiene el n° de comparativas que realizaremos entre el nuevo KEYCODE definido y los anteriormente definidos.
;   Así evitaremos que se asigne una misma tecla para varias funciones distintas.

    ld hl,Move_LEFT                                         ; 1er KEYCODE a comparar.

1 ld a,(hl)                                                 ; KEY_CODE de Move_LEFT en A.
    cp e                                                    ; Comparo con el Key_code recién adquirido.
    jr z,3B                                                 ; Esta tecla ya se definió anteriormente. Volvemos a escanear el teclado.

    inc hl                                                  ; Next KEYCODE to compare.

    djnz 1B

2 ld a,e                                                    ; KEY_code en A.

    pop de                                                  ; POP Puntero ASCII_CODE.
    pop hl                                                  ; POP Puntero KEYCODE.

    ld (hl),a                                               ; Key_code almacenado.

;   Sonido, (BEEP) de la pulsación de las teclas, (cuando está autorizada). No se ejecuta [BEEP] si la tecla ya está definida.

    call BEEP   ; v2. Ok.

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
;
;   Recordatorio: Cada caja ASCII consta de 6 bytes, esto es porque el msg. de texto que se almacena al pulsar una SPECIAL KEY consta de 5 caracteres.
;   El 6° byte SIEMPRE contendrá "0" pues indica a [Print_text_msg], "FIN DE CADENA DE TEXTO".
;
;   Guardamos el ASCII_CODE seguido de "0" para indicar "fin de cadena de texto".
;

    ld c,a
    ld b,0

    ld hl,Tabla_de_conversion_KEYCODE_ASCII_CODE

    add hl,bc

    ld a,(hl)                                               
    ld (de),a

    inc de

    xor a
    ld (de),a                                                ; "0", indica a [Print_text_msg], "Fin de cadena de texto".

    ret

Print_SYMB:

    ld hl,Symbol_key
    call Get_ascii_message
    ret z

Print_SPACE:

    ld hl,Space_key
    call Get_ascii_message
    ret z

Print_ENTER:

    ld hl,Enter_key
    call Get_ascii_message
    ret z

Print_CAPS:

    ld hl,Caps_key
    call Get_ascii_message
    ret z

; --------------------------------------------------
;
;   18/10/26
;
;   Sub.: Almacena los 5 códigos ASCII que construyen la palabra de la SPECIAL KEY.:
;
;   Symbol_key defm "SYMB.",0
;   Space_key defm "SPACE",0
;   Enter_key defm "ENTER",0
;   Caps_key defm "CAPS.",0
;
;   Al salir de la rutina tendremos en la caja correspondiente algo así:
;
;   $961e db $45, $4e, $54, $45, $52, $00 ..... Move_LEFT_ASCII_CODE db "SPACE",0
;
;   MODIFY: A, HL y DE.

Get_ascii_message:

    ld a,(hl)
    ld (de),a

    and a
    ret z

    inc hl
    inc de

    jr Get_ascii_message

; ----------------------------------------------------------
;
;   13/3/26
;
;   Pantalla de información. Imprime los controles, (teclas) que hemos seleccionado para nuestros movimientos_
;   _ después de seleccionar "K", KEYBOARD en el menú principal. Una vez en esta pantalla si pulsamos START, (FIRE)_
;   _ iniciaremos partida. Si no pulsamos START, pasado un tiempo volveremos al menú principal, (Set_1 Ctrl_6).
;
;   MODIFY: AF, HL, DE y BC.
;
;   OUTPUT: SET 1, (Ctrl_6) NO START PRESSED, (FIRE key). RETURN TO MAIN MENU.

Show_controls_keys:


    call Clean_main_menu    ; v2. Ok.

;   Imprimimos CONTROLES.

    ld hl,a7                                                ; Cadena de texto: "Controls:".
    ld de,Line_8 + 12                                       ; Dirección de pantalla, Fila 8, columna 12. (1a línea).
    ld b,0                                                  ; No efecto "Máquina de escribir".
    ld a,%01000110                                          ; Attrs.: BRIGHT, BLACK PAPER, YELLOW INK.

;           HL apunta al mensage a imprimir, (msg).
;           DE indica la fila de pantalla donde queremos imprimir el msg.
;            A contiene los attrs. del msg.
;            B Actúa como temporizador, ralentiza la impresión de caracteres, (simula una máquina de escribir).
;              No actua cuando su valor es "0".
;
;   Recordatorio. TABLA DE ATRIBUTOS:
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
;

    call Print_text_msg ; v2. Ok.                           ; PRINT "Controls:".

;   Next line to print:                                     "Press "X" or "X" to move". -------------------------------------------

    ld hl,Move_LEFT                                         ; HL se sitúa en el KEYCODE de la tecla de control "Move_LEFT".
    ld de,Line_12 + 6                                       ; Posición inicial de la 2a línea a imprimir.

    call Corrige_inicio_de_linea    ; v2. Ok.

    inc hl                                                  ; HL se sitúa en el KEYCODE de la tecla de control "Move_RIGHT".

    call Corrige_inicio_de_linea                            ; Hemos DESPLAZADO el carro de impresión, si hemos seleccionado teclas especiales para_
;                                                           ; _ los controles: (Move_LEFT) y (Move_RIGHT).

;   PRINT LINE:

    ld hl,a0                                                ; Cadena de texto: "Press ".
    ld a,%01000111                                          ; Attrs.: BRIGHT, BLACK PAPER, WHITE INK.

    call Print_text_msg ; v2. Ok.                           ; PRINT "Press ".

    inc e                                                   ; +1 Columna, (space).

;   Lo siguiente es imprimir el código ASCII correspondiente al KEYCODE (Move_LEFT).
;   A menos que hayamos definido nuevos controles, por defecto el ASCII CODE de (Move_LEFT) es $31, tecla "1", KEYCODE $24.

    ld hl,Move_LEFT_ASCII_CODE                              ; Move_LEFT_ASCII_CODE -----
    ld a,%01110000                                          ; Attrs.: BRIGHT, YELLOW PAPER, BLACK INK.

    call Print_text_msg

    inc e                                                   ; +1 Columna, (space).

    ld hl,a1                                                ; Cadena de texto: "or ".
    ld a,%01000111                                          ; Attrs.: BRIGHT, BLACK PAPER, WHITE INK.

    call Print_text_msg                                     ; Print "or ".

    inc e                                                   ; +1 Columna, (space).

;   Lo siguiente es imprimir el código ASCII correspondiente al KEYCODE (Move_RIGHT).
;   A menos que hayamos definido nuevos controles, por defecto el ASCII CODE de (Move_RIGHT) es $32, tecla "2", KEYCODE $1c.

    ld hl,Move_RIGHT_ASCII_CODE                             ; Move_RIGHT_ASCII_CODE -----
    ld a,%01110000                                          ; Attrs.: BRIGHT, YELLOW PAPER, BLACK INK.

    call Print_text_msg

    inc e                                                   ; +1 Columna, (space).

    ld hl,a2                                                ; Cadena de texto: " to move ".
    ld a,%01000111                                          ; Attrs.: BRIGHT, BLACK PAPER, WHITE INK.

    call Print_text_msg                                     ; Print " to move".

    inc e                                                   ; +1 Columna, (space).

;   Next line.

    ld hl,a3                                                ; Cadena de texto: " LEFT and RIGHT.".
    ld de,Line_14 + 8                                       ; Posición inicial del carro de impresión en esta línea, fila 14, columna 8.
    ld a,%01000111                                          ; Attrs.: BRIGHT, BLACK PAPER, WHITE INK.

    call Print_text_msg                                     ; Print " LEFT and RIGHT.".

;   Hay que corregir la posición donde escribiremos la tercera línea de texto si hemos definido "SPACE" o "ENTER"_
;   _como alguna de las teclas de disparo o shield.

    ld hl,Move_FIRE                                         ; HL se sitúa en el KEYCODE de la tecla de control "Move_FIRE".
    ld de,Line_16 + 6                                       ; Posición inicial del carro de impresión de esta 4a línea.

    call Corrige_inicio_de_linea    ; v2. Ok.

    inc hl                                                  ; HL se sitúa en el KEYCODE de la tecla de control "Move_SHIELD".
                                                    
    call Corrige_inicio_de_linea                            ; Hemos corregido el carro de impresión, (si hemos pulsado teclas especiales). 

;   PRINT LINE:

    ld hl,a0                                                ; Cadena de texto: "Press ".
    ld a,%01000111                                          ; Attrs.: BRIGHT, BLACK PAPER, WHITE INK.

    call Print_text_msg                                     ; Print "Press ".

    inc e                                                   ; +1 Columna, (space).

;   Lo siguiente es imprimir el código ASCII correspondiente al KEYCODE (Move_FIRE).
;   A menos que hayamos definido nuevos controles, por defecto el ASCII CODE de (Move_FIRE) es $35, tecla "5", KEYCODE $04.

    ld hl,Move_FIRE_ASCII_CODE                              ; Move_FIRE_ASCII_CODE -----
    ld a,%01110000                                          ; Attrs.: BRIGHT, YELLOW PAPER, BLACK INK.

    call Print_text_msg

    inc e                                                   ; +1 Columna, (space).

    ld hl,a4                                                ; Cadena de texto: " to FIRE and ".
    ld a,%01000111                                          ; Attrs.: BRIGHT, BLACK PAPER, WHITE INK.

    call Print_text_msg                                     ; Print " to FIRE and ".

    inc e                                                   ; +1 Columna, (space).

;   Lo siguiente es imprimir el código ASCII correspondiente al KEYCODE (Move_SHIELD).
;   A menos que hayamos definido nuevos controles, por defecto el ASCII CODE de (Move_SHIELD) es $53,$50,$41,$43,$45, tecla "SPACE", KEYCODE $20.

    ld hl,Move_SHIELD_ASCII_CODE                            ; Move_SHIELD_ASCII_CODE -----
    ld a,%01110000                                          ; Attrs.: BRIGHT, YELLOW PAPER, BLACK INK.

    call Print_text_msg

;   Next line.

    ld hl,a5                                                ; Cadena de texto: "to SHIELD."
    ld de,Line_18 + 11                                      ; Posición inicial del carro de impresión de esta 5a línea.
    ld a,%01000111                                          ; attrs.

    call Print_text_msg                                     ; Print " to SHIELD.".

;   Next line.

    ld hl,a6                                                ; Cadena de texto: "Press FIRE to START"
    ld de,Line_22 + 7                                       ; Posición inicial del carro de impresión de la última línea.
    ld a,%11000101                                          ; Attrs.: FLASH, BRIGHT, BLACK PAPER, CYAN INK.

    call Print_text_msg                                     ; Print "Press FIRE to START".

;   Scan KEYBOARD to START GAME.

    call Press_START    ; v2. Ok.                           ; Activa el bit_1 de Ctrl_6 si no hemos pulsado START.

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

; -----------------------------------------------------------------------
;
;   11/10/26
;
;   Fija los atributos a NEGRO de las Filas del Menú Principal que contienen texto.
;
;   MODIFY: AF, HL y B.


Clean_main_menu: 

    ld hl,Line_9
    call CLean_file ; v2. Ok.

    ld hl,Line_11
    call CLean_file

    ld hl,Line_13
    call CLean_file

    ld hl,Line_15
    call CLean_file

    ld hl,Line_22
    call CLean_file

    ld hl,Line_19
    call CLean_file

    ld hl,Line_20
    call CLean_file

    ld hl,Line_21
    call CLean_file

    ret

; -----------------------------------------------------------------------
;
;   14/10/26
;
;   Fija los atributos a NEGRO de las 6 Filas de texto que componen la pantalla SHOW CONTROLS MENU.
;
;   MODIFY: AF, HL y B.

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

; ---------------------------------------------------------------------
;
;   11/10/26
;
;   Set BLACK attrs. a screen file.
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
;
;   INPUTS: HL contiene la dirección de pantalla del primer byte de la 1a columna de la fila, ej.: $4820, $4080, $5000, etc ..
;
;   MODIFY: AF, HL y B.

CLean_file:

    call Calcula_direccion_atributos    ; v2. Ok.

    ld b,32                             ; B actúa como contador de columnas, ($20).
    xor a

1 ld (hl),a
    inc hl
    djnz 1B

    ret

; ----------------------------------------------------------
;
;   12/10/26
;
;   Sitúa DOS columnas a la izquierda el comienzo de la línea de texto, (para que quede centrado), cuando el control_
;   _ a analizar, (HL) sea una TECLA ESPECIAL.
;
;   Las teclas especiales se mostrarán en pantalla como cadenas de texto de 5 caracteres:
;
;   Special keys:
;
;   Symbol_key defm "SYMB."
;   Space_key defm "SPACE"
;   Enter_key defm "ENTER"
;   Caps_key defm "CAPS."
;
;   MODIFY: AF, E.
;
;   INPUTS: HL apunta a la dirección que contiene el KEYCODE de la tecla de CONTROL a sondear:
;
;   Move_LEFT db $24
;   Move_RIGHT db $1c
;   Move_FIRE db $04
;   Move_SHIELD db $20
;
;           (DE) contiene la dirección de pantalla del texto a imprimir: Fila/Columna.
;
;   OUTPUT: Retrocede DOS columnas a la izquierda el carro de impresión, (Columna donde se imprime la cadena de texto).

Corrige_inicio_de_linea:

;  Compara el KEYCODE contenido en (HL) con el de las 4 SPECIAL KEYS.

    ld a,$18                                                ; "SYMBOL SHIFT" KEYCODE code.
    cp (hl)
    jr z,Retrocede_carro

    ld a,$20                                                ; "SPACE" KEYCODE.
    cp (hl)
    jr z,Retrocede_carro

    ld a,$21                                                ; "ENTER" KEYCODE.
    cp (hl)
    jr z,Retrocede_carro

    ld a,$27                                                ; "CAPS SHIFT" KEYCODE.
    cp (hl)
    jr z,Retrocede_carro

    ret

; --------------------------------

Retrocede_carro:

    dec e
    dec e
 
    ret

; ----------------------------------------------------------
;
;   16/9/26
;
;   Print MAIN MENU.
;
;       KEYBOARD
;       KEMPSTON
;       SINCLAIR
;       DEFINE
;
;   MODIFY: AF, HL, BC y DE.

Print_Main_menu:

    ld hl,Keyboard                                          ; HL contiene el mensaje.
    ld b,0                                                  ; NO TEMPORIZADOR.
    ld de,Line_9 + 12                                       ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01010000                                          ; RED BRIGHT paper, BLACK ink.
    call Modify_first_char_attr

    ld hl,Kempstom                                          ; msg.
    ld bc,0                                                 ; NO TEMPORIZADOR.
    ld de,Line_11 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    inc l

    ld b,%01110000                                          ; YELLOW BRIGHT paper, BLACK ink.
    call Modify_first_char_attr

    ld hl,Interface                                         ; msg.
    ld bc,0                                                 ; NO TEMPORIZADOR.
    ld de,Line_13 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01100000                                          ; GREEN BRIGHT paper, BLACK ink.
    call Modify_first_char_attr

    ld hl,Define                                            ; msg.
    ld bc,0                                                 ; NO TEMPORIZADOR.
    ld de,Line_15 + 12                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%01000111                                          ; attrs. Ink white.

    push de
    call Print_text_msg
    pop hl

    ld b,%01001000                                          ; BLUE BRIGHT paper, BLACK ink.
    call Modify_first_char_attr

    ret

; ----------------------------------------------------------
;
;   21/07/26
;

Print_DONE:

    ld bc,0
    ld hl,Done                                              ; msg.
    ld de,Line_11 + 14                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,%11100000                                          ; attrs.

    call Print_text_msg

    ret

Clean_DONE

    ld hl,a12                                               ; msg., "    ", 
    ld de,Line_11 + 14                                      ; Línea de pantalla donde se imprimirá el msg.
    ld a,0                                                  ; attrs.

    call Print_text_msg

    ret

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



