/* heap.s */
.data
array: .word 1, 2, 3
length: .word 3
printFMT: .asciz "%d, "
enter: .asciz "\n"

.text
.global main
main:
heap:
    sub sp, sp, #12
    str r0, [sp, #0] @ r0 = i
    str r1, [sp, #4] @ r1 = n
    str lr, [sp, #8]

    cmp r1, #1
    beq base_case @ branch if n == 1 to base_case

for_loop:
    cmp r0, r1
    bge end: @ does for loop as long as i < n
    sub r1, r1, #1 @ n = n -1
    bl heap @ call heap

    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    and r2, r1, #1 @ get remainder to check if odd or even
    cmp r2, #0
    beq even_case @ branch if even
    b odd_case @ branches if odd

even_case:
    ldr r6, [r3, r0, lsl #2] @ r6 <- array[i*4]
    sub r7, r1, #1 @ r7 <- n - 1
    ldr r8, [r3, r7, lsl #2] r7 <- array[(n - 1)*4]
    str r6, [r3, r7, lsl #2] array[(n - 1)*4] <- r6
    str r8, [r3, r0, lsl #2] @ array[i*4] <- r8
    mov r6, #0 @ reset register
    mov r7, #0 @ reset register
    mov r8, #0 @ reset register
    add r0, r0, #1 @ i <- i + 1
    str r0, [sp, #0]
    mov r0 #0 @ reset register
    b for_loop @ loops


odd_case:
    ldr r6, [r3, #0] @ r6 <- array[0]
    sub r7, r1, #1 @ r7 <- n - 1
    ldr r8, [r3, r7, lsl #2] r7 <- array[(n - 1)*4]
    str r6, [r3, r7, lsl #2] array[(n - 1)*4] <- r6
    str r8, [r3, #0] @ array[0] <- r8
    mov r6, #0 @ reset register
    mov r7, #0 @ reset register
    mov r8, #0 @ reset register
    add r0, r0, #1 @ i <- i + 1
    str r0, [sp, #0]
    mov r0 #0 @ reset register
    b for_loop @ loops

base_case:
    ldr r4, =length @ r4 <- &length
    ldr r4, [r4] @ r4 <- *r4
    cmp r5, r4
    bge end @ branches once all indexs have been printed

    ldr r0, =printFMT @ r0 <- &printFMT
    ldr r1, [r3, r5, lsl #2] @ r1 <- array[r5*4]
    bl printf @ call printf

    add r5, r5, #1 @ r5 <- r5 + 1

end:
    ldr r0, =enter @ r0 <- &enter
    bl puts @ call puts

    mov r1, #1 @ r1 <- 1
    ldr lr, [sp, #8] @ loads previous return
    add sp, sp, #12 @ pops current leyer
    bx lr

.global puts
.global printf
    