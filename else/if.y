%{
	#include <stdio.h>
%}

%token IF ELSE NL SE ID LE GE EQ NE OR AND NUM
%right '='
%left AND OR
%left '<''>' LE GE EQ NE
%left '+''-'
%left '*''/'
%right MINUS
%left '!'

%%

START 	: S 	{printf("valid\n");return 1;}
		;

S		: IF '(' E ')' '{' NL S '}' NL Z 	
		| E SE NL	 			
		;

Z		: ELSE '{' NL S '}' NL 
		;

E		: ID '=' E
		| E '+' E
		| E '-' E
		| E '*' E
		| E '/' E
		| E '<' E
		| E '>' E
		| E LE E
		| E GE E
		| E EQ E
		| E NE E
		| E OR E
		| E AND E
		| ID
		| NUM
		;

%%

#include "lex.yy.c"
int x = 0;

int yyerror(const char *str) {	
	x = 1; 
	int j;
	char s[] = "else{\nnull\n}\n";		
	printf("%s",s);
}
int yywrap(){return 1;}

int main(){
	system("clear");
	yyin = fopen("i.txt","r");	
/*	int i = yylex();
	do{
		printf("%s",yytext);
		i = yylex();
	}while(i);
	*/yyparse();
}

/*
int main(){
	yyin = fopen("i.txt","r");
	yyout = fopen("out.txt","w");
	int i = yylex();
	yyparse();
	while(i){
		fprintf(yyout, "%s", yytext);
		i = yylex();
	}
}*/
