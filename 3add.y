%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define ROW 2
	#define COLUMN 2
	void gen();
	char stack(char, char, char);
	char make(char a);
	int i = 0;
	char temp = 'A';
	struct assign{
		char op, op1, op2;
	};
	FILE *yyin;
%}

%union{
	char sym;
}

%token <sym> LET NUM NL
%type <sym> E
%type <sym> T
%type <sym> F
%type <sym> S
%type <sym> L
%left '+''-'
%right '*''/'

%%

START	:	S		{return 0;}	
	;
S	:	L EQ E SE	{$$ = stack('=', (char)$1, (char)$3);}
	|	LET EQ E SE	{$$ = stack('=', (char)$1, (char)$3);}
	;
L	:	LET O E C	{$3 = make($3);$$ = stack('+', (char)$1, (char)$3);}
	|	L O E C		{$$ = stack('+', (char)$1, (char)$3);}
	;

E	:	L 			{$$ = (char)$1;}
	|	E'+'T		{$$ = stack('+', (char)$1, (char)$3);}
	|	E'-'T		{$$ = stack('-', (char)$1, (char)$3);}
	|	T			{$$ = (char)$1;}
	;
T	:	T'*'F		{$$ = stack('*', (char)$1, (char)$3);}
	|	T'/'F		{$$ = stack('/', (char)$1, (char)$3);}
	|	F		{$$ = (char)$1;}
	;
F	:	'('E')'		{$$ = (char)$2;}
	|	NUM		{$$ = (char)$1;}	//coz leaf ;)
	|	LET		{$$ = (char)$1;}	//coz leaf ;)
	;
EQ	:	'='
	;
SE	:	';'
	;
O	:	'['
	;
C	:	']'
	;

%%

int yyerror(const char *c){printf("%s", c); exit(0);}

struct assign arr[100];

char stack(char op, char op1, char op2){
	arr[i].op = op;
	arr[i].op1 = op1;
	arr[i].op2 = op2;
	i++;
	temp++;
	return temp;
}

char make(char aa){
	int x = (aa - '0') * ROW;
	return x + '0';
}

void gen(){
	int count = 0;
	temp++;
	printf("THE THREE ADDRESS CODE IS \n\n");
	while(count < i){
		printf("%c\t:\t", temp);
		if(isalpha(arr[count].op1))
			printf("%c\t", arr[count].op1);
		else if(isdigit(arr[count].op1))
			printf("%c\t", arr[count].op1);
		else
			printf("%c\t", temp);

		printf("%c\t", arr[count].op);
		if(isalpha(arr[count].op2))
			printf("%c\t", arr[count].op2);
		else if(isdigit(arr[count].op2))
			printf("%c\t", arr[count].op2);
		else
			printf("%c\t", temp);
		printf("\n");
		count++;
		temp++;
	}
}

#include "lex.yy.c"

int main(){
	system("clear");
	int t = 4;
	yyin = fopen("in.txt", "r");
	yyparse();
	temp = 'A';
	gen();
	return 0;
}
