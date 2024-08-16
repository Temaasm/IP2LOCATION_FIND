;=======================================================================
format PE GUI 4.0
;=======================================================================
include 'win32ax.inc'    ;*
include '_MACRO.inc'    ;*
include 'rc.inc'        ;*
;=======================================================================
section '.code' code readable executable

entry $
    
    invoke InitCommonControls
    invoke GetModuleHandle,0
    mov [hInstance],eax
    invoke DialogBoxParam,[hInstance],D_MAIN,0,dlg_proc,0
    invoke ExitProcess,0

;***************************************************************************************************************
proc dlg_proc hwnd,msg,wparam,lparam
        push_all
        cmp     [msg],WM_NOTIFY
        je      .WM_NOTIFY
        cmp     [msg],WM_INITDIALOG
        je      .WM_INITDIALOG
        cmp     [msg],WM_COMMAND
        je      .WM_COMMAND
        cmp     [msg],WM_CLOSE
        je      .WM_CLOSE
        cmp     [msg],WM_TIMER
        je      .WM_TIMER
        cmp     [msg],WM_DROPFILES
        je      .WM_DROPFILES
        xor     eax,eax
        jmp     .finish
.WM_TIMER:
        jmp     .processed
.WM_NOTIFY:
        jmp     .processed
.WM_INITDIALOG:
        invoke  DragAcceptFiles,[hwnd],TRUE
        stdcall pLoadFile,pFILE
        mov     [pBASE],eax
        .if     eax=0
                invoke  MessageBox,0,IP2LOCATION_BIN_NotFound,IP2LOCATION_BIN_NotFound,0
                jmp     .WM_CLOSE
        .endif
        jmp     .processed
.WM_DROPFILES:
        invoke  DragQueryFile,[wparam],0,pBuff,pBuff.size
        ;invoke  SetDlgItemText,[hwnd],IDC_EDIT,pBuff
        jmp     .processed
.WM_COMMAND:
        .if     [wparam]=IDC_FIND
                
            invoke  GetDlgItemText,[hwnd],IDC_IP,pBuff,pBuff.size-1
            stdcall pFind_IP,pBuff
                .if     eax=0
                        invoke  SendMessage,[hwnd],WM_SETTEXT,0,IPAddressNotFoundTEXT
                        jmp     .processed
                .endif
            stdcall pFormatDB,pBuff
            stdcall SetClipboard,pBuff
            invoke  SendMessage,[hwnd],WM_SETTEXT,0,pClipboardTEXT
        
        .endif
        jmp     .processed
.exit_true:
        mov eax,TRUE  
        jmp .finish
.exit_false:
        mov eax,FALSE  
        jmp .finish            
.WM_CLOSE:
        invoke  EndDialog,[hwnd],0
.processed:
        mov     eax,1
.finish:
        pop_all
        ret
endp  
;*************************************************************************************************************** 



;****************************************************************************************************
proc    pLoadFile,pFILE
locals
        hFile           dd      ?
        hSize           dd      ?
        hMem            dd      ?
        pNumbers        dd      ?
endl
        push_all
        invoke  CreateFile,[pFILE],GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL
        mov     [hFile],eax
        invoke  GetFileSize,[hFile],0
        mov     [hSize],eax
        or      eax,eax
        je      .ret
        invoke  VirtualAlloc,0,[hSize],MEM_COMMIT+MEM_RESERVE,PAGE_EXECUTE_READWRITE
        mov     [hMem],eax
        or      eax,eax
        je      .ret
        invoke  ReadFile,[hFile],[hMem],[hSize],addr pNumbers,0
        invoke  CloseHandle,[hFile]
        mov     eax,[hMem]
        cmp     dword[eax+pFILE_HEADER_.pSuM],"IPV4"
        je      .ret
        xor     eax,eax
.ret:
        pop_all
        ret
endp
;****************************************************************************************************

;****************************************************************************************************
proc    pFind_IP,pIP
        push_all
        xor     ebx,ebx
        cmp     [pBASE],ebx
        je      .find_end
        stdcall _RtlZeroMemory,pCOLLUM,COLLUM_COUNT*4
        stdcall _RtlIpv4StringToAddress,[pIP]
        mov     esi,[pBASE]
        mov     edi,[pBASE]
        mov     ecx,[edi+pFILE_HEADER_.pCollum]
        mov     edx,ecx
        shl     edx,2
        add     esi,sizeof.pFILE_HEADER_
        bswap   eax
.find_ip:
        cmp     eax,[esi+0]
        jb      .next_ip
        cmp     eax,[esi+4]
        ja      .next_ip
        mov     eax,[esi]
        bswap   eax
        mov     dword[pCOLLUM],eax
        mov     eax,[esi+4]
        bswap   eax
        mov     dword[pCOLLUM+4],eax
        mov     ebx,2
.add_base:
        mov     eax,[esi+ebx*4]
        add     eax,edi
        mov     [pCOLLUM+ebx*4],eax
        inc     ebx
        cmp     ebx,[edi+pFILE_HEADER_.pCollum]
        jb      .add_base
        mov     eax,pCOLLUM
        jmp     .ret
.next_ip:
        add     esi,edx
        inc     ebx
        cmp     ebx,[edi+pFILE_HEADER_.pCnt]
        jb      .find_ip
.find_end:
        xor     eax,eax
.ret:
        pop_all
        ret
endp
;****************************************************************************************************

;****************************************************************************************************
proc    pFormatDB,pBuff
iglobal
        pFormat         db      "%I",0x0A,"%I",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,\
                                "%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,\
                                "%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,\
                                "%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,\
                                "%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,"%s",0x0A,0
endg
        push_all
        mov     ebx,esp
        stdcall IP2LOCATION_sprintf,[pBuff],pFormat,[pCOLLUM.COLLUM_0],[pCOLLUM.COLLUM_1],[pCOLLUM.COLLUM_2],[pCOLLUM.COLLUM_3],[pCOLLUM.COLLUM_4],[pCOLLUM.COLLUM_5],[pCOLLUM.COLLUM_6],[pCOLLUM.COLLUM_7],[pCOLLUM.COLLUM_8],[pCOLLUM.COLLUM_9],[pCOLLUM.COLLUM_10],\
                                       [pCOLLUM.COLLUM_11],[pCOLLUM.COLLUM_12],[pCOLLUM.COLLUM_13],[pCOLLUM.COLLUM_14],[pCOLLUM.COLLUM_15],[pCOLLUM.COLLUM_16],[pCOLLUM.COLLUM_17],[pCOLLUM.COLLUM_18],[pCOLLUM.COLLUM_19],[pCOLLUM.COLLUM_20],\
                                       [pCOLLUM.COLLUM_21],[pCOLLUM.COLLUM_22],[pCOLLUM.COLLUM_23],[pCOLLUM.COLLUM_24],[pCOLLUM.COLLUM_25],[pCOLLUM.COLLUM_26],[pCOLLUM.COLLUM_27],[pCOLLUM.COLLUM_28],[pCOLLUM.COLLUM_29],[pCOLLUM.COLLUM_30],\
                                       [pCOLLUM.COLLUM_31],[pCOLLUM.COLLUM_32],[pCOLLUM.COLLUM_33],[pCOLLUM.COLLUM_34],[pCOLLUM.COLLUM_35],[pCOLLUM.COLLUM_36],[pCOLLUM.COLLUM_37],[pCOLLUM.COLLUM_38],[pCOLLUM.COLLUM_39],[pCOLLUM.COLLUM_40],\
                                       [pCOLLUM.COLLUM_41],[pCOLLUM.COLLUM_42],[pCOLLUM.COLLUM_43],[pCOLLUM.COLLUM_44],[pCOLLUM.COLLUM_45],[pCOLLUM.COLLUM_46],[pCOLLUM.COLLUM_47],[pCOLLUM.COLLUM_48],[pCOLLUM.COLLUM_49],[pCOLLUM.COLLUM_50]
        mov     esp,ebx
        mov     eax,[pBuff]
.ret:
        pop_all
        ret
endp
;****************************************************************************************************

;****************************************************************************************************
proc    IP2LOCATION_sprintf,pBuff,pFormat
        push_all
        mov     esi,[pFormat]
        mov     edi,[pBuff]
        mov     [pBuff],edi
        mov     ebx,ebp
        add     ebx,4*4
        xor     edx,edx
.scan_format:
        mov     ax,[esi]
        cmp     ax,"%s"
        je      .to_string
        cmp     ax,"%d"
        je      .to_dec
        cmp     ax,"%h"
        je      .to_hex
        cmp     ax,"%x"
        je      .to_hex_max
        cmp     ax,"%f"
        je      .to_float
        cmp     ax,"%I"
        je      .to_ip
        or      al,al
        je      .scan_format_ret
        mov     [edi],al
.scan_format_next:
        inc     edi
        inc     esi
        jmp     .scan_format
.to_null:
        add     ebx,4
        add     esi,2
        jmp     .scan_format
.to_string:
        xor     eax,eax
        cmp     [ebx],eax
        je      .scan_format_ret
        stdcall _lstrcat,edi,dword[ebx]
        add     edi,eax
        jmp     .to_null
.to_dec:
        mov     eax,[ebx]
        stdcall RadixConvertEx,edi,10,0
        add     edi,eax
        jmp     .to_null
.to_hex:
        mov     eax,[ebx]
        stdcall RadixConvertEx,edi,16,0
        add     edi,eax
        jmp     .to_null
.to_hex_max:
        mov     eax,[ebx]
        stdcall RadixConvertEx,edi,16,8
        add     edi,eax
        jmp     .to_null
.to_float:
        mov     eax,[ebx]
        stdcall FloatToString,edi,3,eax
        add     edi,eax
        jmp     .to_null
.to_ip:
        movzx   eax,byte[ebx]
        stdcall RadixConvertEx,edi,10,0
        add     edi,eax
                mov             al,"."
                stosb
                movzx   eax,byte[ebx+1]
        stdcall RadixConvertEx,edi,10,0
        add     edi,eax
                mov             al,"."
                stosb
                movzx   eax,byte[ebx+2]
        stdcall RadixConvertEx,edi,10,0
        add     edi,eax
                mov             al,"."
                stosb
                movzx   eax,byte[ebx+3]
        stdcall RadixConvertEx,edi,10,0
        add     edi,eax
        jmp     .to_null
.scan_format_ret:
        mov     [edi],al
        sub     edi,[pBuff]
        mov     eax,edi
        pop_all
        ret
endp 
;****************************************************************************************************



;***************************************************************************************************************
proc SetClipboard,txtSerial
    local   sLen      dd  0
    local   hMem    dd  0
    local   pMem    dd  0

    push_all
        stdcall  _lstrlen, [txtSerial]
        inc eax
        mov [sLen], eax
        invoke OpenClipboard, 0
        invoke GlobalAlloc, GHND, [sLen]
        mov [hMem], eax
        invoke GlobalLock, eax
        mov [pMem], eax
        mov esi, [txtSerial]
        mov edi, eax
        mov ecx, [sLen]
        rep movsb
        invoke EmptyClipboard
        invoke GlobalUnlock, [hMem]
        invoke SetClipboardData, CF_TEXT, [hMem]
        invoke CloseClipboard
    pop_all 
    ret
endp    
;***************************************************************************************************************


IncludeAllGlobals      


;=======================================================================
include 'idata.inc'
include  'data.inc'
;=======================================================================
section '.rsrc' resource from 'dialog.res' data readable
