alpha [a-zA-Z]
digit [0-9]
%{
	#include <stdlib.h>
	#include <stdio.h>
%}

%%

"if"				{return IF;}
"else"				{return ELSE;}
{digit}+			{return NUM;}
{alpha}({alpha}|{digit})*	{return ID;}
"<="				{return LE;}
">="				{return GE;}
"=="				{return EQ;}
"!="				{return NE;}
"&&"				{return AND;}
"||"				{return OR;}
";"					{return SE;}
\n					{return NL;}
.					{return yytext[0];}

%%
