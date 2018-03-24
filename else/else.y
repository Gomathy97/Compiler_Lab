%{
	#include <stdio.h>
	FILE *fout;
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

S	: IF '(' E ')' NL S Z	
	| E SE NL	
	;

Z	: ELSE NL S
	;

E	: ID '=' E
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

int yyerror(const char *str) {	x = 1; printf("\nerror\n");}
int yywrap(){return 1;}

/*int main(){
	yyparse();
	if (x)
		printf("else\nnull\n");
}*/

int main(){
	//fout = fopen("output.txt","w");
	yyin = fopen("input.txt","r");
	//int i = yylex();
	yyparse();
	/*while(i){
			fprintf(fout,"%s",yytext);
			i = yylex();
	}*/
	if (x){
		int i;
		char s[] = "else\nnull\n";		
		fclose(yyin);
		yyin = fopen("input.txt","a");
		for(i=0;i<strlen(s);i++)
			fprintf(yyin,"%c",s[i]);
	}
}
