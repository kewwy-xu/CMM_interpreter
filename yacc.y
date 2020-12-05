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
	stmt_sequence{}
	;
stmt_sequence:
	statement ';'stmt_sequence{}
	| statement %prec N{}
	| /* empty */
	;
statement:
	if_stmt{}
	| while_stmt{}
	| assign_stmt{}
	| read_stmt{}
	| write_stmt{}
	| declare_stmt{}
	;
stmt_block:
	 stmt_sequence  {}
	;
if_stmt:
	IF '(' exp ')' THEN stmt_block {} %prec IFX
	| IF '(' exp ')' THEN stmt_block ELSE stmt_block {}
	;
while_stmt:
	WHILE '(' exp ')' stmt_block{}
	;
assign_stmt:
	variable '=' exp ';'{}
	;
read_stmt:
	READ variable ';'{}
	;
write_stmt:
	WRITE exp ';'{}
	;
declare_stmt:
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
	addtive_exp logical_op addtive_exp {}
	| addtive_exp {} %prec NLO
	;
addtive_exp:
	term add_op addtive_exp {}
	| term {} %prec NAO
	;
term: 
	factor mul_op term {}
	| factor {} %prec NMO
	;
factor:
	'(' exp ')' {}
	| NUMBER {}
	| variable {}
	| add_op exp {}
	;
logical_op:
	'>' {}
	| '<' {}
	| '>' '=' {}
	| '<' '=' {}
	| '<' '>' {}
	| '=' '=' {}
	;
add_op:
	'+' {}
	| '-' {}
	;
mul_op:
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
		return _1;
	}
	extern FILE* yyin;				//yyin和yyout都是FILE*类型
	yyin=fp;						//yacc会从yyin读取输入，yyin默认是标准输入，这里改为磁盘文件。yacc默认向yyout输出，可修改yyout改变输出目的

	printf("_____begin parsing %s\n", sFile);
	yyparse();						//使yacc开始读取输入和解析，它会调用lex的yylex()读取记号
	puts("_____end parsing");

	fclose(fp);

	return 0;
}
