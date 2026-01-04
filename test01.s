/* heap.s */
.data
array: .word 1, 2, 3

.text
heap:
    sub sp, sp, #12
    str r0, [sp, #0] @ r0 = i
    str r1, [sp, #4] @ r1 = n
    str lr, [sp, #8]

    