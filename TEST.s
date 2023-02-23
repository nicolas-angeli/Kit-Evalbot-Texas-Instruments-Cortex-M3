	AREA     |.pgm|, CODE, READONLY

n   EQU     8


    ENTRY     ; specifies the beginning of program

    EXPORT     main

main

        LDR R1,=tab1
        LDR R2,=tab2
        MOV R4,#n
        MOV R5,#0
Cont
        LDRB R3,[R1,R5]
        STRB R3,[R2,R5]
        ADDS R5,#1
        CMP R5,R4
        BNE Cont
        MOV R5,#1
        LDRB R8,[R2]
        LDRB R9,[R2]
bou
        LDRB R7,[R2,R5]
        CMP R7,R8
        BGE Inst1
        B Inst2
Inst1    MOV R8,R7
Inst2    CMP R7,R9
        BLE Inst3

        B Inst4
Inst3        MOV R9,R7
Inst4        ADD R5,#1
        CMP R5,R4
        BLO bou
        LDR R2,=res
        STRB R8,[R2]
        LDR R3,=res1
        STRB R9,[R3]
        NOP
    AREA     |.constants|, DATA, READONLY

tab1    DCB        8,6,4,2,0x01,0x2B,22,0x3E

    AREA |.variable|, DATA, READWRITE

res        SPACE        4
res1    SPACE        2
tab2    SPACE        10
        END