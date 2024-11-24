mem
    ALLOCM r31

    BR entry

entry
    LIFETIME_START r31
    INM r31

    MOV r20 200
    MOV r1 1337

    DUMP

    STR r31 r20 r20 42

    LDA r1 r31 r20 r20

    DUMP

    BR exit
exit
    FREEM r31
    HLT
