%{
	#include "y.tab.h"
%}

%%

[\t]	return 0;
[0-9]+	{ yylval.sym = (char)yytext[0]; return NUM;}
[a-z]+	{ yylval.sym = (char)yytext[0]; return LET;}
[+]	return '+';
[-]	return '-';
[*]	return '*';
[/]	return '/';
.	return yytext[0];

%%

int yywrap(){return 1;}
