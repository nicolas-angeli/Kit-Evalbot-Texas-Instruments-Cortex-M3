	AREA 	|.text|, CODE, READONLY

a 	EQU 	0x7
b 	EQU 	0x3
c 	EQU 	0x4

	ENTRY 	; specifies the beginning of program

	EXPORT 	__main

__main

	LDR R1, =a
	LDR R2, =b
	LDR R3, =c

	CMP R1, R2
	BHS Inst1
	MOV R5, R2
	B fsi1

Inst1
	MOV R5,R1
fsi1
	CMP R3, R5
	BHS Inst2

	B fsi2
Inst2
		MOV R5,R3
	LDR R6,=max
		STRB R5,[R6]
fsi2
	LDR R6,=max
		STRB R5, [R6]

	NOP

		AREA	result, DATA, READWRITE
max SPACE	1
	END
