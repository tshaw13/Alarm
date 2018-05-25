By Terrell Shaw
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;Pick a color
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 .386
 .model flat, stdcall
 option casemap :none

 include \MASM32\INCLUDE\windows.inc
 include \MASM32\INCLUDE\gdi32.inc
 include \MASM32\INCLUDE\user32.inc
 include \MASM32\INCLUDE\kernel32.inc
 includelib \MASM32\LIB\gdi32.lib
 includelib \MASM32\LIB\user32.lib
 includelib \MASM32\LIB\kernel32.lib
 ColorBar PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
 WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
 WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
      
 m2m MACRO M1, M2
  push M2
  pop  M1
 ENDM
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.DATA
szClassName db "WinClass",0
szDisplayName db "Color Picker",0
hWnd dd 0
hInstance dd 0
hIcon dd 0
hCursor dd 0
SCls db "EDIT",0
hStat1 dd 0
hStat2 dd 0
hStat3 dd 0
szPrime db "%lu", 0 
x dd 0
y dd 0
tb dd 0
wDC dd 0
wDC2 dd 0
cDC dd 0
cDC2 dd 0
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.CODE
start:
 invoke GetModuleHandle,0
 mov hInstance,eax
 invoke WinMain,hInstance,0,0,SW_SHOWDEFAULT
 invoke ExitProcess,eax
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
WinMain proc hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
      
 LOCAL wc:WNDCLASSEX,msg:MSG
      
      invoke LoadIcon,hInst,600
      mov hIcon, eax
      mov wc.cbSize,sizeof WNDCLASSEX
      mov wc.style,CS_HREDRAW or CS_VREDRAW
      mov wc.lpfnWndProc,offset WndProc
      mov wc.cbClsExtra,0
      mov wc.cbWndExtra,0
      m2m wc.hInstance,hInst
      mov wc.hbrBackground,COLOR_BTNFACE+1 
      mov wc.lpszMenuName,0
      mov wc.lpszClassName,offset szClassName
      m2m wc.hIcon,hIcon
      invoke LoadCursor,NULL,IDC_ARROW
      mov wc.hCursor,eax
      m2m wc.hIconSm,hIcon
      invoke RegisterClassEx,ADDR wc
      invoke CreateWindowEx,WS_EX_LEFT,ADDR szClassName,ADDR szDisplayName,WS_OVERLAPPEDWINDOW,250,140,290,310,0,0,hInst,0
      mov hWnd,eax
      invoke ShowWindow,hWnd,SW_SHOWNORMAL
      invoke UpdateWindow,hWnd
    StartLoop:
      invoke GetMessage,ADDR msg,0,0,0
      cmp eax,0
      je ExitLoop
      invoke TranslateMessage,ADDR msg
      invoke DispatchMessage,ADDR msg
      jmp StartLoop
    ExitLoop:
  mov eax,msg.wParam
  ret
WinMain endp
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
WndProc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam :DWORD
    
 LOCAL lpPaint:PAINTSTRUCT,hDC:DWORD
    
 cmp uMsg,WM_CREATE
 je @WM_CREATE
 cmp uMsg,WM_MOUSEMOVE
 je @WM_MOUSEMOVE
 cmp uMsg,WM_PAINT
 je @WM_PAINT
 cmp uMsg,WM_CLOSE
 je @WM_CLOSE
 cmp uMsg,WM_DESTROY
 je @WM_DESTROY
 invoke DefWindowProc,hWin,uMsg,wParam,lParam
 ret
    
@WM_CREATE:
  invoke CreateWindowEx,WS_EX_STATICEDGE,ADDR SCls,0,WS_CHILD or WS_VISIBLE or SS_LEFT,15,260,50,20,hWin,103,hInstance,0
  mov hStat1,eax
  invoke CreateWindowEx,WS_EX_STATICEDGE,ADDR SCls,0,WS_CHILD or WS_VISIBLE or SS_LEFT,95,260,50,20,hWin,104,hInstance,0
  mov hStat2,eax
  invoke CreateWindowEx,WS_EX_STATICEDGE,ADDR SCls,0,WS_CHILD or WS_VISIBLE or SS_LEFT,180,260,50,20,hWin,105,hInstance,0
  mov hStat3,eax
  
  invoke GetDC,hWin
  mov hDC,eax
  invoke CreateCompatibleDC,hDC
  mov wDC,eax
  invoke CreateCompatibleBitmap,hDC,255,255
  invoke SelectObject,wDC,eax
  invoke DeleteObject,eax
    
    @X:
    @Y:
    xor eax,eax
    mov ah,byte ptr x
    rol eax,8
    mov ah,255
    sub ah,byte ptr y
    mov al,255
    sub al,byte ptr x
    invoke SetPixel,wDC,x,y,eax
    inc y
    cmp y,256
    jl @Y
    inc x
    mov y,0
    cmp x,256
    jl @X
    
  invoke CreateCompatibleDC,hDC
  mov wDC2,eax
  invoke CreateCompatibleBitmap,hDC,15,255
  invoke SelectObject,wDC2,eax
  invoke DeleteObject,eax
  
  mov x,0
  mov y,0
  
  @X2:
  @Y2:
  xor eax,eax
  mov ebx,y
  mov ah,bl
  rol eax,8
  mov ah,bl
  mov al,bl
  invoke SetPixel,wDC2,x,y,eax
  inc y
  cmp y,256
  jl @Y2
  mov y,0
  inc x
  cmp x,16
  jl @X2
  
  invoke CreateCompatibleDC,hDC
  mov cDC,eax
  invoke CreateCompatibleBitmap,hDC,16,128
  invoke SelectObject,cDC,eax
  invoke DeleteObject,eax
  invoke CreateCompatibleDC,hDC
  mov cDC2,eax
  invoke CreateCompatibleBitmap,hDC,16,128
  invoke SelectObject,cDC2,eax
  invoke DeleteObject,eax
  xor eax,eax
  ret
 
@WM_MOUSEMOVE:
  mov eax,wParam
  cmp eax,MK_LBUTTON
  jne @ELBD
  mov eax,lParam
  and eax,0ffffh
  mov edx,eax
  cmp eax,255
  jg @ELBD
  mov eax,lParam
  shr eax,16
  cmp eax,255
  jg @ELBD
  
  mov ah,dl
  xor edx,edx
  mov dh,ah
  rol edx,8
  mov dh,255
  sub dh,al
  mov dl,255
  sub dl,ah
  mov ebx,edx
  
  invoke wsprintf,OFFSET tb,OFFSET szPrime,bl
  invoke SetWindowText,hStat1,OFFSET tb
  invoke wsprintf,OFFSET tb,OFFSET szPrime,bh
  invoke SetWindowText,hStat2,OFFSET tb 
  ror ebx,8
  invoke wsprintf,OFFSET tb,OFFSET szPrime,bh
  invoke SetWindowText,hStat3,OFFSET tb
  rol ebx,8

  invoke ColorBar,cDC,0FFFFFFh,ebx,128,16,1
  invoke ColorBar,cDC2,ebx,0000000h,128,16,1
  invoke BitBlt,wDC2,0,0,16,128,cDC,0,0,SRCCOPY
  invoke BitBlt,wDC2,0,127,16,128,cDC2,0,0,SRCCOPY 
  
  invoke GetDC,hWin
  mov hDC,eax
  invoke BitBlt,hDC,260,0,15,255,wDC2,0,0,SRCCOPY
 @ELBD:ret
  
@WM_PAINT:
 invoke BeginPaint,hWin,addr lpPaint
 mov ebx,eax
 invoke BitBlt,ebx,0,0,255,255,wDC,0,0,SRCCOPY
 invoke BitBlt,ebx,260,0,15,255,wDC2,0,0,SRCCOPY
 invoke EndPaint,hWin,addr lpPaint
 xor eax,eax
 ret
@WM_CLOSE:
 invoke PostQuitMessage,0        
 xor eax,eax
 ret
@WM_DESTROY:
 invoke DeleteDC,wDC
 invoke DeleteDC,wDC2
 invoke DeleteDC,cDC
 invoke DeleteDC,cDC2
 invoke PostQuitMessage,0
 xor eax,eax
 ret

WndProc endp
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ColorBar PROC USES ebx esi edi, hDC:DWORD,StartColor:DWORD,EndColor:DWORD,RangeCount:DWORD,ht:DWORD,BarWidth:DWORD

LOCAL dx1:DWORD,dx2:DWORD,dx3:DWORD,iLeft:DWORD

mov ecx, StartColor
mov edi, EndColor
sal ecx, 7
sal edi, 7
mov eax, ecx
mov ebx, edi
and eax, 0FF000000h / 2
and ebx, 0FF000000h / 2
sub eax, ebx
cdq
idiv RangeCount
mov dx1, eax
mov eax, ecx
mov esi, edi
and eax, 0FF0000h / 2
and esi, 0FF0000h / 2
sub eax, esi
cdq
idiv RangeCount
mov dx2, eax
mov eax, ecx
and eax, 0FF00h / 2
and edi, 0FF00h / 2
sub eax, edi
cdq
idiv RangeCount
mov dx3, eax
mov eax, EndColor
lp:


invoke CreateSolidBrush,eax
invoke SelectObject,hDC,eax
push eax
mov eax,RangeCount
sub eax,1
mul BarWidth
mov iLeft,eax
invoke PatBlt,hDC,0,iLeft,ht,BarWidth,PATCOPY
pop eax
invoke SelectObject,hDC,eax
invoke DeleteObject,eax

add ebx, dx1
mov eax, ebx
and eax, 0FF000000h / 2
add esi, dx2
mov edx, esi
and edx, 0FF0000h / 2
or eax, edx
add edi, dx3
mov edx, edi
and edx, 0FF00h / 2
or eax, edx
shr eax, 7
dec RangeCount
jne lp
xor eax,eax
ret
ColorBar ENDP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
end start
