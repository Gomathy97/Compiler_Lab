%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "lex.yy.c"
	char temp[100], symbol[100][100];
	int err = 0, i = 0, j = 0, type[100], fl = 0, block = 0;
	void insert(int t);
	FILE *yyin;
%}

%token INT FLOAT CHAR DOUBLE NL C SE ID OPEN CLOSE

%%
START	:	OPEN NL S1 START START NL CLOSE	{return;}
	|	S1				{return;}
	;
S1	:	S NL S1
	|	S NL
	;
S 	:	INT L1 E	|	INT L1 E S
	|	FLOAT L2 E	|	FLOAT L2 E S
	|	CHAR L3 E	|	CHAR L3 E S
	|	DOUBLE L4 E	|	DOUBLE L4 E S
	;
L1	:	L1 C ID	{ strcpy(temp, (char *)$3); insert(0); }
	|	ID 	{ strcpy(temp, (char *)$1); insert(0); }
	;
L2	:	L2 C ID	{ strcpy(temp, (char *)$3); insert(1); }
	|	ID 	{ strcpy(temp, (char *)$1); insert(1); }
	;
L3	:	L3 C ID	{ strcpy(temp, (char *)$3); insert(2); }
	|	ID 	{ strcpy(temp, (char *)$1); insert(2); }
	;
L4	:	L4 C ID	{ strcpy(temp, (char *)$3); insert(3); }
	|	ID 	{ strcpy(temp, (char *)$1); insert(3); }
	;
E	: 	SE
	;
%%

int yyerror(char const *c){}

int main(){
	system("clear");
	yyin = fopen("input.txt", "r");
	yyparse();
	printf("TYPE\tVAR\n");	
	if(err == 0){	
		for ( j=0;j<i;j++ ) {

			switch(type[j]){
				case 0:	printf ("INT ");	break;
				case 1:	printf ("FLOAT ");	break;
				case 2:	printf ("CHAR ");	break;
				case 3:	printf ("DOUBLE ");	break;
			}
			printf("%s\n", symbol[j]);

		} 
	}
	return 0;
}

void insert(int t){
	fl = 0;
	for (j=0; j<i; j++){
		if(strcmp(temp,symbol[j]) == 0){
			if(type[j] == t)	printf("\nredeclarations\n");
			else	{
				printf("\nmultiple declarations\n");
				fl = 1;
			}
			err = 1;
		}
	}
	if(fl == 0){
		type[i] = t;
		strcpy(symbol[i],temp);
		i++;
	}
}
