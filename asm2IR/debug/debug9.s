mem
    ALLOCM r10
    ALLOCM r11

    BR entry

entry
    LIFETIME_START r10

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

    MOV r3 0
    BR loop_epoch_begin

loop_epoch_begin
    MOV r4 0
    BLE r3 1000 loop_x_begin exit

loop_x_begin
    MOV r5 0
    BLE r4 512 loop_y_begin loop_epoch_end

loop_y_begin
    BLE r5 512 body loop_x_end

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

    SUB r7 r4 0
    SUB r8 r5 1
    LDA r6 r10 r7 r8

    BR if_1

if_1
    BEQ r6 3 draw_alive if_2

if_2
    LDA r6 r10 r4 r5
    BEQ r6 3 draw_alive draw_dead

draw_alive
    STR r11 r4 r5 1
    PUT_PIXEL r4 r5 16711935

    BR loop_y_end

draw_dead
    PUT_PIXEL r4 r5 255

    BR loop_y_end

loop_y_end
    ADD r5 r5 1
    BR loop_y_begin

loop_x_end
    ADD r4 r4 1
    BR loop_x_begin

loop_epoch_end
    FLUSH

    SWAP r10 r11
    INM r11

    ADD r3 r3 1

    MOV r31 0
    BR loop_epoch_begin

exit
    FREEM r10
    FREEM r11
    HLT
