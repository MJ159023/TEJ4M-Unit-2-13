/* heap.s */
.data
array: .word 1, 2, 3
temp: .word 0 

.text
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

    and r2, r1, #1 @ get remainder to check if odd or even
    cmp r2, #0
    beq even_case @ branch if even
    b odd_case @ branches if odd

even_case:
    ldr r5, =temp @ r5 <- &temp
    ldr r6, [r3, ]

odd_case: