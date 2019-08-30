.data
	newLine:	.asciz "\n"
	numFormat:	.asciz "%d"
	stringFormat:	.asciz "%s"
	prompt:		.asciz "Enter Two Integers: "
	num1:		.space 100
	num2:		.space 100
	test:		.asciz "test" 

.global main

.text

main:
	//Prompt
	ldr x0, =prompt
	bl printf

	//First num read
	ldr x0, =numFormat
	ldr x1, =num1
	bl scanf

	//Second num read
	ldr x0, =numFormat
	ldr x1, =num2
	bl scanf

	//Save to registers
	ldr x1, =num1
	ldr x2, =num2
	ldr x19, [x1, #0]
	ldr x20, [x2, #0]

	bl check_negative

	bl check_zero

	bl gcd

	b output

check_zero:
	//Check second number for zero
	cmp xzr, x20
	beq output
	
	//Check first number for zero
	cmp xzr, x19
	beq flipOutput

	br x30

flipOutput:
	//Switch x19 and x20 for output
	mov x19, x20
	b output

check_negative:
	//Check first number for negative
	cmp w19, wzr
	b.lt flip_negative1

	//Check second number for negative
	cmp w20, wzr
	b.lt flip_negative2

	br x30

flip_negative1:
	//negate x19
	neg w19, w19
	b check_negative

flip_negative2:
	//negate x20
	neg w20, w20
	b check_negative

gcd:
	sub sp, sp, #32
	str x30, [sp, #0]

	str x19, [sp, #8]
	str x20, [sp, #16]

	//Check if x19 != x20
	subs x21, x19, x20
	cbnz x21, gcd_recurse

	ldr x30, [sp, #0]
	add sp, sp, #32

	br x30
	
gcd_recurse:
	ldr x19, [sp, #8]
	ldr x20, [sp, #16]	

	//If x19 < x20
	cmp x19, x20
	b.lt gcd_branch1

	//If x19 > x20
	cmp x19, x20
	b.ge gcd_branch2

gcd_branch1:
	//x20 = x20 - x19
	sub x20, x20, x19
	b gcd
	
gcd_branch2:
	//x19 = x19 - x20
	sub x19, x19, x20
	b gcd

output:	
	//text output
	ldr x0, =numFormat
	mov x1, x19
	bl printf

	b exit

exit:
	ldr x0, =newLine
	bl printf
	mov x0, #0
	mov x8, #93
	svc #0
