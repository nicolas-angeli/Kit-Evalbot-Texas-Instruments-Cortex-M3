		AREA    |.text|, CODE, READONLY, ALIGN=2

	
		
__main	PROC
		EXPORT	__main
		entry

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;VOTRE CODE




			ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    definition des constantes

	AREA constants, DATA, READONLY 
tab1	DCB  1,2,3,4,5
		ALIGN
val1  	DCD  0x12345678


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    reservations pour variables

	AREA variables, DATA, READWRITE 

resu	SPACE 10


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			END