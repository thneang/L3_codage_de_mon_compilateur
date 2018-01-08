/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_SRC_TCOMPIL_H_INCLUDED
# define YY_YY_SRC_TCOMPIL_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IF = 258,
    ELSE = 259,
    WHILE = 260,
    PRINT = 261,
    VOID = 262,
    CONST = 263,
    MAIN = 264,
    RETURN = 265,
    READ = 266,
    READCH = 267,
    PV = 268,
    VRG = 269,
    LPAR = 270,
    RPAR = 271,
    LACC = 272,
    RACC = 273,
    LSQB = 274,
    RSQB = 275,
    CARACTERE = 276,
    NUM = 277,
    TYPE = 278,
    IDENT = 279,
    BOPE = 280,
    COMP = 281,
    ADDSUB = 282,
    DIVSTAR = 283,
    NEGATION = 284,
    EGAL = 285,
    NOELSE = 286
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 20 "./SRC/tcompil.y" /* yacc.c:1909  */

	int 		entier;
	int*		tvalue;
	char		caractere;
	int 		operation;
   	char*		id;
	symbole		symb;
   	int		type;
	int		adresse;

#line 97 "./SRC/tcompil.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_TCOMPIL_H_INCLUDED  */
