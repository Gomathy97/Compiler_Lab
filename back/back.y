%{
	#include <stdio.h>
	#include "header.h"
%}

%token RELOP AND OR NOT ID TRUE FALSE

%union{
	L str;
	M m;
	char *s;
}

%type<str> E START
%type<m> M
%type<s> ID RELOP

%%

START		:	E			{printf("\nSUCCESS\n"); return 0;}
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

%%

int yyerror(const char *c){printf("%s", c); exit(0);}

#include "lex.yy.c"

int main(){
	system("clear");
	yyparse();	
	
	return 0;
}
