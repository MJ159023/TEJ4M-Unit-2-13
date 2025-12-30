/* -- rand02.s
rand.s gives us an array of 100 pseudo-random numbers
in the range 0 <= n < 100 based on Knuth’s advice.
X[n+1] <- (aX[n] + c) mod m
using m = 2^16 = 65536 which works on a 16-bit machine well
using a = 32445 so that a mod 8 = 5 and 99m/100 > a > m/100
using c = 1
using X0 = input
*/
.text
.global main
main:
    ldr r1, =return @ save return address
    str lr, [r1]
    @ X0 - initialized (input)

    ldr r0, =message01 @ r0 <- &message
    bl puts @ call puts

    ldr r0, =scanFMT @ r0 <- &scanFMT
    ldr r1, =number @ r1 <- &number
    bl scanf @ call scanf

    ldr r0, =message02 @ r0 <- &message02
    bl puts @ call puts

    ldr r0, =scanFMT @ r0 <- &scanFMT
    ldr r1, =max @ r1 <- &max
    bl scanf @ call scanf

    ldr r1, =max @ r1 <- &max
    ldr r1, [r1] @ r1 <- *r1

    cmp r1, #0
    blt Exit @ exits program if user choose a negative number

    ldr r0, =message03 @ r0 <- &message03
    bl puts @ call puts

    ldr r0, =scanFMT @ r0 <- &scanFMT
    ldr r1, =min @ r1 <- &min
    bl scanf @ call scanf

    ldr r1, =min @ r1 <- &min
    ldr r1, [r1] @ r1 <- *r1
    ldr r2, =max @ r2 <- &max
    ldr r2, [r2] @ r2 <- *r2

    cmp r1, #0
    blt Exit @ exits program if user choose a negative number
    cmp r2, r1
    ble Exit @ exist program if min is equal to or greater than max

    ldr r0, =message04 @ r0 <- &message04
    bl puts @ call puts

    ldr r0, =scanFMT @ r0 <- &scanFMT
    ldr r1, =returns @ r1 <- &returns
    bl scanf @ call scanf

    ldr r1, =returns @ r1 <- &returns
    ldr r1, [r1] @ r1 <- *r1

    cmp r1, #99
    bge Exit @ exits if r1 is greater than 99
    cmp r1, #0
    ble Exit @ also exits if returns is 0

    mov r1, r1, lsl #2 @ r1 <- r1 * 4
    sub r1, r1, #4
    ldr r2, =returns @ r2 <- &returns
    str r1, [r2] @ *r2 <- r1

    ldr r0, =number @ r0 <- &number
    ldr r0, [r0] @ r0 <- *r0

    /* ldr r4, #32445 @ a - initialized */
    mov r4, #0x7e
    mov r4, r4, LSL #8
    add r4, r4, #0xbd @ a = r4 = 0x7ebd = 32445

    /* ldr r5, #0x0000FFFF @ mask to do modulo (m-1) - initialized */
    mov r5, #0xFF
    mov r5, r5, LSL #8
    add r5, r5, #0xFF @ mask = m-1 = 0x0000FFFF
    ldr r6, =returns @ counter - initialized 4*100-4 for 100 ints
    ldr r6, [r6]
    ldr r7, =max @ limit - max
    ldr r7, [r7]
    ldr r10, =min @ limit - min
    ldr r10, [r10]

Loop: @ while counter < 100
    cmp r6, #0 @ check counter
    blt Exit @ Stop when counter passes zero
    mul r2, r0, r4 @ X = aX (mul works like this)
    mov r0, r2 @ r0 <- r2
    add r0, #1 @ now X = aX+c
    and r0, r0, r5 @ now X = (aX+c) mod m
    mov r8, r0 @ save X in r8 temporarily
    mov r9, r0, lsr #8 @ divide by 256 (use upper 8 bits) check
    cmp r9, r7 @ check size
    bgt Loop @ only want those =< max
    cmp r9, r10
    blt Loop @ only want those >= min

    @Print
    ldr r0, =format
    mov r1, r9 @ prepare to print
    bl printf

    @Store
    mov r0, r8 @ put X back
    ldr r1, =list @ prepare to store
    str r0, [r1, r6] @ store and then decrement counter
    add r6, r6, #-4 @ r6 <- r6 - 4

    @End_of_Loop
    b Loop
Exit:
    ldr lr, =return
    ldr lr, [lr] @ standard return to OS
    bx lr

.data
list: .space 400 @ room for 100 integers
number: .word 0 @ reprsents X0
min: .word 0 @ holds min number possible
max: .word 0 @ holds max number possible
returns: .word 0 @ holds ammount of generated numbers returned
return: .word 0 @ save return address
format: .asciz " %d "
enter: .asciz "\n"
message01: .asciz "Input X0: "
message02: .asciz "\nInput max number generable (must be postive): "
message03: .asciz "\nInput min number generable (must be postive): "
message04: .asciz "\nInput ammount of # generated (can't be more than 99): "
scanFMT: .asciz "%d"

/* External */
.global puts
.global printf
.global scanf

