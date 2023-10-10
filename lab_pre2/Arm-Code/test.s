@ .arch arm7-add
@ 程序中无全局变量

.text @ 下面是代码段
.global Leo
.type Leo, %function
Leo: @ function  int Leo(int n)
    str fp, [sp, #-4]! @ pre-index mode, sp = sp - 4, push fp
    mov fp, sp
    sub sp, sp, #100 @ allocate space for local variable

    @ 使用栈保存r4（n~1的值）
	push  {r4,lr} @ r4存入栈中以便恢复
	mov	r4, r0 @ r4赋值为当前的n
	cmp	r0, #1 @ 比较n和1的大小，若n=1则跳转（结束递归）
	beq	.L1
	subs  r0, r4, #1 @ 此处n>1，执行操作r0=n-1
	bl	Leo(PLT) @ 调用Leo函数
    @ 执行到该步骤时，栈从底向上（n~1），每次r4都出栈开始乘
	mul	r0, r4, r0  @ r0存储n-1的阶乘结果
.L1:
    pop	{r4, pc} @ 弹出r4和pc，恢复原始值


.data
fmt:
    .string "%d"

.bss
a:
    .space 40 @ 10个int的空间给数组a

.text
.global main
.type main, %function
main:
    push {fp, lr}
    add fp, sp, #4

    ldr r1,=a @ 数组a的地址，也就是指针p的当前值
    mov r2,#0 @ 循环计数器i

loop:
    cmp r2,#10 @ 比较i和10
    bge funct_leo @ >=10时，跳转到递归调用部分
    str r2,[r1] @ p[i]=i
    ldr r1,=fmt @ 加载格式字符串的地址到p
    bl printf @ 输出p[0]
    add r1,r1,#4 @ p=p+1
    add r2,r2,#1 @ i++
    b loop @ 循环

funct_leo: @ 调用Leo函数并处理结果
    mov r0, #10  @ 参数n=10
    bl Leo @ 调用Leo函数
    mov r5, r0 @ 将Leo函数的返回值存储到r5
    ldr r5, =fmt @ 加载格式字符串的地址到r5
    bl printf @ 输出阶乘结果

end:
    mov r0, #0 @ 返回值为 0
    mov pc, lr @ 程序结束
    