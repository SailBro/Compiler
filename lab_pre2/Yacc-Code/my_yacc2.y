%{

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#ifndef YYSTYPE
// 返回字符串类型*
#define YYSTYPE char*
#endif

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

char id_array[100];// 存储ID
char num_array[100];// 存储num

%}


// 声明词法单元
%token NUMBER
%token ID
%token ADD 
%token SUB
%token MUL
%token DIV
%token MINUS
%token LEFT_PAR
%token RIGHT_PAR

// 声明运算符的结合性和优先级
%left ADD SUB
%left MUL DIV 
%right UMINUS        

%%

// 语法制导规则

// 遇到";"时处理输入并打印计算结果
lines :    lines expr ';' { printf("%s\n", $2); } 
      |    lines ';'
      |
      ;

// 中缀->后缀，strcat实现拼接
// a+b -> ab+
expr    : expr ADD expr { $$ = strcat(strcat($1, " "), strcat($3, " +")); }
        | expr SUB expr { $$ = strcat(strcat($1, " "), strcat($3, " -")); }
        | expr MUL expr { $$ = strcat(strcat($1, " "), strcat($3, " *")); }
        | expr DIV expr { $$ = strcat(strcat($1, " "), strcat($3, " /")); }
        | LEFT_PAR expr RIGHT_PAR { $$ = $2; }
        | SUB expr %prec UMINUS { $$ = strcat($2, " -"); }
        | NUMBER { $$ = strdup($1); }
        | ID { $$ = strdup($1); }
        ;

%%

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' ' || t=='\t'||t=='\n')
            ;

        // NUMBER读取（不用做转换）
        else if (isdigit(t)){
            int len=0;
            // 第一个为整数
            while(isdigit(t)){
                num_array[len]=t;
                t=getchar();
                len++;
            }
            num_array[len]='\0';
            yylval=num_array; //字符串赋值
            ungetc(t,stdin);
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
            yylval=id_array; // yylval存储地址，相当于字符串指针赋值
            ungetc(t,stdin);
            return ID;
        }

        // 识别部分不再变动
        else if(t=='+') {
            return ADD;  
        }
        else if(t=='-'){
            return SUB;
        }
        else if(t=='*'){
            return MUL;
        }
        else if(t=='/'){
            return DIV;
        }
        else if(t=='('){
            return LEFT_PAR;
        }
        else if(t==')'){
            return RIGHT_PAR;
        }
        else {
            return t;
        }
    }
}

int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    } while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}