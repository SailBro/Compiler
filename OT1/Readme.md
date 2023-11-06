# OT1
完成了Thompson构造法的yacc编程，将正则式转化为可视化的NFA

## 目录说明
- Thompson.cpp是编写的yacc代码部分，使用C++语言，在编译时请转成.y格式
- exe是作者编译后的生成程序，可以点开直接测试
- y.tab.c是yacc编译后的源码
- input.dot是程序自动化生成的链表信息格式文档，输入的测试样例是`(a|b)cb*;`
- output.png是Graphviz插件将input.dot可视化的图形结果

## 编译&测试说明
### 直接打开exe输入样例测试
输入样例即可，具体见下方Step5和Step6

### 自行编译测试步骤
```
Step1：将Thompson.cpp更改为Thompson.y格式
Step2：打开终端，输入命令`yacc Thompson.y`，生成y.tab.c
Step3：输入命令`g++ y.tab.c -o exe`，生成可运行文件exe
Step4：输入命令`./exe`进入程序测试
Step5：输入测试样例(a|b)cb*;（注意需要添加`;`作为结尾符）然后得到input.dot
Step6：输入命令`dot -Tpng input.dot -o output.png`得到最终的NFA可视化结果output.png
```
