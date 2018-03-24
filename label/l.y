%{
	#include <stdio.h>
	#include <stdlib.h>
	typedef struct node{
		int val;
		struct node *left, *right;
	}node;
	node* makeNode(char val, node *left, node *right);
	void genCode(node *n, int reg);
	void genOp(char op, int r1, int r2);
	void genLoad(char val, int reg);
	void inorder(node *n);
	int yylex();
	void yyerror(const char *);

%}

%union{
	node *str;
	char c;
}

%left '+''-'
%left '*''/'
%token NUM LET
%type<str> E T F S L START
%type<c> NUM LET

%%

START	:	'{' START '}'	{ return 0;}
		|	S START			{ printf("\n"); }
		|	S				{ printf("\n"); }
		;
S		:	L '=' L		{ genCode($3, 0); $$ = makeNode('=', $1, $3); }
		;
L		:	E			{ $$ = $1; }
		;
E		:	E'+'T	{$$ = makeNode('-', $1, $3);}
		|	E'-'T	{$$ = makeNode('-', $1, $3);}
		|	T		{$$ = $1;}
		;
T		:	T'*'F	{$$ = makeNode('*', $1, $3);}
		|	T'/'F	{$$ = makeNode('/', $1, $3);}
		|	F		{$$ = $1;}
		;
F		:	'('E')'	{$$ = $2;}
		|	NUM		{$$ = makeNode($1, NULL, NULL);}	//coz leaf ;)
		|	LET		{$$ = makeNode($1, NULL, NULL);}	//coz leaf ;)
		;

%%

#include "lex.yy.c"

node* makeNode(char v, node *l, node *r){
	node *temp = (node *)malloc(sizeof(node));
	temp->val = v;
	temp->left = l;
	temp->right = r;
	return temp;
}

void genCode(node *n, int reg){
	if(n->val == '+' || n->val == '-' || n->val == '*' || n->val == '/'){
		if(n->left) genCode(n->left, reg);
		if(n->right) genCode(n->right, reg + 1);
		genOp(n->val, reg, reg + 1);
	}
	else{
		genLoad(n->val, reg);
	}
}

void genOp(char op, int r1, int r2){
	char *opCode;
	switch (op) {
		case '+': opCode = "ADD";
		 break;
		case '-': opCode = "SUB";  
		 break;
		case '*': opCode = "MUL";  
		 break;
		case '/': opCode = "DIV";  
		 break;
	}
	printf("%s R%d, R%d, R%d\n", opCode, r2, r1, r2);
}

void genLoad(char val, int reg){
	printf("LOAD %c, R%d\n", val, reg);
}

void inorder(node *n){
	if(n->left != NULL)	inorder(n->left);
	if(n->right != NULL)	inorder(n->right);
	printf("%c", n->val);
}

void yyerror(const char *c){printf("%s\n", c); }

int main(){
	system("clear");
	yyparse();
}
