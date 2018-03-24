%{
	#include "y.tab.h"
%}

%%

[\t\n]	;
"if"	 return IF;
"else"	{ yylval.s = strdup(yytext);  return ELSE; }
[a-z]+	{ yylval.s = strdup(yytext);  return ID;}
[0-9]+	{ yylval.s = strdup(yytext);  return NUM;}
[><]	{ yylval.s = strdup(yytext);  return RELOP;}
">="	{ yylval.s = strdup(yytext);  return RELOP;}
"<="	{ yylval.s = strdup(yytext);  return RELOP;}
"!="	{ yylval.s = strdup(yytext);  return RELOP;}
"=="	{ yylval.s = strdup(yytext);  return RELOP;}
"!"	 return NOT;
"&&"	 return AND;
"||"	 return OR;
"+"	 return '+';
"-"	 return '-';
"*"	 return '*';
"/"	 return '/';
.	 return yytext[0];

%%

int yywrap(){ return 1;}
