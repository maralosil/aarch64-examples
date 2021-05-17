.data

.input:
        .string "Please type a number: "
.format:
        .string "%d"
.output:
        .string "Fibonacci number of %d is %d\n"

.text

.global _start
_start:
	adrp	x0, .input
	add	x0, x0, :lo12:.input
	bl	printf
	sub	sp, sp, 16
	mov	x1, sp
	adrp	x0, .format
	add	x0, x0, :lo12:.format
	bl	scanf
	ldr	w0, [sp]
	bl	fibonacci
	mov	x2, x0
	ldr	x1, [sp]
	adrp	x0, .output
	add	x0, x0, :lo12:.output
	bl	printf
	mov	x0, 0
	bl	exit

fibonacci:
	cbz	w0, .end
	cmp	w0, 1
	ble	end
	sxtw	x0, w0
	mov	w2, 1
	add	x3, x0, 1
	mov	w4, 0
	mov	x1, 2
.loop:
	add	w0, w4, w2
	add	x1, x1, 1
	mov	w4, w2
	mov	w2, w0
	cmp	x3, x1
	bne	.loop
.end:
	ret

