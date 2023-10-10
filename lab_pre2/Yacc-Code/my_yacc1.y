%{

/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别

// 声明词法单元
%token NUMBER
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
lines   :       lines expr ';' { printf("%f\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
//$$——产生式最终值；$1及其以后——从左到右的值
expr    :       expr ADD expr   { $$=$1+$3; }
        |       expr MINUS expr   { $$=$1-$3; }
        |       expr MUL expr   { $$=$1*$3; }
        |       expr DIV expr   { $$=$1/$3; }
        |       MINUS expr %prec UMINUS   {$$=-$2;}
        |       NUMBER  {$$=$1;}
        |       LEFT_PAR expr RIGHT_PAR   { $$ = $2; }
        ;

%%

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        // 增加对空格、换行符等检查
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }else if(isdigit(t)){
            //TODO:解析多位数字返回数字类型 
            // 遇到第一个数字
            yylval=0; //语法分析器与词法分析器中传递数值
            while(isdigit(t)){
                yylval=yylval*10+t-'0'; //移位，其中t-'0'是ASCII之差
                t=getchar();。/
            }
            // 跳出->非digit
            ungetc(t, stdin);// 缓冲区取回
            return NUMBER;
        }else if(t=='+'){
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