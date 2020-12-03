%{

#include "main.h"	

extern "C"			
{					
	void yyerror(const char *s);
	extern int yylex(void);
}

%}


%token ID
%token INT
%token REAL
%token IF
%token ELSE
%token WHILE
%token READ
%token WRITE
%token NUMBER
%token THEN

%nonassoc NAO
%left '+' '-'
%nonassoc NMO
%left '*' '/'
 
%nonassoc IFX
%nonassoc ELSE
%nonassoc NLO
%nonassoc '<' '=' '>'

%nonassoc N
%nonassoc ';'
%%

program:
	stmt-sequence{}
	;
stmt-sequence:
	statement ';'stmt-sequence{}
	| statement %prec N{}
	| /* empty */
	;
statement:
	if-stmt{}
	| while-stmt{}
	| assign-stmt{}
	| read-stmt{}
	| write-stmt{}
	| declare-stmt{}
	;
stmt-block:
	 stmt-sequence  {}
	;
if-stmt:
	IF '(' exp ')' THEN stmt-block {} %prec IFX
	| IF '(' exp ')' THEN stmt-block ELSE stmt-block {}
	;
while-stmt:
	WHILE '(' exp ')' stmt-block{}
	;
assign-stmt:
	variable '=' exp ';'{}
	;
read-stmt:
	READ variable ';'{}
	;
write-stmt:
	WRITE exp ';'{}
	;
declare-stmt:
	INT ID '=' exp{}
	| INT ID {}
	| INT ID '[' exp ']'{}
	| REAL ID '=' exp {}
	| REAL ID {}
	| REAL ID '[' exp ']'{}
	ID '=' exp {} 
	;
variable:
	ID{}
	| ID'['exp']'{}
	;
exp:
	addtive-exp logical-op addtive-exp {}
	| addtive-exp {} %prec NLO
	;
addtive-exp:
	term add-op addtive-exp {}
	| term {} %prec NAO
	;
term: 
	factor mul-op term {}
	| factor {} %prec NMO
	;
factor:
	'(' exp ')' {}
	| NUMBER {}
	| variable {}
	| add-op exp {}
	;
logical-op:
	'>' {}
	| '<' {}
	| '>' '=' {}
	| '<' '=' {}
	| '<' '>' {}
	| '=' '=' {}
	;
add-op:
	'+' {}
	| '-' {}
	;
mul-op:
	'*' {}
	| '/' {}
	;


%%

void yyerror(const char *s)			//当yacc遇到语法错误时，会回调yyerror函数，并且把错误信息放在参数s中
{
	cerr<<s<<endl;					//直接输出错误信息
}

int main()							//程序主函数，这个函数也可以放到其它.c, .cpp文件里
{
	const char* sFile="file.txt";	//打开要读取的文本文件
	FILE* fp=fopen(sFile, "r");
	if(fp==NULL)
	{
		printf("cannot open %s\n", sFile);
		return -1;
	}
	extern FILE* yyin;				//yyin和yyout都是FILE*类型
	yyin=fp;						//yacc会从yyin读取输入，yyin默认是标准输入，这里改为磁盘文件。yacc默认向yyout输出，可修改yyout改变输出目的

	printf("-----begin parsing %s\n", sFile);
	yyparse();						//使yacc开始读取输入和解析，它会调用lex的yylex()读取记号
	puts("-----end parsing");

	fclose(fp);

	return 0;
}
