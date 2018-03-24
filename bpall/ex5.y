%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "h1.h"
	#include "g.h"
	#include <string.h>
	void gen();
	int quadraple();
	char* stack(char *, char *, char *);
	int i = 0;
	int count = 0, line = 100, k = 0, b = 0;
	char temp[] = "A";
	struct assign{
		char op[10], op1[10], op2[10], t[1], block;
	};
%}

%token RELOP AND OR NOT ID TRUE FALSE  IF NUM LET ELSE

%union{ 
	L str;
	M m;
	char *s;
}

%left '+''-'
%right '*''/'
%type<str> E START R P
%type<m> M
%type<s> RELOP ID S NUM E1 T F L  ELSE

%%

START	:	'{' START '}'									{ return 0; }	
		|	IF '(' E ')' '{' S R '}' START					{ return 0; }
		|	IF '(' E ')' '{' S R '}' ELSE '{' S P'}' START	{ return 0; }
		|	E START											{ return 0; }
		|	S START											{ return 0; }
		|	E												{ return 0; }
		|	S												{ return 0; }
		;		
R		:   %empty											{printf("\nBLOCK %d\n", b); o[n] = b++;
															gen();
															$$.tl = makelist(line);
															$$.fl = makelist(line + 1); 
															printf("goto %d\n", b+1); d[n++] = b+1;
															}
		;	
P		:	%empty											{printf("\nBLOCK %d\n", b); o[n] = b++;
															gen();
															$$.tl = makelist(line);
															$$.fl = makelist(line + 1); 
															printf("goto %d\n", b); d[n++] = b;
															printf("\nBLOCK %d\n", b); o[n] = b++;
															}
		;		
E		:	E OR M E										{bp($1.fl, $3.inst); 
															$$.tl = merge($1.tl, $4.tl);
															$$.fl = $4.fl;
															}
		|	E AND M E										{bp($1.tl, $3.inst); 
															$$.tl = $4.tl;
															$$.fl = merge($1.fl, $4.fl);
															}
		|	NOT E											{$$.tl = $2.fl; $$.fl = $2.tl;}
		|	'('E')'											{$$.fl = $2.fl; $$.tl = $2.tl;}
		|	E1 RELOP E1										{gen();
															$$.tl = makelist(line);
															$$.fl = makelist(line + 1);
															printf("if %s %s %s goto %d\n", $1, $2, $3, b); d[n++] = b;
															printf("goto %d\n", b+1); o[n] = 0; d[n++] = b+1;
															}
		|	TRUE											{$$.tl = makelist(line + 1);}
		|	FALSE											{$$.fl = makelist(line + 2);}
		;

M		:	%empty											{$$.inst = line+1;}
		;
S		:	L EQ E1 SE 										{$$ = stack("=", (char *)$1, (char *)$3);}
		|	ID EQ E1 SE   									{$$ = stack("=", (char *)$1, (char *)$3);}
		|	S S	
		;
L		:	ID O E1 C										{$$ = stack("+", (char *)$1, (char *)$3);}
		|	L O E1 C										{$1 = stack("*", (char *)$1, "w"); 
															$3 = stack("*", (char *)$3, "w");
															$$ = stack("+", (char *)$1, (char *)$3);}
		;

E1		:	L												{$$ = (char *)$1;}
		|	E1 '+' T										{$$ = stack("+", (char *)$1, (char *)$3);}
		|	E1 '-' T										{$$ = stack("-", (char *)$1, (char *)$3);}
		|	T												{$$ = (char*)$1;}
		;
T		:	T '*' F											{$$ = stack("*", (char *)$1, (char *)$3);}
		|	T '/' F											{$$ = stack("/", (char *)$1, (char *)$3);}
		|	T '%' F											{$$ = stack("%", (char *)$1, (char *)$3);}
		|	F												{$$ = (char *)$1;}
		;
F		:	'('E1')'										{$$ = (char *)$2;}
		|	NUM												{$$ = (char *)$1;}	//coz leaf ;)
		|	ID												{$$ = (char *)$1;}	//coz leaf ;)
		;
EQ		:	'='
		;
SE		:	';'
		;
O		:	'['
		;
C		:	']'
		;


%%

struct assign arr[100];

int yyerror(const char *c){ printf("\n%s\n", c); exit(0); }

char* stack(char *op, char *op1, char *op2){
	if(op[0] == '='){
		strcpy(arr[i].op, op);
		strcpy(arr[i].op1, op1);
		strcpy(arr[i].op2, op2);
		strcpy(arr[i].t, "!");
		arr[i].block = b - 1;
	}
	else{
		strcpy(arr[i].op, op);
		strcpy(arr[i].op1, op1);
		strcpy(arr[i].op2, op2);
		strcpy(arr[i].t, temp);
		arr[i].block = b - 1;
		temp[0]++;
		if(temp[0] > 90)
			temp[0] = 'A';
	}
	i++;
	return arr[i-1].t;
}

void opt(){
	int ni, nj;
	for(ni=0; ni<i; ni++)
		for(nj=ni+1; nj<i;nj++){
			if(arr[ni].op[0] == arr[nj].op[0] && arr[ni].op1[0] == arr[nj].op1[0] && arr[ni].op2[0] == arr[nj].op2[0] && arr[ni].block == arr[nj].block){
				int z;
				for(z=nj+1; z<i; z++){
					if(arr[z].op1[0] == arr[nj].t[0])
						arr[z].op1[0] = arr[ni].t[0];
					if(arr[z].op2[0] == arr[nj].t[0])
						arr[z].op2[0] = arr[ni].t[0];
				}
			arr[nj].op[0] = '!';            
		}
	}
}

void cprm(){
	int ni, nj;
	for(ni=0; ni<i; ni++){
		if (arr[ni].op[0] == '=' && isdigit(arr[ni].op2[0])){
			for(nj=ni+1; nj<i; nj++){		
				if (arr[ni].op1[0] == arr[nj].op1[0])
					arr[nj].op1[0] = arr[ni].op2[0];
				else if (arr[ni].op1[0] == arr[nj].op2[0])
					arr[nj].op2[0] = arr[ni].op2[0];
			}          
		}
	}	
}

void cfold(){
	int ni, nj;
	for(ni=0; ni<i; ni++){
		if (isdigit(arr[ni].op1[0]) && isdigit(arr[ni].op2[0])){
			if (arr[ni].op[0] == '+'){
				arr[ni].op1[0] = ((arr[ni].op1[0] - '0') + (arr[ni].op2[0] - '0')) + '0';     
				arr[ni].op2[0] = ' ';
				arr[ni].op[0] = ' '; 
			}
			else if (arr[ni].op[0] == '-'){
				arr[ni].op1[0] = ((arr[ni].op1[0] - '0') - (arr[ni].op2[0] - '0')) + '0';    
				arr[ni].op2[0] = ' ';
				arr[ni].op[0] = ' ';
			}
			else if (arr[ni].op[0] == '*'){
				arr[ni].op1[0] = ((arr[ni].op1[0] - '0') * (arr[ni].op2[0] - '0')) + '0';     
				arr[ni].op2[0] = ' ';
				arr[ni].op[0] = ' ';
			}
			else if (arr[ni].op[0] == '/'){
				arr[ni].op1[0] = ((arr[ni].op1[0] - '0') / (arr[ni].op2[0] - '0')) + '0';     
				arr[ni].op2[0] = ' ';
				arr[ni].op[0] = ' ';
			}
			else if (arr[ni].op[0] == '%'){
				arr[ni].op1[0] = ((arr[ni].op1[0] - '0') % (arr[ni].op2[0] - '0')) + '0';     
				arr[ni].op2[0] = ' ';
				arr[ni].op[0] = ' ';
			}
		}
	}	
}

void gen(){
	opt();
	cprm();
	cfold();
	temp[0]++;
	while(count < i){
		if (arr[count].op[0] == '!'){
			count++;
			continue;
		}
		if (arr[count].op[0] == ' '){
			printf("%d: %c\t:\t%c\n", line, arr[count].t[0], arr[count].op1[0]);
			int g = count + 1;
			while(g<i){
				if (arr[g].op1[0] == arr[count].t[0])
					arr[g].op1[0] = arr[count].op1[0];
				else if (arr[g].op2[0] == arr[count].t[0])
					arr[g].op2[0] = arr[count].op1[0];
				g++;
			}
			count++;
			continue;
		}
		if(arr[count].t[0] != '!'){
			printf("%d: %c\t:\t", line, arr[count].t[0]);
			if(isalpha(arr[count].op1[0]))
				printf("%c\t", arr[count].op1[0]);
			else if(isdigit(arr[count].op1[0]))
				printf("%c\t", arr[count].op1[0]);
			else
				printf("%c\t", arr[count].t[0]);
			printf("%s\t", arr[count].op);
			if(isalpha(arr[count].op2[0]))
				printf("%c\t", arr[count].op2[0]);
			else if(isdigit(arr[count].op2[0]))
				printf("%c\t", arr[count].op2[0]);
			else
				printf("%c\t", arr[count].t[0]);
			printf("\n");
		}
		else{
			printf("%d: %c\t:\t", line, ' ');
			if(isalpha(arr[count].op1[0]))
				printf("%c\t", arr[count].op1[0]);
			else if(isdigit(arr[count].op1[0]))
				printf("%c\t", arr[count].op1[0]);
			else
				printf("%c\t", ' ');
			printf("%s\t", arr[count].op);
			if(isalpha(arr[count].op2[0]))
				printf("%c\t", arr[count].op2[0]);
			else if(isdigit(arr[count].op2[0]))
				printf("%c\t", arr[count].op2[0]);
			else
				printf("%c\t", arr[count].t[0]);
			printf("\n");
		}
		count++;
		temp[0]++;
		line++;
	}
}

int quadraple(){
	opt();
	temp[0]++;
	while(k < i)	{
		if (arr[k].op[0] == '!'){
			k++;
			continue;
		}
		if (arr[k].t[0] != '!'){
			printf("%c",arr[k].op[0]);
			printf("\t");
			if(isalpha(arr[k].op1[0]) || isdigit(arr[k].op1[0]))
				printf("%c\t",arr[k].op1[0]);
			else	
				printf("%c\t",arr[k].t[0]);

			if(isalpha(arr[k].op2[0]) || isdigit(arr[k].op2[0]))
				printf("%c\t",arr[k].op2[0]);
			else	
				printf("%c\t",arr[k].t[0]);

			printf("%c",arr[k].t[0]);

			printf("\n");
			k++;
			temp[0]++;
			line++;
		}
		else{
			printf("%c",arr[k].op[0]);
			printf("\t");
			if(isalpha(arr[k].op1[0]) || isdigit(arr[k].op1[0]))
				printf("%c\t",arr[k].op1[0]);
			else	
				printf("%c\t",' ');

			if(isalpha(arr[k].op2[0]) || isdigit(arr[k].op2[0]))
				printf("%c\t",arr[k].op2[0]);
			else	
				printf("%c\t",' ');

			printf("%c", ' ');

			printf("\n");
			k++;
			line++;
		}
	}
	return 1;
}

#include "lex.yy.c"

int main(){
	system("clear");
	printf("BLOCK %d\n", b++);
	yyparse();	
	printf("\nDAG\n");
	for (i=0;i<n;i++){
		printf("%d\t%d\n", o[i], d[i]);
	}
	gen();
	o[n] = -1;
	d[n] = -1;
	create_graph();
	return 0;
}
