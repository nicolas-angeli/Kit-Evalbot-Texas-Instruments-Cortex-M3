; programme delay
val EQU 5320
		PRESERVE8
		AREA    |.text|, CODE, READONLY			
		align
			
				
delay
		export delay
			
		push {lr,r0,r5,r4}
		cpy r5,r0
bouc_ext

		mov r4,#5230
		
bouc_int		
		nop
		subs r4,#1
		bne bouc_int
		
		subs r5,r5,#1
		bne bouc_ext
		
		pop {lr,r0,r5,r1}
		ldr r2,=0x10101010
		
		bx lr

		END