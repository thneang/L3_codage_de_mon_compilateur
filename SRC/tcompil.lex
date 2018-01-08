%{
#include <symbole.h>
#include <tcompil.h>

%}
%%
[ \t\n]+ ;
"\*"[a-zA-Z0-9]*"*/" ;
[0-9]+ {sscanf(yytext,"%d",&yylval.entier); return NUM;}
"'"[A-Za-z]"'" {yylval.caractere = yytext[1]; return CARACTERE;}
"entier" {yylval.type = 0; return TYPE;}
"caractere" {yylval.type = 1; return TYPE;}
"void" {return VOID;}
"const" { return CONST;}
"main" {return MAIN;}
"==" {yylval.operation=0 ;return COMP;}
"!=" {yylval.operation=1 ;return COMP;}
"<" {yylval.operation=2 ;return COMP;}
">" {yylval.operation=3 ;return COMP;}
"<=" {yylval.operation=4 ;return COMP;}
">=" {yylval.operation=5 ;return COMP;}
"=" {return EGAL;}
"+" {yylval.operation = 0;return ADDSUB;}
"-" {yylval.operation = 1;return ADDSUB;}
"*" {yylval.operation =0 ;return DIVSTAR;}
"/" {yylval.operation = 1;return DIVSTAR;}
"%" {yylval.operation = 2;return DIVSTAR;}
"!" {return NEGATION;}
"&&" {yylval.operation=0;return BOPE;}
"||" {yylval.operation=1;return BOPE;}
"if" {return IF;}
"print" {return PRINT;}
"readch" {return READCH; }
"else" { return ELSE; }
"while" { return WHILE; }
"read" { return READ;}
"return" { return RETURN;}
";" {return PV;}
"," {return VRG;}
"(" {return LPAR;}
")" {return RPAR;}
"{" {return LACC;}
"}" {return RACC;}
"["  {return LSQB;}
"]" {return RSQB;}
[a-zA-z][a-zA-Z0-9]* {yylval.id = malloc(32); strncpy(yylval.id,yytext,32);return IDENT;}
"'" {;}
. {fprintf(stderr,"Erreur %s non reconnu\n",yytext); exit(1);}

%%
