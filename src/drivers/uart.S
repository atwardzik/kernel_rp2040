#ifdef ARCH_RP2040
.cpu cortex-m0
#elifdef ARCH_RP2350
.cpu cortex-m33
#endif
.thumb
.syntax unified

.equ UART_DR, 0x0
.equ UART_FR, 0x18
.equ UART_IBRD, 0x24
.equ UART_FBRD, 0x28
.equ UART_LCR_H, 0x2c
.equ UART_CR, 0x30

.equ eol, 0x00
.equ endl, 0x0A
.equ carriage_return, 0x0D
.equ backspace, 0x08
.equ escape, 0x1b
.equ empty_space, 0x20

/**
 * Init uart, set uart0
 */
.thumb_func
.global uart_init
.align 4
uart_init:
        push {lr}
        @ 1) Set baudrate; values calculated according to datasheet for 115200
        ldr  r1, UART0_BASE

        movs r0, #6
        str  r0, [r1, UART_IBRD]

        movs r0, #33
        str  r0, [r1, UART_FBRD]

        @ 2) Set word length
        movs r0, #0b01110000        @ Bit 6-7 - word length = 8 bit; Bit 5 - fifo enable
        str  r0, [r1, UART_LCR_H]

        @ 3) enable uart
        movs r0, #3                 @ Bit 9 - rx_enable; Bit 8 - tx_enable
        lsls r0, #8
        adds r0, #1                 @ Bit 1 - uart_enable
        str  r0, [r1, UART_CR]

        @ 4) select pins
        movs r0, #0                 @ UART0_TX
        movs r1, #2                 @ 2 - UART
        bl   GPIO_function_select

        movs r0, #1                 @ UART0_RX
        movs r1, #2                 @ 2 - UART
        bl   GPIO_function_select

        pop  {pc}

/**
 * UART send single character
 * r0 - character to be sent, does not change r0
 */
.thumb_func
.align 4
uart_Tx:
        ldr  r3, UART0_BASE

        movs r2, #32                @ Bit 5 - TXFF (transmit fifo full)
        .tx_fifo_empty_loop:
                ldr  r1, [r3, UART_FR]
                tst  r1, r2
                bne  .tx_fifo_empty_loop

        strb r0, [r3, UART_DR]

        bx   lr

/**
 * Put character into UART
 *   r0 - char or char sequence (e.g. Arrows)
 */
.thumb_func
.global uart_putc
.align 4
uart_putc:
        push    {r4, r5, lr}
        mov     r4, r0

        cmp     r0, #0xff
        ble     .putc_normal_char

        .putc_escape_sequence:
                movs    r5, #0xff
                lsrs    r0, r4, #16
                ands    r0, r0, r5
                bl      uart_Tx

                lsrs    r0, r4, #8
                ands    r0, r0, r5
                bl      uart_Tx

                ands    r0, r4, r5
                bl      uart_Tx

                b       .exit_putc

        .putc_normal_char:
                bl      uart_Tx

                cmp     r4, backspace
                beq     .putc_backspace

                cmp     r4, endl
                beq     .putc_endl

                b       .exit_putc

        .putc_backspace:
                movs    r0, empty_space
                bl      uart_Tx

                movs    r0, backspace
                bl      uart_Tx

                b       .exit_putc

        .putc_endl:
                movs    r0, carriage_return
                bl      uart_Tx

        .exit_putc:
                pop     {r4, r5, pc}


/**
 * UART receive single character
 */
.thumb_func
.align 4
uart_Rx:
        ldr  r3, UART0_BASE

        movs r2, #16                @ Bit 4 - RXFE (receive fifo empty)
        .rx_fifo_empty_loop:
                ldr  r1, [r3, UART_FR]
                tst  r1, r2
                bne .rx_fifo_empty_loop

        ldrb  r0, [r3, UART_DR]

        bx   lr

/**
 * Get character from UART (alias for uart_Rx)
 */
.thumb_func
.global uart_getc
.align 4
uart_getc:
        push    {lr}
        bl      uart_Rx
        pop     {pc}



/**
 * Clears the screen and moves the cursor to the home position (0,0)
 */
.thumb_func
.global uart_clr_screen
.align 4
uart_clr_screen:
        push    {lr}

        movs    r0, escape
        bl      uart_Tx

        movs    r0, 0x5b
        bl      uart_Tx

        movs    r0, 0x32
        bl      uart_Tx

        movs    r0, 0x4a
        bl      uart_Tx

        pop     {pc}



#ifdef ARCH_RP2040
.align 4
UART0_BASE:     .word 0x40034000
#elifdef ARCH_RP2350
.align 4
UART0_BASE:     .word 0x40070000
#endif
