/* load.s*/

.data
array: .word 0x11223344

.text
.global main
main:
    ldr r0, =array        @ r0 = &array
    ldr r1, [r0]          @ load 32-bit
    ldrb r2, [r0]         @ load 8-bit
    ldrh r3, [r0]         @ load 16-bit
    ldrsh r4, [r0]        @ load signed 16-bit
    bx lr

