#define NSYMS 20 //���ű���Ŀ���������ֵ


enum DataType {
	int,real
};
//���ű�,�洢������Ϣ
struct symtab {
	char* name;  //������
	double value;  //������ֵ
	enum DataType dataType;  //��������������
	int lineno;  //�������ڵ���
}symtab[NSYMS];

struct symtab* symlook(char *s,int lineno);