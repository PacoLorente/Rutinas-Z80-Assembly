
Subroutine_001


; ------------------------------------------------------------------------------------------------------- ;

;> call Main_menu_key (Banco_de_pruebas) > call Print_Moon (Print_routines)

Rutinas v2. Ok. :   ; v2. Ok.

Main_menu_key:
Define_menu:
Asigna_B_Attr:
Define_key:
Active_sinclair_joystick:
Active_kempstom_joystick:
Dec_START_counter:
Show_controls_keys:
Press_START:
Press_START_SINCLAIR:
Press_START_KEMPSTON:
Clean_main_menu:
Calcula_direccion_atributos:
Clean_file:
Print_text_msg:
Corrige_inicio_de_linea:
BEEP:
Pinta_imagen:
Pinta_Escudo:
Print_SCORE_Logo:

;>>> Variables o cajas que NO SE REINICIAN NUNCA !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(Stack) ..... defw $0000 [Define_menu] ----- NO REINICIA !!!
(Sound) ..... defw $0000 [BEEP], [Sound_Generator] ----- NO REINICIA !!!

Estas 2 variables sólo se utilizan en las pantallas de menú. Ae pueden utilizar para otra cosa IN GAME.

(Start_counter) ..... defw $0000 [Press_START], [Press_START_KEMPSTON], [Press_START_SINCLAIR] ----- NO REINICIA !!!
(Start_counter_2) ..... db $05 [Press_START_KEMPSTON], [Press_START_SINCLAIR] ----- NO REINICIA !!!

(Keyboard_db_box) ..... db $24, $1c, $04, $20 [Active_sinclair_joystick] ----- NO REINICIA !!!

(Move_LEFT) ..... db $24 [Active_sinclair_joystick] ----- NO REINICIA !!!
(Move_RIGHT) ..... db $1c [Active_sinclair_joystick] ----- NO REINICIA !!!
(Move_FIRE) ..... db $04 [Active_sinclair_joystick] ----- NO REINICIA !!!
(Move_SHIELD) ..... db $20 [Active_sinclair_joystick] ----- NO REINICIA !!!

(Move_LEFT_ASCII_CODE) ..... db $31, $00, $00, $00, $00, $00 ----- NO REINICIA !!!
(Move_RIGHT_ASCII_CODE) ..... db $32, $00, $00, $00, $00, $00 ----- NO REINICIA !!!
(Move_FIRE_ASCII_CODE) ..... db $35, $00, $00, $00, $00, $00 ----- NO REINICIA !!!
(Move_SHIELD_ASCII_CODE) ..... db $53, $50, $41, $43, $45, $00 ----- NO REINICIA !!!

(Numero_de_teclas_definidas) ..... db $00 ----- NO REINICIA !!!

;>>> Variables o cajas que SE REINICIAN con GAME OVER !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(Puntero_de_vidas) ..... defw Tabla_marcador_de_vidas [Pinta_Vida] ----- REINICIA GAME OVER !!!
(Puntero_de_escudos) .....defw Tabla_marcador_de_escudos [Pinta_Escudo] ----- REINICIA GAME OVER !!!




