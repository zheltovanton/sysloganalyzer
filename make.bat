copy d:\_SysLogAnalizer\Client\SysLogAnalizer\slac.exe d:\_SysLogAnalizer\SLAC\slac.exe  /y
upx.exe  d:\_SysLogAnalizer\SLAC\slac.exe 

copy d:\_SysLogAnalizer\Client_mini\SysLogAnalizer\mslac.exe d:\_SysLogAnalizer\mSLAC\mslac.exe  /y
upx.exe  d:\_SysLogAnalizer\mSLAC\mslac.exe 


C:\Progra~1\NSIS\makensis.exe  slac.nsi
C:\Progra~1\NSIS\makensis.exe  mslac.nsi

