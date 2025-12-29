/* -- isort.s **********************
* Demonstrates insertion sort *
***********************************/
.text
@@@@@@@@@@@@@@@@@ ISORT
/*
@@ sort the integers
@ C/C++/Java Code:
@ null insertion(int[] a, int n)
@ { for (int i = 1; i < n; i++)
@ { temp = a[i];
@ j = i-1;
@ while (j >= 0 && temp < a[j])
@ { a[j+1] = a[j];
@ j = j-1;
@ }
@ a[j+1] = temp;
@ }
@ }
@@
*/
isort:
    mov r2, #1 @ i = 1
    iloop: @ for-loop as while loop
    cmp r2, r1 @ i - n
    bge iloopend @ i >= n => loopend

    add r10, r0, r2, LSL #2 @ temp = &array[4*i]
    ldr r10, [r10] @ temp = array[4*i]
    sub r3, r2, #1 @ j = i - 1
jloop: @ while-loop
    cmp r3, #0 @ j >= 0 ?
    blt jloopend
    add r9, r0, r3, LSL #2 @ r9 <- &array[4*j]
    ldr r9, [r9] @ r9 <- array[4*j]
    cmp r10, r9 @ temp < array[4*j] ?
    bge jloopend
    add r8, r0, r3, LSL #2
    add r8, r8, #4 @ r8 <- &array[4*(j+1)]
    str r9, [r8] @ a[j+1] <- a[j]
    sub r3, r3, #1 @ j <- j - 1
    b jloop
    @ end jloop
jloopend:
    add r3, r3, #1 @ j <- j+1
    add r8, r0, r3, LSL #2 @ r8 <- &array[4*(j+1)]
    str r10, [r8] @ a[j+1] <- temp
    add r2, r2, #1 @ i++
    b iloop
    @ end iloop
iloopend:
    @ end isort
    mov r8, #0 @ resets r8 to intial value
    mov r9, #0 @ resets r9 to intial value
    mov r10, #0 @ resets r10 to intial value
    bx lr @ returns to main

@ gets strlen of string inputed
my_strlen:
    ldrb r5, [r0] @ r1 <- one byte of *r0 and then move to next byte
    add r0, r0, #1 @ add one to pointer
    cmp r5, #0
    beq end_strlen @ if byte is empty the string is done
    add r1, r1, #1 @ r1 <- r1 + 1
    b my_strlen @ loops until string is empty
end_strlen:
    ldr r2, =length @ r2 <- &length
    str r1, [r2] @ *r2 <- r1
    mov r5, #0 @ resets r5
    bx lr


.global main
main:
    @@@@@@@@@@@@@@@@@ INITIALIZE
    ldr r7, =return @ get ready to save
    str lr, [r7] @ link register for return
    mov r6, #0 @ keep count in r6
    ldr r4, =array @ keep constant &array in r4`

    @@@@@@@@@@@@@@@@@ INPUT
input:
    ldr r0, =prompt
    bl puts
    ldr r0, =scanFMT @ r0 <- &scan format
    ldr r1, =buffer @ r1 <- &buffer
    bl scanf @ call to scanf

    ldr r0, =buffer @ r0 <- &buffer
    ldr r1, =length @ r1 <- &length
    ldr r1, [r1] @ r1 <- *r1
    bl my_strlen @ calls my_strlen

    ldr r7, =length @ r7 <- &length
    ldr r7, [r7] @ keep r7 as constant for length
    ldr r0, =buffer @ r0 <- &buffer
    ldr r8, =array @ r8 <- &array

    @ loops input into array for sorting
loop:
    ldrb r5, [r0] @ r0 <- *r0 stores one byte of ascii
    add r8, r8, r6, lsl #2 @ r8 <- &address[counter * 4]
    str r5, [r8]
    add r0, r0, #1 @ r0 <- r0 + 1
    add r6, r6, #1 @ r6 <- r6 + 1

    cmp r7, r6
    ble sort @ if r7 <= r6 branch to sort
    b loop @ loop program

sort:
    ldr r0, =array @ r0 <- &array
    ldr r1, =length @ r1 <- &length
    ldr r1, [r1] @ r1 <- *r1
    bl isort @ calls isort function

output:
    ldr r0, =result
    bl puts
    mov r5, #0 @ r5 counter
    ploop: cmp r6, r5 @ n - counter
    ble exit @ done printing
    add r3, r4, r5, LSL #2 @ r3 <- &array[4*counter]
    ldr r1, [r3] @ r1 <- array[4*counter]
    ldr r0, =printFMT @ r0 <- &print format
    bl printf
    add r5, r5, #1 @ n++
    b ploop
    @@@@@@@@@@@@@@@@ EXIT
exit:
    mov r0, r6 @ r0 = r6 return code = n
    ldr r1, =return @ r1 <- &return
    ldr lr, [r1] @ lr <- *r1 saved return address
    bx lr


@@@@@@@@@@@@@@@@@
.data
buffer: .space 100 @ creates space for 100 ascii bytes
length: .word 0 @ place to hold length of array
array: .space 100 @ room for 25 integers = 100 bytes
return: .word 0 @ place for return address of main
prompt: .asciz "Input a positive integer (negative to quit): "
result: .asciz "Sorted, those integers are: \n"
scanFMT: .asciz "%s"
printFMT: .asciz " %d\n"
@@@@@@@@@@@@@@@@@
/* External */
.global printf
.global scanf
.global puts

