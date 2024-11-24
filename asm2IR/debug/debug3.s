mem
    ALLOCM r10
    ALLOCM r11
    BR entry

entry
    LIFETIME_START r10
    LIFETIME_START r11
    CPYM r10 r11
    BR exit

exit
    FREEM r10
    FREEM r11
    HLT
