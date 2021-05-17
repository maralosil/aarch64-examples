.data

.type_a_number:
	.string "Please type a number: "
.scanf_format:
	.string "%d"
.number_is_prime:
	.string "%d is prime\n"
.number_is_not_prime:
	.string "%d is not prime\n"

.text

.global _start
_start:
	adr	x0, .type_a_number
	bl	printf
	sub	sp, sp, 16
	mov	x1, sp
	adr	x0, .scanf_format
	bl	scanf
	ldr	w0, [sp]
	bl	is_prime
	ldr	x1, [sp]
	cmp	x0, 1
	beq	.output_is_prime
	adr	x0, .number_is_not_prime
.output:
	bl	printf
	mov	x0, 0
	bl	exit
.output_is_prime:
	adr	x0, .number_is_prime
	b .output

is_prime:
	cmp	x0, 1
	ble	.is_not_prime
	mov	x1, 2
.loop:
	mul	x2, x1, x1
	cmp	x2, x0
	bgt	.is_prime
	udiv	x3, x0, x1
	msub	x4, x3, x1, x0
	cmp	x4, 0
	beq	.is_not_prime
	add	x1, x1, 1
	b	.loop
.is_prime:
	mov	x0, 1
	ret
.is_not_prime:
	mov	x0, 0
	ret
