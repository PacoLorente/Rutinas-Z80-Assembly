; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	17/02/23
;
;	Sprites e índices.

	org $8400

;	LOGO del menú principal.

; 	ASM source file created by SevenuP v1.20
; 	SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;	GRAPHIC DATA:

;	Pixel Size:      ( 24,  24)
;
;	(Puntero_de_impresion) ..... $4060

Logo_nave:

	DEFB	$00,$18,$00,$00,$24,$00,$00,$42
	DEFB	$00,$00,$7E,$00,$00,$CF,$00,$00
	DEFB	$BF,$00,$09,$7F,$90,$19,$C3,$98
	DEFB	$39,$81,$9C,$3B,$81,$DC,$7B,$81
	DEFB	$DE,$7A,$C3,$DE,$DA,$FF,$DF,$DB
	DEFB	$7F,$DF,$DD,$3F,$BF,$CD,$BF,$BF
	DEFB	$65,$9F,$BE,$66,$9F,$7E,$3E,$FF
	DEFB	$7C,$3C,$FF,$3C,$19,$7E,$98,$01
	DEFB	$BD,$80,$03,$DB,$C0,$07,$00,$E0

;	Pixel Size:      ( 24,  16)
;
;	(Puntero_de_impresion) ..... $4083

Logo_ma:

	DEFB	$00,$00,$00,$00,$00,$01,$03,$03
	DEFB	$0F,$07,$87,$1F,$0F,$9F,$9E,$1D
	DEFB	$B9,$80,$79,$F1,$80,$71,$E1,$87
	DEFB	$F3,$C1,$8F,$E3,$83,$0F,$E7,$83
	DEFB	$0C,$C7,$03,$0E,$C2,$07,$0F,$C0
	DEFB	$07,$03,$00,$02,$00,$00,$00,$00


;	Pixel Size:      ( 24,  24)
;
;	(Puntero_de_impresion) ..... $4066

logo_ad:

	DEFB	$00,$00,$02,$00,$00,$02,$00,$00
	DEFB	$06,$00,$00,$06,$00,$00,$06,$00
	DEFB	$00,$06,$00,$00,$0E,$00,$00,$0C
	DEFB	$78,$00,$0C,$F8,$00,$0C,$D8,$03
	DEFB	$FC,$18,$1F,$F8,$18,$7F,$F8,$30
	DEFB	$F0,$79,$30,$E0,$33,$E1,$C0,$3F
	DEFB	$E1,$C0,$3C,$E1,$C0,$70,$79,$E0
	DEFB	$70,$78,$FF,$E0,$F8,$3F,$C0,$F0
	DEFB	$3E,$00,$00,$00,$00,$00,$00,$00

;	Pixel Size:      ( 24,  16)
;
;	(Puntero_de_impresion) ..... $4089

logo_eu:

	DEFB	$00,$F0,$00,$03,$F8,$18,$07,$FC
	DEFB	$38,$1E,$0C,$30,$3C,$1C,$70,$7C
	DEFB	$F8,$60,$7F,$F0,$E0,$7F,$C0,$C0
	DEFB	$78,$00,$C1,$70,$1C,$C3,$70,$7C
	DEFB	$C7,$7F,$F0,$FF,$1F,$E0,$7C,$0F
	DEFB	$00,$38,$00,$00,$00,$00,$00,$00

;	Pixel Size:      ( 24,  16)
;
;	(Puntero_de_impresion) ..... $408c

Tabla_de_puntuacion:

	db 20
	db 30
	db 40
	db 50
	db 60

; --------------------------------------------------------------------------
; FREE SPACE $0b, 11d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8500

logo_us:

	DEFB	$00,$00,$00,$00,$1E,$00,$00,$3F
	DEFB	$00,$00,$73,$80,$30,$E1,$C0,$70
	DEFB	$E1,$C0,$60,$70,$C0,$C0,$30,$00
	DEFB	$C0,$38,$00,$80,$1C,$00,$80,$0F
	DEFB	$00,$8F,$C3,$80,$E7,$FF,$80,$E0
	DEFB	$3F,$00,$00,$00,$00,$00,$00,$00

;	---------- + ----------

;	Icono de las Vidas + Shield.

;	Pixel Size:      ( 24,  24)
;
;	(Puntero_de_impresion) ..... $4066


Escudo_00:

	DEFB	$00,$00,$80,$01,$C0,$03,$7F,$FE
	DEFB	$3F,$FC,$00,$00,$0F,$F0,$03,$C0

Escudo_00_Fb:

	DEFB	$00,$00,$00,$08,$00,$10,$0C,$00
	DEFB	$30,$07,$FF,$E0,$03,$FF,$C0,$00
	DEFB	$00,$00,$00,$FF,$00,$00,$3C,$00

;	Disparo.

Disparo_de_entidad_derecho DEFB $18,$00,$00
Disparo_de_entidad_izquierdo DEFB $00,$00,$18

Indice_disparo_Amadeus:

	defw Disparo_0
	defw Disparo_f9
	defw Disparo_fb
	defw Disparo_fd

;	Disparo (CTRL_DESPLZ)="0".

Disparo_0 DEFB $01,$80
Disparo_0b DEFB $07,$e0 						; (No se imprime, detección de colisión).

;	Disparo (CTRL_DESPLZ)="f9"

Disparo_f9 DEFB $00,$60
Disparo_f9b DEFB $01,$f8 						; (No se imprime, detección de colisión).

;	Disparo (CTRL_DESPLZ)="fb"

Disparo_fb DEFB $18,$00
Disparo_fbb DEFB $7e,$00 						; (No se imprime, detección de colisión).

;	Disparo (CTRL_DESPLZ)="fd"

Disparo_fd DEFB $06,$00
Disparo_fdb DEFB $1f,$80 						; (No se imprime, detección de colisión).

; ----------------------------------------------------------------------------------------

;	Badplate.

Indice_Badplate_der:

	defw Badplate
	defw Badplate_f8								
	defw Badplate_f9							
	defw Badplate_fa	
	defw Badplate_fb     						                     
	defw Badplate_fc	
	defw Badplate_fd							 
	defw Badplate_fe	 									

Indice_Badplate_izq:

	defw Badplate
	defw Badplate_fe	
	defw Badplate_fd							 
	defw Badplate_fc	
	defw Badplate_fb     						                     
	defw Badplate_fa	
	defw Badplate_f9							 
	defw Badplate_f8	 									

Badplate:

	DEFB	$03,$00,$00,$00,$80,$00,$00,$80
	DEFB	$00,$03,$C0,$00,$04,$20,$00,$0D
	DEFB	$30,$00,$09,$90,$00,$09,$90,$00
	DEFB	$09,$90,$00,$19,$98,$00,$78,$9E
	DEFB	$00,$CC,$33,$00,$CF,$F3,$00,$7C
	DEFB	$3E,$00,$3C,$3C,$00,$0F,$F0,$00

Badplate_f8:

	DEFB	$01,$80,$00,$00,$40,$00,$00,$40
	DEFB	$00,$01,$E0,$00,$02,$10,$00,$06
	DEFB	$98,$00,$04,$C8,$00,$04,$C8,$00
	DEFB	$04,$C8,$00,$0C,$CC,$00,$3C,$4F
	DEFB	$00,$66,$19,$80,$67,$F9,$80,$3E
	DEFB	$1F,$00,$1E,$1E,$00,$07,$F8,$00

; --------------------------------------------------------------------------
; FREE SPACE $0a, 10d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8600

Badplate_f9:

	DEFB	$00,$C0,$00,$00,$20,$00,$00,$20
	DEFB	$00,$00,$F0,$00,$01,$08,$00,$03
	DEFB	$4C,$00,$02,$64,$00,$02,$64,$00
	DEFB	$02,$64,$00,$06,$66,$00,$1E,$27
	DEFB	$80,$33,$0C,$C0,$33,$FC,$C0,$1F
	DEFB	$0F,$80,$0F,$0F,$00,$03,$FC,$00

Badplate_fa:

	DEFB	$00,$60,$00,$00,$10,$00,$00,$10
	DEFB	$00,$00,$78,$00,$00,$84,$00,$01
	DEFB	$A6,$00,$01,$32,$00,$01,$32,$00
	DEFB	$01,$32,$00,$03,$33,$00,$0F,$13
	DEFB	$C0,$19,$86,$60,$19,$FE,$60,$0F
	DEFB	$87,$C0,$07,$87,$80,$01,$FE,$00

Badplate_fb:

	DEFB	$00,$30,$00,$00,$08,$00,$00,$08
	DEFB	$00,$00,$3C,$00,$00,$42,$00,$00
	DEFB	$C3,$00,$00,$81,$00,$00,$81,$00
	DEFB	$00,$81,$00,$01,$81,$80,$07,$81
	DEFB	$E0,$0D,$C3,$B0,$0C,$7E,$30,$06
	DEFB	$3C,$60,$03,$BD,$C0,$00,$FF,$00

Badplate_fc:

	DEFB	$00,$18,$00,$00,$04,$00,$00,$04
	DEFB	$00,$00,$1E,$00,$00,$21,$00,$00
	DEFB	$61,$80,$00,$40,$80,$00,$40,$80
	DEFB	$00,$40,$80,$00,$C0,$C0,$03,$C0
	DEFB	$F0,$06,$E1,$D8,$06,$3F,$18,$03
	DEFB	$1E,$30,$01,$DE,$E0,$00,$7F,$80

Badplate_fd:

	DEFB	$00,$0C,$00,$00,$02,$00,$00,$02
	DEFB	$00,$00,$0F,$00,$00,$10,$80,$00
	DEFB	$30,$C0,$00,$20,$40,$00,$20,$40
	DEFB	$00,$20,$40,$00,$60,$60,$01,$E0
	DEFB	$78,$03,$70,$EC,$03,$1F,$8C,$01
	DEFB	$8F,$18,$00,$EF,$70,$00,$3F,$C0

; --------------------------------------------------------------------------
; FREE SPACE $10, 16d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8700

Badplate_fe:

	DEFB	$00,$06,$00,$00,$01,$00,$00,$01
	DEFB	$00,$00,$07,$80,$00,$08,$40,$00
	DEFB	$18,$60,$00,$10,$20,$00,$10,$20
	DEFB	$00,$10,$20,$00,$30,$30,$00,$F0
	DEFB	$3C,$01,$B8,$76,$01,$8F,$C6,$00
	DEFB	$C7,$8C,$00,$77,$B8,$00,$1F,$E0

;	Badsat.

Indice_Badsat_izq:

	defw Badsat_izquierda
	defw Badsat_izq_fe
	defw Badsat_izq_fd
	defw Badsat_izq_fc
	defw Badsat_izq_fb
	defw Badsat_izq_fa
	defw Badsat_izq_f9
	defw Badsat_izq_f8

Badsat_izquierda:

	DEFB 	$00,$08,$00
	DEFB 	$02,$14,$00
	DEFB 	$02,$2A,$00
	DEFB 	$02,$55,$00
	DEFB	$02,$AA,$00
	DEFB 	$02,$54,$00
	DEFB 	$7F,$E8,$00
	DEFB 	$03,$60,$00
	DEFB	$0A,$E0,$00
	DEFB 	$17,$F8,$00
	DEFB 	$2B,$E8,$00
	DEFB 	$54,$40,$00
	DEFB	$AA,$60,$00
	DEFB 	$54,$00,$00
	DEFB 	$28,$00,$00
	DEFB 	$10,$00,$00	 						; Sprite principal a izquierda, (sin desplazar).

Badsat_izq_f8:

	DEFB 	$00,$04,$00,$01,$0A,$00,$01,$15
	DEFB	$00,$01,$2A,$80,$01,$55,$00,$01
	DEFB	$2A,$00,$3F,$F4,$00,$01,$B0,$00
	DEFB	$05,$70,$00,$0B,$FC,$00,$15,$F4
	DEFB	$00,$2A,$20,$00,$55,$30,$00,$2A
	DEFB	$00,$00,$14,$00,$00,$08,$00,$00 	; $F8 (7º DESPLZ a izquierda).

Badsat_izq_f9:

	DEFB 	$00,$02,$00,$00,$85,$00,$00,$8A
	DEFB	$80,$00,$95,$40,$00,$AA,$80,$00
	DEFB	$95,$00,$1F,$FA,$00,$00,$D8,$00
	DEFB	$02,$B8,$00,$05,$FE,$00,$0A,$FA
	DEFB	$00,$15,$10,$00,$2A,$98,$00,$15
	DEFB	$00,$00,$0A,$00,$00,$04,$00,$00 	; $F9 (6º DESPLZ a izquierda).

Badsat_izq_fa:

	DEFB 	$00,$01,$00,$00,$42,$80,$00,$45
	DEFB	$40,$00,$4A,$A0,$00,$55,$40,$00
	DEFB	$4A,$80,$0F,$FD,$00,$00,$6C,$00
	DEFB	$01,$5C,$00,$02,$FF,$00,$05,$7D
	DEFB	$00,$0A,$88,$00,$15,$4C,$00,$0A
	DEFB	$80,$00,$05,$00,$00,$02,$00,$00 	; $Fa (5º DESPLZ a izquierda).

Badsat_izq_fb:

	DEFB 	$00,$00,$80,$00,$21,$40,$00,$22
	DEFB	$A0,$00,$25,$50,$00,$2A,$A0,$00
	DEFB	$25,$40,$07,$FE,$80,$00,$36,$00
	DEFB	$00,$AE,$00,$01,$7F,$80,$02,$BE
	DEFB	$80,$05,$44,$00,$0A,$A6,$00,$05
	DEFB	$40,$00,$02,$80,$00,$01,$00,$00 	; $Fb (4º DESPLZ a izquierda).

Badsat_izq_fc:

	DEFB 	$00,$00,$40,$00,$10,$A0,$00,$11
	DEFB	$50,$00,$12,$A8,$00,$15,$50,$00
	DEFB	$12,$A0,$03,$FF,$40,$00,$1B,$00
	DEFB	$00,$57,$00,$00,$BF,$C0,$01,$5F
	DEFB	$40,$02,$A2,$00,$05,$53,$00,$02
	DEFB	$A0,$00,$01,$40,$00,$00,$80,$00 	; $Fc (3er DESPLZ a izquierda).

Badsat_izq_fd:

	DEFB 	$00,$00,$20,$00,$08,$50,$00,$08
	DEFB	$A8,$00,$09,$54,$00,$0A,$A8,$00
	DEFB	$09,$50,$01,$FF,$A0,$00,$0D,$80
	DEFB	$00,$2B,$80,$00,$5F,$F8,$00,$AF
	DEFB	$80,$01,$51,$00,$02,$A9,$00,$01
	DEFB	$51,$00,$00,$A0,$00,$00,$40,$00 	; $Fd (2º DESPLZ a izquierda).

Badsat_izq_fe:

	DEFB 	$00,$00,$10,$00,$04,$28,$00,$04
	DEFB	$54,$00,$04,$AA,$00,$05,$54,$00
	DEFB	$04,$A8,$00,$FF,$D0,$00,$06,$C0
	DEFB	$00,$15,$C0,$00,$2F,$FC,$00,$57
	DEFB	$C0,$00,$A8,$80,$01,$54,$80,$00
	DEFB	$A8,$80,$00,$50,$00,$00,$20,$00 	; $Fe (1er DESPLZ a izquierda).


Indice_Badsat_der:

	defw Badsat_derecha
	defw Badsat_der_f8
	defw Badsat_der_f9
	defw Badsat_der_fa
	defw Badsat_der_fb
	defw Badsat_der_fc
	defw Badsat_der_fd
	defw Badsat_der_fe

Badsat_derecha:

	DEFB	$10,$00,$00
	DEFB    $28,$40,$00
	DEFB	$54,$40,$00
	DEFB	$AA,$40,$00
	DEFB	$55,$40,$00
	DEFB	$2A,$40,$00
	DEFB	$17,$FE,$00
	DEFB	$06,$C0,$00
	DEFB	$07,$50,$00
	DEFB	$1F,$E8,$00
	DEFB	$17,$D4,$00
	DEFB	$02,$2A,$00
	DEFB	$06,$55,$00
	DEFB	$00,$2A,$00
	DEFB	$00,$14,$00
	DEFB	$00,$08,$00 						; Sprite principal a derecha, (sin desplazar).

Badsat_der_f8:

	DEFB 	$08,$00,$00,$14,$20,$00,$2A,$20
	DEFB	$00,$55,$20,$00,$2A,$A0,$00,$15
	DEFB	$20,$00,$0B,$FF,$00,$03,$60,$00
	DEFB	$03,$A8,$00,$0F,$F4,$00,$0B,$EA
	DEFB	$00,$01,$15,$00,$03,$2A,$80,$00
	DEFB	$15,$00,$00,$0A,$00,$00,$04,$00 	; $F8 (1er DESPLZ a derecha).

Badsat_der_f9:

	DEFB 	$04,$00,$00,$0A,$10,$00,$15,$10
	DEFB	$00,$2A,$90,$00,$15,$50,$00,$0A
	DEFB	$90,$00,$05,$FF,$80,$01,$B0,$00
	DEFB	$01,$D4,$00,$07,$FA,$00,$05,$F5
	DEFB	$00,$00,$8A,$80,$01,$95,$40,$00
	DEFB	$0A,$80,$00,$05,$00,$00,$02,$00 	; $F9 (2º DESPLZ a derecha).

Badsat_der_fa:

	DEFB 	$02,$00,$00,$05,$08,$00,$0A,$88
	DEFB	$00,$15,$48,$00,$0A,$A8,$00,$05
	DEFB	$48,$00,$02,$FF,$C0,$00,$D8,$00
	DEFB	$00,$EA,$00,$03,$FD,$00,$02,$FA
	DEFB	$80,$00,$45,$40,$00,$CA,$A0,$00
	DEFB	$05,$40,$00,$02,$80,$00,$01,$00 	; $Fa (3er DESPLZ a derecha).

Badsat_der_fb:

	DEFB 	$01,$00,$00,$02,$84,$00,$05,$44
	DEFB	$00,$0A,$A4,$00,$05,$54,$00,$02
	DEFB	$A4,$00,$01,$7F,$E0,$00,$6C,$00
	DEFB	$00,$75,$00,$01,$FE,$80,$01,$7D
	DEFB	$40,$00,$22,$A0,$00,$65,$50,$00
	DEFB	$02,$A0,$00,$01,$40,$00,$00,$80 	; $Fb (4º DESPLZ a derecha).

Badsat_der_fc:

	DEFB	$00,$80,$00,$01,$42,$00,$02,$A2
	DEFB	$00,$05,$52,$00,$02,$AA,$00,$01
	DEFB	$52,$00,$00,$BF,$F0,$00,$36,$00
	DEFB	$00,$3A,$80,$00,$FF,$40,$00,$BE
	DEFB	$A0,$00,$11,$50,$00,$32,$A8,$00
	DEFB	$01,$50,$00,$00,$A0,$00,$00,$40 	; $Fc (5º DESPLZ a derecha).

; --------------------------------------------------------------------------
; FREE SPACE $10, 16d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8a00

Badsat_der_fd:

	DEFB 	$00,$40,$00,$00,$A1,$00,$01,$51
	DEFB	$00,$02,$A9,$00,$01,$55,$00,$00
	DEFB	$A9,$00,$00,$5F,$F8,$00,$1B,$00
	DEFB	$00,$1D,$40,$01,$FF,$A0,$00,$1F
	DEFB	$50,$00,$08,$A8,$00,$09,$54,$00
	DEFB	$08,$A8,$00,$00,$50,$00,$00,$20 	; $Fd (6º DESPLZ a derecha).

Badsat_der_fe:

	DEFB	$00,$20,$00,$00,$50,$80,$00,$A8
	DEFB	$80,$01,$54,$80,$00,$AA,$80,$00
	DEFB	$54,$80,$00,$2F,$FC,$00,$0D,$80
	DEFB	$00,$0E,$A0,$00,$FF,$D0,$00,$0F
	DEFB	$A8,$00,$04,$54,$00,$04,$AA,$00
	DEFB	$04,$54,$00,$00,$28,$00,$00,$10 	; $Fe (7º DESPLZ a derecha).

; ----------------------------------------------------------------------------------------

; 	Amadeus. 2x2.

Indice_Amadeus_der:

	defw Amadeus
	defw 0	
	defw Amadeus_F9								; [$F9] right - [$FA] left
	defw 0	
	defw Amadeus_Fb     						; [$FB] right - [$FC] left
	defw 0	
	defw Amadeus_Fd								; [$FD] right - [$FE] left
	defw 0	 									; (Fín de índice).

Indice_Amadeus_izq:

	defw Amadeus
	defw 0	
	defw Amadeus_Fd								; [$F9] right - [$FA] left
	defw 0	
	defw Amadeus_Fb     						; [$FB] right - [$FC] left
	defw 0	
	defw Amadeus_F9								; [$FD] right - [$FE] left
	defw 0	 									; (Fín de índice).

Amadeus:

	DEFB 	$01,$80,0
	DEFB	$23,$C4,0
	DEFB	$26,$64,0
	DEFB	$24,$24,0
	DEFB	$2C,$34,0
	DEFB	$6D,$B6,0
	DEFB	$6F,$F6,0
	DEFB	$67,$E6,0
	DEFB	$E7,$E7,0
	DEFB	$F3,$CF,0
	DEFB	$F7,$EF,0
	DEFB	$FF,$FF,0
	DEFB	$FB,$DF,0
	DEFB	$FB,$DF,0
	DEFB	$8B,$D1,0
	DEFB	$71,$8E,0 							; Sprite principal, (sin desplazar).

; --------------------------------------------------------------------------

Amadeus_F9:

	DEFB	$00,$60,$00,$08,$F1,$00,$09,$99
	DEFB	$00,$09,$09,$00,$0B,$0D,$00,$1B
	DEFB	$6D,$80,$1B,$FD,$80,$19,$F9,$80
	DEFB	$39,$F9,$C0,$3C,$F3,$C0,$3D,$FB
	DEFB	$C0,$3F,$FF,$C0,$3E,$F7,$C0,$3E
	DEFB	$F7,$C0,$22,$F4,$40,$1C,$63,$80 	; $F9 (2º DESPLZ a derecha).

; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 16,  16)
;Char Size:       (  2,   2)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx
;Interleave:      Line
;Mask:            No

_or:

	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$8F,$3D,$D9,$9F,$F9,$DF
	DEFB	$F9,$DC,$39,$DC,$39,$DC,$39,$DC
	DEFB	$D9,$9C,$8F,$3C,$00,$00,$00,$00

Amadeus_Fb:

	DEFB	$00,$18,$00,$02,$3C,$40,$02,$66
	DEFB	$40,$02,$42,$40,$02,$C3,$40,$06
	DEFB	$DB,$60,$06,$FF,$60,$06,$7E,$60
	DEFB	$0E,$7E,$70,$0F,$3C,$F0,$0F,$7E
	DEFB	$F0,$0F,$FF,$F0,$0F,$BD,$F0,$0F
	DEFB	$BD,$F0,$08,$BD,$10,$07,$18,$E0 	; $Fb (4º DESPLZ a derecha).

Amadeus_Fd:

	DEFB	$00,$06,$00,$00,$8F,$10,$00,$99
	DEFB	$90,$00,$90,$90,$00,$B0,$D0,$01
	DEFB	$B6,$D8,$01,$BF,$D8,$01,$9F,$98
	DEFB	$03,$9F,$9C,$03,$CF,$3C,$03,$DF
	DEFB	$BC,$03,$FF,$FC,$03,$EF,$7C,$03
	DEFB	$EF,$7C,$02,$2F,$44,$01,$C6,$38 	; $Fd (6º DESPLZ a derecha).

; ----------------------------------------------------------------------------------------

Indice_Explosion_entidades:

	defw Explosion_entidades_1
	defw Explosion_entidades_2
	defw Explosion_entidades_3

Explosion_entidades_1:

	DEFB 	$00,$10,$00
	DEFB 	$08,$10,$00
	DEFB	$04,$38,$40
	DEFB	$03,$7D,$80
	DEFB	$02,$E6,$80
	DEFB	$01,$B7,$00
	DEFB	$01,$7F,$00
	DEFB	$03,$DD,$80
	DEFB	$0F,$FF,$E0
	DEFB	$03,$3B,$80
	DEFB	$01,$9D,$00
	DEFB	$01,$F6,$00
	DEFB	$02,$FD,$80
	DEFB	$03,$00,$40
	DEFB	$04,$00,$00
	DEFB	$08,$00,$00

Explosion_entidades_2:

	DEFB 	$08,$00,$00,$05,$38,$10,$03,$BC
	DEFB	$20,$06,$00,$C0,$04,$06,$C0,$00
	DEFB	$37,$00,$00,$7F,$00,$03,$DD,$80
	DEFB	$03,$FE,$00,$03,$3A,$70,$01,$9C
	DEFB	$60,$01,$F6,$40,$04,$F8,$80,$06
	DEFB	$00,$00,$08,$00,$00,$00,$00,$00

Explosion_entidades_3:

	DEFB 	$03,$18,$10,$04,$00,$20,$08,$00
	DEFB	$40,$00,$00,$C0,$00,$06,$00,$00
	DEFB	$15,$00,$08,$1E,$00,$00,$14,$30
	DEFB	$08,$66,$00,$00,$38,$00,$01,$08
	DEFB	$00,$01,$80,$00,$00,$80,$00,$04
	DEFB	$03,$20,$06,$00,$10,$08,$00,$20

; ------------------------------------------

Indice_Explosion_Amadeus:

	defw Explosion_Amadeus_1
	defw Explosion_Amadeus_2
	defw Explosion_Amadeus_3

; --------------------------------------------------------------------------
; FREE SPACE $04, 04d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8c00

Explosion_Amadeus_1:

	DEFB 	$00,$18,$02
	DEFB	$02,$3C,$36
	DEFB	$02,$66,$56
	DEFB	$02,$42,$48
	DEFB	$02,$C3,$32
	DEFB	$06,$DB,$0C
	DEFB	$06,$FE,$46
	DEFB	$06,$79,$68
	DEFB	$0E,$76,$D8
	DEFB	$1E,$34,$6C
	DEFB	$0F,$6E,$BE
	DEFB	$0F,$EF,$B0
	DEFB	$0F,$B5,$A0
	DEFB	$0F,$B1,$8A
	DEFB	$08,$BA,$4C
	DEFB	$07,$19,$80

Explosion_Amadeus_2:

	DEFB 	$00,$18,$02
	DEFB	$00,$3C,$36
	DEFB	$00,$66,$56
	DEFB	$04,$42,$48
	DEFB	$0A,$03,$32
	DEFB	$14,$DB,$0C
	DEFB	$1C,$DE,$46
	DEFB 	$36,$49,$68
	DEFB	$0C,$76,$D8
	DEFB	$10,$34,$6C
	DEFB	$2B,$6E,$BE
	DEFB	$0E,$AF,$B0
	DEFB	$29,$B5,$A0
	DEFB	$0C,$91,$8A
	DEFB	$08,$BA,$4C
	DEFB	$07,$19,$80

Explosion_Amadeus_3:

	DEFB 	$00,$00,$00
	DEFB	$00,$00,$00
	DEFB	$00,$00,$00
	DEFB	$00,$00,$40
	DEFB	$00,$00,$30
	DEFB	$00,$00,$08
	DEFB	$00,$82,$40
	DEFB	$04,$04,$68
	DEFB	$04,$20,$58
	DEFB	$18,$12,$2C
	DEFB	$2A,$40,$3C
	DEFB	$0F,$C2,$30
	DEFB	$29,$80,$A0
	DEFB	$0F,$84,$88
	DEFB	$08,$A0,$4C
	DEFB	$07,$11,$80		

; --------------------------------------------------------------------------

Index_big_numbers:

	DEFW Cero
	DEFW Uno
	DEFW Dos
	DEFW Tres
	DEFW Cuatro
	DEFW Cinco
	DEFW Seis
	DEFW Siete
	DEFW Ocho
	DEFW Nueve

; --------------------------------------------------------------------------

; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 16,  24)
;Char Size:       (  2,   3)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx
;Interleave:      Line
;Mask:            No

Cero:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$4F,$F2,$60,$06,$70,$0E,$70,$0E
	DEFB	$70,$0E,$70,$0E,$60,$06,$40,$02
	DEFB	$00,$00,$40,$02,$60,$06,$70,$0E
	DEFB	$70,$0E,$70,$0E,$70,$0E,$60,$06
	DEFB	$4F,$F2,$1F,$F8,$3F,$FC,$00,$00


; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 16,  16)
;Char Size:       (  2,   2)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx
;Interleave:      Line
;Mask:            No

_e:
	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$00,$9E,$38,$BB,$38,$B3,$38
	DEFB	$73,$80,$7F,$80,$70,$00,$79,$B8
	DEFB	$3F,$38,$1E,$38,$00,$00,$00,$00

; --------------------------------------------------------------------------
; FREE SPACE $0c, 12d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8d00

Uno:

	DEFB	$00,$00,$00,$00,$00,$00,$00,$00
	DEFB	$00,$02,$00,$06,$00,$0E,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$06,$00,$02
	DEFB	$00,$00,$00,$02,$00,$06,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$0E,$00,$06
	DEFB	$00,$02,$00,$00,$00,$00,$00,$00

Dos:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$0F,$F2,$00,$06,$00,$0E,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$06,$0F,$F2
	DEFB	$1F,$F8,$4F,$F0,$60,$00,$70,$00
	DEFB	$70,$00,$70,$00,$70,$00,$60,$00
	DEFB	$4F,$F0,$1F,$F8,$3F,$FC,$00,$00

Tres:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$0F,$F2,$00,$06,$00,$0E,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$06,$0F,$F2
	DEFB	$1F,$F8,$0F,$F2,$00,$06,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$0E,$00,$06
	DEFB	$0F,$F2,$1F,$F8,$3F,$FC,$00,$00

Cuatro:

	DEFB	$00,$00,$00,$00,$00,$00,$40,$02
	DEFB	$60,$06,$70,$0E,$70,$0E,$70,$0E
	DEFB	$70,$0E,$70,$0E,$60,$06,$5F,$FA
	DEFB	$3F,$FC,$1F,$FA,$00,$06,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$0E,$00,$0E
	DEFB	$00,$06,$00,$02,$00,$00,$00,$00

Cinco:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$4F,$F0,$60,$00,$70,$00,$70,$00
	DEFB	$70,$00,$70,$00,$60,$00,$4F,$F0
	DEFB	$1F,$F8,$0F,$F2,$00,$06,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$0E,$00,$06
	DEFB	$0F,$F2,$1F,$F8,$3F,$FC,$00,$00

; --------------------------------------------------------------------------
; FREE SPACE $10, 16d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8e00

Seis:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$4F,$F0,$60,$00,$70,$00,$70,$00
	DEFB	$70,$00,$70,$00,$60,$00,$4F,$F0
	DEFB	$1F,$F8,$4F,$F2,$60,$06,$70,$0E
	DEFB	$70,$0E,$70,$0E,$70,$0E,$60,$06
	DEFB	$4F,$F2,$1F,$F8,$3F,$FC,$00,$00

Siete:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$0F,$F2,$00,$06,$00,$0E,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$06,$00,$02
	DEFB	$00,$00,$00,$02,$00,$06,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$0E,$00,$06
	DEFB	$00,$02,$00,$00,$00,$00,$00,$00

Ocho:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$4F,$F2,$60,$06,$70,$0E,$70,$0E
	DEFB	$70,$0E,$70,$0E,$60,$06,$4F,$F2
	DEFB	$1F,$F8,$4F,$F2,$60,$06,$70,$0E
	DEFB	$70,$0E,$70,$0E,$70,$0E,$60,$06
	DEFB	$4F,$F2,$1F,$F8,$3F,$FC,$00,$00

Nueve:

	DEFB	$00,$00,$00,$00,$3F,$FC,$1F,$F8
	DEFB	$4F,$F2,$60,$06,$70,$0E,$70,$0E
	DEFB	$70,$0E,$70,$0E,$60,$06,$4F,$F2
	DEFB	$1F,$F8,$0F,$F2,$00,$06,$00,$0E
	DEFB	$00,$0E,$00,$0E,$00,$0E,$00,$06
	DEFB	$0F,$F2,$1F,$F8,$3F,$FC,$00,$00

; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 16,  16)
;Char Size:       (  2,   2)
;Sort Priorities: X char, Char line, Y char
;Data Outputted:  Gfx
;Interleave:      Line
;Mask:            No

_Sc:

	DEFB	$00,$00,$00,$00,$1F,$C0,$33,$C0
	DEFB	$71,$C0,$78,$C7,$3E,$0D,$1F,$1D
	DEFB	$07,$9D,$03,$DC,$61,$DC,$70,$DC
	DEFB	$79,$8F,$7F,$07,$00,$00,$00,$00


Indice_de_digitos_score:

	DEFW	Cero_Score
	DEFW	Uno_Score
	DEFW	Dos_Score
	DEFW	Tres_Score
	DEFW	Cuatro_Score
	DEFW	Cinco_Score
	DEFW	Seis_Score
	DEFW	Siete_Score
	DEFW	Ocho_Score
	DEFW	Nueve_Score

; --------------------------------------------------------------------------
; FREE SPACE $0c, 12d ------------------------------------------------------
; --------------------------------------------------------------------------

	org $8f00

;   28/10/25
;
;   Tablas_rápidas.
;
;	El objetivo de estas tablas es el de generar los scanlines lo más rápido posible en el álbum de pintado.
;
;	La tabla + el índice: 

Fast_H_Index:

;	defw H1ter
;	defw H2ter
;	defw H3ter

Fast_H_Table:

H1ter db $40,$41,$42,$43,$44,$45,$46,$47,0	 			; El "0" Indica "Fín de línea".
H2ter db $48,$49,$4a,$4b,$4c,$4d,$4e,$4f,0
H3ter db $50,$51,$52,$53,$54,$55,$56,$57,0

Fast_L_Index:

	defw Line_0
	defw Line_1
	defw Line_2
	defw Line_3
	defw Line_4
	defw Line_5
	defw Line_6
	defw Line_7
	defw Line_8
	defw Line_9
	defw Line_a
	defw Line_b
	defw Line_c
	defw Line_d
	defw Line_e
	defw Line_f
	defw 0

Fast_L_Table:

Line_0  db $00,$00,$00,$00,$00,$00,$00,$00
Line_2	db $20,$20,$20,$20,$20,$20,$20,$20
Line_4	db $40,$40,$40,$40,$40,$40,$40,$40
Line_6	db $60,$60,$60,$60,$60,$60,$60,$60
Line_8	db $80,$80,$80,$80,$80,$80,$80,$80
Line_a	db $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0
Line_c	db $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0
Line_e	db $e0,$e0,$e0,$e0,$e0,$e0,$e0,$e0

Line_1  db $10,$10,$10,$10,$10,$10,$10,$10
Line_3	db $30,$30,$30,$30,$30,$30,$30,$30
Line_5	db $50,$50,$50,$50,$50,$50,$50,$50
Line_7	db $70,$70,$70,$70,$70,$70,$70,$70
Line_9	db $90,$90,$90,$90,$90,$90,$90,$90
Line_b	db $b0,$b0,$b0,$b0,$b0,$b0,$b0,$b0
Line_d	db $d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0
Line_f	db $f0,$f0,$f0,$f0,$f0,$f0,$f0,$f0

; --------------------------------------------------------------------------
; FREE SPACE $??, ??d ------------------------------------------------------
; --------------------------------------------------------------------------
