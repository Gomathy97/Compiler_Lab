#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#define SIZE 20

typedef struct list{
	struct list *next;
	int ad;
}list;

typedef struct l{
	list *tl, *fl;	
}L;

typedef struct ins{
	int inst;
}M;

list* makeList();
list* merge(list*, list*);
list* makelist(int);
list* bp(list *, int);

int nextAd = 100;

list* makeList(){
	list *l = (list *)malloc(sizeof(list));
	l->next = NULL;
	return l;
}

list* bp(list *li, int v){
	list *m = li;
	while(m->next != NULL)
		m = m->next;
	list *temp = makeList();
	temp->ad = v;
	m->next = temp;
	return li;
}

list* merge(list *a, list *b){
	list *li = a;
	list *temp = li;
	while(temp->next)
			temp = temp->next;
	temp->next = b;
	return li;
}

list* makelist(int a){
	list *li = makeList();
	li->ad = a;
	li->next = NULL;
	return li;
}
