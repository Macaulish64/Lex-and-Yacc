%{
	#include "node.h"
	#include "second.tab.h"

	int calc_num();
//	#define num 257
%}

digit [0-9]
num	{digit}+

%%

{num} {
	//printf("%s\n",yytext);
	yylval.type_int=calc_num();
	return(num);
}

"+" {return('+');}
"-" {return('-');}
"*" {return('*');}
"/" {return('/');}
"(" {return('(');}
")" {return(')');}
\n  {return('\n');}
"." {return('.');}
%%
int yywrap() {
	return 1;
}

int calc_num() {
//	printf("%s\n",yytext);
	int sum=0,i;
	for(i = 0; yytext[i] != '\0' ;i++)
			sum=sum*10+(yytext[i]-'0');
	//printf("%d\n",sum);
	return sum;
}

