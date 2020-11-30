%{
#include<math.h>
#include<string.h>
#include "yacc.tab.h"

extern "C"//为了能够在C++程序里面调用C函数，必须把每一个需要使用的C函数，其声明都包括在extern "C"{}块里面，这样C++链接时才能成功链接它们。extern "C"用来在C++环境下设置C链接类型。
{	//yacc.y中也有类似的这段extern "C"，可以把它们合并成一段，放到共同的头文件main.h中
	int yywrap(void);
	int yylex(void);//这个是lex生成的词法分析函数，yacc的yyparse()里会调用它，如果这里不声明，生成的yacc.tab.c在编译时会找不到该函数
}

#define IF 1 
#define ELSE 2 
#define WHILE 3
#define READ 4 
#define WRITE 5 
#define INT 6
#define REAL 7
#define PLUS 8 //+
#define MINUS 9 //-
#define MUL 10 //*
#define DIV 11 // /
#define ASSIGN 12 //=
#define LT 13 //<
#define EQ 14 //==
#define NEQ 15 //<>
#define LPARENT 16 //(
#define RPARENT 17 //)
#define LBRACE 18  //{
#define RBRACE 19 //}
#define LBRACKET 20 //[
#define RBRACKET 21 //]
#define LET 22 //<=
#define GT 23 //>
#define GET 24 //>=
#define SEMI 25 //;
#define ID 26 //标识符
#define DOT 27 //.
#define RETURN 28 //return
#define NUMBER 29 //整数int
#define LCOM 30 // /*
#define RCOM 31 // */
#define MAIN 32  //main入口函数
#define DECIMAL 33  //实数real
#define BREAK 34
#define CONTINUE 35
int errornum=0;  //错误id数量
int linenum = 1;
%}

delim  [ \t\n]
ws  {delim}+
newline [\n]
digit [0-9]
number {digit}+
letter [A-Za-z]
id {letter}|({letter}({letter}|{digit}|_)*({letter}|{digit})+)
decimal [-]?({number}[.]{number})([Ee][+-]?{number})? 
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

{newline} {linenum++;}

"if" {fprintf(yyout, "IF %d %s\n", IF, yytext);yylval.text=yytext;yylval.line=linenum;return IF; }
"else" {fprintf(yyout, "ELSE %d %s\n", ELSE, yytext);yylval.text=yytext;yylval.line=linenum;return ELSE; }
"return" {fprintf(yyout, "RETURN %d %s\n", RETURN, yytext); yylval.text=yytext;yylval.line=linenum;return RETURN;}
"while" {fprintf(yyout, "WHILE %d %s\n", WHILE, yytext);yylval.text=yytext;yylval.line=linenum;return WHILE; }
"int"  {fprintf(yyout, "INT %d %s\n", INT, yytext); yylval.text=yytext;yylval.line=linenum;return INT;}
"real"  {fprintf(yyout, "INT %d %s\n", INT, yytext); yylval.text=yytext;yylval.line=linenum;return REAL;}
"read" {fprintf(yyout, "PRINTF %d %s\n", PRINTF, yytext); yylval.text=yytext;yylval.line=linenum;return READ;}
"write" {fprintf(yyout, "PRINTF %d %s\n", PRINTF, yytext); yylval.text=yytext;yylval.line=linenum;return WRITE;}
"main"  {fprintf(yyout, "INT %d %s\n", INT, yytext); yylval.text=yytext;yylval.line=linenum;return MAIN;}
"break"  {fprintf(yyout, "INT %d %s\n", INT, yytext); yylval.text=yytext;yylval.line=linenum;return BREAK;}
"continue"  {fprintf(yyout, "INT %d %s\n", INT, yytext); yylval.text=yytext;yylval.line=linenum;return CONTINUE;}

"."                     { fprintf(yyout, ". %d %s\n", DOT, yytext); yylval.text=yytext;yylval.line=linenum;return DOT; }
";"                     { fprintf(yyout, "; %d %s\n", SEMI, yytext); yylval.text=yytext;yylval.line=linenum;return SEMI; }
"="                     { fprintf(yyout, "= %d %s\n", ASSIGN, yytext);  yylval.text=yytext;yylval.line=linenum;return ASSIGN;}
"+"                     { fprintf(yyout, "+ %d %s\n", PLUS, yytext); yylval.text=yytext;yylval.line=linenum;return PLUS; }
"-"                     { fprintf(yyout, "- %d %s\n", MINUS, yytext); yylval.text=yytext;yylval.line=linenum;return MINUS; }
"*"                     { fprintf(yyout, "* %d %s\n", MUL, yytext); yylval.text=yytext;yylval.line=linenum;return MUL; }
"/"                     { fprintf(yyout, "/ %d %s\n", DIV, yytext);  yylval.text=yytext;yylval.line=linenum;return DIV;}
"["                     { fprintf(yyout, "[ %d %s\n", LBRACKET, yytext);  yylval.text=yytext;yylval.line=linenum;return LBRACKET;}
"]"                     { fprintf(yyout, "] %d %s\n", RBRACKET, yytext); yylval.text=yytext;yylval.line=linenum;return RBRACKET; }
"("                     { fprintf(yyout, "( %d %s\n", LPARENT, yytext); yylval.text=yytext;yylval.line=linenum;return LPARENT; }
")"                     { fprintf(yyout, ") %d %s\n", RPARENT, yytext);  yylval.text=yytext;yylval.line=linenum;return RPARENT;}
"=="                    { fprintf(yyout, "== %d %s\n", EQ, yytext);  yylval.text=yytext;yylval.line=linenum;return EQ;}
"<="                    { fprintf(yyout, "<= %d %s\n", LET, yytext);  yylval.text=yytext;yylval.line=linenum;return LET;}
">="                    { fprintf(yyout, ">= %d %s\n", GET, yytext); yylval.text=yytext;yylval.line=linenum;return GET; }
"<>"                    { fprintf(yyout, "<> %d %s\n", NEQ ,yytext); yylval.text=yytext;yylval.line=linenum;return NEQ; }
">"                     { fprintf(yyout, "> %d %s\n", GT, yytext);  yylval.text=yytext;yylval.line=linenum;return LT;}
"<"                     { fprintf(yyout, "< %d %s\n", LT, yytext); yylval.text=yytext;yylval.line=linenum;return GT; }

{number} {fprintf(yyout, "NUMBER %d %s\n", NUMBER, yytext); yylval.m_nInt=atoi(yytext);yylval.line=linenum;return NUMBER;}
{decimal} {fprintf(yyout, "REAL %d %s\n", REAL, yytext); yylval.m_decimal=atof(yytext);yylval.line=linenum;return DECIMAL;}
{id} {   
      fprintf(yyout, "ID %d %s\n", IDcount - 1 + 70, yytext); yylval.text=yytext;yylval.line=linenum;return ID;
}

"{" {
    
      fprintf(yyout, "LBRACE %d %s\n", LBRACE, yytext);  yylval.text=yytext;yylval.line=linenum;return LBRACE;
}

"}" {
   
   fprintf(yyout, "RBRACE %d %s\n", RBRACE, yytext);  yylval.text=yytext;yylval.line=linenum;return RBRACE;
}
%%
int main()
{
  yyin=fopen("testin.c","r");
  yyout=fopen("testout.txt","w");
  fprintf(yyout,"lexme  code  test\n");
  yylex();
  return 0;
}
int yywrap()
{
  return 1;
}