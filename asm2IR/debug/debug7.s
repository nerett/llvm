mem
    ALLOCM r31

    BR entry

entry
    LIFETIME_START r31
    INM r31

    MOV r20 200
    MOV r21 201
    MOV r22 202
    MOV r23 203
    MOV r24 204
    MOV r25 205

    DUMP

    STR r31 r20 r20 1
    STR r31 r21 r20 2
    STR r31 r22 r20 3

    STR r31 r20 r21 4
    STR r31 r21 r21 5
    STR r31 r22 r21 6

    STR r31 r20 r22 7
    STR r31 r21 r22 8
    STR r31 r22 r22 9

    DUMP

    LDA r1 r31 r20 r20
    LDA r2 r31 r21 r20
    LDA r3 r31 r22 r20

    LDA r4 r31 r20 r21
    LDA r5 r31 r21 r21
    LDA r6 r31 r22 r21

    LDA r7 r31 r20 r22
    LDA r8 r31 r21 r22
    LDA r9 r31 r22 r22

    DUMP

    BR exit
exit
    FREEM r31
    HLT
