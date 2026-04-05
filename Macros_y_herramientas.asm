;   ---------------------------------------------------------------------------------------

	macro Push_regs

	push ix
	push iy
	push af
	push hl
	push bc
	push de

	endm

;   ---------------------------------------------------------------------------------------

	macro Pop_regs

	pop de
	pop bc
	pop hl
	pop af
	pop iy
	pop ix

	endm

;   ---------------------------------------------------------------------------------------

	macro Delay

	ld bc,$1fff
wait dec bc
	ld a,b
	and a
	jr nz,wait

	endm

;   ---------------------------------------------------------------------------------------

	macro Pinta_frame_danza

	ld hl,(Album_de_pintado)
	ld (Scanlines_album_SP),hl
	ld de,(Puntero_objeto)
	ex de,hl
	call Pinta_Sprites

	endm

;   ---------------------------------------------------------------------------------------

	macro Depurador_de_danzas_v01

	Push_regs	;	--- macro ---
	ld hl,(Album_de_pintado)
	ld (Scanlines_album_SP),hl
	ld ix,(Puntero_de_impresion)
	ld de,(Puntero_objeto)
	call Genera_datos_de_impresion

;	INPUTS: IX contiene (Puntero_de_impresion)
;			IY contiene (Puntero_objeto)

	call Codifica_Puntero_de_impresion
	push iy
	pop hl
	ld (Puntero_objeto),hl
	ld a,(Attr)
	ld c,a
	ld a,(Columnas)

; Pinta ------

	Pinta_frame_danza	;	--- macro ---
	call Pulsa_ENTER
	push bc
	Delay	;	--- macro ---
	pop bc

; Borra ------

	Pinta_frame_danza	;	--- macro ---
	Pop_regs	;	--- macro ---

	endm

;   ---------------------------------------------------------------------------------------

