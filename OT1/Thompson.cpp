%{

#include<iostream>
#include<fstream>
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
// 定义空字符为#
#define EmptyVal '#'

using namespace std;

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

// 使用链表存储NFA的结构

// 状态节点类
class Node;

// 状态边类
class Edge;

Node* node_array[1000];
int node_num=1;

Edge* edge_array[1000];
int edge_num=1;

class Node{
public:
    int num;// 序号
    Edge* edge_prev[2];// 前向边
    Edge* edge_next[2];// 后向边
    int prev_num,next_num;
    Node(){
        num=node_num;
        cout<<num<<endl;
        node_array[node_num++]=this;
        prev_num=next_num=0;
        edge_prev[0]=edge_prev[1]=edge_next[0]=edge_next[1]=nullptr;
    }
    void setNum(int number){
        num=number;
    }
    void merge(Node* NextNode);
    
};

class Edge{
public:
    char val;// 边的值
    Node* node_prev;// 前一个状态
    Node* node_next;// 后一个状态
    int num;// 序号
    Edge(){
        val=EmptyVal;
        node_prev=node_next=nullptr;
        num=edge_num;
        edge_array[edge_num++]=this;
    }
    Edge(char value){
        val=value;
        node_prev=node_next=nullptr;
        num=edge_num;
        edge_array[edge_num++]=this;
    }
    void setNum(int number){
        num=number;
    }
    void setVal(char value){
        val=value;
    }
    // 连接边和两个节点
    void connect_edge_with_nodes(Node* node1, Node* node2){
        // 边对象中设置
        node_prev=node1;
        node_next=node2;

        // 点对象中设置
        if(node1->next_num==2||node2->prev_num==2){
            yyerror("The node has been filled with!");
            return;
        }
        node1->edge_next[node1->next_num++]=this;
        node2->edge_prev[node2->prev_num++]=this;
    }
};

// 与后面的节点合并（后面的节点为起始节点，即没有前向边）
void Node::merge(Node* NextNode){
    // 前面点的next边要改
    for(int i=0;i<NextNode->next_num;i++)
        edge_next[next_num++]=NextNode->edge_next[i];

    // 后面边的起始点要改
    for(int i=0;i<NextNode->next_num;i++)
        NextNode->edge_next[i]->node_prev=this;

    // 在数组中删除：
    cout<<"!"<<NextNode->num;
    for(int i=1;i<=node_num;i++)
        if(node_array[i]->num==NextNode->num){
            node_array[i]->num=0;
            NextNode->num=0;
            break;
        }
    cout<<"!"<<NextNode->num;
    // delete(NextNode);
}

class NFA{
public:
    // 始末节点
    Node* start;
    Node* end;
    NFA(){
        start=end=nullptr;
    }
    NFA(Node* node1, Node* node2){
        start=node1;
        end=node2;
    }
};


// 正则计算相关函数
NFA* func_char(char symbol);
NFA* func_connect(NFA* state1, NFA* state2);
NFA* func_or(NFA* state1, NFA* state2);
NFA* func_closure(NFA* state);
void func_printNFA(NFA* state);

%}

%union{
    char cval;  // 字符
    struct NFA* nval;  // 控制NFA
}

// 声明词法单元
%token <cval>CHAR
%token OR
%token CONNECT
%token CLOSURE
%token LEFT_PAR
%token RIGHT_PAR

// 声明运算符的结合性和优先级
%left CONNECT 
%left OR
%left CLOSURE 

%type <nval>expr 
%type <nval>con_expr
%type <nval>term

%start lines

%%

// 语法制导规则

// 遇到";"时处理输入并打印计算结果
lines   : lines expr ';' { func_printNFA($2); } 
        | lines ';'
        |
        ;

// 优先级顺序定义
// OR
expr    : expr OR con_expr { $$=func_or($1,$3); }
        | con_expr { $$=$1; }
        ;

// CONNECT
con_expr: term con_expr { $$=func_connect($1,$2); }
        | term { $$=$1; }
        ;

// CLOSURE
term    : term CLOSURE { $$=func_closure($1); }
        | LEFT_PAR expr RIGHT_PAR { $$=$2; }
        | CHAR { $$=func_char($1); }
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
        else if (isdigit(t)||(t>='a'&& t<='z')||(t>='A'&&t<='Z')||t=='#'){
            yylval.cval = t;
            return CHAR;
        }
        else if(t=='|') {
            return OR;  
        }
        else if(t=='*'){
            return CLOSURE;
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


NFA* func_char(char symbol){
    Node* node1=new Node();
    Node* node2=new Node();

    Edge* edge=new Edge(symbol);
    edge->connect_edge_with_nodes(node1,node2);

    NFA* res= new NFA(node1, node2);
    return res;
}

NFA* func_connect(NFA* state1, NFA* state2){
    Node* mid1=state1->end;
    mid1->merge(state2->start);

    NFA* res=new NFA(state1->start, state2->end);
    return res;
}

NFA* func_or(NFA* state1, NFA* state2){
    Node* start=new Node();
    Node* end=new Node();

    Edge* e1=new Edge(EmptyVal);
    Edge* e2=new Edge(EmptyVal);
    Edge* e3=new Edge(EmptyVal);
    Edge* e4=new Edge(EmptyVal);
    e1->connect_edge_with_nodes(start, state1->start);
    e2->connect_edge_with_nodes(start, state2->start);
    e3->connect_edge_with_nodes(state1->end, end);
    e4->connect_edge_with_nodes(state2->end, end);

    NFA* res=new NFA(start, end);
    return res;
}

NFA* func_closure(NFA* state){
    Node* start=new Node();
    Node* end=new Node();

    Edge* e1=new Edge(EmptyVal);
    Edge* e2=new Edge(EmptyVal);
    Edge* e3=new Edge(EmptyVal);
    Edge* e4=new Edge(EmptyVal);

    e1->connect_edge_with_nodes(start, state->start);
    e2->connect_edge_with_nodes(state->end, end);
    e3->connect_edge_with_nodes(start, end);
    e4->connect_edge_with_nodes(state->end, state->start);

    NFA* res=new NFA(start, end);
    return res;
}

void func_printNFA(NFA* state){
    cout<<endl<<"!!"<<node_num<<" "<<edge_num<<endl;

    cout<<"nodes:"<<endl;
    for(int i=1;i<=node_num;i++)
        if(node_array[i]!=nullptr)
            cout<<node_array[i]->num<<" ";
    cout<<endl<<"edges:"<<endl;
    for(int i=1;i<edge_num;i++)
        if(edge_array[i]!=nullptr)
            cout<<edge_array[i]->num<<" ";


    // 打开文件流以将数据写入文件
    std::ofstream w("input.dot"); // 文件名可以是相对路径或绝对路径

    if (w.is_open()) {
        // 写入数据到文件
        w<<"digraph LinkedList {"<<endl;
        w<<"node [shape=ellipse];"<<endl;

        // 开始写节点信息
        for(int i=1;i<=node_num;i++){
            if(node_array[i]==nullptr)
                continue;
            int temp_num=node_array[i]->num;
            if(temp_num<=0||temp_num>node_num)
                continue;
            w<<"Node"<<temp_num<<" [label=\""<<temp_num<<"\"];" ;
            w<<endl;
        }

        // 开始写边的信息（节点连接关系）
        for(int i=1;i<edge_num;i++){
            cout<<i<<"!"<<endl;
            Edge* temp_edge=edge_array[i];
            if(temp_edge==nullptr)
                continue;
            cout<<"OK!"<<endl;
            cout<<temp_edge->num<<endl;
            cout<<temp_edge->node_prev<<endl;
            if(temp_edge->node_prev==nullptr)
                cout<<"worning"<<endl;
            int n1=temp_edge->node_prev->num;
            cout<<i<<" n1:"<<n1<<endl;
            int n2=temp_edge->node_next->num;
            cout<<i<<" n2:"<<n2<<endl;
            w<<"Node"<<n1<<" -> Node"<<n2<<"[label=\""<<temp_edge->val<<"\"];" ;
            w<<endl;
        }

        w<<"}"<<endl;

        // 关闭文件流
        w.close();

        std::cout << "Data has been written to 'input.dot'." << std::endl;
    } else {
        std::cerr << "Unable to open the file for writing." << std::endl;
    }

}





