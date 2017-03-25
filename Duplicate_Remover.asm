;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------

LIST_IN		.set	0x0200
LIST_OUT	.set	0x0220

			clr.w	R5
			clr.w	R6
			clr.w	R7
			clr.w	R8

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

Setup		mov.w	#LIST_IN, R5	;store listin in register R5
			mov.w	#LIST_OUT, R7	;store listout in register R7
			call	#Setup_LIST_IN
			call	#REP_FREE

Mainloop	jmp	Mainloop

Setup_LIST_IN	mov.w	#15, 0(R5)
 				mov.w	#1, 2(R5)
				mov.w	#1, 4(R5)
				mov.w	#4, 6(R5)
				mov.w	#5, 8(R5)
				mov.w	#32, 10(R5)
				mov.w	#33,	12(R5)
				mov.w	#33, 14(R5)
				mov.w	#45, 16(R5)
				mov.w	#45, 18(R5)
				mov.w	#71, 20(R5)
				mov.w	#72, 22(R5)
				mov.w	#72, 24(R5)
				mov.w	#100,	26(R5)
				mov.w	#101,	28(R5)
				mov.w	#101,	30(R5)

				ret

REP_FREE		push	R5
				push	R6
				push	R7
				push	R8
				mov.w	0(R5),	R6	;move the first element of the array into R6 for counter
				dec.w	R6		;decrement counter by 1
				mov.w	R7,	R8	;store the address location pointing to the first element in R7 into R8
				mov.w	@R5+,	0(R7)	;store n in memory location pointed to by R7, increment R5
				mov.w	@R5+,	2(R7)	;store next element since impossible to be a duplicate

CopyLoop		mov.w	@R5+,	4(R7)	;Begin moving the next element and increment R5
				cmp.w	2(R7),	4(R7)	;compare new word with old word
				jnz	Skip		;if the two are not equal, skip this step
				dec.w	0(R8)	;The two are equal, decrease the value n stored in R8 by 1
				decd.w	R7		;Decrease the address location to ignore the previous change for R7

Skip			Incd.w	R7
				dec.w	R6		;Decrease counter by 1
				jnz CopyLoop	;repeat if counter is not 0

				pop	R8
				pop	R7
				pop	R6
				pop	R5

				ret




;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
