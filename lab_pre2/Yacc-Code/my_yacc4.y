%{

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

char id_array[100];// 存储ID

#define MAX_NAME_LEN 100

// 符号结构体
struct symbol{
    char *name; //符号名
    double value; //符号值
    struct symbol *next; //符号指针
};

// 符号表
// 头指针
struct symbol *symbolTable = NULL;

struct symbol* find(char* name){
    // 在符号表中查找符号
    struct symbol *s;
    for(s=symbolTable;s!=NULL;s=s->next){  // for循环遍历符号表
        if(strcmp(s->name,name)==0){
            return s;
        }
    }
    return NULL;  // 没有找到
}

void add(char* name, double value){
    // 向符号表中添加符号
    struct symbol *s = find(name);
    if(s!=NULL){  // 如果存在
        s->value = value;
        return;
    }
    // 不存在就创建
    s = malloc(sizeof(struct symbol));
    s->name = strdup(name);
    s->value = value;
    s->next = symbolTable;
    symbolTable = s;// 放到链表头
}


%}

// YYSTYPE：名+值j

%union{
    double dval;  // 变量值
    char *name;   // 变量名
}

// 声明词法单元
%token<dval> NUMBER
%token<name> ID
%token ADD 
%token SUB
%token MUL
%token DIV
%token MINUS
%token LEFT_PAR
%token RIGHT_PAR
%token ASSIGN // 赋值符号


// 声明运算符的结合性和优先级
%left ASSIGN
%left ADD MINUS
%left MUL DIV
%right UMINUS   

%type<dval> expr
%type<dval> stmt
%start lines

%%

// 语法制导规则

// 遇到";"时处理输入并打印计算结果
lines   :       lines stmt ';' { printf("%f\n", $2); }
        |       lines ';'
        |
        ;
// 语句    
stmt    :       expr  { $$=$1; }
        |       ID ASSIGN expr  {  $$=$3;add($1,$3); }  // a=b;添加到符号表 

expr    : expr ADD expr   {
            $$=$1+$3; 
            printf("MOV R0 %d\n",$1);
            printf("MOV R1 %d\n",$3);
            printf("ADD R0 R0 R1\n");
        }
        | expr SUB expr   { 
            $$=$1-$3;
            printf("MOV R0 %d\n",$1);
            printf("MOV R1 %d\n",$3);
            printf("SUB R0 R0 R1\n");}
        | expr MUL expr     { 
            $$=$1*$3;
            printf("MOV R0 %d\n",$1);
            printf("MOV R1 %d\n",$3);
            printf("MUL R0 R0 R1\n"); }
        | expr DIV expr     {  
            $$=$1/$3; 
            printf("MOV R0 %d\n",$1);
            printf("MOV R1 %d\n",$3);
            printf("DIV R0 R0 R1\n");}
        | LEFT_PAR expr RIGHT_PAR  {$$ = $2; }
        | NUMBER  {$$=$1;}
        | ID  {   struct symbol *res=find($1);
                                if(res==NULL){
                                    yyerror("ERROR！");
                                }
                                $$=res->value;
                            }
        ;


%%

// programs section

int yylex()  // 词法分析器
{
    int t;
    while(1){
        t=getchar();
        // 增加对空格、换行符等检查
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }
        
        // 数字读取
        else if(isdigit(t)){
            //TODO:解析多位数字返回数字类型 
            // 遇到第一个数字
            yylval.dval=0;
            while(isdigit(t)){
                yylval.dval=yylval.dval*10+t-'0'; //移位，其中t-'0'是ASCII之差
                t=getchar();
            }
            // 跳出->非digit
            ungetc(t, stdin);
            return NUMBER;
        }

        // ID读取
        else if ((t>='a'&& t<='z')||(t>='A'&&t<='Z')||(t=='_')){
            // 第一个符号为字母或下划线
            int len=0; // 记录长度
            while((t>='a'&& t<='z')||(t>='A'&&t<='Z')||(t=='_')||(t>='0'&&t<='9')){
                id_array[len]=t;
                len++;
                t=getchar();
            }
            id_array[len]='\0'; // 最后一个
            yylval.name=id_array; // yylval存储地址，相当于字符串指针赋值
            ungetc(t,stdin);
            return ID;
        }
        
        else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return MINUS;
        }else if(t=='*'){
            return MUL;
        }else if(t=='/'){
            return DIV;
        }else if(t=='('){
            return LEFT_PAR;
        }else if(t==')'){
            return RIGHT_PAR;
        }
        else if(t=='='){  // 赋值符号
            return ASSIGN;
        }
        else{
            return t;
        }
    }
}



int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}