; Evalbot (Cortex M3 de Texas Instrument
; programme - permettant de faire allumer la LED1 connectée au ; port GPIOF, un appui sur SW1, l'éteint
   	
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
; GPIO 2-mA Drive Select - p428 datasheet de lm3s9B92.pdf
GPIO_O_DR2R   		EQU 	0x500  

; Digital enable register
; To use the pin as a digital input or output, the ;corresponding GPIODEN bit must be set.
; GPIO Digital Enable - p437 datasheet de lm3s9B92.pdf
GPIO_O_DEN   		EQU 	0x51C  

; Registre pour activer les switchs  en logiciel - par défaut ;ils sont reliés à la masse donc inactifs
GPIO_PUR			EQU		0x510
; Port select - LED1 sur la ligne 4 du port 
PORT4				EQU		0x30		

; PORT D : selection du SW1,LIGNE 6 du Port D
PORT6				EQU		0x80

; Instruct<ion : aucune LED allumée
NOLED				EQU		0x00
; Instruction : LED 1 allumée, ligne 4, du port F
LED1				EQU		0x30

; blinking frequency, non utile dans ce programme
;DUREE   			equipe

	  	ENTRY
		EXPORT	__main
__main	
;clock sur GPIO F où sont branchés les leds et GPIO D sur ;lequel sont branchés les SW : 0x28 == 000101000)
; Enable the Port F and D,  peripheral clock by setting the ;corresponding bits,(p291 datasheet de lm3s9B96.pdf), ;GPIO::FEDCBA)
		
		ldr r6, = SYSCTL_PERIPH_GPIOF  		
        	mov r0, #0x00000028  				

	      str r0, [r6]

;"There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
;tres tres important....;; pas necessaire en simu ou en debbug ;step by step...
		nop	   									
		nop	   
		nop	   									
	
; CONFIGURATION LED1 
        	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DIR    

; une broche (Pin) du portF en sortie (broche 4 : 00010000)
		ldr r0, = PORT4 	
        	str r0, [r6]

; Enable Digital Function 					
        	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DEN	
        	ldr r0, = PORT4 		
        	str r0, [r6]

; Choix de l'intensité de sortie (2mA)			
		ldr r6, = GPIO_PORTF_BASE+GPIO_O_DR2R	
        	ldr r0, = PORT4 			
		str r0, [r6]

        					
; pour eteindre LED - r2 = 0
 		mov r2, #0x000           

; Configuration du Port D - Enable Digital Function - Port D			
		ldr r7, = GPIO_PORTD_BASE+GPIO_O_DEN	
        	ldr r0, = PORT6		
        	str r0, [r7]			

; Activer le registre des switchs, Port D			
		ldr r7, = GPIO_PORTD_BASE+GPIO_PUR	
        	ldr r0, = PORT6
        	str r0, [r7]

;Lire dans R5 l'etat du switch SW1									
			

; allumer la led broche 4 (PORT4), Allume portF broche 4 : ;00010000, @data Register = @base + (mask<<2) ==> LED

			mov r3, #PORT4       				
			ldr r6, = GPIO_PORTF_BASE + (PORT4<<2) 
			str	r3,[r6]   
loop

;lecture de l'état du SW1 et ranger cet état dans r5
			ldr r7,= GPIO_PORTD_BASE + (PORT6<<2)
			ldr r5, [r7]       					

;Traitement qui allume/éteint la LED1 en fonction de l'état  ;du SW1, la LED1 est initialement allumée, et s'éteint si SW1 ;est activé = appuyé

;si switch 1 est actif (=0), on éteint la LED1
			cmp	r5,#0x80
			
			
			mov r3, #PORT4       				
			ldr r6, = GPIO_PORTF_BASE + (PORT4<<2) 
			str	r3,[r6]   

			bne	noled1		
			b	loop
	
;étiendre LED1
noled1		
			str r2, [r6]
; on peut insérer un délai - dans ce cas on prend en compte 
; les instructions suivantes, en enlevant les ;
;			LDR	r1,=DUREE
;suit			adds	r1,#-1
;			bne suit

; on recommence - aller à loop
			b	loop			
	
			nop	
			END 