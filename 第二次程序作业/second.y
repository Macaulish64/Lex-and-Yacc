%{
	#include<stdio.h>
	#include<ctype.h>
%}
%token num
%left '+' '-'
%left '*' '/'
%%
line:expr'\n'			{printf("Answer = %d\n",$1);}
	;
expr:expr'+'term		{$$=$1+$3;printf("\t\t%d -> %d + %d\t\t\tE -> E + T\n",$$,$1,$3);}
	|expr'-'term		{$$=$1-$3;printf("\t\t%d -> %d - %d\t\t\tE -> E - T\n",$$,$1,$3);}
	|term				{$$=$1;printf("\t\t%d -> %d\t\t\tE -> T\n",$$,$1);}
	;
term:term'*'factor		{$$=$1*$3;printf("\t\t%d -> %d * %d\t\t\tT -> T * F\n",$$,$1,$3);}
	|term'/'factor		{$$=$1/$3;printf("\t\t%d -> %d / %d\t\t\tT -> T / F\n",$$,$1,$3);}
	|factor				{$$=$1;printf("\t\t%d -> %d\t\t\tT -> F\n",$$,$1);}
	;
factor:'('expr')'		{$$=$2;printf("\t\t%d -> (%d)\t\t\tF -> (E)\n",$$,$2);}
	|num				{$$=$1;printf("\t\t%d -> %d\t\t\tF -> num\n",$$,$1);}
	;
%%
int main(){
	return yyparse();
}

int yyerror(char *s) {
	printf("%s\n",s);
}
