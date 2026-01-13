/* magicSquare */
/*
Created by: Michael Bruneau
Created on: 08/01/2026
Purpose: program will generate all possible magic squares.
*/

.data
mode_and_scope: .word 3      @ mode_and_scope will be equal to array size
array_index: .word 0         @ indexs through array values
array_length: .word 3        @ holds the length of the array.
array: .word 1, 2, 3         @ test array
return: .word 0              @ holds the return code to exit program
printFMT: .asciz "%d, "      @ format for array numbers being printed
enter: .asciz ""             @ enter for next permuation of array numbers

.text
heap:
    sub sp, sp, #12          @ creates 3 item space to store in stack
    str r0, [sp, #0]         @ stores array_index in *[sp]
    str r1, [sp, #4]         @ stores mode_and_scope in *[sp + 4]
    str lr, [sp, #8]         @ stores return address for recursion in *[sp + 8]

    cmp r1, #1
    beq base_case            @ branch to base_case if mode_and_conrol = 1

for_loop:
    sub r1, r1, #1           @ mode_and_scope = mode_and_scope - 1
    mov r0, #0               @ reset array_index
    bl heap                  @ recursis

    @ loads proper parameters for that recursion
    ldr r0, [sp, #0]
    ldr r1, [sp, #4]
    ldr r6, =array           @ r6 <- &array

    and r10, r1, #1          @ determines if mode_and_scope is even or odd
    cmp r10, #0
    beq even_case            @ branches to even_case if mode_and_scope is even

    @ else odd_case
odd_case:
    ldr r7, [r6, #0]         @ r7 <- *array[0]
    sub r8, r1, #1           @ r8 <- mode_and_scope - 1
    ldr r9, [r6, r8, lsl #2] @ r9 <- *array[(mode_and_scope -1) * 4]

    @ swaps mode_and_scope with 0th index
    str r7, [r6, r8, lsl #2] @ *array[(mode_and_scope - 1) * 4] <- r7
    str r9, [r6, #0]         @ *array[0] <- r9

    mov r7, #0               @ reset register
    mov r8, #0               @ reset register
    mov r9, #0               @ reset register

    add r0, r0, #1           @ array_index <- array_index + 1
    str r0, [sp, #0]         @ array_index in *[sp]
    b for_loop               @ loops code

even_case:
    ldr r7, [r6, r0, lsl #2] @ r7 <- *array[array_index * 4]
    sub r8, r1, #1           @ r8 <- mode_and_scope - 1
    ldr r9, [r6, r8, lsl #2] @ r9 <- *array[(mode_and_scope -1) * 4]

    @ swaps mode_and_scope with array_index
    str r7, [r6, r8, lsl #2] @ *array[(mode_and_scope - 1) * 4] <- r7
    str r9, [r6, r0, lsl #2] @ *array[array_index * 4] <- r9

    mov r7, #0               @ reset register
    mov r8, #0               @ reset register
    mov r9, #0               @ reset register

    add r0, r0, #1           @ array_index <- array_index + 1
    str r0, [sp, #0]         @ stores array_index in *[sp]
    b for_loop               @ loops code

base_case:
    ldr r4, =array_length    @ r4 <- &length
    ldr r4, [r4]             @ r4 <- *r4
    ldr r6, =array           @ r6 <- &array
    mov r5, #0               @ r5 <- 0

loop:
    cmp r5, r4
    beq space                @ branches once all indexs have been printed

    ldr r0, =printFMT        @ r0 <- &printFMT
    ldr r1, [r6, r5, lsl #2] @ r1 <- *array[r5*4]
    bl printf                @ call printf

    add r5, r5, #1           @ r5 <- r5 + 1
    b loop                   @ loops

space:
    ldr r0, =enter          @ r0 <- &enter
    bl puts                 @ call puts

end:
    mov r0, #0
    mov r1, #1              @ r1 <- 1
    mov r4, #0              @ reset register
    mov r5, #0              @ reset register
    mov r6, #0              @ reset register
    ldr lr, [sp, #8]        @ loads previous return
    add sp, sp, #12         @ pops current layer
    bx lr                   @ returns to previosu layer

.global main
main:
    ldr r1, =return         @ r1 <- &return
    str lr, [r1]            @ saves exit address in *return

    ldr r0, =array_index    @ r0 <- &array_index
    ldr r0, [r0]            @ r0 <- *r0
    ldr r1, =mode_and_scope @ r1 <- &mode_and_scope
    ldr r1, [r1]            @ r1 <- *r1
    bl heap                 @ call to heap function

    ldr lr, =return
    ldr lr, [lr]
    bx lr
/* External */
.global puts
.global printf

