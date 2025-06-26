.data
.align 4

# ==========testcase1===========
arr: .word 1, 2, 3, 4, 5, 6, 7, 8
length: .word 8
strOutput: .string "The minimum number of multiplications: "
# output: The minimum number of multiplications: 166
# ==============================

# ==========testcase2===========
#arr: .word 5, 6, 3, 4, 1, 2, 9, 10, 7, 8, 5, 6
#length: .word 12
#strOutput: .string "The minimum number of multiplications: "
# output: The minimum number of multiplications: 394
# ==============================

.text
.global _start


# Start your coding below, don't change anything upper except testing different testcase
_start:

    #print: "The minimum number of multiplications: " 
    la a0, strOutput
    la t0, arr         # t0 = arr base address
    li a7, 4
    ecall

     
    # 初始化指標
	lw t1, length       # t1 = n (length)
        #print: minNumber
	addi a0, zero, 0		#argument 0, length - 1
	addi a1, t1, -1

    jal ra, matrix      #a0 =res
    
    #print: minNumber
    li a7, 1
    ecall

    #print: "\n"
    li a0, 10       # ASCII of '\n' 是 10
    li a7, 11       # syscall: print_char
    ecall

    j end       # Jump to end of program


matrix:                     #a0: i, a1: j
	addi  s0, a0, 1                 #s0:k
     blt s0, a1, count
     addi a0, zero, 0
     jalr zero, ra

count:
    addi s1, zero, 2047                #s1:res = 2047
    addi s2, zero, 0                 #s2:curr = 0
    addi sp, sp, -28
    sw a0, 0(sp)           #i
    sw a1, 4(sp)           #j
    sw ra, 8(sp)           #ra
      
 loop:
    sw s0, 12(sp)            #k
    sw s1, 16(sp)            #res
    sw s2, 20(sp)            #curr
    


    #matrixMultiplication(i, k)
    lw a0, 0(sp)
    mv a1, s0
    jal ra, matrix
    sw a0, 24(sp)               #matrixMultiplication(i, k)

    # matrixMultiplication(k, j) 
    lw a0, 12(sp)
    lw a1, 4(sp)
    jal ra, matrix
    lw  t2, 24(sp)
    add t2, t2, a0
    sw t2, 24(sp)               #matrixMultiplication(i, k) + matrixMultiplication(k, j) 

    # arr[i] * arr[k] * arr[j];
    lw t2, 0(sp)
    lw t3, 12(sp)
    lw t4, 4(sp)

    slli t2, t2, 2     # offset = i * 4
    slli t3, t3, 2     # offset = k * 4
    slli t4, t4, 2     # offset = j * 4

    add t2, t0, t2     # t2 = &arr[i]
    add t3, t0, t3     # t3 = &arr[k]
    add t4, t0, t4     # t4 = &arr[j]

    lw t2, 0(t2)       # t2 = arr[i]
    lw t3, 0(t3)       # t3 = arr[k]
    lw t4, 0(t4)       # t4 = arr[j]

    mul t2, t2, t3
    mul t2, t2, t4          #t2 = arr[i] * arr[k] * arr[j]
    
    # curr = matrixMultiplication(i, k) + matrixMultiplication(k, j) + arr[i] * arr[k] * arr[j];
    lw s1, 16(sp)                    #s1 = res
    lw t3, 24(sp) 
    add s2, t2, t3          #s2 = curr
    
    ble s1, s2, continue                    #if(res < curr)     continue
    mv s1, s2
   # mv a0, s1
     #li a7, 1
    #ecall
continue:
    lw s0, 12(sp)           #s0 = k
    addi s0, s0, 1          #s0 = k = k+1
    lw t2, 4(sp)
    blt  s0, t2, loop           #if(k<j)       loop  

    #return res
    lw ra, 8(sp)
    mv a0, s1

    #li a7, 1
    #ecall
    addi sp, sp, 28
    jalr zero, ra 
end:nop

    
  