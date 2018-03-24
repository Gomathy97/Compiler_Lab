%{
	#include <stdio.h>
	#include "header.h"
	void gen();
	char stack(char, char, char);
	int i = 0;
	char temp = 'A';
	struct assign{
		char op, op1, op2;
	};
%}

%token RELOP AND OR NOT ID TRUE FALSE NUM NL

%union{
	L str;
	M m;
	char *s;
	char sym;
}

%token <sym> NUM
%type <sym> E1 T F S L
%left '+''-'
%right '*''/'
%type<str> E START
%type<m> M
%type<s> ID RELOP

%%

START		:	"if("E")" NL S		{printf("\nSUCCESS\n"); return 0;}
		|	"if("E")" NL S NL "else" NL S
		;
		
E		:	E OR M E		{bp($1.fl, $3.inst); 
						$$.tl = merge($1.tl, $4.tl);
						$$.fl = $4.fl;
						}
		|	E AND M E		{bp($1.tl, $3.inst); 
						$$.tl = $4.tl;
						$$.fl = merge($1.fl, $4.fl);
						}
		|	NOT E			{$$.tl = $2.fl; $$.fl = $2.tl;}
		|	'('E')'			{$$.fl = $2.fl; $$.tl = $2.tl;}
		|	ID RELOP ID		{
						$$.tl = makelist(nextAd);
						nextAd++;
						$$.fl = makelist(nextAd);
						nextAd++;
						printf("if %s %s %s goto %d\n", $1, $2, $3, $$.tl->ad);
						printf("goto %d\n", $$.fl->ad);
						}
		|	TRUE			{$$.tl = makelist(nextAd);}
		|	FALSE			{$$.fl = makelist(nextAd);}
		;

M		:	%empty			{$$.inst = nextAd;}
		;
S		:	L EQ E1 SE	{$$ = stack('=', (char)$1, (char)$3);}
		|	ID EQ E1 SE	{$$ = stack('=', (char)$1, (char)$3);}
		;
L		:	ID O E1 C	{$$ = stack('+', (char)$1, (char)$3);}
		|	L O E1 C		{$$ = stack('+', (char)$1, (char)$3);}
		;

E1		:	L		{$$ = (char)$1;}
		|	E1'+'T		{$$ = stack('+', (char)$1, (char)$3);}
		|	E1'-'T		{$$ = stack('-', (char)$1, (char)$3);}
		|	T		{$$ = (char)$1;}
		;
T		:	T'*'F		{$$ = stack('*', (char)$1, (char)$3);}
		|	T'/'F		{$$ = stack('/', (char)$1, (char)$3);}
		|	F		{$$ = (char)$1;}
		;
F		:	'('E1')'		{$$ = (char)$2;}
		|	NUM		{$$ = (char)$1;}	//coz leaf ;)
		|	ID		{$$ = (char)$1;}	//coz leaf ;)
		;
EQ		:	'='
		;
SE		:	';'
		;
O		:	'['
		;
C		:	']'
		;


%%

struct assign arr[100];

int yyerror(const char *c){printf("%s", c); exit(0);}

#include "lex.yy.c"

int main(){
	system("clear");
	yyparse();	
	
	return 0;
}
