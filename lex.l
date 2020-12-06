%{
#include<math.h>
#include<string.h>
#include "main.h"
#include "yacc.tab.h"
#include "symbol_table.h"

extern YYSTYPE yylval;
extern "C"//为了能够在C++程序里面调用C函数，必须把每一个需要使用的C函数，其声明都包括在extern "C"{}块里面，这样C++链接时才能成功链接它们。extern "C"用来在C++环境下设置C链接类型。
{	//yacc.y中也有类似的这段extern "C"，可以把它们合并成一段，放到共同的头文件main.h中
	int yywrap(void);
	int yylex(void);//这个是lex生成的词法分析函数，yacc的yyparse()里会调用它，如果这里不声明，生成的yacc.tab.c在编译时会找不到该函数
}


int errornum=0;  //错误id数量
int linenum = 1;
%}

spchar ("{"|"}"|"["|"]"|"("|")"|";"|","|"'"|":")
ariop ("+"|"-"|"*"|"/")
relop ("<"|"<="|">"|">="|"=="|"<>"|"=")
delim  [ \t\n]
ws  {delim}+
newline [\n]
digit [0-9]
number [+-]?{digit}+
letter [A-Za-z]
id {letter}|({letter}({letter}|{digit}|_)*({letter}|{digit})+)
decimal [+-]?({number}[.]{number})([Ee][+-]?{number})? 
commentbegin "/*"
commentelement .|\n
commentend "*/"
%x COMMENT
sgCommentbegin "//"
%x SGCOMMENT 

%%
{commentbegin} {BEGIN COMMENT; fprintf(yyout, "Begin comments:\n"); }
<COMMENT>{commentelement} {fprintf(yyout, "%s", yytext); }
<COMMENT>{commentend} {BEGIN INITIAL; fprintf(yyout, "\n comments End!\n"); }

{sgCommentbegin} {BEGIN SGCOMMENT ;fprintf(yyout, "Begin a comment:\n"); }
<SGCOMMENT>. {fprintf(yyout, "%s", yytext); }
<SGCOMMENT>\n {BEGIN INITIAL;fprintf(yyout, "\n this comment End!\n");}

{newline} {lineno++;}

"if" {fprintf(yyout, "IF %d %s\n", IF, yytext);return IF; }
"else" {fprintf(yyout, "ELSE %d %s\n", ELSE, yytext);return ELSE; }
"while" {fprintf(yyout, "WHILE %d %s\n", WHILE, yytext);return WHILE; }
"int"  {fprintf(yyout, "INT %d %s\n", INT, yytext); return INT;}
"real"  {fprintf(yyout, "INT %d %s\n", INT, yytext); return REAL;}
"read" {fprintf(yyout, "PRINTF %d %s\n", READ, yytext); return READ;}
"write" {fprintf(yyout, "PRINTF %d %s\n", WRITE, yytext);return WRITE;}
"break"  {fprintf(yyout, "INT %d %s\n", BREAK, yytext);return BREAK;}
"continue"  {fprintf(yyout, "INT %d %s\n", CONTINUE, yytext);return CONTINUE;}

{number} {fprintf(yyout, "NUMBER %d %s\n", NUMBER, yytext); yylval.m_int=atoi(yytext);return NUMBER;}
{decimal} {fprintf(yyout, "REAL %d %s\n", REAL, yytext); yylval.m_decimal=atof(yytext);return DECIMAL;}
{id} { fprintf(yyout, "ID %d %s\n", ID, yytext); yylval.symp=symlook(yytext,lineno);return ID;}
{relop} {fprintf(yyout,"RELOP, %s\n",yytext);yylval.m_relop=yytext;return RELOP;}
. {fprintf(yyout,"%s\n",yytext);errornum++;return yytext[0];}
%%
/*
int main()
{
  yyin=fopen("testin.txt","r");
  yyout=fopen("testout.txt","w");
  fprintf(yyout,"lexme  code  test\n");
  yylex();
  return 0;
}
*/
int yywrap()
{
  puts("-----the file end");
  return 1;//返回1表示读取全部结束。如果要接着读其它文件，可以这里fopen该文件，文件指针赋给yyin，并返回0
}

