title "adlib test"

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
			;call clear_all_registers

			; ao limpar todos os registradores
			; C0-C8 vai ficar no modo de frequencia modulada
			; desta forma o operador 2 é que vai estar produzindo som
			
			;mov bl, 0c0h
			;mov bh, 1
			;call write
			
			; op2 atk decay
			mov bl, 63h
			mov bh, 077h
			call write
			
			; op2 sustain release
			;mov bl, 83h
			;mov bh, 077h
			;call write
			
			; note on freq octave
			mov bl, 0b0h
			mov bh, 037h
			call write
			
			; wait for keypress
			mov ah, 0
			int 16h
			
			; note off
			mov bl, 0b0h
			mov bh, 0
			call write
			
			; exit process
			mov ax, 4c00h
			int 21h
		
	main endp

code ends	

data segment para 'DATA'
	
data ends

stack segment para stack 'STACK'
	db 256 dup (0)
stack ends

end main
