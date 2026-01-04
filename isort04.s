/* -- isort.s **********************
 * Demonstrates insertion sort
 ***********************************/
        .text
        .global main

main:
@@@@@@@@@@@@@@@@@ INITIALIZE
        @ Save lr on stack instead of global memory
        push    {lr}

        mov     r6, #0          @ r6 = count
        ldr     r4, =array      @ r4 = &array (base address)

@@@@@@@@@@@@@@@@@ INPUT
input:
        ldr     r0, =prompt
        bl      puts

        ldr     r0, =scanFMT    @ r0 <- &scan format
        ldr     r1, =number     @ r1 <- &number
        bl      scanf           @ scanf("%d", &number)

        @ Load input once into r1 and reuse
        ldr     r1, =number
        ldr     r1, [r1]        @ r1 = number

        cmp     r1, #0          @ sentinel (negative)
        blt     isort           @ if (number < 0) -> sort

        @ array[count] = number
        add     r0, r4, r6, LSL #2      @ r0 = &array[count]
        str     r1, [r0]

        add     r6, r6, #1      @ count++

        b       input

@@@@@@@@@@@@@@@@@ ISORT
/*
 * void insertion(int *a, int n)
 * {
 *   for (i = 1; i < n; i++) {
 *     temp = a[i];
 *     j = i - 1;
 *     while (j >= 0 && temp < a[j]) {
 *       a[j+1] = a[j];
 *       j--;
 *     }
 *     a[j+1] = temp;
 *   }
 * }
 */
isort:
        mov     r0, r4          @ r0 = a (array base)
        mov     r1, r6          @ r1 = n (count)

        mov     r2, #1          @ i = 1

iloop:                          @ for (i = 1; i < n; i++)
        cmp     r2, r1
        bge     iloopend        @ if (i >= n) break

        @ temp = a[i]
        add     r10, r0, r2, LSL #2
        ldr     r10, [r10]      @ r10 = temp

        sub     r3, r2, #1      @ j = i - 1

jloop:                          @ while (j >= 0 && temp < a[j])
        cmp     r3, #0
        blt     jloopend        @ if (j < 0) break

        add     r9, r0, r3, LSL #2
        ldr     r9, [r9]        @ r9 = a[j]

        cmp     r10, r9         @ temp < a[j] ?
        bge     jloopend

        @ a[j+1] = a[j]
        add     r8, r0, r3, LSL #2
        add     r8, r8, #4      @ &a[j+1]
        str     r9, [r8]

        sub     r3, r3, #1      @ j--
        b       jloop

jloopend:
        add     r3, r3, #1      @ j+1
        add     r8, r0, r3, LSL #2
        str     r10, [r8]       @ a[j+1] = temp

        add     r2, r2, #1      @ i++
        b       iloop

iloopend:
@@@@@@@@@@@@@@@@@ OUTPUT
output:
        ldr     r0, =result
        bl      puts

        mov     r5, #0          @ r5 = print index

ploop:
        cmp     r5, r6          @ while (r5 < count)
        bge     exit

        add     r3, r4, r5, LSL #2
        ldr     r1, [r3]        @ r1 = array[r5]

        ldr     r0, =printFMT
        bl      printf

        add     r5, r5, #1
        b       ploop

@@@@@@@@@@@@@@@@@ EXIT
exit:
        mov     r0, r6          @ return n
        pop     {lr}            @ restore lr
        bx      lr

@@@@@@@@@@@@@@@@@
        .data
number:   .word 0
array:    .space 100        @ room for 25 integers = 100 bytes
return:   .word 0           @ no longer used, but kept if other code expects it
prompt:   .asciz "Input a positive integer (negative to quit): "
result:   .asciz "Sorted, those integers are: \n"
scanFMT:  .asciz "%d"
printFMT: .asciz " %d\n"

        .global printf
        .global scanf
        .global puts

