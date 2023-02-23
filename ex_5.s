

; BUMPERS  - LEDs
   	
		AREA    |.text|, CODE, READONLY
 
; This register controls the clock gating logic in normal Run ;mode SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf

SYSCTL_PERIPH_GPIOF EQU		0x400FE108

; The GPIODATA register is the data register
; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de ;lm3s9B92.pdf

GPIO_PORTF_BASE		EQU		0x40025000
GPIO_PORTD_BASE		EQU		0x40007000


; configure the corresponding pin to be an output
; all GPIO pins are inputs by default
; GPIO Direction (p417 datasheet de lm3s9B92.pdf

GPIO_O_DIR   		EQU 	0x400

; The GPIODR2R register is the 2-mA drive control register
; By default, all GPIO pins have 2-mA drive.
; GPIO 2-mA Drive Select (p428 datasheet de lm3s9B92.pdf)

GPIO_O_DR2R   		EQU 	0x500  

; Digital enable register
; To use the pin as a digital input or output, the ;corresponding GPIODEN bit must be set.
; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

GPIO_O_DEN   		EQU 	0x51C  

; Registre pour activer les switchs  en logiciel (par défaut ;ils sont reliés �  la masse donc inactifs)

GPIO_PUR			EQU		0x510

; Port select - LED1 et LED2 sur la ligne 4 et 5 du port F

PORT_F45              EQU		0x30

; Port select - LED 2 sur la ligne 5 du port F

PORT_F5               EQU     0x20

; Port select - LED 1 sur la ligne 4 du port F

PORT_F4				EQU		0x10

; PORT E : selection des SWITCH 1 et 2,LIGNE  du Port D

PORT_E01				EQU		0xC0

; PORT E : selection du SWITCH1, LIGNE 6 du Port D

PORT0				EQU		0x40

; PORT E : selection du SWITCH2, LIGNE 6 du Port D

PORT1               EQU     0x80

; Instruction : aucune LED allumée

NOL2D				EQU		0x00

; Instruction : LED 1 allumée, ligne 4, du port F

LED1				EQU		0x10

; blinking frequency, non utile dans ce programme

DUREE   			EQU     0x002FFFFF	

	  	ENTRY
		EXPORT	__main
__main	

;clock sur GPIO F où sont branchés les leds et GPIO D sur ;lequel sont branchés les SW : 0x38 == 000101000)
; Enable the Port F and D,  peripheral clock by setting the ;corresponding bits,(p291 datasheet de lm3s9B96.pdf), ;GPIO::FEDCBA)
		
		ldr r6, = SYSCTL_PERIPH_GPIOF  		
        	mov r0, #0x00000038  				

	      str r0, [r6]

;"There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
;tres tres important....;; pas necessaire en simu ou en debbug ;step by step...

		nop	   									
		nop	   
		nop	   									
	
; CONFIGURATION LED

        	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DIR    

; une broche (Pin) du portF en sortie (broche 4 et 5 : 00110000)

		ldr r0, = PORT_F45	
        	str r0, [r6]
		;ldr r0, = PORT_F5
		    ;str r0, [r8]  ; r8 contient sortie du PORT_F5

; Enable Digital Function 	

        	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DEN	
        	ldr r0, = PORT_F45 		
        	str r0, [r6]
			
; Choix de l'intensité de sortie (2mA)	

		ldr r6, = GPIO_PORTF_BASE+GPIO_O_DR2R	
        	ldr r0, = PORT_F45		
		str r0, [r6]
		
; pour eteindre LED

 		mov r2, #0x000          

; Enable Digital Function - Port D

		ldr r7, = GPIO_PORTD_BASE+GPIO_O_DEN	
        	ldr r0, = PORT_E01		
        	str r0, [r7]	

; Activer le registre des SWITCHS, Port D

		ldr r7, = GPIO_PORTD_BASE+GPIO_PUR	
        	ldr r0, = PORT_E01
        	str r0, [r7]

;Lire dans R5 l'etat du SWITCH1 et dans R10 l'état du SWITCH2

loop			


			mov r3, #PORT_F45       				
			ldr r6, = GPIO_PORTF_BASE + (PORT_F45<<2)
			str r3,[r6]


			
;lecture de l'état du SWITCH1

			ldr r7,= GPIO_PORTD_BASE + (PORT0<<2)
			ldr r5, [r7]
 
;lecture de l'état du SWITCH2

            ldr r9, =  GPIO_PORTD_BASE + (PORT1<<2)
			ldr r10, [r9]

;Traitement qui allume/éteint la LED1 et la LED2 en fonction de l'état  ;du SW1, la LED1 est initialement allumée, et s'éteint si SW1 ;est activé = appuyé

;si SWITCH 1 est actif (=0), on éteint la LED1

			cmp	r5,#0x40      
			bne	led1_OFF
			
;si SWITCH 2 est actif (=0), on éteint la LED2

			cmp r10,#0x80
			bne   led2_OFF

			str r3, [r6]          ; allume les leds 1 et 2
			b	loop
	
;étiendre LED1

led1_OFF		
			ldr r6, = GPIO_PORTF_BASE + (PORT_F4<<2) 
			str r2, [r6]          ; éteint la led 1
			ldr r1, = DUREE 					;; pour la duree de la boucle d'attente1 (wait1)

wait1		subs r1, #1
        	bne wait1
			b	loop	
			
;éteindre LED2

led2_OFF      ldr r6, = GPIO_PORTF_BASE + (PORT_F5<<2)
			str r2, [r6]          ; éteint la led 2
			ldr r1, = DUREE 					;; pour la duree de la boucle d'attente1 (wait1)

wait2		subs r1, #1
        	bne wait2
            b   loop
			nop		
     		   	END 