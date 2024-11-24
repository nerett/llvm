entry
    MOV r10 256
    MOV r11 128
    PUT_PIXEL r10 r11 16711935
    FLUSH

    MOV r0 0
    BR loop_start

loop_start
    ADD r0 r0 1
    PUT_PIXEL r0 r11 16711935
    FLUSH
    BLE r0 100000 loop_start exit

exit
    HLT
