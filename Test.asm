.386
.model flat , stdcall
option casemap : none 

include\masm32\include\windows.inc
include\masm32\include\kernel32.inc
include\masm32\include\masm32.inc

includelib\masm32\lib\kernel32.lib
includelib\masm32\lib\masm32.lib

.data

msg			db 'RET simulator' ,0

.code

start:

	call	testproc
	invoke	Beep ,3000,20000
	invoke  ExitProcess,0
	
testproc PROC

	invoke	StdOut, ADDR msg
	pop		eax			
	jmp		eax

testproc ENDP

END start