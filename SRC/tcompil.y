%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <symbole.h>

int yyerror(char*);
int yylex();
 FILE* yyin; 
 int jump_label=0;
 void inst(const char *);
 void instarg(const char *,int);
 void comment(const char *);
int type_decl;


%}

%union 
{
	int 		entier;
	int*		tvalue;
	char		caractere;
	int 		operation;
   	char*		id;
	symbole		symb;
   	int		type;
	int		adresse;
}


%token IF ELSE WHILE PRINT VOID CONST MAIN RETURN READ READCH PV VRG LPAR RPAR LACC RACC LSQB RSQB
%token <caractere> CARACTERE
%token <entier> NUM 
%token <type> TYPE
%token <id> IDENT
%type <symb> Exp Litteral LValue 
%type <entier>  NombreSigne  JUMPIF JUMPELSE BOUCLE JUMPWHILE
%type <id> Ident
%left <operation> BOPE COMP 
%left <operation> ADDSUB 
%left <operation> DIVSTAR
%left NEGATION
%right EGAL
%left NOELSE

%%
Prog : DeclConst DeclVarPuisFonct DeclMain ;



DeclConst : DeclConst CONST ListConst PV | ;
ListConst : ListConst VRG IDENT EGAL Litteral {
				int i = chercher_symbole($3);
				if(i == -1)
					ajouter_symbole($3,$5);
				else{
					yyerror("Impossible de modifier la constante\n");
				}
			}
	| IDENT EGAL Litteral { 
				int i = chercher_symbole($1);
				if(i == -1)
					ajouter_symbole($1,$3);
				else{
					yyerror("Impossible de modifier la constante\n");
				}
	};
Litteral : NombreSigne {$$.type = 0; $$.size=4;$$.value = $1;} | CARACTERE {$$.type = 1;$$.size=1;$$.caractere = $1;} ;
NombreSigne : NUM | ADDSUB NUM {
	    			if($1 == 1)
					$$ = -$2;
				else
					$$ = $2;
			} ;
DeclVarPuisFonct : TYPE ListVar{type_decl = $1;} PV DeclVarPuisFonct | DeclFonct | ;
ListVar : ListVar VRG Ident {
			int i = chercher_symbole($3);
			if(i == -1)
				creer_symbole($3,type_decl);
			else
				fprintf(stderr,"%s déja déclaré\n",$3);
	} 
	| Ident {
			int i = chercher_symbole($1);
			if(i == -1)
				creer_symbole($1,type_decl);
			else
				fprintf(stderr,"%s déja déclaré\n",$1);
	
	} ;
Ident : IDENT Tab ;
Tab : Tab LSQB NUM RSQB | ;
DeclMain : EnTeteMain Corps ;
EnTeteMain : MAIN LPAR RPAR ;
DeclFonct : DeclFonct DeclUneFonct | DeclUneFonct ;
DeclUneFonct : EnTeteFonct Corps ;
EnTeteFonct : TYPE IDENT LPAR Parametres RPAR
	| VOID IDENT LPAR Parametres RPAR ;
Parametres : VOID | ListTypVar ;
	   //La portée n'est pas gérer est l'appelle écrase les anciennes valeurs
ListTypVar : ListTypVar VRG TYPE IDENT {creer_symbole($4,$3);}
	   |TYPE IDENT  {creer_symbole($2,$1);}; 
Corps : LACC DeclConst DeclVar SuiteInstr RACC ;
DeclVar :  DeclVar2 TYPE {type_decl = $2;} ListVar  PV | ;
DeclVar2 :  DeclVar TYPE {type_decl = $2;} ListVar  PV ;
SuiteInstr : SuiteInstr Instr  | ;
InstrComp : LACC SuiteInstr RACC ;

Instr: 	 
		
     		 LValue EGAL Exp PV { 
					int i = chercher_symbole($1.name);
					inst("POP");
					if(i == -1){
						fprintf(stderr,"%s n'est pas déclarer\n",$1.name);
					}
					else
						maj_symb(i,$3);	
						}
       	    	| IF LPAR Exp RPAR JUMPIF Instr %prec NOELSE {instarg("LABEL",$5);}
		| IF LPAR Exp RPAR JUMPIF Instr ELSE JUMPELSE {instarg("LABEL",$5);} Instr {instarg("LABEL",$8);}
		| WHILE JUMPWHILE {instarg("LABEL",$2);} LPAR Exp RPAR JUMPIF  Instr BOUCLE  {instarg("LABEL",$7);}
		| RETURN Exp PV { instarg("SET",$2.value);inst("RETURN");}
		| RETURN PV {inst("RETURN");}
		| IDENT LPAR Arguments RPAR PV
		| READ LPAR IDENT RPAR PV 
			{ 
				int i = chercher_symbole($3);
				if(i==-1){
						fprintf(stderr,"%s n'est pas déclarer\n",$3);
					}
				else{
					if(tab_sym[i].type != 0){
						fprintf(stderr,"Erreur utilisation de READ avec %s qui est autre chose qu'un entier\n",$3);
					}
					else{
						inst("READ");
						//probleme maj tab symbole
					}
				}
				
			}
		| READCH LPAR IDENT RPAR PV 
			{ 
				int i = chercher_symbole($3);
				if(i==-1){
						fprintf(stderr,"%s n'est pas déclarer\n",$3);
					}
				else{
					if(tab_sym[i].type != 1){
						fprintf(stderr,"Erreur utilisation de READCH avec %s qui est autre chose qu'un caractere\n",$3);
					}
					else{
						inst("READCH");
						//probleme maj tab symbole
					}
				}
		}
		| PV
		|  PRINT LPAR Exp RPAR PV {
     			inst("POP"); 
			if($3.type == 0)
				inst("WRITE");
			else
				inst("WRITECH");
			}
		| InstrComp
	  	 ;
Arguments : ListExp | ;

LValue : IDENT TabExp {
		int i = chercher_symbole($1);
		if (i == -1)
			fprintf(stderr,"Erreur %s non définie\n",$1);
		else{
			$$=tab_sym[i];
		}
	};

TabExp : TabExp LSQB Exp RSQB | ;

//Met les arguments dans la pile
ListExp : ListExp VRG Exp {if ($3.type == 0) instarg("SET",$3.value); else instarg("SET",$3.caractere); inst("PUSH");}
	| Exp {if ($1.type == 0) instarg("SET",$1.value); else instarg("SET",$1.caractere); inst("PUSH");}

JUMPIF: {
      		inst("POP");
		instarg("JUMPF",$$=jump_label++);
	};
JUMPELSE: {
		instarg("JUMP",$$=jump_label++);
	};
JUMPWHILE:{
      		$$=jump_label++;
	};
BOUCLE: {
      		instarg("JUMP",$$ = jump_label-2);
	};
Exp : 
	 LPAR Exp RPAR {$$ = $2;}
    
	| Exp ADDSUB  Exp {
		if(!test_entier($1,$3))
			yyerror("Erreur operation arithmétique avec autre chose qu'un entier\n");
		else{
		$$.type = 0;		
		if($2 == 0){
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("ADD");
			inst("PUSH");
			$$.value=$1.value+$3.value;
			}
		else{
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("SUB");
			inst("PUSH");
			$$.value=$1.value-$3.value;
		    	}
		}
	}
	| Exp DIVSTAR Exp {
		if(!test_entier($1,$3))
			yyerror("Erreur operation arithmétique avec autre chose qu'un entier\n");
		else{
			$$.type = 0;
			if($2==0){
				inst("POP");
				inst("SWAP");
				inst("POP");
				inst("MUL");
				inst("PUSH");
				$$.value = $1.value*$3.value;
			}
			else if( $2==1 ){
				inst("POP");
				inst("SWAP");
				inst("POP");
				inst("DIV");
				inst("PUSH");
				$$.value=$1.value/$3.value;
			}
			else{
				inst("POP");
				inst("SWAP");
				inst("POP");
				inst("MOD");
				inst("PUSH");
				$$.value=$1.value%$3.value;
			}
		}
	}
	| Exp COMP Exp {
		$$.type = 0;
		if($2 == 0){
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("EQUAL");
			inst("PUSH");
			$$.value=$1.value==$3.value;
		}
		else if($2 == 1){
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("NOTEQ");
			inst("PUSH");
			$$.value=$1.value!=$3.value;
		}
		else if($2 == 2){
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("LESS");
			inst("PUSH");
			$$.value=$1.value<$3.value;
		}
		else if($2 == 3){
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("GREATER");
			inst("PUSH");
			$$.value=$1.value>$3.value;
		}
		else if($2 == 4){
			
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("LEQ");
			inst("PUSH");
			$$.value=$1.value<=$3.value;
		}
		else {
			inst("POP");
			inst("SWAP");
			inst("POP");
			inst("GEQ");
			inst("PUSH");
			$$.value=$1.value>=$3.value;
		}
	}
			
	| ADDSUB Exp {
		if($2.type != 0)
			yyerror("Erreur operation arithmétique avec autre chose qu'un entier\n");
		else{
			$$.type = 0;
			if($1 == 1){
				inst("POP");
				inst("NEG");
				inst("PUSH");
				$$.value = -$2.value;
			}
			else{
				$$.value=$2.value;	
			}
		}
	}		
	| Exp BOPE Exp {
		if(!test_entier($1,$3))
			yyerror("Erreur operation booléenne avec autre chose qu'un entier\n");
		else{
			inst("POP");inst("POP");$$.type = 0;
			if($2 == 1){
				instarg("SET",$1.value || $3.value);
				inst("PUSH");
				$$.value=$1.value||$3.value;
			}
			else{
				instarg("SET", $1.value && $3.value);
				inst("PUSH");
				$$.value = $1.value && $3.value;
			}
		}
	}
	
	
			
	| NEGATION Exp {
		if($2.type != 0)
			yyerror("Erreur operation de négation avec autre chose qu'un entier\n");
		else{
			instarg("SET",0);
			inst("SWAP");
			inst("POP");
			inst("EQUAL");
			inst("PUSH");
			$$.value=!$2.value;
			$$.type = 0;
		}
	}
	| LValue { 
			if($1.type == 0)
				instarg("SET",$1.value);
			else
				instarg("SET",$1.caractere);
			inst("PUSH");
	}
		
	| NUM  {instarg("SET",$1);inst("PUSH");$$.type = 0;$$.value=$1;$$.size=1;}
		
	| CARACTERE {instarg("SET",$1);inst("PUSH");$$.type=1;$$.caractere=$1;$$.size=1;}


	| IDENT LPAR Arguments RPAR { 
		int i = chercher_symbole($1);
		if(i == -1)
			fprintf(stderr,"La fonction %s n'est pas déclarer\n",$1);
		else{
			$$=tab_sym[i];
		}
	}
  	    ;
%%

int yyerror(char* s) {
  fprintf(stderr,"%s\n",s);
  return 0;
}



void endProgram() {
  printf("HALT\n");
}

void inst(const char *s){
  printf("%s\n",s);
}

void instarg(const char *s,int n){
  printf("%s\t%d\n",s,n);
}


void comment(const char *s){
  printf("#%s\n",s);
}

int main(int argc, char** argv) {
  if(argc==2){
    yyin = fopen(argv[1],"r");
  }
  else if(argc==1){
    yyin = stdin;
  }
  else{
    fprintf(stderr,"usage: %s [src]\n",argv[0]);
    return 1;
  }
  yyparse();
  endProgram();
  return 0;
}
