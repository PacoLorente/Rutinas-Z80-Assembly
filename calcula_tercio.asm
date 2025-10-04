; ******************************************* Indica el tercio de pantalla en el que nos encontramos según el valor del registro H ********************************************************
; 
;	NOTA: Entrega "0", "1" o "2" en A en función del tercio en el que nos encontremos.
;
; *****************************************************************************************************************************************************************************************
; 010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  

calcula_tercio: ld a,h
	and $18
	sra a
	sra a
	sra a
	ret

; -----------------------------------------------------------------------------------------
;
;   04/11/22
;
;   Entrega una dirección de ATRIBUTOS de pantalla en HL a partir de una dirección de pantalla, dada en HL.
;
;   INPUT: HL contiene la dirección de memoria de pantalla.
;   OUTPUT: HL contiene la dirección de ATRIBUTOS de pantalla de la dirección que contenía HL.
;
;   DESTRUYE: HL y A. !!!!! 

Calcula_direccion_atributos: call calcula_tercio
    ld h,$58
    add h
    ld h,a
    ret
