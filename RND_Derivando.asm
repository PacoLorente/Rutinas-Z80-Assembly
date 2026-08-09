; ****************************************************************************************************************************************************************************************** 
;
;   9/8/26
;      
;   Construyo un nº aleatorio. Método: "DERIVANDO."
;   (XOR) bit a bit.
;
;   INPUTS: B contendrá el nº de números aleatorios que queremos generar, (0-$ff).
;                 HL contendrá la dirección de mem. donde vamos a almacenar los (B) nº RND. 

Derivando_RND:

3 ld a,r      			                ; La semilla inicial de nuestro nº aleatorio la proporciona el registro `R´. Cargamos A con R.

    push bc
;                                       ; El registro R, es un registro de 8 bits que actúa como contador de refresco de la memoria dinámica. ($00 - $ff).
    ld bc,$0700                         ; C contendrá nuestro nº aleatorio: $0 - $ff. Inicialmente está a "0".
;                                       ; B actuará como contador de bits. Requerimos de 1 byte, ($ff).

6 and a                                 ; Carry a "0".
    srl a                               ; Rotación a la derecha.
    jr nc,1F

    set 0,c    

1 ld d,a                                ; D contiene la copia de nuestra semilla después de la rotación.

    and %00000001                       ; Extraigo bit(0) de r(srl) y lo guardo en E.
    ld e,a
 
    ld a,d
    and %00000010                       ; Extraigo bit(1) de r(srl).

    jr z,2F
 
    srl a

2 xor e                                 ; Realizamos una FUNCIÓN XOR entre el bit(0) y bit (1) de nuestro número aleatorio desplazado.

;   FUNCIÓN XOR

;   0 0 ..... 0
;   0 1 ..... 1
;   1 0 ..... 1
;   1 1 ..... 0

    ld a,d                              ; A vuelve a contener la copia de nuestra semilla después del DESPLAZAMIENTO.

    jr z,4F

    set 7,a
    jr 5F

4 res 7,a

5 sla c
    djnz 6B

    ld (hl),c

    inc hl

    pop bc
    djnz 3B       
    
    ret

    
