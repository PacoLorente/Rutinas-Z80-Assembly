; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	17/02/23
;
;	Sprites e índices.

	org $8370

; Disparo.

Indice_disparo_Amadeus defw Disparo_0
	defw Disparo_f9
	defw Disparo_fb
	defw Disparo_fd

; Disparo (CTRL_DESPLZ)="0".
Disparo_0 DEFB $01,$80
Disparo_0b DEFB $07,$e0 						; (No se imprime, detección de colisión).
; Disparo (CTRL_DESPLZ)="f9"
Disparo_f9 DEFB $00,$60
Disparo_f9b DEFB $01,$f8 						; (No se imprime, detección de colisión).
; Disparo (CTRL_DESPLZ)="fb" 
Disparo_fb DEFB $18,$00
Disparo_fbb DEFB $7e,$00 						; (No se imprime, detección de colisión).
; Disparo (CTRL_DESPLZ)="fd" 
Disparo_fd DEFB $06,$00
Disparo_fdb DEFB $1f,$80 						; (No se imprime, detección de colisión).

; ----------------------------------------------------------------------------------------

; Badsat_izq. 2x2.

Indice_Badsat_izq defw Badsat_izquierda
	defw Badsat_izq_fe
	defw Badsat_izq_fd
	defw Badsat_izq_fc
	defw Badsat_izq_fb
	defw Badsat_izq_fa
	defw Badsat_izq_f9
	defw Badsat_izq_f8

Badsat_izquierda DEFB $00,$08,$00
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
	DEFB 	$10,$00,$00	 ; Sprite principal a izquierda, (sin desplazar).

Badsat_izq_f8 DEFB $00,$04,$00,$01,$0A,$00,$01,$15
	DEFB	$00,$01,$2A,$80,$01,$55,$00,$01
	DEFB	$2A,$00,$3F,$F4,$00,$01,$B0,$00
	DEFB	$05,$70,$00,$0B,$FC,$00,$15,$F4
	DEFB	$00,$2A,$20,$00,$55,$30,$00,$2A
	DEFB	$00,$00,$14,$00,$00,$08,$00,$00 ; $F8 (7º DESPLZ a izquierda).

	org $8400

Badsat_izq_f9 DEFB $00,$02,$00,$00,$85,$00,$00,$8A
	DEFB	$80,$00,$95,$40,$00,$AA,$80,$00
	DEFB	$95,$00,$1F,$FA,$00,$00,$D8,$00
	DEFB	$02,$B8,$00,$05,$FE,$00,$0A,$FA
	DEFB	$00,$15,$10,$00,$2A,$98,$00,$15
	DEFB	$00,$00,$0A,$00,$00,$04,$00,$00 ; $F9 (6º DESPLZ a izquierda).

Badsat_izq_fa DEFB $00,$01,$00,$00,$42,$80,$00,$45
	DEFB	$40,$00,$4A,$A0,$00,$55,$40,$00
	DEFB	$4A,$80,$0F,$FD,$00,$00,$6C,$00
	DEFB	$01,$5C,$00,$02,$FF,$00,$05,$7D
	DEFB	$00,$0A,$88,$00,$15,$4C,$00,$0A
	DEFB	$80,$00,$05,$00,$00,$02,$00,$00 ; $Fa (5º DESPLZ a izquierda).

Badsat_izq_fb DEFB $00,$00,$80,$00,$21,$40,$00,$22
	DEFB	$A0,$00,$25,$50,$00,$2A,$A0,$00
	DEFB	$25,$40,$07,$FE,$80,$00,$36,$00
	DEFB	$00,$AE,$00,$01,$7F,$80,$02,$BE
	DEFB	$80,$05,$44,$00,$0A,$A6,$00,$05
	DEFB	$40,$00,$02,$80,$00,$01,$00,$00 ; $Fb (4º DESPLZ a izquierda).

Badsat_izq_fc DEFB $00,$00,$40,$00,$10,$A0,$00,$11
	DEFB	$50,$00,$12,$A8,$00,$15,$50,$00
	DEFB	$12,$A0,$03,$FF,$40,$00,$1B,$00
	DEFB	$00,$57,$00,$00,$BF,$C0,$01,$5F
	DEFB	$40,$02,$A2,$00,$05,$53,$00,$02
	DEFB	$A0,$00,$01,$40,$00,$00,$80,$00 ; $Fc (3er DESPLZ a izquierda).

Badsat_izq_fd DEFB $00,$00,$20,$00,$08,$50,$00,$08
	DEFB	$A8,$00,$09,$54,$00,$0A,$A8,$00
	DEFB	$09,$50,$01,$FF,$A0,$00,$0D,$80
	DEFB	$00,$2B,$80,$00,$5F,$F8,$00,$AF
	DEFB	$80,$01,$51,$00,$02,$A9,$00,$01
	DEFB	$51,$00,$00,$A0,$00,$00,$40,$00 ; $Fd (2º DESPLZ a izquierda).

	org $8500

Badsat_izq_fe DEFB $00,$00,$10,$00,$04,$28,$00,$04
	DEFB	$54,$00,$04,$AA,$00,$05,$54,$00
	DEFB	$04,$A8,$00,$FF,$D0,$00,$06,$C0
	DEFB	$00,$15,$C0,$00,$2F,$FC,$00,$57
	DEFB	$C0,$00,$A8,$80,$01,$54,$80,$00
	DEFB	$A8,$80,$00,$50,$00,$00,$20,$00 ; $Fe (1er DESPLZ a izquierda).


Indice_Badsat_der defw Badsat_derecha
	defw Badsat_der_f8
	defw Badsat_der_f9
	defw Badsat_der_fa
	defw Badsat_der_fb
	defw Badsat_der_fc
	defw Badsat_der_fd
	defw Badsat_der_fe

Badsat_derecha DEFB	$10,$00,$00
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
	DEFB	$00,$08,$00 ; Sprite principal a derecha, (sin desplazar).

Badsat_der_f8 DEFB $08,$00,$00,$14,$20,$00,$2A,$20
	DEFB	$00,$55,$20,$00,$2A,$A0,$00,$15
	DEFB	$20,$00,$0B,$FF,$00,$03,$60,$00
	DEFB	$03,$A8,$00,$0F,$F4,$00,$0B,$EA
	DEFB	$00,$01,$15,$00,$03,$2A,$80,$00
	DEFB	$15,$00,$00,$0A,$00,$00,$04,$00 ; $F8 (1er DESPLZ a derecha).

Badsat_der_f9 DEFB $04,$00,$00,$0A,$10,$00,$15,$10
	DEFB	$00,$2A,$90,$00,$15,$50,$00,$0A
	DEFB	$90,$00,$05,$FF,$80,$01,$B0,$00
	DEFB	$01,$D4,$00,$07,$FA,$00,$05,$F5
	DEFB	$00,$00,$8A,$80,$01,$95,$40,$00
	DEFB	$0A,$80,$00,$05,$00,$00,$02,$00 ; $F9 (2º DESPLZ a derecha).

Badsat_der_fa DEFB $02,$00,$00,$05,$08,$00,$0A,$88
	DEFB	$00,$15,$48,$00,$0A,$A8,$00,$05
	DEFB	$48,$00,$02,$FF,$C0,$00,$D8,$00
	DEFB	$00,$EA,$00,$03,$FD,$00,$02,$FA
	DEFB	$80,$00,$45,$40,$00,$CA,$A0,$00
	DEFB	$05,$40,$00,$02,$80,$00,$01,$00 ; $Fa (3er DESPLZ a derecha).

Badsat_der_fb DEFB $01,$00,$00,$02,$84,$00,$05,$44
	DEFB	$00,$0A,$A4,$00,$05,$54,$00,$02
	DEFB	$A4,$00,$01,$7F,$E0,$00,$6C,$00
	DEFB	$00,$75,$00,$01,$FE,$80,$01,$7D
	DEFB	$40,$00,$22,$A0,$00,$65,$50,$00
	DEFB	$02,$A0,$00,$01,$40,$00,$00,$80 ; $Fb (4º DESPLZ a derecha).

Badsat_der_fc DEFB $00,$80,$00,$01,$42,$00,$02,$A2
	DEFB	$00,$05,$52,$00,$02,$AA,$00,$01
	DEFB	$52,$00,$00,$BF,$F0,$00,$36,$00
	DEFB	$00,$3A,$80,$00,$FF,$40,$00,$BE
	DEFB	$A0,$00,$11,$50,$00,$32,$A8,$00
	DEFB	$01,$50,$00,$00,$A0,$00,$00,$40 ; $Fc (5º DESPLZ a derecha).

Badsat_der_fd DEFB $00,$40,$00,$00,$A1,$00,$01,$51
	DEFB	$00,$02,$A9,$00,$01,$55,$00,$00
	DEFB	$A9,$00,$00,$5F,$F8,$00,$1B,$00
	DEFB	$00,$1D,$40,$01,$FF,$A0,$00,$1F
	DEFB	$50,$00,$08,$A8,$00,$09,$54,$00
	DEFB	$08,$A8,$00,$00,$50,$00,$00,$20 ; $Fd (6º DESPLZ a derecha).

Badsat_der_fe DEFB $00,$20,$00,$00,$50,$80,$00,$A8
	DEFB	$80,$01,$54,$80,$00,$AA,$80,$00
	DEFB	$54,$80,$00,$2F,$FC,$00,$0D,$80
	DEFB	$00,$0E,$A0,$00,$FF,$D0,$00,$0F
	DEFB	$A8,$00,$04,$54,$00,$04,$AA,$00
	DEFB	$04,$54,$00,$00,$28,$00,$00,$10 ; $Fe (7º DESPLZ a derecha).

; ----------------------------------------------------------------------------------------

; Amadeus. 2x2.

Indice_Amadeus_der defw Amadeus
	defw 0	
	defw Amadeus_F9							; [$F9] right - [$FA] left 
	defw 0	
	defw Amadeus_Fb     					; [$FB] right - [$FC] left                     
	defw 0	
	defw Amadeus_Fd							; [$FD] right - [$FE] left 
	defw 0	 								; (Fín de índice).

Indice_Amadeus_izq defw Amadeus
	defw 0	
	defw Amadeus_Fd							; [$F9] right - [$FA] left 
	defw 0	
	defw Amadeus_Fb     					; [$FB] right - [$FC] left                     
	defw 0	
	defw Amadeus_F9							; [$FD] right - [$FE] left 
	defw 0	 								; (Fín de índice).

	org $8700

Amadeus DEFB $01,$80,0
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
	DEFB	$71,$8E,0 						; Sprite principal, (sin desplazar).

Amadeus_F9 DEFB	$00,$60,$00,$08,$F1,$00,$09,$99
	DEFB	$00,$09,$09,$00,$0B,$0D,$00,$1B
	DEFB	$6D,$80,$1B,$FD,$80,$19,$F9,$80
	DEFB	$39,$F9,$C0,$3C,$F3,$C0,$3D,$FB
	DEFB	$C0,$3F,$FF,$C0,$3E,$F7,$C0,$3E
	DEFB	$F7,$C0,$22,$F4,$40,$1C,$63,$80 ; $F9 (2º DESPLZ a derecha).

Amadeus_Fb DEFB	$00,$18,$00,$02,$3C,$40,$02,$66
	DEFB	$40,$02,$42,$40,$02,$C3,$40,$06
	DEFB	$DB,$60,$06,$FF,$60,$06,$7E,$60
	DEFB	$0E,$7E,$70,$0F,$3C,$F0,$0F,$7E
	DEFB	$F0,$0F,$FF,$F0,$0F,$BD,$F0,$0F
	DEFB	$BD,$F0,$08,$BD,$10,$07,$18,$E0 ; $Fb (4º DESPLZ a derecha).

Amadeus_Fd DEFB	$00,$06,$00,$00,$8F,$10,$00,$99
	DEFB	$90,$00,$90,$90,$00,$B0,$D0,$01
	DEFB	$B6,$D8,$01,$BF,$D8,$01,$9F,$98
	DEFB	$03,$9F,$9C,$03,$CF,$3C,$03,$DF
	DEFB	$BC,$03,$FF,$FC,$03,$EF,$7C,$03
	DEFB	$EF,$7C,$02,$2F,$44,$01,$C6,$38 ; $Fd (6º DESPLZ a derecha).

; ----------------------------------------------------------------------------------------

Indice_Explosion_entidades defw Explosion_entidades_1
	defw Explosion_entidades_2
	defw Explosion_entidades_3

Explosion_entidades_1 DEFB $00,$10,$00
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

	org $8800

Explosion_entidades_2 DEFB $08,$00,$00,$05,$38,$10,$03,$BC
	DEFB	$20,$06,$00,$C0,$04,$06,$C0,$00
	DEFB	$37,$00,$00,$7F,$00,$03,$DD,$80
	DEFB	$03,$FE,$00,$03,$3A,$70,$01,$9C
	DEFB	$60,$01,$F6,$40,$04,$F8,$80,$06
	DEFB	$00,$00,$08,$00,$00,$00,$00,$00

Explosion_entidades_3 DEFB $03,$18,$10,$04,$00,$20,$08,$00
	DEFB	$40,$00,$00,$C0,$00,$06,$00,$00
	DEFB	$15,$00,$08,$1E,$00,$00,$14,$30
	DEFB	$08,$66,$00,$00,$38,$00,$01,$08
	DEFB	$00,$01,$80,$00,$00,$80,$00,$04
	DEFB	$03,$20,$06,$00,$10,$08,$00,$20

; ------------------------------------------

Indice_Explosion_Amadeus defw Explosion_Amadeus_1
	defw Explosion_Amadeus_2
	defw Explosion_Amadeus_3

Explosion_Amadeus_1	DEFB $00,$18,$02
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

Explosion_Amadeus_2	DEFB $00,$18,$02
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

Explosion_Amadeus_3	DEFB $00,$00,$00
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

