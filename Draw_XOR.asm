; ------------------------------------------------------------------
;
; 19/8/26
;

Draw:

Inicializacion:

	ld hl,(Filas) 		 										; (Filas) en B.
	ld b,l 														; (Columns) en C.
	ld c,h

	ld hl,(Posicion_actual)
	ld a,h
	or l
	jr nz,Entidad_iniciada 										; Si el contenido de (Posicion_actual) es distinto de "0" la entidad ya se ha iniciado.

	call Inicia_Puntero_mov

	ld hl,(Posicion_inicio)
	ld (Posicion_actual),hl

	call Calcula_Cuad_objeto

	jr 3F

Entidad_iniciada:

	ld a,(Ctrl_0)
	bit 5,a
	jr nz,3F	 												; El bit(5) de (Ctrl_0) indica que hemos "reaparecido" por algún lado de la pantalla_
; 																; _y por lo tanto estamos lejos de los límites. No loscomprobamos.

	call Comprueba_limite_horizontal
	call Comprueba_limite_vertical

; Llegados a este punto, tengo Filas/Columns en BC y (Cuad_objeto) en A´.
; -----------------------
; -----------------------
; -----------------------

3 call calcula_CColumnass										; Define el valor de la variable (Columnas). Nº de columnas que se van a pintar de la entidad.
	call Calcula_puntero_de_impresion							; Después de ejecutar esta rutina tenemos el puntero de impresión en HL.

	ld a,(Ctrl_0)												; Antes de salir de la rutina restauramos los bits 0,1,2,3 y 5 de (Ctrl_0).
	and $d0									
	ld (Ctrl_0),a

	ret

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;   14/02/25
;
;	Calcula el cuadrante de pantalla donde se encuentra la entidad: (Cuad_objeto), "1", "2", "3" o "4".
;	Esta información es necesaria para poder calcular el (Puntero_de_impresion) de la entidad.
;
;	INPUT:  HL contiene (Posicion_actual).
;	OUTPUT: (Cuad_objeto) y A contienen "1", "2", "3" o "4" en función del cuadrante de pantalla en el que se encuentra la entidad.		
;
;	MODIFY: A.	


Calcula_Cuad_objeto:

	call calcula_tercio

;	Ahora tenemos "0", "1" o "2" en el acumulador en función del tercio de pantalla en el que nos encontremos.

	jr z,Primer_tercio 													

	dec a

	jr z,Segundo_tercio

Tercer_tercio:

	call Determina_lado_de_pantalla

	jr nz,1F

	ld a,4
	ld (Cuad_objeto),a

	ret

1 ld a,3
	ld (Cuad_objeto),a

	ret	

Primer_tercio:

	call Determina_lado_de_pantalla

	jr nz,3F

	ld a,2
	ld (Cuad_objeto),a

	ret

3 ld a,1
	ld (Cuad_objeto),a

	ret

Segundo_tercio:

	ld a,l
	cp $7f
	jr c,Primer_tercio
	jr z,Primer_tercio

	jr Tercer_tercio

; ------------------------------------
;
;	OUTPUT: A contiene "0" si estamos en la mitad derecha de la pantalla y "1" si estamos en la mitad izquierda.
;

Determina_lado_de_pantalla:

	ld a,l
	and $1f
	cp $10
	jr c,1F

	xor a

	ret

1 ld a,1

	ret

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;	19/8/26
;
; 	Comprueba_limite_horizontal.
;
;	INPUT: HL contiene (Posicion_actual).

Comprueba_limite_horizontal:

	ld e,0											; Inicializamos E. El registro actuará como un byte de control indicando:
;
;													; (E) = "0". Indica que no llegamos al centro HORIZONTAL de la pantalla.
; 													; (E) = "1". Indica que hemos MODIFICADO la (Posicion_actual) y (Cuad_objeto) de la entidad.
; 													;            Hemos superado el LÍMITE HORIZONTAL.
; 													; 			 Pasamos del cuadrante (1) al (3) o viceversa.
; 													; 			 Pasamos del cuadrante (2) al (4) o viceversa.
;
; 													;            (Posicion_actual) pasará de señalar las esquinas inferiores del Sprite a las superiores o viceversa.
;
; 													; 			 (call PreviousScan) 15 rep.
; 													;  			 (call NextScan) 15 rep.
; 													;
; 													; (E) = "2". Indica que Hemos superado el centro de la pantalla pero NO HEMOS superado el LÍMITE HORIZONTAL.
;													; 			 Mantenemos (Cuad_objeto) y (Posicion_actual).
; 													; 			 Esta información es indispensable a la hora de modificar la situación del Sprite cuando superamos_
; 													;            _el LÍMITE VERTICAL , [Comprueba_limite_vertical].


;	Exclusiones !!!

	call calcula_tercio  							; RET cuando no estamos en el centro de la pantalla, (2º tercio).
	ret z

	dec a
	dec a
	ret z

; ----------------------------------- Comprobamos límite.

;	HL (Posicion_actual).
;	E=0

	ld a,(Cuad_objeto)
	cp 2
	jr z,1F
	jr c,1F

;	Nos encontramos en la parte INFERIOR de la pantalla.
;	En este caso superamos el CENTRO de la pantalla cuando L < $80

	ld a,$7f 
	sub l
	ret c			 								; RET no hemos llegado al centro de la pantalla, E=0.								
										
	ld e,2											; Indica que hemos superado el centro de la pantalla.

	ld a,$3f 										; (Limite_horizontal) = "$3f".
	sub l
	ret c											; RET con E=2. E2 indica que estamos en la zona NEBULOSA de la pantalla pero no superamos el límite horizontal.

	call Modificaccionne 							; Modificamos (Posicion_actual).
;
;													; (Posicion_actual) pasa de indicar el byte de la esquina inferior, (izq. o derecha), a indicar_
; 													; _el byte de la esquina superior, (izq. o derecha). (call PreviousScan 15 rep.).

	ld a,(Cuad_objeto)
	inc a
	inc a
	ld (Cuad_objeto),a 								; Pasamos del cuadrante (1 o 2) al cuadrante (3 o 4).

	dec e

	ret												; RET con E=1.

;	Nos encontramos en la parte SUPERIOR de la pantalla.
;	En este caso superamos el CENTRO de la pantalla cuando L => $80.

1 ld a,$80
	sub l
	ret nc											; RET no hemos llegado al centro de la pantalla, E=0.

	ld e,2											; Zona NEBULOSA que no es poca cosa.

;	
	ld a,$c0 					 					; (Limite_horizontal) = "$c0".
	sub l
	ret nc 											; RET Estamos en zona nebulosa horizontal, no hemos superado (Limite_horizontal). E=2.

	call Modificaccionne

	ld a,(Cuad_objeto)
	dec a
	dec a
	ld (Cuad_objeto),a

	dec e 											; Hemos modificado (Posicion_actual) debido a que hemos superado el (Limite_horizontal). E=1.

	ret												

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;
;   22/8/26
;
;	Comprueba_limite_vertical
;
; 	Si (E)="1" significa que en la anterior rutina [Comprueba_limite_horizontal] hemos actualizado (Posicion_actual) y (Cuad_objeto) porque hemos pasado_
;	_de la parte alta de pantalla a la parte baja o viceversa.
;
;	Si (E)="0" No ha habido cambio de zona de pantalla por lo que (Posicion_actual) y (Cuad_objeto) están actualizados.
;
;	(E)="2". (Cuad_objeto) no está actualizado pues estamos en el centro de pantalla pero no hemos sobrepasado el límite horizontal.
;
;	FUNCIONAMIENTO:
;
;	Si superamos el límite vertical:
;
;	Si (E)="0" o "1" actualizaremos (Posicion_actual) y (Cuad_objeto) sin modificar (E).
;	Si (E)="2" actualizaremos (Posicion_actual) y sumaremos +1 a (E), ((E) = "3").
;
;	Esta información, (E) = "3" indica a [Calcula_puntero_de_impresion]:
;
;	(Cuad_objeto) = "1": El puntero de impresión se obtiene actualizando (Posicion_actual), (-15 Scanlines).
;	(Cuad_objeto) = "2": El puntero de impresión se obtendrá restando (Columnas-1) a L y actualizando (Posicion_actual), (-15 Scanlines).
;	(Cuad_objeto) = "3": El puntero de impresión está actualizado.
;	(Cuad_objeto) = "4": El puntero de impresión está actualizado.


;	Modifica el registro L del puntero de pantalla cuando se sobrepasa la columna límite, (Limite2).
;	Dependiendo del cuadrante en el que nos encontremos, sumaremos o restaremos, (Columnas-1) a L.
;
;	INPUT: HL contiene (Posicion_actual).

Comprueba_limite_vertical:

	ld a,(Cuad_objeto)
	and 1
	jr z,2F

; 	Si (E)="1" significa que en la anterior rutina [Comprueba_limite_horizontal] hemos actualizado (Posicion_actual) y (Cuad_objeto) porque hemos pasado_
;	_de la parte alta de pantalla a la parte baja o viceversa.

;	Si (E)="0" No ha habido cambio de zona de pantalla por lo que (Posicion_actual) y (Cuad_objeto) están actualizados.

;	(E)="2". (Cuad_objeto) no está actualizado pues estamos en el centro de pantalla pero no hemos sobrepasado el límite horizontal.

;	Nos encontramos en la parte IZQUIERDA de la pantalla.
;	-----------------------------------------------------

	ld a,$13
	ex af,af

	call Comprobacion
	ret nc

;	Cambiamos de cuadrante, hemos superado (Limite_vertical).
;	Pasamos de la mitad izquierda de la pantalla a la mitad derecha.

	dec c											; (Columns-1) en C.

	ld a,l
	sub c
	ld (Posicion_actual),a

	ld a,e
	and 2
	jr nz,3F

	ld a,(Cuad_objeto)
	inc a
	ld (Cuad_objeto),a

	ret

;	Nos encontramos en la parte DERECHA de la pantalla.
;	-----------------------------------------------------

2 ld a,$0c
	ex af,af

	call Comprobacion
	ret c

;	Cambiamos de cuadrante, hemos superado (Limite_vertical).
;	Pasamos de la mitad derecha de la pantalla a la mitad izquierda.

	dec c											; (Columns-1) en C.

	ld a,l
	add c
	ld (Posicion_actual),a

	ld a,e
	and 2
	jr nz,3F

	ld a,(Cuad_objeto)
	dec a
	ld (Cuad_objeto),a

	ret

3 inc e

	ret

; ----- ----- ----- ----- -----

Comprobacion:

	ld a,l
	and $1f
	ld d,a

	ex af,af
	sub d

	ret

; --------------------------------------------------------------------------
;
;	19/8/26
;
;	Modifica (Posicion_actual). 
;
;	En función de la mitad de pantalla de la que partamos:
;
;	CALL [Modifica_Pos_actual], si partimos de la mitad superior de la pantalla. 
;	CALL [Modifica_Pos_actual2], si partimos de la mitad inferior de la pantalla.
;
;	INPUTS: HL contiene (Posicion_actual).
;	OUTPUT: Actualiza (Posicion_actual).
;	MODIFY: A y HL.



Modificaccionne:
	
	ld a,(Cuad_objeto)
	cp 2
    call z,Modifica_Pos_actual                      ; Si por el contrario estamos en la mitad inferior, call Modifica_Pos_actual2.
    ret z

    call c,Modifica_Pos_actual
	ret z

	call Modifica_Pos_actual2
    ret

Modifica_Pos_actual:

	ld b,15                         				; Scanlines-1 en B.
1 call PreviousScan
	djnz 1B

	ld (Posicion_actual),hl
	xor a 											; Carry a "0". Evita que vuelva a entrar consecutivamente.

	ret

Modifica_Pos_actual2:

	ld b,15                        					; Scanlines-1 en B.
1 call NextScan
	djnz 1B

	ld (Posicion_actual),hl
	xor a 											; Fijo el acarreo a "0" para asegurarme de no volver a entrar en la rutina.

	ret

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

Salida_nebulosamente_por_la_derecha

;	E=2. Estamos en la zona nebulosa horizontal. Existe posibilidad de salida por el lado derecho ???

	ld a,(Posicion_actual)
	and $1f
	cp $1e
	ret c

; 	Existe posibilidad de desaparecer por el lado derecho de la pantalla. Si (Cuad_objeto) indica que_
;	_estamos en la parte izquierda de la pantalla, (1/3), la salida será defectuosa. 

	ld a,(Cuad_objeto)
	and 1
	ret z 											; RET. (Cuad_objeto) indica el cuadrante correcto. No habrá problemas en la salida.

	ld a,(Cuad_objeto)
	inc a
	ld (Cuad_objeto),a 								; Corregimos (Cuad_objeto) y activamos FLAG para que no haya llamada a [Inicializacion] más adelante.

	dec c											; (Columns-1) en C.
	ld a,l
	sub c
	ld (Posicion_actual),a

	dec e
	dec e 											; E=0 , evita que ejecutemos [Salida_nebulosamente_por_la_izquierda].

	ret

Salida_nebulosamente_por_la_izquierda

;	E=2. Estamos en la zona nebulosa horizontal. Existe posibilidad de salida por el lado izquierdo ???.

	ld a,(Posicion_actual)
	and $1f
	cp $01
	ret nc
	ret nz

; 	Existe posibilidad de desaparecer por el lado izquierdo de la pantalla. Si (Cuad_objeto) indica que_
;	_estamos en la parte derecha de la pantalla, (2/4), la salida será defectuosa. 

	ld a,(Cuad_objeto)
	and 1
	ret nz 											; RET. (Cuad_objeto) indica el cuadrante correcto. No habrá problemas en la salida.

	ld a,(Cuad_objeto)
	dec a 
	ld (Cuad_objeto),a 								; Corregimos (Cuad_objeto) y activamos FLAG para que no haya llamada a [Inicializacion] más adelante.

	dec c											 				; (Columns-1) en C.
	ld a,l
	inc c
	ld (Posicion_actual),a

	ret

; --------------------------------------------------------------------------------------------------------------------
;
; 	3/2/25
;
;	Modify: A.
;	
;	INPUT: A contiene el byte bajo de (Posicion_actual).
;	OUTPUT: (Columnas).
;	

calcula_CColumnass:

	ld a,(Posicion_actual)
	and $1f
	jr z,One_CColumna
	dec a
	jr z,Due_CColumna
	inc a
	cp $1e
	jr c,one_or_due_ccolumnas
	jr z,Due_CColumna
	jr One_CColumna

one_or_due_ccolumnas ld a,(Columns)
	ld (Columnas),a
	ret

Due_CColumna ld a,2
	jr 1F
One_CColumna ld a,1
1 ld (Columnas),a
	ret

; --------------------------------------------------------------------------------------------------------------------
;
;   2/3/25
;
;	Calcula el puntero de impresión del sprite, (arriba-izquierda).
;
;	OUTPUT: IX Contienen el puntero de impresión.
;			HL e IY Contienen (Puntero_objeto).
;
;	DESTRUYE: HL,B Y A.	

Calcula_puntero_de_impresion:

	ld a,(Cuad_objeto)
	and 1
	jr nz,Lado_izquierdo

Lado_derecho

	ld a,(Cuad_objeto)
	dec a
	dec a
	jr z,Cuadrante_dos
	jr Cuadrante_cuatro

Lado_izquierdo

	ld a,(Cuad_objeto)
	srl a
	jr z,Cuadrante_uno 

; Estamos situados en el 3er cuadrante de pantalla. ----- ----- -----

	call Operandos									; (Posicion_actual) en HL y (Columnas)-1 en B.

	ld a,l
	and $1f
	jr z,4F

6 dec hl
	djnz 6B

	jr 4F

Cuadrante_cuatro

	ld hl,(Posicion_actual) 
	jr 4F

Cuadrante_uno

	call Operandos									; (Posicion_actual) en HL y (Columnas)-1 en B.

	ld a,l
	and $1f
	jr z,3F

1 dec hl
	djnz 1B

3 ld b,15
2 call PreviousScan
	djnz 2B

	jr 4F

Cuadrante_dos

	call Operandos									; (Posicion_actual) en HL y (Columnas)-1 en B.
	ld b,15
5 call PreviousScan
	djnz 5B

4 ld (Puntero_de_impresion),hl

	push hl
	pop ix

	ld hl,(Puntero_objeto)

	push hl
	pop iy

	ret

; --------------------------------------------------------------------------------------------------------------------
;
;	2/1/23
;
;	Sub-rutina de [Calcula_puntero_de_impresion].
;	
;	Tras esta rutina tenemos:
;
;	OUTPUT: HL contiene (Posicion_actual).
;			B contiene (Columnas)-1. Nota: Este valor `nunca' será "0". El valor mínimo es "1".
;
;	DESTRUYE!!!!! HL,B y A.

Operandos:

	ld hl,(Posicion_actual)
	ld a,(Columnas)
	dec a
	jr nz,1F
	inc a
1 ld b,a
	ret

; --------------------------------------------------------------------------------------------------------------------
;
;	Prepara_draw
;
;	Es una rutina de carga.
;	Carga los registros BC,HL y E para posteriormente llamar a la rutina de pintado [DRAW].
;	
;	OUTPUT:
;
;	- LD (Filas/Columns) del objeto a pintar en [BC].
;	- LD (Posicion_actual) del objeto en [HL].
;
;	MODIFY: HL y BC.

Prepara_draw:

	ld hl,Filas 		 							; Prepara los registros BC, E y HL.
	ld b,(hl) 										; Carga Filas/Columns del objeto a pintar o inicializar en BC.

	inc hl 											; Carga (Posicion_actual) en HL.

	ld c,(hl)

	ld hl,(Posicion_actual)

	ret

;----------------------------------------------------------------------------------------------------------------
;
;	5/08/22
;
;   NextScan. 
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el siguiente scanline. (Inc H, línea abajo).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el siguiente scanline.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

NextScan:

	inc h          							; Incrementamos el scanline.
    ld a,h
    and 7
    ret nz              							; Salimos de la rutina si el scanline se encuentra entre (1-7).

	ld a,l              							; Scanlines a "0", cambiamos de tercio. (Siempre que estemos en la última línea, LLL).
    add a,$20           							; Vamos a comprobarlo...
    ld l,a
    ret c               							; Salimos si se produce el cambio de tercio.

    ld a,h              							; No estamos en la última línea del tercio, por lo que inicializamos H restando una_
    sub 8               							; _unidad a los bits que definen el tercio TT, (sub $08).
    ld h,a
    ret

;----------------------------------------------------------------------------------------------------------------     
;
;	5/08/22
;
;   PreviousScan.
;
;   Calcula la dirección de mem. de pantalla donde se sitúa el scanline anterior. (Dec H, línea arriba).
;
;   INPUT: HL contendra la dirección de mem. de video sobre la que queremos calcular el scanline anterior.
;
;   OUTPUT: HL contendrá la nueva dirección de memoria de pantalla.
;
;       DESTRUIDOS: AF y HL !!!
;
;   010T TSSS LLLC CCCC (Codificación de la memoria de pantalla). $4000 - $57FF, (256 x 192 pixeles).  
;

PreviousScan:

	ld a,h
    dec h               							; Dec H.
    and 7
    ret nz              							; Salimos de la rutina si el scanline se encuentra entre (1-7).

    ld a,l              							; Estabamos en el scanline "0" y al decrementar nos situamos en el "7" y cambiamos de tercio.
    sub $20             							; Vamos a comprobarlo...
    ld l,a
    ret c               							; Salimos si estábamos en la primera línea y se produce el cambio de tercio.

    ld a,h              							; No estamos en la primera línea del tercio, por lo que inicializamos H sumando una_
    add a,8             							; _unidad a los bits que definen el tercio TT, (add a,$08).
    ld h,a
    ret

; -----------------------------------------------------------------
;
;	4/4/25
;
;	Limpia un espacio de la memoria.
;
;	INPUTS:  HL apunta al 1er byte del espacio de memoria que queremos limpiar.
;				   BC indica el nº de bytes que vamos a poner a "0".
;
;	MODIFY: HL,DE,BC

Clean_mem:

	ld (hl),0

	push hl
	pop de

	inc de

	ldir

	ret








