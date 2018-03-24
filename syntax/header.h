#include <stdlib.h>
#include <string.h>

typedef struct list{
	struct list *next;
	int l;
	int ad;
}list;

int nextAd = 0;

list* makeList();
list* merge(int, list*, list*);
list* makelist(int, int);
list* bp(int, list*, int);
list* mk(int, list*);

void display(list *l){
	list *m = l;
	while(m != NULL){
		if(m->l)
			printf("\n%d", m->ad);
		else
			printf("\n%d", m->ad);			
		m = m->next;
	}
}

list* mk(int t, list *lis){
	list *li = makeList();
	list *m = li;
	while(lis->next){
		if(lis->l == t)
			m = bp(t, m, lis->ad);
		lis = lis->next;
	}
	return li;
}

list* makeList(){
	list *l = (list *)malloc(sizeof(list));
	l->next = NULL;
	return l;
}

list* bp(int type, list *li, int v){
	list *m = li;
	while(m->next != NULL)
		m = m->next;
	list *temp = makeList();
	temp->ad = v;
	temp->l = type;
	m->next = temp;
	return li;
}

list* merge(int t, list *a, list *b){
	list *li = a;
	list *temp = li;
	while(temp->next)
			temp = temp->next;
	temp->next = b;
	temp->l = t;
	return li;
}

list* makelist(int t, int a){
	list *li = makeList();
	li->ad = a;
	li->l = t;
	li->next = NULL;
	return li;
}
