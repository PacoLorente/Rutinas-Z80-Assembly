
; Mensajes:

Keyboard defm "KEYBOARD",0
Kempstom defm "KEMPSTON",0
Interface defm "SINCLAIR",0
Define defm "DEFINE",0
Start defm "START",0
Top_score defm "BEST SCORE: ",0
Done defm "DONE",0
Game_Over defm "GAME OVER",0

; Msg_keyboard_menu, show CONTROLS.

a0 defm "Press ",0
a1 defm " or ",0
a2 defm " to move ",0
a3 defm " LEFT and RIGHT.",0
a4 defm " to FIRE and ",0
a5 defm "to SHIELD.",0
a6 defm "Press FIRE to START",0
a7 defm "CONTROLS:",0
a8 defm "New Best Score!",0
a9 defm "Enter name & press ENTER",0
a10 defm "--",0
a11 defm "pts",0
a12 defm "    ",0

; DEFINE MENU.

b0 defm "DEFINE CONTROLS",0
b1 defm "LEFT",0
b2 defm "RIGHT",0
b3 defm "FIRE",0
b4 defm "SHIELD",0

; Special keys:

Symbol_key defm "SYMB.",0
Space_key defm "SPACE",0
Enter_key defm "ENTER",0
Caps_key defm "CAPS.",0

; Mensajes de Nivel.

;   Nota: Fila donde se imprimen los msg: $4826

Msg_1 db 8,5 									; El 1er .db indica que sumamos +8 columnas a la dirección donde se imprimen los mensajes: $4826.
	defm "FLIES",0

Msg_2 db 8,5 									; El 1er .db indica que sumamos +8 columnas a la dirección donde se imprimen los mensajes: $4826.
	defm "UFOS",0

Msg_3 db 4,12
	defm "FLIES & UFOS",0
