		AREA text, CODE, READONLY
a	EQU 0x1
b	EQU 0xA
	ENTRY
	EXPORT main
main
	LDR	R1, =a
	LDR	R2, =b
while
	CMP R1, R2
	BEQ fin
	ADD	R1, #1
	B while
fin
	NOP
	END