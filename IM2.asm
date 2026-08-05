;	Reloj del juego. IM2 *******************************************************************************************************************************************************************
;
;	13/08/24
;
;
	org $feff		;$fcff        										; (Debajo de la pila).
	defw $9310															; Indica al vector de interrupciones, (IM2), que el clock del programa se encuentra en $82a0.

;	Reloj del juego. IM2 ---------------------------------------------------------------------------------------------------------------------------------------------------
;
;	13/08/24
;
	org $9310

	ex af,af

	ld a,(Ctrl_6)
	bit 3,a
	ret nz

	ex af,af

	push af
	push hl

;	BC contiene el tiempo de un semiciclo, (tiempo que tiene que estar el beeper activado/desactivado antes de cambiar_
;	_de estado).

 ;	-------------------- STOP si no hemos terminado de construir el FRAME.

	ld hl,Ctrl_3
	bit 0,(hl)
	jr z,$

;	--------------------

; 	Disparos.

	call Pinta_disparos_Amadeus
	call Pinta_disparos_Entidades

;	Sprites.

	call Actualiza_pantalla

; 	Actualiza marcadores.

	ld hl,Ctrl_2
	bit 7,(hl)
	call nz,Borra_escudo

	ld hl,Ctrl_4
	bit 6,(hl)
	call nz,Borra_vida

	call Print_enemy_counter

	ld a,(Score_Ctrl) 													;	Sólo se imprime el marcador Score cuando este se incrementa.
	and a
	call nz, Print_Score_Counter

; Actualiza variables Shield ----------------------- ----------------------- ------------------------

Temporizacion_shield

	ld hl,Shield
	ld a,(hl)
	and a
	jr z,Incrementa_FRAMES												;	No hay escudo. Se agotó el tiempo Shield.

	dec (hl)															;	Decrementa tiempo Shield, (Shield).
	inc hl

	dec (hl)															;	Decrementa temporizador de estados, (Shield_2).
	jr nz,Incrementa_FRAMES


Cambio_de_estado      													; 	El temporizador de estados a llegado a "0". HL apunta a (Shield_2).

;	Indica cambio de estado.

	inc hl																;	Sitúa en (Shield_3).
	bit 3,(hl)
	jr z,2F

	call Inicia_Shield

	call Play_Shield_sound_effect

	ld a,(Shield)
	and a
	jr nz,Incrementa_FRAMES

	ld hl,0
	ld (Sound),hl

	jr Incrementa_FRAMES

2 rlc (hl)																; 	Sitúa en (Shield_3) y rotamos bit. (Indica cambio de comportamiento).

	ld hl,(Puntero_datos_shield) 										;	Carga en (Shield_2) la siguiente temporización.
	inc hl
	ld (Puntero_datos_shield),hl
	ld a,(hl)
	ld (Shield_2),a														;	Iniciamos (Shield_2) con la nueva temporización.

Incrementa_FRAMES

	ld hl,(FRAMES)
	inc hl
	ld (FRAMES),hl

	ld a,h
	or l
	jr nz,1F

	ld hl,FRAMES_3
	inc (hl)

1 push de
	push bc

;	Sound efects

	call Play_burst_sound_effect
	call Play_shot_sound_effect

;	-------------------------------------------------------------
;
;	Repone_Attr_Moon
;
;	Repone los Attr. de la luna, de la zona de vidas y de Amadeus. antes de volcar pantalla, si una entidad sobrevuela sobre ella cambiaría su color.
;
;	MODIFY: HL.

;	Moon.

	ld hl,$4747 													; BRIGHT 1, BLACK paper, WHITE ink

	ld (Attr_Moon_File4),hl
	ld (Attr_Moon_File4_2),hl
	ld (Attr_Moon_File4_3),hl

	ld (Attr_Moon_File5),hl
	ld (Attr_Moon_File5_2),hl
	ld (Attr_Moon_File5_3),hl

	ld hl,Ctrl_6
	res 0,(hl) 														; Inicializa el inhibidor de efectos de sonido.

	ld a,(Ctrl_5)
	bit 6,a
	call nz,Print_Game_Over 										; Imprime "GAME OVER" si LIVES = "0".

	ld a,(Ctrl_1)
	bit 0,a
	call nz,Print_DONE 												; Imprime "DONE" si hemos eliminado a la última entidad del nivel.

	pop bc
	pop de
	pop hl
	pop af

	ei

	ret

; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 16,  16)
;Char Size:       (  2,   2)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx
;Interleave:      Line
;Mask:            No

Best_Score_7: 												; Chars 9,10,11,12, (Últimos 4 chars).

	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$12,$CC,$BA,$DE,$6D,$52
	DEFB	$45,$56,$45,$1C,$45,$10,$45,$10
	DEFB	$ED,$12,$B9,$1E,$11,$0C,$00,$00

Fecha_Firma:

	DEFB	$00,$EE,$22,$62,$84,$84,$E4,$00
