	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.align	1
	.p2align 2,,3
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
	@ link register save eliminated.
	cmp	r0, #1
	it	eq
	moveq	r3, r0
	beq	.L1
	movs	r3, #1
.L2:
	mov	r2, r0
	subs	r0, r0, #1
	cmp	r0, #1
	mul	r3, r2, r3
	bne	.L2
.L1:
	mov	r0, r3
	bx	lr
	.size	Leo, .-Leo
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"%d\000"
	.section	.text.startup,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L16
	ldr	r3, .L16+4
.LPIC3:
	add	r2, pc
	push	{r4, r5, r6, lr}
	sub	sp, sp, #48
	ldr	r6, .L16+8
	add	r5, sp, #4
	ldr	r3, [r2, r3]
	movs	r4, #0
.LPIC0:
	add	r6, pc
	ldr	r3, [r3]
	str	r3, [sp, #44]
	mov	r3,#0
.L11:
	mov	r2, r4
	str	r4, [r5], #4
	mov	r1, r6
	adds	r4, r4, #1
	movs	r0, #1
	bl	__printf_chk(PLT)
	cmp	r4, #10
	bne	.L11
	mov	r1, r6
	mov	r2, #24320
	movs	r0, #1
	movt	r2, 55
	bl	__printf_chk(PLT)
	ldr	r2, .L16+12
	ldr	r3, .L16+4
.LPIC2:
	add	r2, pc
	ldr	r3, [r2, r3]
	ldr	r2, [r3]
	ldr	r3, [sp, #44]
	eors	r2, r3, r2
	mov	r3, #0
	bne	.L15
	movs	r0, #0
	add	sp, sp, #48
	@ sp needed
	pop	{r4, r5, r6, pc}
.L15:
	bl	__stack_chk_fail(PLT)
.L17:
	.align	2
.L16:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC3+4)
	.word	__stack_chk_guard(GOT)
	.word	.LC0-(.LPIC0+4)
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC2+4)
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",%progbits
