mem
    ALLOCM r10
    BR entry

entry
    LIFETIME_START r10

    MOV r1 256
    MOV r2 128
    STR r10 r1 r2 42

    BR exit

exit
    FREEM r10
    HLT
