#include <symbole.h>




int	creer_symbole(char name[32],int type){
	if(indice_ < NS)
	{
		strncpy(tab_sym[indice_].name, name, 32);
		tab_sym[indice_].type = type;
		tab_sym[indice_].size = 0;
		tab_sym[indice_].value = 0;
		indice_++;
		return(1);
	}
	return 0;
}

int	ajouter_symbole(char name[32], symbole s1)
{
	if(indice_ < NS)
	{
		strncpy(tab_sym[indice_].name, name, 32);
		tab_sym[indice_].type = s1.type;
		tab_sym[indice_].size = s1.size;
		if(s1.type==0)
			tab_sym[indice_].value = s1.value;
		else
			tab_sym[indice_].caractere = s1.caractere;
		indice_++;
		return(1);
	}
	return(0);
}

int	chercher_symbole(char name[32])
{
	int	i = 0;

	while(i < indice_)
	{
		if(0 == strncmp(tab_sym[i].name, name, 32))	
			return(i);
		i++;
	}
	return(-1);
}

void	afficher_tab_sym(void)
{
	int	i = 0;

	while(i < indice_)
	{
		printf("%s %d %d %d\n", tab_sym[i].name, tab_sym[i].type, tab_sym[i].size, tab_sym[i].value);
		i++;
	}
	printf("\n");
}
int	test_entier(symbole s1,symbole s2){
	return ((s1.type==s2.type) && s1.type==0);
	}

void	maj_symb(int i, symbole s1){
	if(tab_sym[i].type != s1.type)
		fprintf(stderr,"Affectation avec un type différent %d avec %d pour %s\n",s1.type,tab_sym[i].type,tab_sym[i].name);
	else{
		if(s1.type == 0)
			tab_sym[i].value = s1.value;
		else
			tab_sym[i].caractere = s1.caractere;
	}
}
