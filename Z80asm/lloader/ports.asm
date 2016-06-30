; Ports
;          Ports examiner app for LLoader
;
;          2016-06-15 Scott Lawrence
;
;  This code is free for any use. MIT License, etc.

	.module Ports

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; InPort
;	read in the specified port and print it out
InPort:
	ld	hl, #str_port	; request a byte for the port
	call	Print
	call 	GetByteFromUser
	call	PrintNL

	ld	c, b		; port to read from in a
	in	a, (c)

	push	af		; print out the port data
	ld	hl, #str_data
	call	Print
	pop	af

	call	printByte	; print the value
	call	PrintNL

	xor	a
	ret			; next

; OutPort
;	output the specified byte to the specified port
OutPort:
	ld	hl, #str_port	; request a byte for the port
	call	Print
	call 	GetByteFromUser
	call	PrintNL
	ld	c, b

	ld	hl, #str_data	; request the port data
	call	Print
	call 	GetByteFromUser
	ld	a, b

	out	(c),a		; send it out
	call	PrintNL

	xor	a
	ret


str_port:
	.asciz	"Port: 0x"

str_data:
	.asciz	"Data: 0x"

str_address:
	.asciz 	"Address: 0x"

str_spaces:
	.asciz	" "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Terminal app
;  Opens the SD port, and sends stuff to and fro

str_intro:
	.ascii	"Terminal connection opening\n\r"
	.asciz	"Hit backtick ` to end\n\r"

str_outro:
	.asciz	"\n\rTerminated connection\n\r"

TerminalApp:
	ld	hl, #str_intro
	call	Print

	; check for input from either port

TA0:
	in	a, (TermStatus)
	and	#DataReady
	call	z, TermToSD	; something outgoing... send it!

	in	a, (SDStatus)
	and	#DataReady
	call	z, SDToTerm	; something incoming... get a byte

	jr	TA0		; and repeat

TermExit:
	ld	hl, #str_outro
	call	Print
	ret

TermToSD:
	in	a, (TermData)	; get a byte from the terminal
	push	af
	call	printByte
	call	PrintNL
	pop	af
	cp	#'`		; exit character
	jr	z, TermExit	; yep! Exit!

	out	(SDData), a	; send the byte out to the SD interface
	ret

SDToTerm:
	in	a, (SDData)	; get a byte from the SD interface
	push	af
	call	printByte
	call	PrintNL
	pop	af
	out	(TermData), a	; send the byte out to the terminal
	ret