
code segment para 'CODE'
			assume	cs:code
	
	main proc
			mov		ah, 0eh
			mov		al, 'X'
			int		10h
			
			call	reset_adlib
			
			mov		bl, 63h
			mov		bh, 0f0h
			call	write_adlib
			
			mov		bl, 0b0h
			mov		bh, 37h
			call	write_adlib
			
			; wait for keypress
			mov		ah, 0
			int		16h
			
			mov		bl, 0b0h
			mov		bh, 0
			call	write_adlib
			
		@@exit:
			mov		ax, 4c00h
			int		21h
	main endp
	
	; bl = register
	; bh = value
	write_adlib proc
			push ax
			push bx
			push cx
			push dx
			
			mov 	dx, 388h
			mov 	al, bl
			out 	dx, al

			mov 	cx, 6
		@@delay_1:
			in 		al, dx
			loop 	@@delay_1

			mov 	dx, 389h

			mov 	al, bh
			out 	dx, al

			mov 	dx, 388h

			mov 	cx, 35
		@@delay_2:
			in 		al, dx
			loop 	@@delay_2
			
			pop 	dx
			pop 	cx
			pop 	bx
			pop 	ax
			ret
	write_adlib endp
	
	reset_adlib proc
			mov		bh, 0
			mov 	cx, 0ffh
		@@next_register:
			mov 	bl, cl
			call	write_adlib
			loop	@@next_register
			ret
	reset_adlib endp
	
	
code ends

stack segment para stack 'STACK'
	db 256 dup(?)
stack ends

end main

daqui pra frente eh tudo comentairo