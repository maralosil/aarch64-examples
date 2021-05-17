# Assembling and static linking
```console
$ aarch64-linux-gnu-as hello.S -o hello.o
$ aarch64-linux-gnu-ld -static hello.o -o hello
$ ./hello
Hello!
```

# Assembling and dynamic linking
```console
$ aarch64-linux-gnu-as hello.S -o hello.o
$ aarch64-linux-gnu-ld hello.o -o hello
$ qemu-aarch64 -L /usr/aarch64-linux-gnu ./hello
Hello!
```
# C compiling and static linking with libc
```console
$ aarch64-linux-gnu-gcc -static hello.c -o hello
$ ./hello
Hello!
```

# C compiling and dynamic linking with libc
```console
$ aarch64-linux-gnu-gcc hello.c -o hello
$ qemu-aarch64 -L /usr/aarch64-linux-gnu ./hello
Hello!
```

# Assembling and dynamic linking with libc
```console
$ aarch64-linux-gnu-as fibonacci.S -o fibonacci.o
$ aarch64-linux-gnu-ld -lc fibonacci.o -o fibonacci
$ qemu-aarch64 -L /usr/aarch64-linux-gnu ./fibonacci
Please type a number: 12
Fibonacci number 12 is 144

# C compiling and dynamic linking with libc
```console
$ aarch64-linux-gnu-gcc day.c -o day
$ qemu-aarch64 -L /usr/aarch64-linux-gnu ./day
```

# Just C compiling
```console
$ aarch64-linux-gnu-gcc -c fibonacci.c -o fibonacci.o
$ aarch64-linux-gnu-objdump -d fibonacci.o
```

# Debugging
On a terminal window, run:
```console
$ qemu-aarch64 -L /usr/aarch64-linux-gnu -g 1234 ./args hi hey
```
And on another terminal window, run to debug:
```console
$ gdb-multiarch -q --nh -ex 'set architecture arm64' -ex 'file args' -ex 'target remote localhost:1234' -ex 'layout split' -ex 'layout regs'
```
On gdb, set solib searchpath as:
(gdb) set solib-search-path /usr/aarch64-linux-gnu/lib/

# Notes
- Use the optmization flag -O and see the changes in calling convention.
  Note that arguments are preferably passed in registers instead of stack.
