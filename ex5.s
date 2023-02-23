
; Programme pour calculer le factoriel d'un entier n.
	
	AREA 	|.text|, CODE, READONLY

n 	EQU 	0x4

init	EQU		0x0
init1	EQU		0x1

	ENTRY 	; specifies the beginning of program

	EXPORT 	__main

__main

; chargement de n dans le registre R1
	LDR 	R1, =n

; initialisation des conteurs	
	LDR 	R7, =init1	; conteur b = 1
	LDR 	R8, =init1	; conteur i = 1

; begin
	LDR 	R4, =init1	; a = 1

repeat1					; pour b de 1 à n faire
	LDR 	R2, =init	; fact = 0
	
repeat2					; pour i de 1 à b faire

	ADDS R2, R4			; fact = fact + a
	ADDS R8, #1			; i = i + 1
	
	CMP R8, R7			; comparaison de i et b
	BLS repeat2 		; aller à l’étiquette repeat2 si la condition LS est vraie (i <= b)
	
	MOV 	R4, R2		; a = fact
	
	ADDS R7, #1			; b = b + 1
	LDR 	R8, =init1	; conteur i = 1
	CMP R7, R1			; comparaison de i et b
	BLS repeat1 		; aller à l’étiquette repeat1 si la condition LS est vraie (b <= n)
	
	NOP

	END 	; end of program