section '.idata' import data readable writeable

  library kernel32,'kernel32.dll',\
          user32,'user32.dll',\
          shell32,'shell32.dll',\
          comctl32,'comctl32.dll'

  import kernel32,\
         CloseHandle,'CloseHandle',\
         CreateFile,'CreateFileA',\
         ExitProcess,'ExitProcess',\
         GetFileSize,'GetFileSize',\
         GetModuleHandle,'GetModuleHandleA',\
         GlobalAlloc,'GlobalAlloc',\
         GlobalLock,'GlobalLock',\
         GlobalUnlock,'GlobalUnlock',\
         ReadFile,'ReadFile',\
         VirtualAlloc,'VirtualAlloc'

  import user32,\
         CloseClipboard,'CloseClipboard',\
         DialogBoxParam,'DialogBoxParamA',\
         EmptyClipboard,'EmptyClipboard',\
         EndDialog,'EndDialog',\
         GetDlgItemText,'GetDlgItemTextA',\
         MessageBox,'MessageBoxA',\
         OpenClipboard,'OpenClipboard',\
         SendMessage,'SendMessageA',\
         SetClipboardData,'SetClipboardData'

  import shell32,\
         DragAcceptFiles,'DragAcceptFiles',\
         DragQueryFile,'DragQueryFileA'

  import comctl32,\
         InitCommonControls,'InitCommonControls'