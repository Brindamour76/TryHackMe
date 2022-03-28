Write_Console Macro oText, oNum_of_Chars
  PushA
  PushF
  Push 0                   ; lpvReserved
  Push offset cchWritten   ; lpcchWritten
  Push oNum_of_Chars       ; cchToWrite
  Push oText               ; lpvBuffer
  Push [ConHandle]         ; hConsoleOutput
  Call WriteConsoleA
  PopF
  PopA
EndM