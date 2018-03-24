%{
	#include "y.tab.h"
%}

%%
[\t \n ;]	;
[0-9]+	{ yylval.c = (char)yytext[0]; return NUM;}
[a-z]+	{ yylval.c = (char)yytext[0]; return LET;}
[+]		{ return '+'; }
[-]		{ return '-'; }
[/]		{ return '/'; }
[*]		{ return '*'; }
[=]		{ return '='; }
.		{ return yytext[0]; }

%%

int yywrap(){return 1;}
