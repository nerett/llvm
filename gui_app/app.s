mem
    ALLOCM r10
    ALLOCM r11

    BR entry

entry
    LIFETIME_START r10
    INM r10

    MOV r20 200
    MOV r21 201
    MOV r22 202

    STR r10 r20 r20 0
    STR r10 r21 r20 1
    STR r10 r22 r20 0

    STR r10 r20 r21 0
    STR r10 r21 r21 1
    STR r10 r22 r21 1

    STR r10 r20 r22 1
    STR r10 r21 r22 1
    STR r10 r22 r22 0

    LIFETIME_START r11
    INM r11

    MOV r3 0
    BR loop_epoch

loop_epoch
    MOV r4 0
    BLE r3 1000 loop_x exit

loop_x
    MOV r5 0
    BLE r4 512 loop_y loop_epoch

loop_y
    BLE r5 512 body loop_x

body
    MOV r6 0

    SUB r7 r4 1
    SUB r8 r5 1
    LDA r6 r10 r7 r8

    SUB r7 r4 1
    SUB r8 r5 0
    LDA r6 r10 r7 r8

    SUB r7 r4 1
    ADD r8 r5 1
    LDA r6 r10 r7 r8

    SUB r7 r4 0
    ADD r8 r5 1
    LDA r6 r10 r7 r8

    ADD r7 r4 1
    ADD r8 r5 1
    LDA r6 r10 r7 r8

    ADD r7 r4 1
    SUB r8 r5 0
    LDA r6 r10 r7 r8

    ADD r7 r4 1
    SUB r8 r5 1
    LDA r6 r10 r7 r8

    SUB r7 r4 1
    SUB r8 r5 1
    LDA r6 r10 r7 r8

    SUB r7 r4 0
    SUB r8 r5 1
    LDA r6 r10 r7 r8

    LDA r6 r10 r4 r5

    BEQ r6 3 draw_alive draw_dead

draw_alive
    STR r11 r4 r5 1
    PUT_PIXEL r4 r5 16711935

    BR body_end

draw_dead
    PUT_PIXEL r4 r5 255

    BR body_end

body_end
    FLUSH

    ADD r3 r3 1
    ADD r4 r4 1
    ADD r5 r5 1

    BR swap

swap
    CPYM r10 r11
    INM r11

    BR loop_epoch

exit
    FREEM r10
    FREEM r11
    HLT
