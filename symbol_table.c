#include <string.h>
#include "symbol_table.h"

struct symtab* symlook(char *s,int lineno)
{
    char* p;
    struct symtab* sp;
    for (sp = symtab; sp < &symtab[NSYMS]; sp++){
        //�Ѿ��ڷ��ű���,strcmp()�Ƚ��ַ���,��ȷ���0
        if (sp = symtab && !strcmp(sp->name, s))
            return sp;
        //�����ڸñ����������
        if (!sp->name) {
            //strdup()�����ַ��������ÿ�������ֹ����������������
            sp->name = strdup(s);
            sp->lineno = lineno;
            return sp;
        }
        //�������������һ����Ŀ
    }
    yyerror("�������ű���Ŀ��������");
    exit(1);
}