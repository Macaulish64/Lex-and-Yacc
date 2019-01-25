%{
	#include<stdio.h>
	#include<ctype.h>
	#include<stdlib.h>
	#include "node.h"
/*
	struct Pstype{
			union{
				int vint;
				double vreal;
			}vtype;
			int ttype;
		};
	typedef Pstype pstype;
*/
%}
%union{
	int type_int;
	ptype type_exp;
} 
%token <type_int> num
%type <type_exp> expr term factor
%left '+' '-'
%left '*' '/'
%%
line:expr'\n'		{
				if ($1.ttype==0) 
					printf("Answer = %d\n",$1.vtype.vint);
				else 
					printf("Answer = %.6lf\n",$1.vtype.vreal);
			}
	;
expr:expr'+'term	{
				printf("E ==> ");
				if ($1.ttype==0 && $3.ttype==0) {
					$$.ttype=0;
					$$.vtype.vint=$1.vtype.vint+$3.vtype.vint;
					printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
					printf("BY=E -> E + T\n");

				}
				else {
					$$.ttype=1;
					$$.vtype.vreal=0;
					if ($1.ttype==0) 
						$$.vtype.vreal+=$1.vtype.vint;
					else 
						$$.vtype.vreal+=$1.vtype.vreal;
					if ($3.ttype==0) 
						$$.vtype.vreal+=$3.vtype.vint;
					else 
						$$.vtype.vreal+=$3.vtype.vreal;
					printf("\nVAL=%lf , Type=%s , ",$$.vtype.vreal,"REAL");
					printf("BY=E -> E + T\n");
				}
			}
	|expr'-'term	{
				printf("E ==> ");
				if ($1.ttype==0 && $3.ttype==0) {
					$$.ttype=0;
					$$.vtype.vint=$1.vtype.vint-$3.vtype.vint;
					printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
					printf("BY=E -> E - T\n");

				}
				else {
					$$.ttype=1;
					$$.vtype.vreal=0;
					if ($1.ttype==0) 
						$$.vtype.vreal+=$1.vtype.vint;
					else 
						$$.vtype.vreal+=$1.vtype.vreal;
					if ($3.ttype==0) 
						$$.vtype.vreal-=$3.vtype.vint;
					else 
						$$.vtype.vreal-=$3.vtype.vreal;
					printf("\nVAL=%lf , Type=%s , ",$$.vtype.vreal,"REAL");
					printf("BY=E -> E - T\n");
				}
			}
	|term		{
				printf("E ==> ");
				if ($1.ttype==0) {
					$$.ttype=0;
					$$.vtype.vint=$1.vtype.vint;
					printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
					printf("BY=E -> T\n");

				}
				else {
					$$.ttype=1;
					$$.vtype.vreal=$1.vtype.vreal;
					printf("\nVAL=%lf , Type=%s , ",$$.vtype.vreal,"REAL");
					printf("BY=E -> T\n");
				}
			}
	;
term:term'*'factor	{
				printf("T ==> ");
				if ($1.ttype==0 && $3.ttype==0) {
					$$.ttype=0;
					$$.vtype.vint=$1.vtype.vint*$3.vtype.vint;
					printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
					printf("BY=T -> T * F\n");

				}
				else {
					$$.ttype=1;
					$$.vtype.vreal=1;
					if ($1.ttype==0) 
						$$.vtype.vreal*=$1.vtype.vint;
					else 
						$$.vtype.vreal*=$1.vtype.vreal;
					if ($3.ttype==0) 
						$$.vtype.vreal*=$3.vtype.vint;
					else 
						$$.vtype.vreal*=$3.vtype.vreal;
					printf("\nVAL=%lf , Type=%s , ",$$.vtype.vreal,"REAL");
					printf("BY=T -> T * F\n");
				}
			}
	|term'/'factor	{
				printf("T ==> ");
				if ($1.ttype==0 && $3.ttype==0 && $1.vtype.vint%$3.vtype.vint==0) {
					$$.ttype=0;
					$$.vtype.vint=$1.vtype.vint/$3.vtype.vint;
					printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
					printf("BY=T -> T / F\n");

				}
				else {
					$$.ttype=1;
					$$.vtype.vreal=1;
					if ($1.ttype==0) 
						$$.vtype.vreal*=$1.vtype.vint;
					else 
						$$.vtype.vreal*=$1.vtype.vreal;
					if ($3.ttype==0) 
						$$.vtype.vreal/=$3.vtype.vint;
					else 
						$$.vtype.vreal/=$3.vtype.vreal;
					printf("\nVAL=%lf , Type=%s , ",$$.vtype.vreal,"REAL");
					printf("BY=T -> T / F\n");
				}
			}
	|factor		{
				printf("T ==> ");
				if ($1.ttype==0) {
					$$.ttype=0;
					$$.vtype.vint=$1.vtype.vint;
					printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
					printf("BY=T -> F\n");

				}
				else {
					$$.ttype=1;
					$$.vtype.vreal=$1.vtype.vreal;
					printf("\nVAL=%lf , Type=%s , ",$$.vtype.vreal,"REAL");
					printf("BY=T -> F\n");
				}
			}
	;
factor:'('expr')'	{
				printf("F ==> ");
				if ($2.ttype==0) {
					$$.ttype=0;
					$$.vtype.vint=$2.vtype.vint;
					printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
					printf("BY=F -> (E)\n");

				}
				else {
					$$.ttype=1;
					$$.vtype.vreal=$2.vtype.vreal;
					printf("\nVAL=%lf , Type=%s , ",$$.vtype.vint,"REAL");
					printf("BY=F -> (E)\n");
				}
			}
	|num'.'num	{
				printf("F ==> ");
				$$.ttype=1;
				$$.vtype.vreal=$3;
				while ($$.vtype.vreal>=1) $$.vtype.vreal/=10.;
				$$.vtype.vreal+=$1;
				printf("\nVAL=%lf , Type=%s , ",$$.vtype.vreal,"REAL");
				printf("BY=F -> num.num\n");
			}
	|num		{
				printf("F ==> ");
				$$.ttype=0;
				$$.vtype.vint=$1;
				printf("\nVAL=%d , Type=%s , ",$$.vtype.vint,"INTEGER");
				printf("BY=F -> num\n");
			}
	;
%%
int main(){
	return yyparse();
}

int yyerror(char *s) {
	printf("%s\n",s);
}
