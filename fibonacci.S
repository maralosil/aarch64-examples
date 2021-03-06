/*  Cool example of a recursive fibonacci implementation available at
    https://thinkingeek.com/2017/05/29/exploring-aarch64-assembler-chapter-8/
*/

.data

msg_input: .asciz "Please type a number: "
scanf_fmt : .asciz "%d"
msg_output: .asciz "Fibonacci number %d is %ld\n"

.text

.global main
main:
    stp x19, x30, [sp, #-16]! // Keep x19 and x30 (link register)
    sub sp, sp, #16           // Grow the stack because for a local
                              // variable used by scanf.
    /*
      Our stack at this point will look like this
      Contents  Address
      | var |    [sp]       We will use the first 4 bytes for scanf
      |     |    [sp, #8]
      | x19 |    [sp, #16]
      | x30 |    [sp, #24]
     */

    // Set up first call to printf
    //   printf("Please type a number: ");
    ldr x0, addr_msg_input   // x0 ← &msg_input  [64-bit]
    bl printf                // call printf

    // Set up call to scanf
    //   scanf("%d", &var);
    mov x1, sp               // x1 ← sp
                             // the first 4 bytes pointed by sp will be 'var'
    ldr x0, addr_scanf_fmt   // x0 ← &scanf_fmt  [64-bit]
    bl scanf                 // call scanf

    // Set up call to fibonacci
    //   res = fibonacci(var);
    ldr w0, [sp]             // w0 ← *sp   [32-bit]
                             // this is var in the stack
    bl fibonacci             // call fibonacci

    // Setup call to printf
    //   printf("Fibonacci number %d is %ld\n", var, res);
    mov x2, x0               // x2 ← x0
                             // this is 'res' in the call to fibonacci
    ldr w1, [sp]             // w1 ← *sp   [32-bit]
    ldr x0, addr_msg_output  // x0 ← &msg_output [64-bit]
    bl printf                // call printf

    add sp, sp, #16          // Shrink the stack.
    ldp x19, x30, [sp], #16  // Restore x19 and x30 (link register)
    mov w0, #0               // w0 ← 0
    ret                      // Leave the function

addr_msg_input: .dword msg_input
addr_msg_output: .dword msg_output
addr_scanf_fmt: .dword scanf_fmt

fibonacci:
    // fibonacci(n) -> result
    //   n is 32-bit and will be passed in w0
    //   result is 64-bit and will be returned in x0

    stp x19, x30, [sp, #-16]!  // Keep x19 and x30 (link register)
    stp x20, x21, [sp, #-16]!  // Keep x20 and x21
    /*
      Our stack at this point will look like this
      Contents  Address
      | x20 |    [sp]
      | x21 |    [sp, #8]
      | x19 |    [sp, #16]
      | x30 |    [sp, #24]
     */

    cmp w0, #1                // Compare w0 with 1 and update the flags
    ble simple_case           // if w0 <= 1 branch to simple_case
                              // (otherwise continue to recursive_case)

    recursive_case:           // recursive case
                              // (this label is not used, added for clarity)
      mov w19, w0             // w19 ← w0
      // Set up call to fibonacci
      //     fibonacci(n-1);
      sub w0, w0, #1          // w0 ← w0 - 1
      bl fibonacci            // call fibonacci
      mov x20, x0             // x20 ← x0

      sub w0, w19, #2         // w0 ← w19 - 2
      bl fibonacci            // call fibonacci
      mov x21, x0             // x21 ← x0
 
      add x0, x20, x21        // x0 ← x20 + x21
      b end                   // (unconditional) branch to end

    simple_case:
      sxtw x0, w0             // x0 ← ExtendSigned32To64(w0)

    end:
      ldp x20, x21, [sp], #16  // Restore x20 and x21
      ldp x19, x30, [sp], #16  // Restore x19 and x30 (link register)
    ret

