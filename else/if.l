alpha [a-zA-Z]
digit [0-9]
%{  
	#include <stdlib.h>
	#include <stdio.h>
	int m = 0;
%}

%%

"if"						{ECHO;  return IF;}
"else"						{ECHO;  return ELSE;}
{digit}+					{ECHO;  return NUM;}
{alpha}({alpha}|{digit})*	{ECHO;  return ID;}
"<="						{ECHO;  return LE;}
">="						{ECHO;  return GE;}
"=="						{ECHO;  return EQ;}
"!="						{ECHO;  return NE;}
"&&"						{ECHO;  return AND;}
"||"						{ECHO;  return OR;}
";"							{ECHO;  return SE;}
\n							{ECHO;  return NL;}
.							{ECHO;  return yytext[0];}

%%
