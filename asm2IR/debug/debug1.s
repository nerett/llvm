mem
    ALLOCM r10
    BR entry

entry
    LIFETIME_START r10
    BR exit

exit
    FREEM r10
    HLT
