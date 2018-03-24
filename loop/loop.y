%{
	#include <stdio.h>
	#include <string.h>
	int loop;
	char e1[100], e2[100], e3[100];	
	FILE *fin, *fout;
	
%}

%token FOR WHILE DO NUM ID RELOP NL INT DOUBLE CHAR FLOAT

%union{
	char *str;
}

%type<str>	E1 E2 E3 RELOP ID NUM INT FLOAT CHAR DOUBLE 

%%

START	:	FOR'('E1';'E2';'E3')'				{loop = 1; strcpy(e1, $3); strcpy(e2, $5); strcpy(e3, $7); return 0;}
	|	E1';'NL WHILE'('E2')''{'NL E3';'NL'}'		{loop = 2; strcpy(e1, $1); strcpy(e2, $6); strcpy(e3, $10); return 0;}
	|	E1';'NL DO'{'NL E3';'NL'}'WHILE'('E2')'';'	{loop = 3; strcpy(e1, $1); strcpy(e2, $13); strcpy(e3, $7); return 0;}
	;

E1	:	INT' 'ID'='NUM	{strcpy(e1, $1); strcat(e1, " "); strcat(e1, $3); strcat(e1,"="); strcat(e1,$5); strcat(e1,";"); $$ = e1;}
	|	FLOAT' 'ID'='NUM	{strcpy(e1, $1); strcat(e1, " "); strcat(e1, $3); strcat(e1,"="); strcat(e1,$5); strcat(e1,";"); $$ = e1;}
	|	CHAR' 'ID'='NUM	{strcpy(e1, $1); strcat(e1, " "); strcat(e1, $3); strcat(e1,"="); strcat(e1,$5); strcat(e1,";"); $$ = e1;}
	|	DOUBLE' 'ID'='NUM	{strcpy(e1, $1); strcat(e1, " "); strcat(e1, $3); strcat(e1,"="); strcat(e1,$5); strcat(e1,";"); $$ = e1;}
	;

E2	:	ID RELOP NUM	{strcpy(e2, $1); strcat(e2,$2); strcat(e2,$3); $$ = e2;}
	;

E3	:	ID'+''+'	{strcpy(e3, $1); strcat(e3,"+"); strcat(e3,"+"); strcat(e3,";"); $$ = e3;}
	|	ID'-''-'	{strcpy(e3, $1); strcat(e3,"-"); strcat(e3,"-"); $$ = e3;}
	;

/*
O	:	'('	;	C	:	')'	;	OP	:	'{'	;	CL	:	'}'	;
SE	:	';'	;
*/
%%

#include "lex.yy.c"

int yywrap(){ return 1; }

int yyerror(const char *c){ printf("\n%s\n", c); }

int main(){
	system("clear");
	yyin = fopen("in.txt","r");
        yyparse();
	fin = fopen("in.txt", "r");
	fout = fopen("out.txt", "w");
	char s[100];
	switch(loop){
		case 1:
			fprintf(fout, "%s", e1);
			fprintf(fout, "%s", "\nwhile(");	
			fprintf(fout, "%s", e2);	
			fprintf(fout, "%s", "){\n");		
			fprintf(fout, "%s", e3);
			fprintf(fout, "%s", "\n}");			
			break;

		case 2:
			while(fgets(s, 100, fin) != NULL)
				fprintf(fout, "%s", s);
			break;

		case 3:
			fprintf(fout, "%s", e1);
			fprintf(fout, "%s", "\nwhile(");	
			fprintf(fout, "%s", e2);	
			fprintf(fout, "%s", "){\n");		
			fprintf(fout, "%s", e3);
			fprintf(fout, "%s", "\n}");
			break;		
	}
}
