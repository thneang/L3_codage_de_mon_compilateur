#ifndef __SYMBOLE_
#define __SYMBOLE_
#include <stdio.h>
#include <string.h>
#define	NS	1024

typedef struct {
	char name[32];
	int type;
	int size;
	int value;
	char caractere;
	int* tab_value;
	char*	string;
}symbole;
static int indice_ = 0;
symbole	tab_sym[NS];
int	creer_symbole(char name[32],int type);
	
int	ajouter_symbole(char name[32], symbole s1);

int	chercher_symbole(char name[32]);

void	afficher_tab_sym(void);

int	test_entier(symbole s1,symbole s2);

void	maj_symb(int i, symbole s1);


#endif
