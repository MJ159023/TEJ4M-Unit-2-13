.data
number: .word 0
return: .word 0
time: .word 0
printFMT: .asciz "%d"

.text
.global main
main:
    ldr r1, =return
    str lr, [r1]
    mov r0, #10
    mov r1, #12
    UDIV r2, r1, r0
    MLS r3, r2, r0, r1
    ldr r4, =number
    str r3, [r4]

    ldr r0, =time
    ldr r0, [r0]
    bl time

    ldr r2, =time
    str r0, [r2]

    ldr r0, =printFMT
    ldr r1, =time
    ldr r1, [r1]
    bl printf


    ldr lr, =return
    ldr lr, [lr]
    //mov r0, #0
    bx lr
/* External */
.global printf
.global time
