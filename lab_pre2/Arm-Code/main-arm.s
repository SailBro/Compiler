	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 1
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.align	1
	.global	Leo
	.arch armv7-a
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	Leo, %function
Leo:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, r0
	cmp	r0, #1
	beq	.L1
	subs	r0, r4, #1
	bl	Leo(PLT)
	mul	r0, r4, r0
.L1:
	pop	{r4, pc}
	.size	Leo, .-Leo
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"%d\000"
	.text
	.align	1
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	sub	sp, sp, #52
	ldr	r2, .L11
.LPIC3:
	add	r2, pc
	ldr	r3, .L11+4
	ldr	r3, [r2, r3]
	ldr	r3, [r3]
	str	r3, [sp, #44]
	mov	r3,#0
	movs	r4, #0
	add	r5, sp, #4
	ldr	r7, .L11+8
.LPIC0:
	add	r7, pc
	movs	r6, #1
.L6:
	str	r4, [r5], #4
	mov	r2, r4
	mov	r1, r7
	mov	r0, r6
	bl	__printf_chk(PLT)
	adds	r4, r4, #1
	cmp	r4, #10
	bne	.L6
	movs	r0, #10
	bl	Leo(PLT)
	mov	r2, r0
	ldr	r1, .L11+12
.LPIC1:
	add	r1, pc
	movs	r0, #1
	bl	__printf_chk(PLT)
	ldr	r2, .L11+16
.LPIC2:
	add	r2, pc
	ldr	r3, .L11+4
	ldr	r3, [r2, r3]
	ldr	r2, [r3]
	ldr	r3, [sp, #44]
	eors	r2, r3, r2
	mov	r3, #0
	bne	.L10
	movs	r0, #0
	add	sp, sp, #52
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
.L10:
	bl	__stack_chk_fail(PLT)
.L12:
	.align	2
.L11:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC3+4)
	.word	__stack_chk_guard(GOT)
	.word	.LC0-(.LPIC0+4)
	.word	.LC0-(.LPIC1+4)
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC2+4)
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",%progbits
