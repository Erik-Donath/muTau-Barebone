/* src/crt0.S - Minimal startup code for VexRiscv on LiteX */

.section .init, "ax"
.global _start

_start:
    /* Set stack pointer to top of SRAM (0x10000000 + 0x2000 = 0x10002000) */
    li sp, 0x10002000

    /* Clear the BSS segment */
    la t0, _fbss
    la t1, _ebss
bss_loop:
    bgeu t0, t1, bss_done
    sw zero, 0(t0)
    addi t0, t0, 4
    j bss_loop
bss_done:

    /* Copy data section from ROM to RAM if needed (optional for SRAM-only) */
    la t0, _fdata
    la t1, _edata
    la t2, _fdata  /* In SRAM-only config, data is already in place */
data_loop:
    bgeu t0, t1, data_done
    lw t3, 0(t2)
    sw t3, 0(t0)
    addi t0, t0, 4
    addi t2, t2, 4
    j data_loop
data_done:

    /* Call main */
    call main

    /* If main returns, loop forever */
halt:
    j halt
