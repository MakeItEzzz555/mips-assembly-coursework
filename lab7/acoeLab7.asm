.data
Buffer:     .space 500
KeyRange:   .word 10
Plaintext:  .asciiz "Xliaexivaewewgsphewmgierhwyhhirpcaiwea"

.text
main:
    # Load key range and addresses
    lw   $t0, KeyRange      # t0 = number of keys
    la   $t6, Buffer        # buffer base address
    la   $t7, Plaintext     # keep original plaintext start here

for_loop:
    beq  $t0, $zero, end_program

    # Reset plaintext pointer for new key
    la   $t1, Plaintext

    # Store key number into buffer (ASCII digit)
    addi $t3, $t0, 48       # convert number to ASCII
    sb   $t3, 0($t6)
    addi $t6, $t6, 1

while_loop:
    lb   $t2, 0($t1)        # load character
    beq  $t2, $zero, finish_key

    # Check lowercase letters only
    blt  $t2, 97, store_direct

    # Decrypt: subtract key
    sub  $t2, $t2, $t0

    # Wrap if less than 'a'
    li   $t4, 97
    li   $t5, 122
    blt  $t2, $t4, wrap

store_direct:
    sb   $t2, 0($t6)
    addi $t6, $t6, 1
    addi $t1, $t1, 1
    j    while_loop

wrap:
    # Wrap around alphabet
    addi $t2, $t2, 26
    j    store_direct

finish_key:
    # Move to next key
    addi $t0, $t0, -1
    j for_loop

end_program:
    # Print buffer
    li  $v0, 4
    la  $a0, Buffer
    syscall

    # Exit
    li  $v0, 10
    syscall
