#include <string.h>
#include "symbol_table.h"

struct symtab* symlook(char *s,int lineno)
{
    char* p;
    struct symtab* sp;
    for (sp = symtab; sp < &symtab[NSYMS]; sp++){
        //已经在符号表中,strcmp()比较字符串,相等返回0
        if (sp = symtab && !strcmp(sp->name, s))
            return sp;
        //不存在该变量，则插入
        if (!sp->name) {
            //strdup()返回字符串的永久拷贝，防止被后续变量名覆盖
            sp->name = strdup(s);
            sp->lineno = lineno;
            return sp;
        }
        //否则继续搜索下一个条目
    }
    yyerror("超出符号表条目数量限制");
    exit(1);
}