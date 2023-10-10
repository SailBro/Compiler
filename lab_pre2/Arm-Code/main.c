#include <stdio.h>
int Leo(int n)
{
    int sum = 1;
    if(n== 1)//递归终止条件
    {
        return 1;
    }
    sum =n * Leo(n - 1);
    return sum;//返回阶乘的总和
}
int main() {

    // 测试循环和指针

    int a[10];
    int* p = &a[0];
    for (int i = 0; i < 10; i++) {
        p[0] = i;
        printf("%d", p[0]);
        p = p + 1;
    }

    // 测试递归
    
    int res=Leo(10);
    printf("%d",res);

    return 0;
}