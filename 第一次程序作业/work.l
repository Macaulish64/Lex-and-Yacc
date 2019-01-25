%{
	int wordCounter =0;
	int charCounter =0;
	int column = 0,line = 1;
	void addLine(int);
	void addColumn(int);
	void clearColumn();
	void addChar(int);
	void addWord(int);
%}
char		'[^']*' 
string		\"[^\"]*\" 
line_comment	(\/\/.*\n) 
%x BLOCK_COMMENT 
letter	[A-Za-z_] 
digit	[0-9] 
identifier	{letter}({letter}|{digit})* 
reserveword	"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"
preprocess	^#.*\n	
integer	{digit}+	
float	{digit}*(\.{digit}+)?(e|E[+\-]?{digit}+)?	
operater	"!"|"%"|"^"|"&"|"*"|"("|")"|"-"|"+"|"="|"=="|"{"|"}"|"["|"]"|"\\"|"|"|":"|";"|"<"|">"|","|"."|"/"|"?"|"!="|"<="|">="|"&&"|"||"|"+="|"-="|"*="|"/="|"|%="|"<<="|">>="|"^="|"&=" 
il_char		\'[^']{4}	
il_string	\"[^"]{30} 
il_identifier	{digit}({letter}|{digit})*{letter}({letter}|{digit})*

%%

{preprocess} {
	printf("Line=%3d,Column=%3d : This is preprocess %s",line,column,yytext);
	addChar(yyleng);
	clearColumn();
	addLine(1);
}

{operater}	{
	addColumn(1);
	addChar(1);
	printf("Line=%3d,Column=%3d : This is operater %s\n",line,column,yytext);
}

{reserveword} {
	printf("Line=%3d,Column=%3d : This is reserveword %s\n",line,column,yytext);
	addChar(yyleng);
	addColumn(yyleng);
	addWord(1);
}

{identifier} {
	printf("Line=%3d,Column=%3d : This is identifier %s\n",line,column,yytext);
	addChar(yyleng);
	addColumn(yyleng);
	addWord(1);
}

{il_identifier} {
	addChar(yyleng);
	addColumn(yyleng);
	printf("Error(Line=%3d,Column=%3d): wrong identifier: %s\n",line,column,yytext);
}

{char}	{
	printf("Line=%3d,Column=%3d : This is char %s\n",line,column,yytext);
	addChar(yyleng);
	addColumn(yyleng);
}

{string} {
	printf("Line=%3d,Column=%3d : This is string %s\n",line,column,yytext);
	addColumn(yyleng);
	addChar(yyleng);
}

"/*" {
	printf("Line=%3d,Column=%3d : This is block comment begin\n",line,column);
	BEGIN(BLOCK_COMMENT);
	yymore();
	addColumn(2);
	addChar(2);
}
<BLOCK_COMMENT>.|\n	{
	yymore();
	if(yytext[0] == '\n'){
		clearColumn();
		addLine(1);
	}
	else
		addColumn(1);
}

<BLOCK_COMMENT>"*/" {
	addChar(2);
	addColumn(2);
	puts("----------------");
	printf("%s\n",yytext);
	puts("----------------");
	printf("Line=%3d,Column=%3d : This is block comment end\n",line,column);
	BEGIN(INITIAL);
}


{line_comment}	{
	printf("Line=%3d,Column=%3d : This is line comment %s",line,column,yytext);
	addChar(yyleng);
	clearColumn();
	addLine(1);
}

{integer} {
	addChar(yyleng);
	addColumn(yyleng);
	printf("Line=%3d,Column=%3d : This is integer %s\n",line,column,yytext);
}

{float}	{
	addChar(yyleng);
	addColumn(yyleng);
	printf("Line=%3d,Column=%3d : This is float %s\n",line,column,yytext);
}

{il_string} {
	addChar(yyleng);
	addColumn(yyleng);
	printf("Error(Line=%3d,Column=%3d): not closed string: %s\n",line,column,yytext);
}

{il_char} {
	addChar(yyleng);
	addColumn(yyleng);
	printf("Error(Line=%3d,Column=%3d): not closed char: %s\n",line,column,yytext);
}

.	{
	addChar(1);
	addColumn(1);
}

\n	{
	addChar(1);
	addLine(1);
	clearColumn();
}

%%
int main(void)
{
	puts("==========================================");
	puts("Welcome to use the analyzer in C");
	puts("==========================================");
	yylex();
	puts("==========================================");
	puts("Couter");
	printf("CharCounter:%5d\n",charCounter);
	printf("LineCounter:%5d\n",line);
	printf("WordCounter:%5d\n",wordCounter);
	puts("==========================================");
	return 0;
}
int yywrap() {
	return 1;
}

void addLine(int cnt) {
	line += cnt;
}
void addColumn(int cnt) {
	column += cnt;
}
void clearColumn(){
	column = 0;
}
void addChar(int leng) {
	charCounter += leng;
}
void addWord(int cnt) {
	wordCounter += cnt;
}
