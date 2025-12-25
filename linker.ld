/* linker.ld - SRAM-resident firmware for muTau-RV32-SoC */

/* Use LiteX-generated memory layout and output format. */
INCLUDE generated/regions.ld
INCLUDE generated/output_format.ld

/* Use sram (defined in regions.ld) for everything */
REGION_ALIAS("REGION_TEXT", sram);
REGION_ALIAS("REGION_RODATA", sram);
REGION_ALIAS("REGION_DATA", sram);
REGION_ALIAS("REGION_BSS", sram);
REGION_ALIAS("REGION_STACK", sram);

SECTIONS
{
    .text :
    {
        _ftext = .;
        KEEP(*(.init))
        *(.text .text.*)
        KEEP(*(.fini))
        _etext = .;
    } > REGION_TEXT

    .rodata :
    {
        *(.rodata .rodata.*)
    } > REGION_RODATA

    .data :
    {
        _fdata = .;
        *(.data .data.*)
        _edata = .;
    } > REGION_DATA AT > REGION_TEXT

    .bss (NOLOAD) :
    {
        _fbss = .;
        *(.bss .bss.*)
        *(COMMON)
        _ebss = .;
    } > REGION_BSS

    .stack (NOLOAD) :
    {
        . = ALIGN(4);
        _stack_top = ORIGIN(sram) + LENGTH(sram);
    } > REGION_STACK
}
