
ENTRY(start)
SECTIONS
{
    . = 0x100000; /* Kernel load address at 1MB */

    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
        *(COMMON)
    }
}
