%%

""
"for"		{return FOR;}
"while"		{return WHILE;}
"do"		{return DO;}
"int"		{ yylval.str = strdup(yytext); return INT;}
"float"		{ yylval.str = strdup(yytext); return FLOAT;}
"double"	{ yylval.str = strdup(yytext); return DOUBLE;}
"char"		{ yylval.str = strdup(yytext); return CHAR;}
[a-z]+		{ yylval.str = strdup(yytext); return ID;}
[0-9]+		{ yylval.str = strdup(yytext); return NUM;}
"\n"		{ yylval.str = strdup(yytext); return NL;}
"<"		{ yylval.str = strdup(yytext); return RELOP;}
">"		{ yylval.str = strdup(yytext); return RELOP;}
"<="		{ yylval.str = strdup(yytext); return RELOP;}
">="		{ yylval.str = strdup(yytext); return RELOP;}
"=="		{ yylval.str = strdup(yytext); return RELOP;}
"!="		{ yylval.str = strdup(yytext); return RELOP;}
.		{return yytext[0];}

%%
