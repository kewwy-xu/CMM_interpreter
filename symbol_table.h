#pragma once
#ifndef SYMBOL_TABLE_HPP
#define SYMBOL_TABLE_HPP
#define NSYMS 20 //符号表条目数量的最大值


enum DataType {
	dt_int, dt_real
};
//符号表,存储变量信息
struct symtab {
	char* name;  //变量名
	double value;  //变量的值
	enum DataType dataType;  //变量的数据类型
	int lineno;  //词素所在的行
}symtab[NSYMS];

struct symtab* symlook(char *s,int lineno);

#endif