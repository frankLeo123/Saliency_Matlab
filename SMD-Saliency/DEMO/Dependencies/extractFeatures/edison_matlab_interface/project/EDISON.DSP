# Microsoft Developer Studio Project File - Name="EDISON" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=EDISON - Win32 Debug_wx240
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "EDISON.MAK".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "EDISON.MAK" CFG="EDISON - Win32 Debug_wx240"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "EDISON - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "EDISON - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE "EDISON - Win32 Release_wx240" (based on "Win32 (x86) Console Application")
!MESSAGE "EDISON - Win32 Debug_wx240" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "EDISON - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /I "c:/wx2/include" /I "../edge" /I "../segm" /I "../GUI" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "__WINDOWS__" /D "__WXMSW__" /D "__WIN95__" /D "__WIN32__" /D WINVER=0x0400 /D "STRICT" /YX /FD /c
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /i "c:/wx2/include" /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib rpcrt4.lib wsock32.lib winmm.lib wx.lib xpm.lib png.lib zlib.lib jpeg.lib tiff.lib /nologo /subsystem:windows /machine:I386 /nodefaultlib:"libc.lib" /nodefaultlib:"libci.lib" /nodefaultlib:"msvcrtd.lib" /libpath:"c:/wx2/lib"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "EDISON - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /Gm /GX /ZI /Od /I "c:/wx2/include" /I "../project" /I "../edge" /I "../segm" /I "../GUI" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "__WINDOWS__" /D "__WXMSW__" /D DEBUG=1 /D "__WXDEBUG__" /D "__WIN95__" /D "__WIN32__" /D WINVER=0x0400 /D "STRICT" /YX /FD /c
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /i "D:\bin\wxWidgets-2.8.4\include" /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib rpcrt4.lib wsock32.lib winmm.lib wxzlibd.lib wxtiffd.lib wxregexd.lib wxpngd.lib wxjpegd.lib wxexpatd.lib wxmsw28d_xrc.lib wxmsw28d_richtext.lib wxmsw28d_qa.lib wxmsw28d_media.lib wxmsw28d_html.lib wxmsw28d_gl.lib wxmsw28d_dbgrid.lib wxmsw28d_core.lib wxmsw28d_aui.lib wxmsw28d_adv.lib wxbase28d_xml.lib wxbase28d_odbc.lib wxbase28d_net.lib wxbase28d.lib /nologo /subsystem:windows /profile /map /debug /machine:I386 /nodefaultlib:"libcd.lib" /nodefaultlib:"libcid.lib" /nodefaultlib:"msvcrt.lib" /nodefaultlib:"LIBCMT.lib" /libpath:"D:\bin\wxWidgets-2.8.4\lib\vc_lib"

!ELSEIF  "$(CFG)" == "EDISON - Win32 Release_wx240"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "EDISON___Win32_Release_wx240"
# PROP BASE Intermediate_Dir "EDISON___Win32_Release_wx240"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release_wx240"
# PROP Intermediate_Dir "Release_wx240"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /I "c:/wx2/include" /I "../edge" /I "../segm" /I "../GUI" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "__WINDOWS__" /D "__WXMSW__" /D "__WIN95__" /D "__WIN32__" /D WINVER=0x0400 /D "STRICT" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GX /O2 /I "c:/wx2/include" /I "c:/wx2/lib/msw" /I "../edge" /I "../segm" /I "../GUI" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "__WINDOWS__" /D "__WXMSW__" /D "__WIN95__" /D "__WIN32__" /D WINVER=0x0400 /D "STRICT" /YX /FD /c
# ADD BASE RSC /l 0x409 /i "c:/wx2/include" /d "NDEBUG"
# ADD RSC /l 0x409 /i "c:/wx2/include" /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib rpcrt4.lib wsock32.lib winmm.lib wx.lib xpm.lib png.lib zlib.lib jpeg.lib tiff.lib /nologo /subsystem:windows /machine:I386 /nodefaultlib:"libc.lib" /nodefaultlib:"libci.lib" /nodefaultlib:"msvcrtd.lib" /libpath:"c:/wx2/lib"
# SUBTRACT BASE LINK32 /pdb:none
# ADD LINK32 wxmsw28_core.lib wxbase28.lib wxtiff.lib wxjpeg.lib wxpng.lib wxzlib.lib wxregex.lib wxexpat.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib rpcrt4.lib wsock32.lib winmm.lib wxmsw.lib png.lib zlib.lib jpeg.lib tiff.lib /nologo /subsystem:windows /machine:I386 /nodefaultlib:"libc.lib" /nodefaultlib:"libci.lib" /nodefaultlib:"msvcrtd.lib" /nodefaultlib:"LIBCMT.lib" /libpath:"D:\bin\wxWidgets-2.8.4\lib"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "EDISON - Win32 Debug_wx240"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "EDISON___Win32_Debug_wx240"
# PROP BASE Intermediate_Dir "EDISON___Win32_Debug_wx240"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug_wx240"
# PROP Intermediate_Dir "Debug_wx240"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /I "c:/wx2/include" /I "../edge" /I "../segm" /I "../GUI" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "__WINDOWS__" /D "__WXMSW__" /D DEBUG=1 /D "__WXDEBUG__" /D "__WIN95__" /D "__WIN32__" /D WINVER=0x0400 /D "STRICT" /YX /FD /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /I "c:/wx2/include" /I "c:/wx2/lib/mswd" /I "../edge" /I "../segm" /I "../GUI" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "__WINDOWS__" /D "__WXMSW__" /D DEBUG=1 /D "__WXDEBUG__" /D "__WIN95__" /D "__WIN32__" /D WINVER=0x0400 /D "STRICT" /YX /FD /c
# ADD BASE RSC /l 0x409 /i "c:/wx2/include" /d "_DEBUG"
# ADD RSC /l 0x409 /i "c:/wx2/include" /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib rpcrt4.lib wsock32.lib winmm.lib wxd.lib xpmd.lib pngd.lib zlibd.lib jpegd.lib tiffd.lib /nologo /subsystem:windows /profile /map /debug /machine:I386 /nodefaultlib:"libcd.lib" /nodefaultlib:"libcid.lib" /nodefaultlib:"msvcrt.lib" /libpath:"c:/wx2/lib"
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib rpcrt4.lib wsock32.lib winmm.lib wxmswd.lib pngd.lib zlibd.lib jpegd.lib tiffd.lib /nologo /subsystem:windows /profile /map /debug /machine:I386 /nodefaultlib:"libcd.lib" /nodefaultlib:"libcid.lib" /nodefaultlib:"msvcrt.lib" /libpath:"c:/wx2/lib"

!ENDIF 

# Begin Target

# Name "EDISON - Win32 Release"
# Name "EDISON - Win32 Debug"
# Name "EDISON - Win32 Release_wx240"
# Name "EDISON - Win32 Debug_wx240"
# Begin Group "Headers"

# PROP Default_Filter "*.h"
# Begin Source File

SOURCE=..\edge\BgDefaults.h
# End Source File
# Begin Source File

SOURCE=..\edge\BgEdge.h
# End Source File
# Begin Source File

SOURCE=..\edge\BgEdgeDetect.h
# End Source File
# Begin Source File

SOURCE=..\edge\BgEdgeList.h
# End Source File
# Begin Source File

SOURCE=..\edge\BgImage.h
# End Source File
# Begin Source File

SOURCE=..\GUI\BgImagPGM.h
# End Source File
# Begin Source File

SOURCE=..\GUI\BgImagPNM.h
# End Source File
# Begin Source File

SOURCE=..\GUI\bgimsystem.h
# End Source File
# Begin Source File

SOURCE=..\segm\ms.h
# End Source File
# Begin Source File

SOURCE=..\segm\msImageProcessor.h
# End Source File
# Begin Source File

SOURCE=..\segm\msSys.h
# End Source File
# Begin Source File

SOURCE=..\segm\RAList.h
# End Source File
# Begin Source File

SOURCE=..\segm\rlist.h
# End Source File
# Begin Source File

SOURCE=..\segm\tdef.h
# End Source File
# End Group
# Begin Group "Source"

# PROP Default_Filter "*.cpp"
# Begin Source File

SOURCE=..\edge\BgEdge.cpp
# End Source File
# Begin Source File

SOURCE=..\edge\BgEdgeDetect.cpp
# End Source File
# Begin Source File

SOURCE=..\edge\BgEdgeList.cpp
# End Source File
# Begin Source File

SOURCE=..\edge\BgGlobalFc.cpp
# End Source File
# Begin Source File

SOURCE=..\edge\BgImage.cpp
# End Source File
# Begin Source File

SOURCE=..\GUI\BgImagPGM.cpp
# End Source File
# Begin Source File

SOURCE=..\GUI\BgImagPNM.cpp
# End Source File
# Begin Source File

SOURCE=..\GUI\bgimsystem.cpp
# End Source File
# Begin Source File

SOURCE=..\segm\ms.cpp
# End Source File
# Begin Source File

SOURCE=..\segm\msImageProcessor.cpp
# End Source File
# Begin Source File

SOURCE=..\segm\msSys.cpp
# End Source File
# Begin Source File

SOURCE=..\segm\RAList.cpp
# End Source File
# Begin Source File

SOURCE=..\segm\rlist.cpp
# End Source File
# End Group
# Begin Group "Bitmaps"

# PROP Default_Filter "*.bmp"
# Begin Source File

SOURCE=..\GUI\icons\arrow.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\caip_logo.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\copy.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\cross.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\cut.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\down_arrow.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\h.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\help.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\new.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\new_e.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\new_s.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\open.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\p.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\paste.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\print.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\riul_logo.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\rotated_h.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\rotated_p.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\rutgers_logo.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\save.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\zoom_in.bmp
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\zoom_out.bmp
# End Source File
# End Group
# Begin Group "Icons"

# PROP Default_Filter "*.ico"
# Begin Source File

SOURCE=..\GUI\icons\bgimsystem.ico
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\chart.ico
# End Source File
# Begin Source File

SOURCE=.\wx\msw\error.ico
# End Source File
# Begin Source File

SOURCE=.\wx\msw\info.ico
# End Source File
# Begin Source File

SOURCE=..\GUI\icons\mondrian.ico
# End Source File
# Begin Source File

SOURCE=.\wx\msw\question.ico
# End Source File
# Begin Source File

SOURCE=.\wx\msw\tip.ico
# End Source File
# Begin Source File

SOURCE=.\wx\msw\warning.ico
# End Source File
# End Group
# Begin Group "Cursors"

# PROP Default_Filter "*.cur"
# Begin Source File

SOURCE=.\wx\msw\blank.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\bullseye.cur
# End Source File
# Begin Source File

SOURCE=.\edison.rc
# End Source File
# Begin Source File

SOURCE=.\wx\msw\hand.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\magnif1.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\noentry.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\pbrush.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\pencil.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\pntleft.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\pntright.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\query.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\roller.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\size.cur
# End Source File
# Begin Source File

SOURCE=.\wx\msw\watch1.cur
# End Source File
# End Group
# End Target
# End Project
