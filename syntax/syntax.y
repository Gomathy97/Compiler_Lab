%{
	#include <stdio.h>
	#include <stdlib.h>
	typedef struct node{
		int val;
		struct node *left, *right;
	}node;
	node* makeNode(char val, node *left, node *right);
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
%type<str> E T F S L
%type<c> NUM LET

%%

START	:	'{' START '}'	{ return 0;}
		|	S START			{ inorder($1); printf("\n"); }
		|	S				{ inorder($1); printf("\n"); }
		;
S		:	L '=' L		{ $$ = makeNode('=', $1, $3); }
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
