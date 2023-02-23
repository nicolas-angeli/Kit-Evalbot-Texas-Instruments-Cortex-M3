	AREA 	|.text|, CODE, READONLY

a 	EQU 	0x7
b 	EQU 	0x3
c 	EQU 	0x4

	ENTRY 	; specifies the beginning of program

	EXPORT 	__main

__main

	n
init1
_main
AREA
EQU
EQU
1.text], CODE, READONLY
0x4
0x1
; n represente la taille du tableau
; specifies the beginning of program
; pointe vers les donnËes, en zone READONLY (CODE)
; pointe vers les donnÈes en zone READWRITE (IRAM)
; recopie tab_r depuis la zone READONLY
; vers tab_rw reserve dans la zone READWRITE
; # partir de 1# on peut lire Ecrire
; conteur i = 1
; max = Tab [1]
; pour i de 2n faire
; Temp = Tab[i]
; comparaison de Tab[i] et max, adressage indirect
; aller #liEtiquette Inst1 si la condition LE est
; branchement inconditionnel # lÌtiquette
ENTRY
EXPORT _main
LDR
R1,=tab_r
LDR
LDR
R2, tab_rw
R3, [R1]
R3, [R2]
STR
chargement de n dans le registre R5
LDR R5, =n
; initialisation du conteur
LDR R6, init1
; begin
LDRB
R8, [R2]
repeat
LDRB
R7, [R2,R6]
R7, R8
CMP
avec index
BLS
Inst?
vraie (Tab[i] >= min)
B
Inst2
AUTAN
Inst1
LDRB
R7, [R2,R6]
R7, R8
; Temp = Tab[i]
CMP
; comparaison de Tab[i] et max, adressage indirect
avec index
BLS
Inst2
; aller #liEtiquette Inst1 si la condition LE est
vraie (Tab[i] >= min)
B
; branchement inconditionnel # li»tiquette
Inst2
Inst1
MOV R8, R7
; max = Tab[i]
Inst2
ADDS
R6, #1
; i=i+1
CMP
R6, R5
; comparaison de i et n
BLO
repeat
; aller # lÌEtiquette repeat si la condition LO
est vraie (i < n)
NOP
AREA
constantes, DATA, READONLY
tab_r
DCB
2,7,6,15; tableau d'entiers stockE en zone ReadOnly directement la
suite du code
AREA
variables, DATA, READWRITE; zone ReadWrite, situEe par dÈfaut, á l'adresse
9x29998008
tab_
space
; definit 4 octets dans la zone de donntes initialises + zEro
; end of program
END
Inst1

