title "adlib test"

OP1_OFFSET equ 0 
OP2_OFFSET equ 3

code segment para 'CODE'

	; bl = register
	; bh = data
	write proc near
			mov dx, 388h
			mov al, bl
			out dx, al
			mov dx, 389h
			mov al, bh
			out dx, al
			ret
	write endp

	clear_all_registers proc near
			mov cx, 0f5h
			
		clear_next_register:
			mov bl, cl
			mov bh, 0
			call write
			loop clear_next_register
			ret
	clear_all_registers endp
	
	main proc near
			assume ds:data
			
			mov ax, data
			mov ds, ax
			
			call clear_all_registers
			
			; waveform select enable
			mov bl, 01h
			mov bh, 20h
			call write
			
			; enable percussion mode
			;mov bl, 0bdh
			;mov bh, 020h
			;call write

			; setup snare drum -> operator 17
			; a configuracao abaixo do attack/release
			; lembra o som do mar do jogo outrun 

			;   operator 1                          operator 2 
			;   20   40    60    80    c0    e0     20   40    60    80    e0
			; 0x06, 0x0A, 0xFA, 0x1F, 0x0C, 0x00, 0x11, 0x00, 0xF5, 0xF5, 0x00 
			
			; setup freq mult factor
			mov bl, 20h + OP1_OFFSET
			mov bh, 06h
			call write

			; volume
			mov bl, 40h + OP1_OFFSET
			mov bh, 0ah
			call write
			
			; set attack / decay
			mov bl, 60h + OP1_OFFSET
			mov bh, 0fah
			call write

			; setup sustain / release
			mov bl, 80h + OP1_OFFSET
			mov bh, 01fh
			call write

			; 
			mov bl, 0c0h
			mov bh, 0ch
			call write

			;
			mov bl, 0e0h + OP1_OFFSET
			mov bh, 00h
			call write

			; --- operator 2
			;   operator 1                          operator 2 
			;   20   40    60    80    c0    e0     20   40    60    80    e0
			; 0x06, 0x0A, 0xFA, 0x1F, 0x0C, 0x00, 0x11, 0x00, 0xF5, 0xF5, 0x00 

			; setup freq mult factor
			mov bl, 20h + OP2_OFFSET
			mov bh, 11h
			call write

			; volume
			mov bl, 40h + OP2_OFFSET
			mov bh, 00h
			call write
			
			; set attack / decay
			mov bl, 60h + OP2_OFFSET
			mov bh, 0f5h
			call write

			; setup sustain / release
			mov bl, 80h + OP2_OFFSET
			mov bh, 0f5h
			call write

			;
			mov bl, 0e0h + OP2_OFFSET
			mov bh, 00h
			call write


			; frequency
			mov bl, 0a0h
			mov bh, 068h
			call write
			
			; note on 
			mov bl, 0b0h
			mov bh, 02fh
			call write

			; wait for keypress
			mov ah, 0
			int 16h
			
			; note off
			mov bl, 0bdh
			mov bh, 00h
			call write
			
			; exit process
			mov ax, 4c00h
			int 21h
		
	main endp

code ends	

data segment para 'DATA'
	registers db 20h+16, 40h+16, 60h+16, 80h+16, 0ch+6, 0e0h+16, 20h+19, 40h+19, 60h+19, 80h+19, 0e0h+19
	values db 01h, 07h, 0fah, 0fdh, 05h, 00h, 01h, 00h, 0f6h, 47h, 00h
data ends

stack segment para stack 'STACK'
	db 256 dup (0)
stack ends

end main
