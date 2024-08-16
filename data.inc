section '.data' data readable writeable
        hInstance        dd ?
        
        COLLUM_COUNT    =  50
struct  pFILE_HEADER_
            pSuM        dd  0
            pCnt        dd  0
            pCollum     dd  0
            pBASE       rd  COLLUM_COUNT
ends

struct  pCOLLUM_
       COLLUM_0         dd      0
       COLLUM_1         dd      0
       COLLUM_2         dd      0
       COLLUM_3         dd      0
       COLLUM_4         dd      0
       COLLUM_5         dd      0
       COLLUM_6         dd      0
       COLLUM_7         dd      0
       COLLUM_8         dd      0
       COLLUM_9         dd      0
       COLLUM_10        dd      0
       COLLUM_11        dd      0
       COLLUM_12        dd      0
       COLLUM_13        dd      0
       COLLUM_14        dd      0
       COLLUM_15        dd      0
       COLLUM_16        dd      0
       COLLUM_17        dd      0
       COLLUM_18        dd      0
       COLLUM_19        dd      0
       COLLUM_20        dd      0
       COLLUM_21        dd      0
       COLLUM_22        dd      0
       COLLUM_23        dd      0
       COLLUM_24        dd      0
       COLLUM_25        dd      0
       COLLUM_26        dd      0
       COLLUM_27        dd      0
       COLLUM_28        dd      0
       COLLUM_29        dd      0
       COLLUM_30        dd      0
       COLLUM_31        dd      0
       COLLUM_32        dd      0
       COLLUM_33        dd      0
       COLLUM_34        dd      0
       COLLUM_35        dd      0
       COLLUM_36        dd      0
       COLLUM_37        dd      0
       COLLUM_38        dd      0
       COLLUM_39        dd      0
       COLLUM_40        dd      0
       COLLUM_41        dd      0
       COLLUM_42        dd      0
       COLLUM_43        dd      0
       COLLUM_44        dd      0
       COLLUM_45        dd      0
       COLLUM_46        dd      0
       COLLUM_47        dd      0
       COLLUM_48        dd      0
       COLLUM_49        dd      0
       COLLUM_50        dd      0
ends 
       pCOLLUM          pCOLLUM_
       pBASE            dd  0
       pFILE            db      "IP2LOCATION.BIN",0
       pClipboardTEXT   db      "Copy To Clipboard Ctr+V",0
       IPAddressNotFoundTEXT    db   "IP Address Not Found",0
       IP2LOCATION_BIN_NotFound db   "IP2LOCATION.BIN Not Found",0
       pBuff            rb  4096
       