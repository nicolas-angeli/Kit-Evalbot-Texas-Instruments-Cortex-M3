; Evalbot (Cortex M3 de Texas Instrument
; programme - clignotement LED1 connectée au port GPIOF
   	
		AREA    |.text|, CODE, READONLY
 
; This register controls the clock gating logic in normal Run mode
; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf

SYSCTL_PERIPH_GPIOF EQU		0x400FE108	
	
; The GPIODATA register is the data register
; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf

GPIO_PORTF_BASE		EQU		0x40025000	
GPIO_PORTD_BASE		EQU		0x40007000


; configure the corresponding pin to be an output
; all GPIO pins are inputs by default
; GPIO Direction (p417 datasheet de lm3s9B92.pdf

GPIO_O_DIR   		EQU 	0x400  

; The GPIODR2R register is the 2-mA drive control register
; By default, all GPIO pins have 2-mA drive.
; GPIO 2-mA Drive Select (p428 datasheet de lm3s9B92.pdf)

GPIO_O_DR2R   		EQU 	0x400  

; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

GPIO_O_DEN   		EQU 	0x51C  

; Port select - LED1 sur la ligne 5 du port 
PORT5				EQU		0x20

; blinking frequency
DUREE   			EQU     0x002FFFFF	

	  	ENTRY
		EXPORT	__main
__main	

; Enable the Port F peripheral clock by setting bit 5 (0x20 == 0b100000)		
;(p291 datasheet de lm3s9B96.pdf), (GPIO::FEDCBA)
		
		ldr r6, = SYSCTL_PERIPH_GPIOF  		;; RCGC2
        	mov r0, #0x00000020  				;; Enable clock sur GPIO F où sont branchés les leds (0x20 == 0b100000)
	      str r0, [r6]
		
;"There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
;tres tres important....;; pas necessaire en simu ou en debbug step by step...
		nop	   									
		nop	   
		nop	   									
	
; CONFIGURATION LED

        	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DIR    ;; une broche (Pin) du portF en sortie (broche 4 : 00010000)
        	ldr r0, = PORT5 	
        	str r0, [r6]
		
        	ldr r6, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        	ldr r0, = PORT5 		
        	str r0, [r6]
 
		ldr r6, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensité de sortie (2mA)
        	ldr r0, = PORT5			
       	 str r0, [r6]

        	mov r2, #0x000       				;; pour eteindre LED
     
; allumer la led broche 5 (PORT5)

		mov r3, #PORT5       				;; Allume portF broche 4 : 00010000
		ldr r6, = GPIO_PORTF_BASE + (PORT5<<2)    ;; @data Register = @base + (mask<<2) ==> LED

; Fin configuration LED 

; CLIGNOTEMENT led 2

loop
        	str r2, [r6]    					;; Eteint LED car r2 = 0x00      
        	ldr r1, = DUREE 					;; pour la duree de la boucle d'attente1 (wait1)

wait1		subs r1, #1
        	bne wait1

        	str r3, [r6]  					;; Allume portF broche 4 : 00010000 (contenu de r3)
        	ldr r1, = DUREE					;; pour la duree de la boucle d'attente2 (wait2)

wait2   	subs r1, #1
        	bne wait2

        	b loop       
		
		nop		
        	END 