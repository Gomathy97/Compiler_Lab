%{
	#include "y.tab.h"
%}

%%

[\n\t]	return 0;
[a-z]+	{ yylval.s = strdup(yytext); return ID;}
[><]	{ yylval.s = strdup(yytext); return RELOP;}
">="	{ yylval.s = strdup(yytext); return RELOP;}
"<="	{ yylval.s = strdup(yytext); return RELOP;}
"!="	{ yylval.s = strdup(yytext); return RELOP;}
"=="	{ yylval.s = strdup(yytext); return RELOP;}
"!"		return NOT;
"&&"	return AND;
"||"	return OR;
.	return yytext[0];

%%

int yywrap(){return 1;}
