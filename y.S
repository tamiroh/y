// yes(1) for macOS on Apple Silicon (arm64).

#ifndef BUFSZ
#define BUFSZ 32768
#endif

#define SYS_exit  1
#define SYS_write 4

        .text
        .globl  _main
        .p2align 2
_main:
        adrp    x19, _buf@PAGE
        add     x19, x19, _buf@PAGEOFF

        // Fill the buffer (BUFSZ plus 16 bytes of slack) 16 bytes at a time.
        mov     x9, #0x0a79             // "y\n"
        orr     x9, x9, x9, lsl #16
        orr     x9, x9, x9, lsl #32
        mov     x10, x19
        add     x11, x19, #BUFSZ
        add     x11, x11, #16
1:      stp     x9, x9, [x10], #16
        cmp     x10, x11
        b.lo    1b

        mov     x20, #BUFSZ
        mov     x16, #SYS_write
2:      mov     x0, #1
        mov     x1, x19
        mov     x2, x20
        svc     #0x80
        b.cs    3f
        // A short write of odd length leaves us mid-pair; restart from the
        // matching byte so the stream stays "y\ny\n...".
        and     x0, x0, #1
        eor     x19, x19, x0
        b       2b

3:      mov     x0, #1
        mov     x16, #SYS_exit
        svc     #0x80

        .zerofill __DATA,__bss,_buf,BUFSZ+16,14
