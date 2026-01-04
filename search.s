.data                           @ Data section
return: .word 0
array:  .word 2,5,11,23,47,95,191,383,767,998
num_read: .word 0
prompt: .asciz "\nInsert integer key (key < 0 to quit): "
scanFMT: .asciz "%d"
echo:   .asciz "\nYou entered: %d\n"
ymsg:   .asciz "\nKey was found at position %d\n"
nmsg:   .asciz "\nKey not found! a near index is: %d\n"

        .text
        .global main
main:
        @ Save lr on stack instead of global memory
        push    {lr}

input:
        ldr     r0, =prompt            @ Print prompt
        bl      puts

        ldr     r0, =scanFMT           @ scanf("%d", &num_read)
        ldr     r1, =num_read
        bl      scanf

        @ Load key once, keep in r6 for the whole iteration
        ldr     r6, =num_read
        ldr     r6, [r6]               @ r6 = key

        @ Echo the key
        ldr     r0, =echo
        mov     r1, r6                 @ r1 = key
        bl      printf

        @ Check sentinel (key < 0)
        cmp     r6, #0
        blt     exit

        @ Binary search setup
        ldr     r7, =array             @ r7 = base address of array
        mov     r0, #0                 @ low = 0
        mov     r1, #9                 @ high = 9  (10 - 1)

Loop:
        cmp     r1, r0                 @ while (low <= high)
        blt     fail

        @ mid = (low + high) / 2
        add     r3, r0, r1
        mov     r3, r3, ASR #1         @ r3 = mid
`        mov     r8, r3                 @ save index for printing

        @ Load array[mid]
        add     r5, r7, r3, LSL #2     @ r5 = &array[mid]
        ldr     r5, [r5]               @ r5 = array[mid]

        cmp     r5, r6               @ compare array[mid] and key
        blt     RH                   @ if array[mid] < key -> search right half
        bgt     LH                   @ if array[mid] > key -> search left half

        @ Found
found:
        add     r1, r8, #1             @ convert 0-based index to 1-based
        ldr     r0, =ymsg
        bl      printf
        b       input

RH:     add     r0, r3, #1             @ low = mid + 1
        b       Loop

LH:     sub     r1, r3, #1             @ high = mid - 1
        b       Loop

fail:                                   @ Not found
        add     r1, r8, #1             @ report near index (1-based)
        ldr     r0, =nmsg
        bl      printf
        b       input

exit:
        pop     {lr}                   @ restore lr
        bx      lr

        .global puts
        .global printf
        .global scanf

