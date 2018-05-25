
    .486                                    ; create 32 bit code
    .model flat, stdcall                    ; 32 bit memory model
    option casemap :none                    ; case sensitive
    include \masm32\include\windows.inc     ; always first
    include \masm32\macros\macros.asm       ; MASM support macros

    include \masm32\include\masm32.inc
    include \masm32\include\gdi32.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc

    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

	.data

	IntroCaption	db "Login Info Program",0
	IntroText		db "In this program you can create user data with usernames and passwords.",13,10
					db "First enter a username and password.",13,10
					db "Then confirm it by re-entering the information.",13,10
					db "The program will check whether the information was correct or not.",0

	CorrectCaption	db "Correct",0
	CorrectText		db "Correct information entered.",13,10
					db "Press yes to enter another user.",13,10
					db "Press no to exit.",0

	WrongCaption	db "Incorrect",0
	WrongText		db "Wrong information entered.",13,10
					db "Press yes to enter another user.",13,10
					db "Press no to exit.",13,10
					db "Press cancel to try to re-enter the information again.",0

	NullCheck		DWORD ?
	NullText		db "No username",0

    .code                       ; Tell MASM where the code starts
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
start:                          ; The CODE entry point to the program
    call main                   ; branch to the "main" procedure
    exit
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
main proc
    LOCAL username:DWORD, password:DWORD , usercheck:DWORD, passcheck:DWORD
    
	invoke MessageBox, NULL, addr IntroText, addr IntroCaption, MB_ICONWARNING
	
L1:	
	mov username, input("Enter a username : ")			;user inputs username
    mov password, input("Enter a password : ")			;user inputs password

L2:
	print chr$(" ",13,10)

    mov usercheck, input("Re-enter the username : ")	;user re-enters username
    mov passcheck, input("Re-enter the password : ")	;user re-enters password

	mov esi,  username
	mov edi,  usercheck
	cmpsd					;compare username to re-entered username
	jne L3					;show the "wrong" messagebox if they aren't equal

	mov esi,  password
	mov edi,  passcheck
	cmpsd					;compare password to re-entered password
	jne L3					;show the "wrong" messagebox if they aren't equal

	
	invoke MessageBox, NULL, addr CorrectText, addr CorrectCaption, MB_YESNO
	.if eax==IDYES				;yes button was clicked
		invoke ClearScreen		;console window is cleared
		jmp L1					;lets user enter another username and password
    .elseif eax==IDNO			;no button was clicked
		jmp L4					;exits
    .endif

	jmp L4						;exits, should be redundant
L3:
	invoke MessageBox, NULL, addr WrongText, addr WrongCaption, MB_YESNOCANCEL
	.if eax==IDYES				;yes button was clicked
		invoke ClearScreen		;console window is cleared
		jmp L1					;lets user enter another username and password
    .elseif eax==IDNO			;no button was clicked
		jmp L4					;exits
	.elseif eax==IDCANCEL		;cancel button was clicked
		jmp L2					;lets user re-attempt to re-enter username and password
    .endif
L4:

    ret
main endp

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

end start                       ; Tell MASM where the program ends
    	