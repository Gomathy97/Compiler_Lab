%{
	#include "y.tab.h"
%}

%%

[\t]	return 0;
[\n] 	return NL;
[a-z]+	{ yylval.s = strdup(yytext); return ID;}
[><]	{ yylval.s = strdup(yytext); return RELOP;}
">="	{ yylval.s = strdup(yytext); return RELOP;}
"<="	{ yylval.s = strdup(yytext); return RELOP;}
"!="	{ yylval.s = strdup(yytext); return RELOP;}
"=="	{ yylval.s = strdup(yytext); return RELOP;}
"!"		return NOT;
"&&"	return AND;
"||"	return OR;
[0-9]+	{ yylval.sym = (char)yytext[0]; return NUM;}
[+]	return '+';
[-]	return '-';
[*]	return '*';
[/]	return '/';
.	return yytext[0];
.	return yytext[0];

%%

int yywrap(){return 1;}
