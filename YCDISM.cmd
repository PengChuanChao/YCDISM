@echo off
color 1F
chcp 936 >nul
mode con cols=96 lines=42
set title= ***** �곿�ռ� MS ISO���ؾ����������� [YCDISM NT6-10 ��ʽ�� 2017-03-31] *****
title  %title%
if /i %PROCESSOR_ARCHITECTURE% EQU AMD64 (set Obt=x64) ELSE (set Obt=x86)
cd /d "%~dp0"&&if exist DISM%Obt%\DISM.exe (SET YCDM=DISM%Obt%\DISM.exe) ELSE (SET YCDM=DISM.exe)
setlocal EnableDelayedExpansion
ver |find " 10.">nul &&set TheOS=Win10
ver |find " 6.4">nul &&set TheOS=Win10
ver |find " 6.3">nul &&set TheOS=Win81
ver |find " 6.2">nul &&set TheOS=Win8
ver |find " 6.1">nul &&set TheOS=Win7
ver |find " 6.0">nul &&set TheOS=Vista
if !TheOS! equ Win10 goto SETP
if !TheOS! equ Win81 goto SETP
if !TheOS! equ Win8 goto SETP
if !TheOS! equ Win7 goto SETP
echo.
echo   ��ȷ�������� Windows 7 ����ϵͳ�����б����� 6����Զ��˳�
echo.
ping -n 6 127.1>nul
exit /q

:SETP
SET YCP=%~dp0
echo.
echo.
echo         %title%
echo.
for /f "tokens=3 delims=: " %%b in ('%YCDM% /english /online /Get-Intl ^| find /i "System locale"') do set OUI=%%b
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set OOS=%%a
set OOS=%OOS:~29%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "BuildLabEx"') do set UBR=%%a
set UBR=%UBR:~28%
for /f "tokens=2 delims=." %%a in ('echo %UBR%') do (set OZD=%%a)
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set OMD=%%a
set OMD=%OMD:~29%
set OMD=%OMD%
if %OMD% GEQ 15051 set ORS=1703
if %OMD% LSS 15051 set ORS=1607
if %OMD% LSS 10587 set ORS=1511
if %OMD% LSS 10241 set ORS=1507
if %OMD% LSS 9601 set ORS=1309
if %OMD% LSS 9201 set ORS=1208
if %OMD% LEQ 7601 set ORS=1102
echo.
echo       ��ǰϵͳ^:%OOS% %Obt% %OUI%  ���к�^:%ORS%  �汾��^:%OMD%  ������^:%OZD%
echo.
echo                                   ��������^:%date%
echo.
echo.
echo                ����ʼ����ǰ��ȷ��������������ΪNTFS��ʽ������30G���ɿ�д�ռ�
echo.
echo                �������Ƽ����ڷ������� Ŀ¼���ƾ�����Ҫ����^:�ո�/���Ļ��������
echo.
echo                INSTALL.WIM��ESD������ESD����TOOL\ESDtoISO\ESDtoISO.CMD����ת����
echo.
echo                �ںͳ��򻥶�ʱ�뱣�����뷨״̬ΪӢ�� ���������������˳�����ֹ
echo.
echo                ��ǰ���������е�λ��Ϊ %~dp0��������ϼ����������ƶ������
:SISO
echo.
echo                ��װ�ػ�������װ��ISO���̷���ĸ������ð����Щ������ʹ���������� 
echo.
echo                ��������NetFx3��ҪISO������֧�ֻ�ǰϵͳDISM�����ò�����ǰӳ�� 
echo.
if !TheOS! equ Win7 (
echo                ��ǰΪWin7ϵͳ    �����Զ�����UltraISO����Ϊ��װ��ISO��������
echo.
start %YCP%TOOL\UltraISO\UltraISO.EXE
)
if !TheOS! equ Vista (
echo                ��ǰΪVistaϵͳ   �����Զ�����UltraISO����Ϊ��װ��ISO��������
echo.
start %YCP%TOOL\UltraISO\UltraISO.EXE
)
set ISO=%YCP%
SET /P ISO=������ISOװ�ط������̷�  ��Ҫ����ð�� ���س�������
set WEfile=install.wim
set SOUR=%ISO%\Sources\
if not exist %SOUR%%WEfile% set SOUR=%ISO%Sources\
if not exist %SOUR%%WEfile% (
set WEfile=install.esd
)
if not exist %SOUR%\%WEfile% set SOUR=%YCP%
if not exist %SOUR%%WEfile% (
set WEfile=install.wim
)
if not exist %SOUR%%WEfile% (
set WEfile=YCSINS.WIM
)
if exist %SOUR%YCSINS.WIM (
set WEfile=YCSINS.WIM
)
if not exist %SOUR%%WEfile% goto :CheckWE
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%SOUR%%WEfile% ^| find /i "index"') do set ZS=%%a
for /f "skip=1 tokens=4 delims=:." %%G in ('%YCDM% /english /get-wiminfo /wimfile:%SOUR%%WEfile% /index:1 ^| find /i "Version"') do set /a OFFSYS=%%G
if not "%OFFSYS%"=="" set DmVer=%OFFSYS%
if %OFFSYS% GEQ 9651 set FSYS=Win10
if %OFFSYS% LSS 9601 set FSYS=Win81
if %OFFSYS% LSS 9201 set FSYS=Win8
if %OFFSYS% LEQ 7601 set FSYS=Win7
if %OFFSYS% EQU 6000 set FSYS=Vista
if exist %SOUR%dism.exe (SET YCDM=%SOUR%dism.exe) ELSE (SET YCDM=dism.exe)
echo.
echo                �������%DmVer%ADK���������ʹ��  ����ʹ��ISO�е�DISMִ�к�������
echo.
ping -n 3 127.1>nul
if exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe set ADK=%DmVer%
goto BYDM

:BYDM
if %DmVer% LEQ 10240 (
echo                ��ǰ����ӳ�����͹�����%DmVer%  ����Ĭ������10240��ADK��������
echo.
ping -n 6 127.1>nul
SET YCDM=%YCP%TOOL\10240\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\10240\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% EQU 10586 (
echo                ��ǰ����ӳ�����͹�����%DmVer% 10587��������%ADK%��ADK��������
echo.
ping -n 3 127.1>nul
SET YCDM=%YCP%TOOL\10586\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\10586\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% EQU 14295 (
echo                ��ǰ����ӳ�����͹�����%DmVer% 14295��������%ADK%��ADK��������
echo.
ping -n 3 127.1>nul
SET YCDM=%YCP%TOOL\14295\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\14295\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% EQU 14393 (
echo                ��ǰ����ӳ�����͹�����%DmVer% 14393��������%ADK%��ADK��������
echo.
ping -n 3 127.1>nul
SET YCDM=%YCP%TOOL\14393\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\14393\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% GTR 14393 (
if !TheOS! EQU Win7 (
echo                ��ǰ !TheOS! ϵͳ������� 14393 ӳ��ʹ��10240 ADK��DISM�������в���
echo.
SET YCDM=%YCP%TOOL\10240\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\10240\%Obt%\Dism\dism.exe goto DMER
) ELSE (
echo                ��ǰ����ӳ�����͹�����%DmVer% 15063��������%ADK%��ADK��������
echo.
SET YCDM=%YCP%TOOL\15063\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\15063\%Obt%\Dism\dism.exe goto DMER
)
)
if %DmVer% GTR 15063 (
echo                ��ǰ����ӳ�����͹�����Ϊ%DmVer%����15063ʹ��ISO�Դ���DISM����
echo.
ping -n 3 127.1>nul
if exist %ISO%\Sources\dism.exe SET YCDM=%ISO%\Sources\dism.exe
)

echo                Ϊ��֤����������ӳ�񴿾�      ����Ĭ��ִ�������������� ���Ժ�...
echo. 
%YCDM% /cleanup-wim>nul
ping -n 3 127.1 >nul
goto SSOU

:SSOU
if not exist %SOUR%%WEfile% (
set WEfile=install.wim
)
if not exist %SOUR%%WEfile% (
set WEfile=install.esd
)
if not exist %SOUR%%WEfile% (
set WEfile=YCSINS.WIM
)

:EXPO
set INDEX=1
if exist %YCP%YCSINS.WIM goto MENU
%YCDM% /Get-Wiminfo /WimFile:%SOUR%%WEfile%
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%SOUR%%WEfile% ^| find /i "index"') do set ZS=%%a
SET /P INDEX=������Ҫ���� %SOUR%%WEfile% �е���ӳ���������ֹ�%ZS%����ӳ�� ֱ�ӻس�Ĭ��Ϊ1: 
%YCDM% /Export-Image /SourceImageFile:%SOUR%%WEfile% /SourceIndex:%INDEX% /DestinationImageFile:%YCP%YCSINS.WIM
cls
if not exist %YCP%YCSINS.WIM goto EXPO

:MENU
cls
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\System32 if not exist %MOU%\Windows\SysWOW64 (set Mbt=x86) ELSE (set Mbt=amd64)
if not exist %MOU%\Windows\System32 set GMOS=׼���������� ��װ��ӳ��
echo.
echo         %title%
echo.
echo     ��������^:%date%
echo     ��ǰϵͳ^:%OOS% %Obt% %OUI%  ���к�^:%ORS%  �汾��^:%OMD%  ������^:%OZD%
set dqwz=  ����^��YCDISM2017�I�ڽ���...
set dqwc=  ����^��YCDISM2017�Ѿ����
set dqcd=  ���˵����^:
if exist %MOU%\Windows\system32\config ( Goto YM ) ELSE ( Goto NM)

:YM
if exist INDEXset.cmd Call INDEXset.cmd
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set MOS=%%a
set MOS=%MOS:~29%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set MEID=%%a
set MEID=%MEID:~27%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set MMD=%%a
set MMD=%MMD:~29%
if %MMD% GEQ 15051 set MRS=1703
if %MMD% LSS 15051 set MRS=1607
if %MMD% LSS 10587 set MRS=1511
if %MMD% LSS 10241 set MRS=1507
if %MMD% LSS 9601 set MRS=1309
if %MMD% LSS 9201 set MRS=1208
if %MMD% LEQ 7601 set MRS=1102
reg unload HKLM\0 >NUL
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Architecture"') do set Mbt=%%a
for /f "delims=" %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "ServicePack Build"') do set MZD=%%a
set MZD=%MZD:~20%
for /f "tokens=1 delims=	 " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Default"') do set MUI=%%a
echo %MEID% |find /i "Server">nul && Set SSYS=%OFFSYS%S
echo %MEID% |find /i "Server">nul || Set SSYS=%OFFSYS%
echo     ��ǰװ��^:%MOS% %Mbt% %MUI%  ���к�^:%MRS%  �汾��^:%MMD%  ������^:%MZD%
Goto MMMM

:NM
echo                                                                    %GMOS%
:MMMM
ECHO     ��*��*��*��*��*��*��*��*��*����************************�ש�*��*��*��*��*��*��*��*��*��
ECHO     ��***    ��  ��  ��  ��   ***  YCDISM ��ʽ�� 2017-03-31 ***    ��  ��  ��  ȫ    ***��
ECHO     ��***��*��*��*��*��*��*��*��*��************************��*��*��*��*��*��*��*��*��***��
ECHO     �� 1 �� 2 ���Ƴ����ֿ�ѡ���� �� 50 �������������ӳ��**�� ������ɫ������ݡ� 26�� 0 ��
ECHO     ��***�� 3 ��ж�ز�������APPS ��*******                 �� ͨ�ð�ȫ�ʶȾ���� 27��   ��
ECHO     ��   �� 4 ���������ý��ù��� ��    YCDISM���곿����DISM�� �����������޾���� 28�� ����
ECHO     ��װ �� 5 ��������� UI ���� ��                        �� WinSxS  ���޾���� 29��   ��
ECHO     ��   �� 6 �����ɲ������߹��� ������������������ϵ��ݩ� �����Ѹı��ӳ��� 30�� �֩�
ECHO     ���� �� 7 ��Win7����IE9 10 11��                        �� ��������װ��ӳ��� 31��   ��
ECHO     ��   �� 8 ���ֶ����ɰ�װ��Կ ���򼰺���ǿ���������չ���� ��ѡж��װ��ӳ��� 32�� �֩�
ECHO     ���� �� 9 ���Զ�����ϵͳ��Կ ��                        �� �ر�ϵͳ�����ڴ�� 33��   ��
ECHO     ��   ��10 ���Ƴ�ϵͳ��ԭӳ�� ���˵�ֱ�ۡ���������ͨ���ש� ȥ�ǹ����û����ơ� 34�� ״��
ECHO     ���� ��11 ���Ƴ�ɱ�� WD ���� ��                        �� ����Ա��׼��ģʽ�� 35��   ��
ECHO     ��   ��12 ���Ƴ�OneDrive���� ���á��������ܡ�ͨ�á�ʵ�é� ����ɱ���������ݡ� 36�� ����
ECHO     ���� ��13 ���Ƴ�����Edge���� ��                        �� ������� KMS����� 37��   ��
ECHO     ��   ��14 ���Ƴ� Cortan ���� ������ȫ�棬�򵥻�������ʵ�� �����Լ�����ϼ��� 38�� ȫ��
ECHO     ���� ��15 ���Ƴ� Speech ���� ��                        �� ���Office��ɫ��� 39��   ��
ECHO     ��   ��16 ����ȫ����Font���� ���־�����ǿ���Ż��̻����� �ر�ϵͳ�Զ����¡� 40�� �˩�
ECHO     ���� ��17 ������Assembly���� ��                        �� ��ȡͨ�ú������ݡ� 41��   ��
ECHO     ��   ��18 ���Ƴ�����ǿ��Ӧ�� �����ù̻��Ĵ���ϵͳ�������� ����װ���е�ӳ��� 42�� ����
ECHO     ��WIM��19 ��N����� WMPlayer ��                        �� ��ȡϵͳ���������� 43��   ��
ECHO     ��   ��20 �����ɻ����������� �����á���ȫ����ɫ���ȶ����� ж�ط����õ������� 44�� �̩�
ECHO     ��ӳ ��21 ����VC DirectX���� ��                        �� ����Ĭ����������� 45��   ��
ECHO     ��   ��22 ���滻������������ ���ɿ���֧��NT6��NT10ϵͳ �� ��ѡ�Ƴ����ֹ��ܡ� 46�� ��
ECHO     ���� ��23 �����û��ĵ��� D�� ��                        �� ��ѡж�ز��������� 47��   ��
ECHO     ��   ��24 ���������ֵ���Ż� ����ϵͳ������ô�򵥣������� ����װ��ӳ��汾�� 48��***��
ECHO     �� 1 ��25 ���滻��� OEM�ļ� ��     *******************�� ����ǹ����Ĳ����� 49�� 0 ��
ECHO     ��***��*��*��*��*��*��*��*��*��************************��*��*��*��*��*��*��*��*��***��
ECHO     �������д�������ռ����� �� �� YCDISM ʵսQQȺ 392016099  �� ��  ycgsotf.lofter.com ��
ECHO     ��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��*��
ECHO.
Set m=N
Set /p m=��������Ҫ�����Ĳ˵��������(0-50) ���س�ִ�в���:
cls
If "%m%"=="1"  Goto GZYX
If "%m%"=="2"  Goto MCAN
If "%m%"=="3"  Goto XZYY
If "%m%"=="4"  Goto NETF
If "%m%"=="5"  Goto ULAN
If "%m%"=="6"  Goto JCBD
If "%m%"=="7"  Goto JCIE
If "%m%"=="8"  Goto SDMY
If "%m%"=="9"  Goto JKEY
If "%m%"=="10" Goto KWNR
If "%m%"=="11" Goto KLWD
If "%m%"=="12" Goto KONE
If "%m%"=="13" Goto KBRO
If "%m%"=="14" Goto KCTA
If "%m%"=="15" Goto KSPH
If "%m%"=="16" Goto PEFT
If "%m%"=="17" Goto KABY
If "%m%"=="18" Goto KSAP
If "%m%"=="19" Goto NWMP
If "%m%"=="20" Goto WNQD
If "%m%"=="21" Goto ADVC
If "%m%"=="22" Goto MWEB
If "%m%"=="23" Goto USER
If "%m%"=="24" Goto WRZS
If "%m%"=="25" Goto MOEM 
If "%m%"=="26" Goto SOFT
If "%m%"=="27" Goto SDJJ
If "%m%"=="28" Goto ZDJJ
If "%m%"=="29" Goto LITE
If "%m%"=="30" Goto SAVE
If "%m%"=="31" Goto ZLBC
If "%m%"=="32" Goto UNMO
If "%m%"=="33" Goto NOPG
If "%m%"=="34" Goto KLNK
If "%m%"=="35" Goto ADMI
If "%m%"=="36" Goto WDUP
If "%m%"=="37" Goto YKMS
If "%m%"=="38" Goto ADTG
If "%m%"=="39" Goto OFFC
If "%m%"=="40" Goto OFUP
If "%m%"=="41" Goto GTZN
If "%m%"=="42" Goto ADZN
If "%m%"=="43" Goto GTQD
If "%m%"=="44" Goto YJYX
If "%m%"=="45" Goto ZTSZ
If "%m%"=="46" Goto YCYY
If "%m%"=="47" Goto YCQD
If "%m%"=="48" Goto SJBB
If "%m%"=="49" Goto CLEA
If "%m%"=="50" Goto SHCH
If "%m%"=="0"  Goto TUIC
echo.
echo    ����������� ����δ�ṩ�����������ص���� ����������������ṩ�Ĳ˵���ţ�����
echo.
ping -n 3 127.1>nul
cls
Goto MENU

:GZYX
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\System32\config\SOFTWARE (
echo.
echo   �Ѿ�װ��ӳ�� �벻Ҫ�ظ�װ�� ����Ѿ�װ�ص�ӳ��������ִ�зϳ�����
echo.
ping -n 3 127.1>nul
cls
Goto MENU
)
title  %dqwz% װ��%YCP%YCSINS.WIMӳ�� %dqcd%1
echo.
echo   %dqwz% װ��%YCP%YCSINS.WIMӳ�� %dqcd%1
echo.
%YCDM% /Get-Wiminfo /WimFile:%YCP%YCSINS.WIM
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
set INDEX=1
set /p INDEX=������%YCP%YCSINS.WIM��Ҫ������������Ź�%ZS%����ӳ�� ֱ�ӻس�Ĭ��Ϊ1:
%YCDM% /Mount-Image /ImageFile:%YCP%YCSINS.WIM /Index:%INDEX% /MountDir:%MOU% 2>nul
if %errorlevel% EQU 11 (
cls
echo.
echo      ��ܰ���ѣ�
echo.
echo          ��ǰ����װ�ص�ӳ������ʵ��ʽΪESD��ʽ    ��ת����WIM��ʽ����  
echo.
echo          ����޼��ܻ���� ���򽫳���ת���ɱ�׼��WIMӳ���Լ���ִ�в���
echo.
echo          ��ʼת�� �����жϻ�Ӱ��ת�����̣�������ҪһЩʱ�� ���Ժ򣡣���
echo.
ren %YCP%YCSINS.WIM YCSINS.ESD
if exist %YCP%YCSINS.ESD %YCDM% /export-image /sourceimagefile:%YCP%YCSINS.ESD /sourceindex:%INDEX% /destinationimagefile:%YCP%YCSINS.WIM /Compress:maximum /Checkintegrity
if %errorlevel% EQU 0 if exist %YCP%YCSINS.WIM del /q /f %YCP%YCSINS.ESD
ping -n 1 127.1>nul
cls
rd /q /s %YCP%YCMOU
Goto GZYX
)
if %errorlevel% NEQ 0 (
echo.
echo    %YCP%YCSINS.WIM �в���������������� %INDEX% ��������ڵĵ�������� 
echo.
ping -n 6 127.1>nul
cls
Goto MENU
)
echo @echo off>%YCP%����װ���е�ӳ��.cmd
echo color 1f>>%YCP%����װ���е�ӳ��.cmd
echo %YCDM% /Unmount-Image /MountDir:%YCP%YCMOU /DISCARD>>%YCP%����װ���е�ӳ��.cmd
echo @echo off>%YCP%�쳣�жϺ�����������װ��ӳ��.cmd
echo color 1f>>%YCP%�쳣�жϺ�����������װ��ӳ��.cmd
echo %YCDM% /Remount-wim /MountDIR:%YCP%YCMOU>>%YCP%�쳣�жϺ�����������װ��ӳ��.cmd
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
if not exist %MOU%\Windows\System32\config %YCDM% /Mount-Image /ImageFile:%YCP%YCSINS.WIM /Index:%INDEX% /MountDir:%MOU%
echo set INDEX=!INDEX!>INDEXset.cmd
for /f "delims=" %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "ServicePack Build"') do set MZD=%%a
set MZD=%MZD:~20%
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set MOS=%%a
set MOS=%MOS:~29%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set MEID=%%a
set MEID=%MEID:~27%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set MMD=%%a
set MMD=%MMD:~29%
if %MMD% GEQ 15051 set MRS=1703
if %MMD% LSS 15051 set MRS=1607
if %MMD% LSS 10587 set MRS=1511
if %MMD% LSS 10241 set MRS=1507
if %MMD% LSS 9601 set MRS=1309
if %MMD% LSS 9201 set MRS=1208
if %MMD% LEQ 7601 set MRS=1102
reg unload HKLM\0 >NUL
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Architecture"') do set Mbt=%%a
for /f "tokens=1 delims=	 " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /Index:%INDEX% ^| find /i "Default"') do set MUI=%%a
echo %MEID% |find /i "Server">nul && Set SSYS=%OFFSYS%S
echo %MEID% |find /i "Server">nul || Set SSYS=%OFFSYS%
title  %dqwc% װ��%YCP%YCSINS.WIMӳ��%INDEX% %dqcd%1
echo.
echo               %MOS% ӳ��װ����ɳ���3����Զ�������һ������
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:MCAN
title  %dqwz% ���ֿ���ж������ %dqcd%2
echo.
echo   %dqwz% ���ֿ���ж������ %dqcd%2
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %FSYS% NEQ Win10 (
echo.
echo          ������ֻ�޶��� Windows 10 ϵͳ��ʹ�� ���򷵻����˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU
)
echo.
echo   ������� ����ֻ�ṩ���Ƽ�ж�ػ��Ƴ����¹��ܻ����� �������й� ���� ���� ͨ�á�
echo   ============================================================================
%YCDM% /Image:%MOU% /English /Get-packages>%YCP%packages.txt
::for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-InsiderHub-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-RetailDemo-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Prerelease-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Speech-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-TextToSpeech-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-OCR-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
:: ����ƽ����Ƴ���д���� Ĭ�ϱ��� �����Ƴ���ȥ��������˫ð��
::for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Handwriting-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Fonts-Hans-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-DeveloperMode-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-ContactSupport-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-QuickAssist-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
echo.
echo   ����Ƕ�����ϵͳ����ɾ�� %MUI% �������԰����� ��ʼ��ѯ������...���Ժ�
echo.
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "LanguageFeatures-Basic-" &&echo %%a>>%YCP%Languagelist.txt)
for /f %%i in (%YCP%Languagelist.txt) do echo %%i |findstr /i "%MUI%" || %YCDM% /image:%MOU% /Remove-Package /PackageName:%%i
del /f /q %YCP%packages.txt
del /f /q %YCP%Languagelist.txt
title  %dqwc% ж�ز��ֿ���ж������ %dqcd%2
echo.
echo   ֻҪϵͳ�������   ��Щж�صĹ��ܶ����ڰ�װ��ɺ���Ҫ��ʱ���   �����ʹ��
echo   ============================================================================
echo.
echo   ���ó��������ж�����Թ� �����Ҫж������ ��ʹ�����˵� 46 ���в���  ���򷵻�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:XZYY
if not exist "%MOU%\Program Files\WindowsApps"  GOTO MENU
title  %dqwz% ж���Դ�Ӧ�� %dqcd%3
echo.
echo   %dqwz% ж���Դ�Ӧ�� %dqcd%3
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
dir /b /a "%MOU%\Program Files\WindowsApps">%YCP%tmp.txt
::%YCDM% /image:%MOU% /English /Get-ProvisionedAppxPackages>%YCP%tmp.txt
findstr "_~_" %YCP%tmp.txt>%YCP%Applist.txt
del /q /f %YCP%tmp.txt
echo @echo off>%YCP%unapp.cmd
echo Color 1f>>%YCP%unapp.cmd
:XZFA
echo.
echo           ������ڿ�ж���Դ�Ӧ��  �곿DISM����Ĭ���Ƽ������Դ�Ӧ�þ���ж�ط���
echo  ======================================================================================
echo                     ж�ع����������ϵͳ�Ҳ���ָ�����ļ���ʾ�Ѿ�ж��
echo    ����������������������������������������������������������������������������������
echo    ��              Ŀ ǰ �� �� �� ж �� �� ֪ �� �� Ӧ �� �� �� �� ��              ��
echo    �ǩ������������������ש������������������ש������������������ש�������������������
echo    ��  A Ĭ �� ж ��   ��  B �� �� �� ��   ��  C �� �� �� ��   ��  D �� �� �� ��   ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��HelpAndTips       ��Reader            ��WindowsScan       ��XboxApp           ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��Getstarted        ��ZuneVideo         ��3DBuilder         ��BingFinance       ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��MicrosoftOfficeHub��ZuneMusic         ��DesktopAppInstalle��BingSports        ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��People            ��Photos            ��OneConnect        ��BingWeather       ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��FeedbackHub       ��SkypeApp          ��OneNote           ��BingNews          ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��Office Sway       ��Camera            ��SolitaireCollectio��communicationsapps��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��                  ��WindowsCalculator ��StickyNotes       ��WindowsMaps       ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��  E Ĭ �� �� ��   ��Microsoft3DViewer ��Wallet            ��XboxGameOverlay   ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��WindowsStore      ��WindowsPhone      ��Messaging         ��StorePurchaseApp  ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��WindowsAlarms     ��SoundRecorder     ��Appconnector      ��XboxLIVEGames     ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��                  ��MSPaint           ��CommsPhone        ��ConnectivityStore ��
echo    �ǩ������������������ߩ������������������響�����������������ߩ�������������������
echo    ��              F ȫ �� ж ��           ��           G �� �� �� ж ��           ��
echo    �����������������������������������������ߩ���������������������������������������
echo          ��ܰ���ѣ� �������������ڶ��η�װ���ѱ��ƻ����ѱ�ǿɾ���Ķ��ι���ӳ��
echo  ======================================================================================      
set XZFA=
set /p XZFA=��ѡ��������Ҫִ�еķ�����ĸ���ִ�Сд ABCDEFG ��0�س������κβ������������˵�
if "%XZFA%"=="0" goto XZFAO
if /i "%XZFA%"=="A" goto XZFAE
if /i "%XZFA%"=="B" goto XZFAE
if /i "%XZFA%"=="C" goto XZFAE
if /i "%XZFA%"=="D" goto XZFAE
if /i "%XZFA%"=="E" goto XZFAE
if /i "%XZFA%"=="F" goto XZFAE
if /i "%XZFA%"=="G" goto XZFAG
echo.
echo   ��������  ����������
echo.
ping -n 3 127.1>nul
cls
goto XZFA

:XZFAE
echo.
echo  %XZFA%�����Դ�Ӧ��ж�ز���...
echo.
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Getstarted_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".MicrosoftOfficeHub_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Office.Sway_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".People_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsFeedbackHub_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".HelpAndTips_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingHealthAndFitness_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingFoodAndDrink_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingFinance_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".BingTravel_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
if /i %XZFA% EQU A (
echo.
echo   %XZFA% �����Դ�Ӧ��ж�ز������
echo.
ping -n 3 127.1>nul
cls
goto XZFAO
)
if /i %XZFA% NEQ B (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "ZuneVideo" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Microsoft3DViewer_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "ZuneMusic" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Photos" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".SkypeApp_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Camera" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsCalculator_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "WindowsPhone" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "SoundRecorder" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Microsoft.WindowsScan_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsReadingList_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsScan_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Reader_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".MSPaint_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
)
if /i %XZFA% NEQ C (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".Wallet_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "3DBuilder" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "DesktopApp" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "OneConnect" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Solitaire" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Note" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Messaging" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Appconnector" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".CommsPhone" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
)
if /i %XZFA% NEQ D (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".ConnectivityStore" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".XboxGameOverlay_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "communicationsapps_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "WindowsMaps" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "StorePurchaseApp" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "XboxApp" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".XboxLIVEGames_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "Bing" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "XboxIdentity" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".XboxSpeechToTextOverlay_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
)
if /i %XZFA% EQU F (
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i "WindowsStore" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
for /f "delims= " %%a in (%YCP%Applist.txt) do (echo "%%a"|find /i ".WindowsAlarms_" &&%YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:%%a)
)
title  %dqwc% %XZFA% ����ж���Դ�Ӧ�� %dqcd%3
echo.
echo  %XZFA% �����Դ�Ӧ��ж�ز������           ����3��󷵻����˵�
echo.
ping -n 3 127.1>nul
goto XZFAO

:XZFAG
echo.
echo  ��ʼִ�� %XZFA% �����Դ�Ӧ��ж�ز���...
echo.
echo   �뽫�򿪵�Applist.TXTÿ��ǰ�� Microsoft.�� CTRL+H ���滻Ϊ��Ϊ%%un%%����
echo.
echo   ����뱣��һЩӦ�� �뽫�����ڵ�һ���дӼ��±���ɾ�������沢�رռ��±�����
echo.
start %YCP%Applist.txt
set hhcd=1
set /p hhcd= ȷ�ϰ�Ҫ��׼������ֱ�ӻس�ִ��ж��  ��0�س������κβ������������˵�:
if "%hhcd%"=="0" goto XZFAO
set un= %YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:Microsoft.
Type %YCP%applist.txt>>%YCP%unapp.cmd
ping -n 1 127.1>nul
call %YCP%unapp.cmd
title  %dqwc% %XZFA% ����ж���Դ�Ӧ�� %dqcd%3
echo.
echo        �Զ����Դ�Ӧ��ж�ز������           ����3��󷵻����˵�
echo.
ping -n 3 127.1>nul
:XZFAO
del /q /f %YCP%applist.txt
del /q /f %YCP%unapp.cmd
cls
goto MENU

:NETF
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% ���û���ù��� %dqcd%4
echo.
echo   %dqwz% ���û���ù��� %dqcd%4
echo.
echo                         �곿DISM Ĭ�ϵ�ͨ�ý��á����ù�����ϸ�б�
echo  ======================================================================================
echo   ͨ��ΪԭʼϵͳĬ��״̬�෴��״̬ �����ǰ�װ����Ҫ���û�����һϵ�й��� �±�����ο�
echo    �����������������������������������������ש���������������������������������������
echo    ��            Ĭ�Ͻ��ù����б�          ��            Ĭ�����ù����б�          ��
echo    �ǩ������������������ש������������������響�����������������ש�������������������
echo    �� 1  ������Ϸ����  ��Windows7(SP1) Only�� 1  Net3.5 ����   ��     NetFx3.5     ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 2  ��ͳ�������  �� LegacyComponents �� 2  Net4.5+ ASP+  ��   ASPNetFx4.5+   ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 3  ý�岥�Ź���  ��    MediaPlayer   �� 3  ��ӡɨ�蹦��  ��ScanManagementCon.��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 4  ý�屸�ݹ���  ��    MediaBckup    �� 4  �ɰ��������  ��    DirectPlay    ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 5  Power  Shell  ��    PowerShell    �� 5  Ŀ¼������  �� DirectoryServices��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 6  �Դ�ɱ������  �� Windows Defender �� 6  ��ӡɨ�蹦��  ��ScanManagementCon.��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 7  PDF ��ӡ����  ��PrintToPDFServices�� 7  SmbDirectֱͨ ��     SmbDirect    ��
echo    ���������������������ߩ������������������ߩ������������������ߩ�������������������
echo   �����Զ������ ��ֱ�Ӹ��ƴ򿪵Ĺ����б� ���� Ӣ�Ĺ������� ճ�� �������򴰿� �س�����
echo  ======================================================================================
echo         Ҫ�Զ�����ð�1  �Զ������ð�2 ����������ư����пո�����ǰ�����˫����        
echo.
:CXGN
set zd=3
set /p zd=��ѡ����β��� ֱ�ӻس�����Ĭ�Ϸ����������úͽ��� ��0 �س� �������˵�:
If "%zd%"=="0" Goto MENU
If "%zd%"=="1" Goto JYGN
If "%zd%"=="2" Goto QYGN
If "%zd%"=="3" Goto TYFA
echo.
echo   ��������  ����������
echo.
ping -n 2 127.1>nul
cls
set zd=
goto CXGN

:TYFA
title  ���ڰ�ͨ��Ĭ�Ϸ������н��ú�����...���Ժ�
echo.
echo   ���ڰ�ͨ��Ĭ�Ϸ������н��ú�����...���Ժ�
echo.
%YCDM% /Image:%MOU% /english /Get-Features>%YCP%Features.txt
if %OFFSYS% LEQ 7601 (
echo.
echo   ΪWin7ϵͳ����������Ϸ
echo.
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "More Games" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "InboxGames" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Hearts" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "FreeCell" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Minesweeper" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "PurblePlace" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "SpiderSolitaire" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Chess" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Games" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Checkers" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Backgammon" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
for /f "tokens=4,5 delims= " %%a in (%YCP%Features.txt) do (echo "%%a %%b"|find /i "Internet Spades" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%%a %%b")
)
title  ��������Ĭ�ϵĹ��ܽ���...
echo.
echo   ���¹���Ĭ�Ͻ���
echo.
if %OFFSYS% GEQ 9868 for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "SearchEngine" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "WindowsPowerShell" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
if exist "%MOU%\Program Files\WindowsPowerShell" (
echo.
echo   Ĭ�Ͻ��ò��Ƴ� WindowsPowerShell ����������
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\WindowsPowerShell" /r /d y && icacls "%MOU%\Program Files\WindowsPowerShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\WindowsPowerShell"
cmd.exe /c takeown /f "%MOU%\Windows\System32\WindowsPowerShell" /r /d y && icacls "%MOU%\Windows\System32\WindowsPowerShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\WindowsPowerShell"
)
if exist "%MOU%\Program Files (x86)\WindowsPowerShell" (
cmd.exe /c takeown /f "%MOU%\Program Files (x86)\WindowsPowerShell" /r /d y && icacls "%MOU%\Program Files (x86)\WindowsPowerShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files (x86)\WindowsPowerShell"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\WindowsPowerShell" /r /d y && icacls "%MOU%\Windows\SysWOW64\WindowsPowerShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\WindowsPowerShell"
)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Windows-Defender" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Printing-PrintToPDFServices-" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "MediaPlay" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
title  ��������Ĭ�ϵĹ�������...
echo.
echo   ���¹���Ĭ������
echo.
if %OFFSYS% GTR 7601 if exist %SOUR%sxs (
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "NetFx3" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /source:%SOUR%sxs /All /LimitAccess)
) ELSE (
echo.
echo   û����sxs���� ���������NET3.5���ܻ�����Win7����ϵͳĬ���������˸ù���
echo.
ping -n 3 127.1>nul
)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "NetFx4" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /source:%SOUR%sxs /LimitAccess)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "DirectoryServices" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "DirectPlay" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "ScanManagementConsole" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "SmbDirect" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Telnet" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
title  �����в����������ù�������...
echo.
echo                     �����������ù��� �����ǰװ��ӳ���д���
echo.
echo                                            �豸�����鼰����ɸѡ�ȹ�7���Ƿ����ã�
echo.
echo    ���������������������ש������������������ש������������������ש�������������������
echo    ��  KeyboardFilter  �� DeviceLockdown   �� EmbeddedBootExp  ��    Containers    ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��UnifiedWriteFilter��Emb..ShellLauncher�� EmbeddedLogon    �� ���� IE�������ѡ��
echo    ���������������������ߩ������������������ߩ������������������ߩ�������������������
echo.
echo                  ��  �밴 Y �س�                           ��  ��ֱ�ӻس�
echo.
set ENF=N
set /p ENF=��ȷ���б���������7����Ƿ����ã�
if /i %ENF% EQU Y (
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Containers" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "EmbeddedShellLauncher" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "EmbeddedLogon" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "DeviceLockdown" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "EmbeddedBootExp" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "KeyboardFilter" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "UnifiedWriteFilter" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
)
echo.
echo   ������� Ϊֻʹ�������������Edge������û����� Internet Explorer
echo.
set jyie=N
set /p jyie=������ֱ�ӻس�     ���ð� Y �س���
echo.
if %jyie% equ Y for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Internet-Explorer-" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
title  %dqwc% ͨ�����úͽ��ù��� %dqcd%4
echo.
echo   ͨ�����úͽ��ù������ 3��󷵻����˵�������ѡ����һ������
echo.
ping -n 5 127.1 >nul
cls
del /q %YCP%Features.txt
goto MENU

:JYGN
echo.
echo                        ��ʼ��ѯװ��ӳ���еĹ���... 
echo.
%YCDM% /Image:%MOU% /Get-Features>%YCP%Features.txt
ping -n 1 127.1>nul
start %YCP%Features.txt
:JYJY
echo.
echo   �븴��Features�ı�������״̬�Ĺ�������ð�ź��Ӣ��ճ���������򴰿ڰ�Enter��
echo.
echo   ���������Ϥ��ع��ܽ��ú��Ӱ���벻Ҫ�������     ���������ȥ����Ҫ���鷳
echo.
set /p jy=�뽫Ҫ���ù��ܵ�Ӣ������ճ�������򴰿��лس���ʼִ�� ��0�س� �������˵�:
if "%jy%"=="0" del %YCP%Features.txt &&goto MENU
%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%jy%" ||%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%jy%" /all
echo.
echo                            ִ����� ��������...
echo.
ping -n 1 127.1 >nul
cls
goto JYJY

:QYGN
echo.
echo             ��ʼ��ѯװ��ӳ���еĹ���... ��ɺ��Զ��򿪹����б�
echo.
%YCDM% /Image:%MOU% /Get-Features>%YCP%Features.txt
ping -n 1 127.1>nul
start %YCP%Features.txt
:QYQY
echo.
echo   �븴��Features�ı��н���״̬�Ĺ�������ð�ź��Ӣ��ճ���������򴰿ڰ�Enter��
echo.
set /p qy=�뽫Ҫ���ù��ܵ�Ӣ������ճ�������򴰿��� �س���ʼִ�� ��0�س� �������˵�:
if "%qy%"=="0" del %YCP%Features.txt &&goto MENU
if /i "%qy%"=="NetFx3" (set gn=%qy% /all /source:%SOUR%sxs /LimitAccess) else (set gn=%qy% /all /LimitAccess)
%YCDM% /image:%MOU% /Enable-feature /Featurename:%gn% 2>nul
echo.
echo  ִ����� ��������...
echo.
ping -n 1 127.1 >nul
cls
goto QYQY

:ULAN
title  %dqwz% �������԰� ����ϵͳ����ִ�� %dqcd%5
echo.
echo   %dqwz% �������԰� ����ϵͳ����ִ�� %dqcd%5
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo    Ϊ�����е�ӳ�񼯳����԰���ɽ�ӳ�������������Ĭ�ϳ���Ӧ���Խ���
echo.
echo    �뽫����Ϊ%SSYS%%Mbt%LP.cab�ŵ�%YCP%PCABĿ¼ ���û�н���Ϊ��������
echo.
echo    ֱ�ӻس�������Ĭ��Ϊ���ó�����  ���������������ֱ��������������
echo.
set ul=ZH-CN
set /p ul=�������뽫ӳ���д��ڲ������ó�Ĭ�ϵ��������Ʊ������������� ZH-CN �س�����:
if not exist %YCP%PCAB\%SSYS%%Mbt%LP.cab goto ULST
echo.
echo    ����ָ��Ŀ¼��������������ó���ʼ�������...
echo.
%YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%SSYS%%Mbt%LP.cab
if !errorlevel!==0 (
echo.
echo    %SSYS%%Mbt%LP.cab ��ӳɹ�  �������
echo.
ping -n 2 127.1>nul
cls
goto ULST
) ELSE (
echo.
echo   ָ��λ�����԰������û��� �����������Ĭ����������
echo.
ping -n 5 127.1>nul
cls
goto ULST
)

:ULST
echo.
echo   ��ȡװ��ӳ�����������Բ�����Ϊ:%ul% ��ʼ��ȡ�������������Ժ�...
echo.
%YCDM% /image:%MOU% /Get-Intl
if !errorlevel!==0 %YCDM% /image:%MOU% /Set-UILang:%ul%
%YCDM% /image:%MOU% /Set-Syslocale:%ul%
%YCDM% /image:%MOU% /Set-Userlocale:%ul%
%YCDM% /image:%MOU% /Set-SKUIntlDefaults:%ul%
if /i "%ul%"=="ZH-CN" %YCDM% /image:%MOU% /Set-Inputlocale:0804:00000804
if /i "%ul%"=="ZH-CN" %YCDM% /image:%MOU% /Set-TimeZone:"China Standard Time"
%YCDM% /image:%MOU% /Set-allIntl:%ul%
for /f "tokens=3 delims=: " %%b in ('%YCDM% /english /image:%MOU% /Get-Intl ^| find /i "System locale"') do set MUI=%%b
title  %dqwc% �������԰�
echo.
echo   Ŀǰֻ�ṩ�����������Ĳ��� �����������޸���Ӧ���� ���򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
GOTO MENU

:JCBD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% ����MSU���»�CAB���� %dqcd%6
echo.
echo   %dqwz% ����MSU���»�CAB���� %dqcd%6
echo.
echo   �����в������ݴ��ڸ���  �뼰ʱ��MS������ȡ��Ӧ���±�֤��Ʒ���²�ͬ��
echo.
echo   ��ȷ��%YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU�в���������ȷ����س�ִ�в���
echo.
if %OFFSYS% equ 7600 (
echo   ��ǰ����ϵͳΪWin7 �뽫%YCP%MSU�е�%SSYS%Ŀ¼����Ϊ7600 ����SP1����
echo.
)
set qr=
set /p qr= ȷ�ϼ��ɲ���ֱ�ӻس� �������������밴N�س� ��MS�����밴G�س�
if /i "%qr%"=="N" goto MENU
if /i "%qr%"=="G" Start http://catalog.update.microsoft.com/v7/site/home.aspx &&goto MENU
echo.
echo   ��ʼ���Լ���%YCP%MSU\%FSYS%\%SSYS%�Ĳ���...
if exist %YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU %YCDM% /image:%MOU% /add-package /packagepath:%YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU
title  %dqwc% ����MSU���»�CAB���� %dqcd%6
echo.
echo   �������%YCP%MSU\%SSYS%��%FSYS%��MSU��CAB����ɼ��� ����6����Զ��������˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:JCIE
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %OFFSYS% GTR 7601 GOTO IEER
title  %dqwz% Win7(sp1)ר�� �Զ��弯��IE %dqcd%7
echo.
echo   %dqwz% Win7(sp1)ר�� �Զ��弯��IE %dqcd%7
echo.
echo   ��ѡ��Ҫ���ɵ�IE�汾 ע��˲�����Ҫ�곿�ṩ��׼���׻���ͬ�淶����֧��
echo.
echo         1  ���� IE9         2  ���� IE10          3  ���� IE11
echo.
set /p i=��������Ҫ���ɵ�IE�汾�˵�������� ֱ�ӻس���������󽫲����κβ����������˵�:
if "%i%"=="1" goto NINE
if "%i%"=="2" goto TENT
if "%i%"=="3" goto OTEN
echo.
echo  �������� ���򷵻����˵�
echo.
ping -n 3 127.1>nul
cls
goto MENU

:NINE
title  %dqwz% ӳ�񼯳�IE9...���Ժ�
echo.
echo   ��ʼΪӳ�񼯳�IE9...���Ժ�
echo.
echo   ��1�׶�       ��Ӽ��� IE9 ���벹��
if exist %YCP%IE\IEJB\%Mbt%\* %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IEJB\%Mbt%
echo.
echo   ��2�׶�       ���ɸ��� IE9 ��������
if exist %YCP%IE\IE9%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE9%Mbt%
echo.
echo   ��3�׶�       ��Ӽ��� IE9 �޸�����
if exist %YCP%IE\IE9%Mbt%H\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE9%Mbt%H
title  %dqwc% ӳ�񼯳�IE9...�����
echo.
echo   ����������� IE9 �Ѿ��ɹ����ɵ�ӳ�� ���򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:TENT
title  %dqwz% ӳ�񼯳�IE10...���Ժ�
echo.
echo   ��ʼΪӳ�񼯳�IE10...���Ժ�
echo.
echo   ��1�׶�       ��Ӽ��� IE10 ���벹��
if exist %YCP%IE\IEJB\%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IEJB\%Mbt%
echo.
echo   ��2�׶�       ���ɸ��� IE10 ��������
if exist %YCP%IE\IE10%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE10%Mbt%
echo.
echo   ��3�׶�       ��Ӽ��� IE10 �޸�����
if exist %YCP%IE\IE10%Mbt%H\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE10%Mbt%H
title  %dqwc% ӳ�񼯳�IE10...�����
echo.
echo   ����������� IE10�Ѿ��ɹ����ɵ�ӳ�� ���򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:OTEN
title  %dqwz% ӳ�񼯳�IE11...���Ժ�
echo.
echo   ��ʼΪӳ�񼯳�IE11...���Ժ�
echo.
echo   ��1�׶�       ��Ӽ��� IE11 ���벹��
if exist %YCP%IE\IEJB\%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IEJB\%Mbt%
echo.
echo   ��2�׶�       ���ɸ��� IE11 ��������
if exist %YCP%IE\IE11%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE11%Mbt%
echo.
echo   ��3�׶�       ��Ӽ��� IE11 �޸�����
if exist %YCP%IE\IE11%Mbt%H\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE11%Mbt%H
title  %dqwc% ӳ�񼯳�IE11...�����
echo.
echo   ����������� IE11�Ѿ��ɹ����ɵ�ӳ�� ���򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:JKEY
title  %dqwz% ���� %MOS% ��װ��Կ %dqcd%9
echo.
echo   %dqwz% ���� %MOS% ��װ��Կ %dqcd%9
echo.
echo        ����ֻ�ṩ���ֳ���Win81��Win10�ṩ��װ��Կ ��װʱ����������KEY
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo       ��⵽����ϵͳΪ %MOS% ����Ϊ���а汾�Զ����ɰ�װ��Կ

if %OFFSYS% LSS 9600 (
echo.
echo        Windows 8.1 ����ϵͳ���輯�ɰ�װ��Կ ���򷵻����˵�����ִ����������
echo.
ping -n 3 127.1 >nul
GOTO MENU
)
ping -n 3 127.1 >nul
GOTO %FSYS%

:Win10
echo.
echo    ===================================================================================
echo.
echo        01 Core                    (��ͥ��)    02 Professional              (רҵ��)
echo.
echo        03 Enterprise              (��ҵ��)    04 Edition                   (������)
echo.
echo        05 CoreCountrySpecific (��ͥ���İ�)    06 EnterpriseS           (��ҵ��LTSB) 
echo.
echo        07 EnterpriseSN       (��ҵ��LTSBN)    08 EducationN               (������N)
echo.
echo        09 EnterpriseSEval     (��ҵ������)    10 EnterpriseG           (��ҵ�� G��)
echo.
echo        11 ServerStandardCore  (��׼���İ�)    12 ServerStandard        (��׼��ͨ��)
echo.
echo        13 ServerDatacenterCore  (���ݺ���)    14 ServerDatacenter        (��������) 
echo. 
echo        15 ProfessionalStudent (ѧ��רҵ��)    16 ProfessionalStudentN (ѧ��רҵ��N)
echo.
echo     ====================================================================================
echo.
if exist %MOU%\Windows\servicing\Editions\ProfessionalStudentNEdition.xml (
echo.
echo    ��ʼ��װ ProfessionalStudentN ѧ��רҵ��N��Կ
%YCDM% /Image:%MOU% /Set-ProductKey:QJFNY-8Q8BQ-6WQH8-9J3K6-CGXVJ
echo.
echo             ѧ��רҵ��N��Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ProfessionalStudentEdition.xml (
echo.
echo    ��ʼ��װ ProfessionalStudent ѧ��רҵ����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:V3NH2-P462J-VT4G4-XD8DD-B973P
echo.
echo             ѧ��רҵ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerDatacenterEdition.xml (
echo.
echo    ��ʼ��װ ServerDatacenter �������İ���Կ
%YCDM% /Image:%MOU% /Set-ProductKey:CB7KF-BWN84-R7R2Y-793K2-8XDDG
echo.
echo             �������İ���Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerDatacenterCoreEdition.xml (
echo.
echo    ��ʼ��װ ServerDatacenterCore ���ݺ��İ���Կ
%YCDM% /Image:%MOU% /Set-ProductKey:CB7KF-BWN84-R7R2Y-793K2-8XDDG
echo.
echo             ���ݺ��İ���Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerStandardEdition.xml (
echo.
echo    ��ʼ��װ ServerStandard ��׼��ͨ����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
echo.
echo             ��׼��ͨ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerStandardCoreEdition.xml (
echo.
echo    ��ʼ��װ ServerStandardCore ��׼���İ���Կ
%YCDM% /Image:%MOU% /Set-ProductKey:WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
echo.
echo             ��׼���İ���Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\EnterpriseGEdition.xml (
echo.
echo    ��ʼ��װ EnterpriseG ��ҵ�� G �� GVL ��Կ
%YCDM% /Image:%MOU% /Set-ProductKey:YYVX9-NTFWV-6MDM3-9PT4T-4M68B
echo.
echo           ��ҵ��G��Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\EnterpriseSEvalEdition.xml (
echo.
echo    ��ʼ��װ EnterpriseSEval ��ҵ��������Կ
%YCDM% /Image:%MOU% /Set-ProductKey:D3M8K-4YN49-89KYG-4F3DR-TVJW3
echo.
echo           ��ҵ��������Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\CoreCountrySpecificEdition.xml (
echo.
echo    ��ʼ��װ Home China �й�����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:N2434-X9D7W-8PF6X-8DV9T-8TYMD
echo.
echo                                �й�����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\CoreEdition.xml (
echo.
echo    ��ʼ��װ Home ��ͥ����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:YTMG3-N6DKC-DKB77-7M9GH-8HVX7
echo.
echo                                ��ͥ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalEdition.xml (
echo.
echo    ��ʼ��װ Professional רҵ����Կ 
%YCDM% /Image:%MOU% /Set-ProductKey:VK7JG-NPHTM-C97JM-9MPGT-3V66T
echo.
echo                                רҵ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalEducationEdition.xml (
echo.
echo    ��ʼ��װ Professional רҵ��������Կ 
%YCDM% /Image:%MOU% /Set-ProductKey:48FWV-TNW4T-CQ6F4-KVGQB-K3D3X
echo.
echo                                רҵ��������Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseEdition.xml (
echo.
echo    ��װ��ҵ����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:XGVPP-NMH47-7TTHJ-W3FW7-8HV2C
echo.
echo                                ��ҵ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseSEdition.xml (
echo.
echo    ��װ��ҵ��LTSB GVL��Կ
%YCDM% /Image:%MOU% /Set-ProductKey:DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
echo.
echo                             ��ҵ��LTSB GVL��Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseSNEdition.xml (
echo.
echo    ��װ��ҵ��LTSBN��Կ
%YCDM% /Image:%MOU% /Set-ProductKey:RW7WN-FMT44-KRGBK-G44WK-QV7YK
echo.
echo                                ��ҵ��LTSBN��Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EducationEdition.xml (
echo.
echo    ��װ��������Կ
%YCDM% /Image:%MOU% /Set-ProductKey:YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
echo.
echo                                ��������Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\EducationNEdition.xml (
echo.
echo    ��װ������N��Կ
%YCDM% /Image:%MOU% /Set-ProductKey:84NGF-MHBT6-FXBX8-QWJK7-DRR8H
echo.
echo                                ������N��Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %ISO%\sources\product.ini start %ISO%\sources\product.ini
echo.
echo             ����ǰû��Ϊװ����ϵͳ�ṩ��װ��Կ �Զ�ת���ֶ���Ӱ�װ��Կ
echo.
echo             ������� �����Ѿ�Ϊ����%ISO%\sources\product.ini�����ֶ�����
echo.
ping -n 5 127.1 >nul
cls
goto SDMY

:Win81
echo.
echo             =============================================================
echo.
echo             1 Core         (���İ�)     2 ProfessionalWMC (רҵ��ý������)
echo.
echo             3 Professional (רҵ��)     4 Professional VL   (��ͻ�רҵ��)
echo.
echo             5 Enterprise   (��ҵ��)     6 Corecountryspecific     (�й���)
echo.
echo             7 Embedded Pro (��ҵ��)     8 CoreSingleLanguage    (�����԰�)
echo.
echo             ==============================================================
echo.
if exist %MOU%\Windows\servicing\Editions\CoreEdition.xml (
echo.
echo    ��ʼ��װ Core ���İ���Կ
%YCDM% /Image:%MOU% /Set-ProductKey:Y9NXP-XT8MV-PT9TG-97CT3-9D6TC
echo.
echo                                ���İ���Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalWMCEdition.xml (
echo.
echo    ��ʼ��װ ProfessionalWMC����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:GBFNG-2X3TC-8R27F-RMKYB-JK7QT
echo.
echo                        רҵ��ý�����İ���Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalEdition.xml (
echo.
echo    ��ʼ��װ Professional רҵ����Կ 
%YCDM% /Image:%MOU% /Set-ProductKey:GBFNG-2X3TC-8R27F-RMKYB-JK7QT
echo.
echo                                רҵ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\gvlkProfessionalEdition.xml (
echo.
echo    ��ʼ��װ Professional ��ͻ�רҵ����Կ 
%YCDM% /Image:%MOU% /Set-ProductKey:GCRJD-8NW9H-F2CDX-CCM8D-9D6T9
echo.
echo                          ��ͻ�רҵ����Կ ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseEdition.xml (
echo.
echo    ��װ��ҵ����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:FHQNR-XYXYC-8PMHT-TV4PH-DRQ3H
echo.
echo                                ��ҵ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\CoreCountrySpecificEdition.xml (
echo.
echo    ��װ�й�����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:TNH8J-KG84C-TRMG4-FFD7J-VH4WX
echo.
echo                                �й�����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EmbeddedIndustryEdition.xml (
echo.
echo    ��װ��ҵ����Կ
%YCDM% /Image:%MOU% /Set-ProductKey:NDXXJ-YX29Q-JDY6B-C93G8-TQ6WH
echo.
echo                                ��ҵ����Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\CoreSingleLanguageEdition.xml (
echo.
echo    ��װ�����԰���Կ
%YCDM% /Image:%MOU% /Set-ProductKey:NDXXJ-YX29Q-JDY6B-C93G8-TQ6WH
echo.
echo                                �����԰���Կ��װ���
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
echo.
echo      ����ǰû��Ϊ�����е�ϵͳ�ṩ��װ��Կ �Զ�ת���ֶ���Ӱ�װ��Կ
echo. 
ping -n 3 127.1 >nul
cls

:SDMY
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set MOS=%%a
set MOS=%MOS:~29%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set MEID=%%a
set MEID=%MEID:~27%
reg unload HKLM\0 >NUL
for /f "tokens=3 delims= " %%a in ('reg QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "BackupProductKeyDefault"') do set KEY=%%a
title  %dqwz% �ֶ�������Կ %dqcd%8
echo.
echo   %dqwz% �Ա���װ��Կ %dqcd%8
echo.
echo    Ϊ %MOS% �ֶ����밲װ��Կ �������밴N�س��������˵�
echo.
echo    ��װ��ϵͳ�͵�ǰϵͳ�汾��ͬ����ʹ�õ�ǰϵͳ�İ�װ��Կ�س�����
echo.
echo    ��ǰϵͳ %OOS% �İ�װ��ԿΪ��%KEY%
echo.
set /p KEY=����ȷ����һ�����İ�װ��Կ �����м�Ķ̻��߻س�ִ�в���:
if /i "%key%"=="N" GOTO MENU
%YCDM% /Image:%MOU% /Set-ProductKey:%KEY%
if %errorlevel% NEQ 0 (
echo.
echo     ��Կ��װʧ��  ��ȷ�����ṩ����Կ������ȷ�����ú�����ִ�м���
echo.
ping -n 3 127.1>nul
cls
goto MENU
)
title  %dqwc% �ֶ�������Կ %dqcd%8
echo.
echo   ��Կ��װ������� ������������������Կ��װ����������Զ����ü���
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KWNR
title  %dqwz% �Ƴ�Recovery ϵͳ��ԭ���� %dqcd%10
echo.
echo   %dqwz% �Ƴ�Recovery ϵͳ��ԭ���� %dqcd%10
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist "%MOU%\Windows\system32\Recovery" (
cmd.exe /c takeown /f "%MOU%\Windows\system32\Recovery" /r /d y && icacls "%MOU%\Windows\system32\Recovery" /grant administrators:F /t
attrib -s -a -h %MOU%\Windows\system32\Recovery\*.*
RMDIR /S /Q "%MOU%\Windows\system32\Recovery"
)
title  %dqwc% �Ƴ�Recovery ϵͳ��ԭ���� %dqcd%10
echo.
echo   ϵͳ�Դ���ԭӳ���������Ƴ� ����Ҫʱ����ʱ��ԭ���� ���򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KLWD
title  %dqwz% ���û��Ƴ�Defender %dqcd%11 
echo.
echo   %dqwz% ���û��Ƴ�Defender %dqcd%11 
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   1 ֻ���ö����Ƴ�����    ֱ�ӻس����ò��Ƴ� Windows Defender
echo.
set kwdm=2
set /p kwdm=Ĭ��ֱ�ӻس��Ƴ�Windows Defender���� ��  1 ���� 0 �������˵�
if /i "%kwdm%"=="0" (
 echo.
 echo   ���򽫲�ִ���κβ����������˵�
 echo.
 ping -n 5 127.1>nul
 cls
 goto MENU
) ELSE (
 echo.
 echo   ����ʼ���ý���ӳ���е� Windows Defender ����ȫ����...
 echo.
 reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
 reg add "HKLM\0\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul
 reg unload HKLM\0 >nul
 title  %dqwc% ����Defender %dqcd%11-1
 echo.
 echo   �ɹ����ý���ӳ���е� Windows Defender ע��� ��
 echo.
 ping -n 5 127.1>nul
if /i %kwdm% EQU 1 CLS &&Goto MENU
)
echo.
echo    ��ѯӳ�� Windows Defender �����Ƿ��ṩ���ò�������Ӧ����...
echo.
%YCDM% /Image:%MOU% /english /Get-Features>%YCP%Features.txt
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Windows-Defender" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
del /f /q %YCP%Features.txt
if exist "%MOU%\Program Files\Windows Defender" (
cmd.exe /c takeown /f "%MOU%\Program Files\Windows Defender" /r /d y && icacls "%MOU%\Program Files\Windows Defender" /grant administrators:F /t
rd /S /Q "%MOU%\Program Files\Windows Defender"
)
if exist "%MOU%\ProgramData\Microsoft\Windows Defender" (
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Defender" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Defender" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Defender"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Program Files (x86)\Windows Defender" (
cmd.exe /c takeown /f "%MOU%\Program Files (x86)\Windows Defender" /r /d y && icacls "%MOU%\Program Files (x86)\Windows Defender" /grant administrators:F /t
rd /S /Q "%MOU%\Program Files (x86)\Windows Defender"
)
if exist "%MOU%\Program Files\Windows Defender Advanced Threat Protection" (
echo.
echo    Ĭ���Ƴ� SecurityHealthService ������
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\Windows Defender Advanced Threat Protection" /r /d y && icacls "%MOU%\Program Files\Windows Defender Advanced Threat Protection" /grant administrators:F /t
rd /S /Q "%MOU%\Program Files\Windows Defender Advanced Threat Protection"
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection"
)
if exist "%MOU%\Windows\System32\SecurityHealthService.exe" (
echo.
echo    ��ȫ�رհ�ȫ���������򼰿�ʼ�˵��е�ͼ��
echo.
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Security Health" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Security Health" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Security Health"
cmd.exe /c takeown /f %MOU%\Windows\System32\SecurityHealthService.exe && icacls %MOU%\Windows\System32\SecurityHealthService.exe /grant administrators:F /t
ren %MOU%\Windows\System32\SecurityHealthService.exe SecurityHealthService.bak
)
echo.
echo    ��ȫ�ر� smartscreen ������
echo.
if exist "%MOU%\Windows\System32\smartscreen.exe" (
cmd.exe /c takeown /f %MOU%\Windows\System32\smartscreen.exe && icacls %MOU%\Windows\System32\smartscreen.exe /grant administrators:F /t
ren %MOU%\Windows\System32\smartscreen.exe smartscreen.bak
)
title  %dqwc% �Ƴ� Windows Defender %dqcd%11 
echo.
echo    ϵͳ�Դ�ɱ������ Windows Defender �������Ƴ� ���򷵻�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KONE
title  %dqwz% �Ƴ�OneDrive��SkyDrive��Win10�������� %dqcd%12
echo.
echo   %dqwz% �Ƴ�OneDrive��SkyDrive��Win10�������� %dqcd%12
echo.
if exist %MOU%\Windows\System32\GWX (
cmd.exe /c takeown /f "%MOU%\Windows\System32\GWX" /r /d y && icacls "%MOU%\Windows\System32\GWX" /grant administrators:F /t
RMDIR /S /Q %MOU%\Windows\System32\GWX
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo Windows Registry Editor Version 5.00>%YCP%GWX.reg
echo.>>%YCP%GWX.reg
echo [HKEY_LOCAL_MACHINE\0\Policies\Microsoft\Windows\Gwx]>>%YCP%GWX.reg
echo "DisableGwx"=dword^:00000000>>%YCP%GWX.reg
regedit /s %YCP%GWX.reg>nul
reg unload HKLM\0>nul
if exist %YCP%GWX.reg del /q %YCP%GWX.reg
)
if exist %MOU%\Windows\system32\SkyDrive.exe (
cmd.exe /c takeown /f %MOU%\Windows\FileManager\FileManager.exe && icacls %MOU%\Windows\FileManager\FileManager.exe /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\system32\SkyDrive.exe && icacls %MOU%\Windows\system32\SkyDrive.exe /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\system32\SkyDriveShell.dll && icacls %MOU%\Windows\system32\SkyDriveShell.dll /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\system32\SkyDriveTelemetry.dll && icacls %MOU%\Windows\system32\SkyDriveTelemetry.dll /grant administrators:F /t
DEL /Q /F %MOU%\Windows\FileManager\FileManager.exe
DEL /Q /F "%MOU%\ProgramData\Microsoft\Windows\Start Menu\FileManager.lnk"
DEL /Q /F %MOU%\Windows\system32\SkyDrive.exe
DEL /Q /F %MOU%\Windows\system32\SkyDriveShell.dll
DEL /Q /F %MOU%\Windows\system32\SkyDriveTelemetry.dll
)
if exist %MOU%\Windows\SysWOW64\OneDriveSetup.exe (
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\OneDriveSetup.exe && icacls %MOU%\Windows\SysWOW64\OneDriveSetup.exe /grant administrators:F /t
DEL /Q /F %MOU%\Windows\SysWOW64\OneDriveSetup.exe 
)
if exist %MOU%\Windows\System32\OneDriveSetup.exe (
cmd.exe /c takeown /f %MOU%\Windows\System32\OneDriveSetup.exe && icacls %MOU%\Windows\System32\OneDriveSetup.exe /grant administrators:F /t
DEL /Q /F %MOU%\Windows\System32\OneDriveSetup.exe
)
echo.
echo   ����ע����еĵ�¼������  ֮ǰ�˽ӿڵ����ð����ƹ�ȫ�����
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
echo Windows Registry Editor Version 5.00>%YCP%KONE.reg
echo.>>%YCP%KONE.reg
echo [-HKEY_LOCAL_MACHINE\0\Software\Microsoft\Windows\CurrentVersion\Run]>>%YCP%KONE.reg
echo [HKEY_LOCAL_MACHINE\0\Software\Microsoft\Windows\CurrentVersion\Run]>>%YCP%KONE.reg
ping -n 1 127.1>nul
regedit /s %YCP%KONE.reg>nul
reg unload HKLM\0>nul
if exist %YCP%KONE.reg del /q %YCP%KONE.reg
title  %dqwc% �Ƴ�OneDrive��SkyDrive��Win10�������� %dqcd%12
echo.
echo   OneDrive��SkyDrive�����������Ƴ� ���򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KBRO
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" (
title  %dqwz% ���� Edge ����� %dqcd%13
echo.
echo   %dqwz% ���� Edge ����� %dqcd%13
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
title  %dqwc% ���� Edge ����� %dqcd%13
echo.
echo  Edge �����Ѿ��Ƴ� ����3��󷵻����˵�
echo.
ping -n 3 127.1 >nul
cls
)
goto MENU

:KCTA
if %OFFSYS% LSS 9686 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" (
title  %dqwz% ���� Cortana С�� %dqcd%14
echo.
echo   %dqwz% ���� Cortana С�� %dqcd%14
echo.
echo   ǿ�ҽ�����ʹ�� ���˵� 46 ����ж�ػ������ع��ܶ��Ǳ�����ɾ������
echo.
ping -n 3 127.1>nul
echo   Cortana С�� ע����������
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo Windows Registry Editor Version 5.00>%YCP%KCTA.reg
echo.>>%YCP%KCTA.reg
echo [HKEY_LOCAL_MACHINE\0\Policies\Microsoft\Windows\Windows Search]>>%YCP%KCTA.reg
echo "AllowCortana"=dword^:00000000>>%YCP%KCTA.reg
regedit /s %YCP%KCTA.reg
ping -n 1 127.1>nul
reg unload HKLM\0>nul
if exist %YCP%KCTA.reg del /q %YCP%KCTA.reg
if %OFFSYS% GTR 15000 goto MENU
echo   �Ƴ� Cortana С������
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy"
title  %dqwc% ���� Cortana С�� %dqcd%14
echo.
echo  Cortana С�������Ѿ��Ƴ� ����3��󷵻����˵�
echo.
ping -n 3 127.1 >nul
cls
)
goto MENU

:KSPH
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% �Ƴ� Speech �������� TTS ���� %dqcd%15
echo.
echo   %dqwz% �Ƴ� Speech �������� TTS ���� %dqcd%15
echo.
echo   ǿ�ҽ�����ʹ�� ���˵� 46 ���� 15000���Ƴ���Ӱ��ϵͳ��װ����
echo.
ping -n 3 127.1 >nul
if %OFFSYS% GTR 15000 Goto MENU
if exist %MOU%\Windows\Speech (
cmd.exe /c takeown /f "%MOU%\Windows\Speech_OneCore" /r /d y && icacls "%MOU%\Windows\Speech_OneCore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Speech_OneCore"
cmd.exe /c takeown /f "%MOU%\Windows\Speech" /r /d y && icacls "%MOU%\Windows\Speech" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Speech"
cmd.exe /c takeown /f "%MOU%\Windows\System32\Speech" /r /d y && icacls "%MOU%\Windows\System32\Speech" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\Speech"
cmd.exe /c takeown /f "%MOU%\Windows\System32\Speech_OneCore" /r /d y && icacls "%MOU%\Windows\System32\Speech_OneCore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\Speech_OneCore"
if exist %MOU%\Windows\SysWOW64 if exist %MOU%\Windows\SysWOW64\Speech (
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\Speech_OneCore" /r /d y && icacls "%MOU%\Windows\SysWOW64\Speech_OneCore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\Speech_OneCore"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\Speech" /r /d y && icacls "%MOU%\Windows\SysWOW64\Speech" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\Speech"
)
)
title  %dqwc% �Ƴ� Speech �������� TTS ���� %dqcd%15
echo.
echo  Speech ���������Ѿ�ǿ��ɾ�� ����3��󷵻����˵�
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:PEFT
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% �������� %dqcd%16 
echo.
echo   %dqwz% �������� %dqcd%16 
echo.
echo   ����WINPE������Ϊ�������� ��ʵ�ʲ��Բ�Ӱ��OFFICE2016��ʽ�氲װ
echo.
echo   ʹ�� boot.wim ������� Fonts ������UI����ֻ�Ƽ������޾������
echo.
echo   1 Ĭ�ϲ���PE����Ϊ��������     2 ʹ��PE���岢����UI���� ��ͷ��
echo.
set ftfa=1
set /p ftfa=��ѡ����Ҫ�ķ���1��2 ������������������0�س���
if "%ftfa%"=="2" goto BTFT
if "%ftfa%"=="1" goto SFFT
if "%ftfa%"=="0" goto MENU

:SFFT
echo.
echo   ����WINPE������Ϊ�������� ��ʵ�ʲ��Բ�Ӱ��OFFICE2016��ʽ�氲װ
echo.
echo   ��ʼ����Ȩ�޲���������... ���Ժ�
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Fonts" /r /d y && icacls "%MOU%\Windows\Fonts" /grant administrators:F /t
attrib -s -r -h -a %MOU%\Windows\Fonts\*.*
ren %MOU%\Windows\Fonts\desktop.ini desktop.bak
del /q /f %MOU%\Windows\Fonts\dokchamp.ttf
del /q /f %MOU%\Windows\Fonts\calibrib.ttf
del /q /f %MOU%\Windows\Fonts\malgunbd.ttf
del /q /f %MOU%\Windows\Fonts\mingliub.ttc
del /q /f %MOU%\Windows\Fonts\msgothic.ttc
del /q /f %MOU%\Windows\Fonts\msyhbd.ttc
del /q /f %MOU%\Windows\Fonts\msjhbd.ttc
del /q /f %MOU%\Windows\Fonts\msjhbl.ttc
del /q /f %MOU%\Windows\Fonts\NirmalaB.ttf
del /q /f %MOU%\Windows\Fonts\YuGothB.ttc
del /q /f %MOU%\Windows\Fonts\gulim.ttc
del /q /f %MOU%\Windows\Fonts\javatext.ttf
del /q /f %MOU%\Windows\Fonts\KhmerUI.ttf
del /q /f %MOU%\Windows\Fonts\KhmerUIb.ttf
del /q /f %MOU%\Windows\Fonts\LeelaUIb.ttf
del /q /f %MOU%\Windows\Fonts\LeelawUI.ttf
del /q /f %MOU%\Windows\Fonts\LeelUIsl.ttf
del /q /f %MOU%\Windows\Fonts\majalla.ttf
del /q /f %MOU%\Windows\Fonts\majallab.ttf
del /q /f %MOU%\Windows\Fonts\malgun.ttf
del /q /f %MOU%\Windows\Fonts\meiryo.ttc
del /q /f %MOU%\Windows\Fonts\mingliu.ttc
del /q /f %MOU%\Windows\Fonts\mmrtextb.ttf
del /q /f %MOU%\Windows\Fonts\monbaiti.ttf
del /q /f %MOU%\Windows\Fonts\msgothic.ttc
del /q /f %MOU%\Windows\Fonts\msjh.ttc
del /q /f %MOU%\Windows\Fonts\msjhl.ttc
del /q /f %MOU%\Windows\Fonts\msyhbd.ttc
del /q /f %MOU%\Windows\Fonts\msyhl.ttc
del /q /f %MOU%\Windows\Fonts\Nirmala.ttf
del /q /f %MOU%\Windows\Fonts\NirmalaB.ttf
del /q /f %MOU%\Windows\Fonts\NirmalaS.ttf
del /q /f %MOU%\Windows\Fonts\seguibl.ttf
del /q /f %MOU%\Windows\Fonts\seguibli.ttf
del /q /f %MOU%\Windows\Fonts\seguiemj.ttf
del /q /f %MOU%\Windows\Fonts\Sitka.ttc
del /q /f %MOU%\Windows\Fonts\SitkaB.ttc
del /q /f %MOU%\Windows\Fonts\SitkaI.ttc
del /q /f %MOU%\Windows\Fonts\SitkaZ.ttc
del /q /f %MOU%\Windows\Fonts\sylfaen.ttf
del /q /f %MOU%\Windows\Fonts\UrdTypeb.ttf
del /q /f %MOU%\Windows\Fonts\yugothib.ttf
del /q /f %MOU%\Windows\Fonts\yugothic.ttf
del /q /f %MOU%\Windows\Fonts\yugothil.ttf
del /q /f %MOU%\Windows\Fonts\yumin.ttf
del /q /f %MOU%\Windows\Fonts\yumindb.ttf
del /q /f %MOU%\Windows\Fonts\yuminl.ttf
del /q /f %MOU%\Windows\Fonts\ahronbd.ttf
del /q /f %MOU%\Windows\Fonts\aldhabi.ttf
del /q /f %MOU%\Windows\Fonts\ALGER.TTF
del /q /f %MOU%\Windows\Fonts\andlso.ttf
del /q /f %MOU%\Windows\Fonts\angsa.ttf
del /q /f %MOU%\Windows\Fonts\angsab.ttf
del /q /f %MOU%\Windows\Fonts\angsai.ttf
del /q /f %MOU%\Windows\Fonts\angsau.ttf
del /q /f %MOU%\Windows\Fonts\angsaub.ttf
del /q /f %MOU%\Windows\Fonts\angsaui.ttf
del /q /f %MOU%\Windows\Fonts\angsauz.ttf
del /q /f %MOU%\Windows\Fonts\angsaz.ttf
del /q /f %MOU%\Windows\Fonts\ANTQUAB.TTF
del /q /f %MOU%\Windows\Fonts\ANTQUABI.TTF
del /q /f %MOU%\Windows\Fonts\ANTQUAI.TTF
del /q /f %MOU%\Windows\Fonts\aparaj.ttf
del /q /f %MOU%\Windows\Fonts\aparajb.ttf
del /q /f %MOU%\Windows\Fonts\aparajbi.ttf
del /q /f %MOU%\Windows\Fonts\aparaji.ttf
del /q /f %MOU%\Windows\Fonts\arabtype.ttf
del /q /f %MOU%\Windows\Fonts\ARIALN.TTF
del /q /f %MOU%\Windows\Fonts\ARIALNB.TTF
del /q /f %MOU%\Windows\Fonts\ARIALNBI.TTF
del /q /f %MOU%\Windows\Fonts\ARIALNI.TTF
del /q /f %MOU%\Windows\Fonts\ARIALUNI.TTF
del /q /f %MOU%\Windows\Fonts\BASKVILL.TTF
del /q /f %MOU%\Windows\Fonts\batang.ttc
del /q /f %MOU%\Windows\Fonts\BAUHS93.TTF
del /q /f %MOU%\Windows\Fonts\BELL.TTF
del /q /f %MOU%\Windows\Fonts\BELLB.TTF
del /q /f %MOU%\Windows\Fonts\BELLI.TTF
del /q /f %MOU%\Windows\Fonts\BERNHC.TTF
del /q /f %MOU%\Windows\Fonts\BKANT.TTF
del /q /f %MOU%\Windows\Fonts\BOD_PSTC.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOS.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOSB.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOSBI.TTF
del /q /f %MOU%\Windows\Fonts\BOOKOSI.TTF
del /q /f %MOU%\Windows\Fonts\BRITANIC.TTF
del /q /f %MOU%\Windows\Fonts\BRLNSB.TTF
del /q /f %MOU%\Windows\Fonts\BRLNSDB.TTF
del /q /f %MOU%\Windows\Fonts\BRLNSR.TTF
del /q /f %MOU%\Windows\Fonts\BROADW.TTF
del /q /f %MOU%\Windows\Fonts\browa.ttf
del /q /f %MOU%\Windows\Fonts\browab.ttf
del /q /f %MOU%\Windows\Fonts\browai.ttf
del /q /f %MOU%\Windows\Fonts\browau.ttf
del /q /f %MOU%\Windows\Fonts\browaub.ttf
del /q /f %MOU%\Windows\Fonts\browaui.ttf
del /q /f %MOU%\Windows\Fonts\browauz.ttf
del /q /f %MOU%\Windows\Fonts\browaz.ttf
del /q /f %MOU%\Windows\Fonts\BRUSHSCI.TTF
del /q /f %MOU%\Windows\Fonts\CALIFB.TTF
del /q /f %MOU%\Windows\Fonts\CALIFI.TTF
del /q /f %MOU%\Windows\Fonts\CALIFR.TTF
del /q /f %MOU%\Windows\Fonts\CENTAUR.TTF
del /q /f %MOU%\Windows\Fonts\CENTURY.TTF
del /q /f %MOU%\Windows\Fonts\CHILLER.TTF
del /q /f %MOU%\Windows\Fonts\COLONNA.TTF
del /q /f %MOU%\Windows\Fonts\COOPBL.TTF
del /q /f %MOU%\Windows\Fonts\cordia.ttf
del /q /f %MOU%\Windows\Fonts\cordiab.ttf
del /q /f %MOU%\Windows\Fonts\cordiai.ttf
del /q /f %MOU%\Windows\Fonts\cordiau.ttf
del /q /f %MOU%\Windows\Fonts\cordiaub.ttf
del /q /f %MOU%\Windows\Fonts\cordiaui.ttf
del /q /f %MOU%\Windows\Fonts\cordiauz.ttf
del /q /f %MOU%\Windows\Fonts\cordiaz.ttf
del /q /f %MOU%\Windows\Fonts\daunpenh.ttf
del /q /f %MOU%\Windows\Fonts\david.ttf
del /q /f %MOU%\Windows\Fonts\davidbd.ttf
del /q /f %MOU%\Windows\Fonts\frank.ttf
del /q /f %MOU%\Windows\Fonts\FREESCPT.TTF
del /q /f %MOU%\Windows\Fonts\FTLTLT.TTF
del /q /f %MOU%\Windows\Fonts\FZSTK.TTF
del /q /f %MOU%\Windows\Fonts\FZYTK.TTF
del /q /f %MOU%\Windows\Fonts\GARA.TTF
del /q /f %MOU%\Windows\Fonts\GARABD.TTF
del /q /f %MOU%\Windows\Fonts\GARAIT.TTF
del /q /f %MOU%\Windows\Fonts\gautami.ttf
del /q /f %MOU%\Windows\Fonts\gautamib.ttf
del /q /f %MOU%\Windows\Fonts\GlobalMonospace.CompositeFont
del /q /f %MOU%\Windows\Fonts\GlobalSansSerif.CompositeFont
del /q /f %MOU%\Windows\Fonts\GlobalSerif.CompositeFont
del /q /f %MOU%\Windows\Fonts\GlobalUserInterface.CompositeFont
del /q /f %MOU%\Windows\Fonts\GOTHIC.TTF
del /q /f %MOU%\Windows\Fonts\GOTHICB.TTF
del /q /f %MOU%\Windows\Fonts\GOTHICBI.TTF
del /q /f %MOU%\Windows\Fonts\GOTHICI.TTF
del /q /f %MOU%\Windows\Fonts\HARLOWSI.TTF
del /q /f %MOU%\Windows\Fonts\HARNGTON.TTF
del /q /f %MOU%\Windows\Fonts\himalaya.ttf
del /q /f %MOU%\Windows\Fonts\HTOWERT.TTF
del /q /f %MOU%\Windows\Fonts\HTOWERTI.TTF
del /q /f %MOU%\Windows\Fonts\INFROMAN.TTF
del /q /f %MOU%\Windows\Fonts\iskpota.ttf
del /q /f %MOU%\Windows\Fonts\iskpotab.ttf
del /q /f %MOU%\Windows\Fonts\ITCKRIST.TTF
del /q /f %MOU%\Windows\Fonts\JOKERMAN.TTF
del /q /f %MOU%\Windows\Fonts\JUICE*.TTF
del /q /f %MOU%\Windows\Fonts\kaiu.ttf
del /q /f %MOU%\Windows\Fonts\kalinga.ttf
del /q /f %MOU%\Windows\Fonts\kalingab.ttf
del /q /f %MOU%\Windows\Fonts\kartika.ttf
del /q /f %MOU%\Windows\Fonts\kartikab.ttf
del /q /f %MOU%\Windows\Fonts\kokila.ttf
del /q /f %MOU%\Windows\Fonts\kokilab.ttf
del /q /f %MOU%\Windows\Fonts\kokilabi.ttf
del /q /f %MOU%\Windows\Fonts\kokilai.ttf
del /q /f %MOU%\Windows\Fonts\KUNSTLER.TTF
del /q /f %MOU%\Windows\Fonts\LaoUI.ttf
del /q /f %MOU%\Windows\Fonts\LaoUIb.ttf
del /q /f %MOU%\Windows\Fonts\latha.ttf
del /q /f %MOU%\Windows\Fonts\lathab.ttf
del /q /f %MOU%\Windows\Fonts\LATINWD.TTF
del /q /f %MOU%\Windows\Fonts\LBRITE.TTF
del /q /f %MOU%\Windows\Fonts\LBRITED.TTF
del /q /f %MOU%\Windows\Fonts\LBRITEDI.TTF
del /q /f %MOU%\Windows\Fonts\LBRITEI.TTF
del /q /f %MOU%\Windows\Fonts\LCALLIG.TTF
del /q /f %MOU%\Windows\Fonts\leelawad.ttf
del /q /f %MOU%\Windows\Fonts\leelawdb.ttf
del /q /f %MOU%\Windows\Fonts\LFAX.TTF
del /q /f %MOU%\Windows\Fonts\LFAXD.TTF
del /q /f %MOU%\Windows\Fonts\LFAXDI.TTF
del /q /f %MOU%\Windows\Fonts\LFAXI.TTF
del /q /f %MOU%\Windows\Fonts\LHANDW.TTF
del /q /f %MOU%\Windows\Fonts\lvnm.ttf
del /q /f %MOU%\Windows\Fonts\lvnmbd.ttf
del /q /f %MOU%\Windows\Fonts\MAGNETOB.TTF
del /q /f %MOU%\Windows\Fonts\malgunbd.ttf
del /q /f %MOU%\Windows\Fonts\mangal.ttf
del /q /f %MOU%\Windows\Fonts\mangalb.ttf
del /q /f %MOU%\Windows\Fonts\MATURASC.TTF
del /q /f %MOU%\Windows\Fonts\meiryob.ttc
del /q /f %MOU%\Windows\Fonts\mingliub.ttc
del /q /f %MOU%\Windows\Fonts\MISTRAL.TTF
del /q /f %MOU%\Windows\Fonts\mmrtext.ttf
del /q /f %MOU%\Windows\Fonts\MOD20.TTF
del /q /f %MOU%\Windows\Fonts\mriam.ttf
del /q /f %MOU%\Windows\Fonts\mriamc.ttf
del /q /f %MOU%\Windows\Fonts\msjhbd.ttc
del /q /f %MOU%\Windows\Fonts\msmincho.ttc
del /q /f %MOU%\Windows\Fonts\msuighub.ttf
del /q /f %MOU%\Windows\Fonts\msuighur.ttf
del /q /f %MOU%\Windows\Fonts\msyi.ttf
del /q /f %MOU%\Windows\Fonts\MTCORSVA.TTF
del /q /f %MOU%\Windows\Fonts\mvboli.ttf
del /q /f %MOU%\Windows\Fonts\NIAGENG.TTF
del /q /f %MOU%\Windows\Fonts\NIAGSOL.TTF
del /q /f %MOU%\Windows\Fonts\nrkis.ttf
del /q /f %MOU%\Windows\Fonts\ntailu.ttf
del /q /f %MOU%\Windows\Fonts\ntailub.ttf
del /q /f %MOU%\Windows\Fonts\nyala.ttf
del /q /f %MOU%\Windows\Fonts\OLDENGL.TTF
del /q /f %MOU%\Windows\Fonts\ONYX.TTF
del /q /f %MOU%\Windows\Fonts\PARCHM.TTF
del /q /f %MOU%\Windows\Fonts\phagspa.ttf
del /q /f %MOU%\Windows\Fonts\phagspab.ttf
del /q /f %MOU%\Windows\Fonts\plantc.ttf
del /q /f %MOU%\Windows\Fonts\PLAYBILL.TTF
del /q /f %MOU%\Windows\Fonts\POORICH.TTF
del /q /f %MOU%\Windows\Fonts\raavi.ttf
del /q /f %MOU%\Windows\Fonts\raavib.ttf
del /q /f %MOU%\Windows\Fonts\RAVIE.TTF
del /q /f %MOU%\Windows\Fonts\REFSAN.TTF
del /q /f %MOU%\Windows\Fonts\rod.ttf
del /q /f %MOU%\Windows\Fonts\Shonar.ttf
del /q /f %MOU%\Windows\Fonts\Shonarb.ttf
del /q /f %MOU%\Windows\Fonts\SHOWG.TTF
del /q /f %MOU%\Windows\Fonts\shruti.ttf
del /q /f %MOU%\Windows\Fonts\shrutib.ttf
del /q /f %MOU%\Windows\Fonts\simfang.ttf
del /q /f %MOU%\Windows\Fonts\simhei.ttf
del /q /f %MOU%\Windows\Fonts\simkai.ttf
del /q /f %MOU%\Windows\Fonts\SIMLI.TTF
del /q /f %MOU%\Windows\Fonts\simpbdo.ttf
del /q /f %MOU%\Windows\Fonts\simpfxo.ttf
del /q /f %MOU%\Windows\Fonts\simpo.ttf
del /q /f %MOU%\Windows\Fonts\simsunb.ttf
del /q /f %MOU%\Windows\Fonts\SIMYOU.TTF
del /q /f %MOU%\Windows\Fonts\SNAP*.TTF
del /q /f %MOU%\Windows\Fonts\STCAIYUN.TTF
del /q /f %MOU%\Windows\Fonts\STENCIL.TTF
del /q /f %MOU%\Windows\Fonts\STFANGSO.TTF
del /q /f %MOU%\Windows\Fonts\STHUPO.TTF
del /q /f %MOU%\Windows\Fonts\STKAITI.TTF
del /q /f %MOU%\Windows\Fonts\STLITI.TTF
del /q /f %MOU%\Windows\Fonts\STSONG.TTF
del /q /f %MOU%\Windows\Fonts\STXIHEI.TTF
del /q /f %MOU%\Windows\Fonts\STXINGKA.TTF
del /q /f %MOU%\Windows\Fonts\STXINWEI.TTF
del /q /f %MOU%\Windows\Fonts\STZHONGS.TTF
del /q /f %MOU%\Windows\Fonts\taile.ttf
del /q /f %MOU%\Windows\Fonts\taileb.ttf
del /q /f %MOU%\Windows\Fonts\TEMPSITC.TTF
del /q /f %MOU%\Windows\Fonts\tradbdo.ttf
del /q /f %MOU%\Windows\Fonts\trado.ttf
del /q /f %MOU%\Windows\Fonts\tunga.ttf
del /q /f %MOU%\Windows\Fonts\tungab.ttf
del /q /f %MOU%\Windows\Fonts\upcdb.ttf
del /q /f %MOU%\Windows\Fonts\upcdbi.ttf
del /q /f %MOU%\Windows\Fonts\upcdi.ttf
del /q /f %MOU%\Windows\Fonts\upcdl.ttf
del /q /f %MOU%\Windows\Fonts\upceb.ttf
del /q /f %MOU%\Windows\Fonts\upcebi.ttf
del /q /f %MOU%\Windows\Fonts\upcei.ttf
del /q /f %MOU%\Windows\Fonts\upcel.ttf
del /q /f %MOU%\Windows\Fonts\upcfb.ttf
del /q /f %MOU%\Windows\Fonts\upcfbi.ttf
del /q /f %MOU%\Windows\Fonts\upcfi.ttf
del /q /f %MOU%\Windows\Fonts\upcfl.ttf
del /q /f %MOU%\Windows\Fonts\upcib.ttf
del /q /f %MOU%\Windows\Fonts\upcibi.ttf
del /q /f %MOU%\Windows\Fonts\upcii.ttf
del /q /f %MOU%\Windows\Fonts\upcil.ttf
del /q /f %MOU%\Windows\Fonts\upcjb.ttf
del /q /f %MOU%\Windows\Fonts\upcjbi.ttf
del /q /f %MOU%\Windows\Fonts\upcji.ttf
del /q /f %MOU%\Windows\Fonts\upcjl.ttf
del /q /f %MOU%\Windows\Fonts\upckb.ttf
del /q /f %MOU%\Windows\Fonts\upckbi.ttf
del /q /f %MOU%\Windows\Fonts\upcki.ttf
del /q /f %MOU%\Windows\Fonts\upckl.ttf
del /q /f %MOU%\Windows\Fonts\upclb.ttf
del /q /f %MOU%\Windows\Fonts\upclbi.ttf
del /q /f %MOU%\Windows\Fonts\upcli.ttf
del /q /f %MOU%\Windows\Fonts\upcll.ttf
del /q /f %MOU%\Windows\Fonts\UrdType.ttf
del /q /f %MOU%\Windows\Fonts\utsaah.ttf
del /q /f %MOU%\Windows\Fonts\utsaahb.ttf
del /q /f %MOU%\Windows\Fonts\utsaahbi.ttf
del /q /f %MOU%\Windows\Fonts\utsaahi.ttf
del /q /f %MOU%\Windows\Fonts\Vani.ttf
del /q /f %MOU%\Windows\Fonts\Vanib.ttf
del /q /f %MOU%\Windows\Fonts\vijaya.ttf
del /q /f %MOU%\Windows\Fonts\vijayab.ttf
del /q /f %MOU%\Windows\Fonts\VINERITC.TTF
del /q /f %MOU%\Windows\Fonts\VIVALDII.TTF
del /q /f %MOU%\Windows\Fonts\VLADIMIR.TTF
del /q /f %MOU%\Windows\Fonts\vrinda.ttf
del /q /f %MOU%\Windows\Fonts\vrindab.ttf
del /q /f %MOU%\Windows\Fonts\WINGDNG2.TTF
del /q /f %MOU%\Windows\Fonts\WINGDNG3.TTF 
del /q /f %MOU%\Windows\Fonts\StaticCache.dat
ren %MOU%\Windows\Fonts\desktop.bak desktop.ini
attrib +s +r +a %MOU%\Windows\Fonts\*.ttf
attrib +s +r +a %MOU%\Windows\Fonts\*.fon
attrib +s +r +h +a %MOU%\Windows\Fonts\*.xml
attrib +h +s %MOU%\Windows\Fonts\desktop.ini
attrib +s +r %MOU%\Windows\Fonts
title  %dqwc% �������� %dqcd%16-1
echo.
echo   ���徫��������  5�����򷵻����˵�
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:BTFT
echo.
echo   ʹ�� boot.wim ������� Fonts ������UI����ֻ�Ƽ������޾������
echo.
echo   װ��ISO״ֱ̬��ִ�з�������ȡISO\Sources\boot.wim �� %YCP%
echo.
echo   ��ʼ����Ȩ�޲�ִ���ռ���ȫ�������徫�����... ���Ժ򣡣���
echo.
if not exist %SOUR%boot.wim (
echo.
echo   û�з��� %SOUR%boot.wim ��ȷ�����������ִ�� ���򷵻�
echo.
ping -n 5 127.1 >nul
cls
goto MENU
)
cmd.exe /c takeown /f "%MOU%\Windows\Fonts" /r /d y && icacls "%MOU%\Windows\Fonts" /grant administrators:F /t
attrib -s -r -h -a %MOU%\Windows\Fonts\*.*
ren %MOU%\Windows\Fonts\desktop.ini desktop.bak
if not exist %YCP%Fonts md %YCP%Fonts
Xcopy /y /h %MOU%\Windows\Fonts\*.xml %YCP%Fonts\
Xcopy /y /h %MOU%\Windows\Fonts\desktop.bak %YCP%Fonts\
XCopy /y %MOU%\Windows\Fonts\msyh.ttc %YCP%MY\
XCopy /y %MOU%\Windows\Fonts\simsun.ttc %YCP%MY\
%YCP%TOOL\7z\7z x %SOUR%boot.wim -o.\ 1\windows\fonts>nul
XCopy /y /h 1\windows\Fonts\*.* %YCP%Fonts\>nul
if exist %YCP%Fonts\msyhl.ttc del /q /f %YCP%Fonts\msyhl.ttc
if exist %YCP%Fonts\msyh.ttc del /q /f %YCP%Fonts\msyh.ttc
if exist %YCP%Fonts\simsun.ttc del /q /f %YCP%Fonts\simsun.ttc
XCopy /y %YCP%MY\msyh.ttc %YCP%Fonts\
XCopy /y %YCP%MY\simsun.ttc %YCP%Fonts\
rd /q /s %YCP%1
RMDIR /S /Q "%MOU%\Windows\Fonts"
rd /q /s %MOU%\Windows\Fonts
move /y %YCP%Fonts %MOU%\Windows\
ren %MOU%\Windows\Fonts\desktop.bak desktop.ini
attrib +s +r +a %MOU%\Windows\Fonts\*.ttf
attrib +s +r +a %MOU%\Windows\Fonts\*.fon
attrib +s +r +h +a %MOU%\Windows\Fonts\*.xml
attrib +h +s %MOU%\Windows\Fonts\desktop.ini
attrib +s +r %MOU%\Windows\Fonts
title  %dqwc% �������� %dqcd%16-2
echo.
echo   ʹ�� boot.wim ������� Fonts ������UI����������  5��󷵻�
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:KABY
if %OFFSYS% LSS 7600 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% ���� assembly �������� %dqcd%17
echo.
echo   %dqwz% ���� assembly �������� %dqcd%17
echo.
if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64"
)
if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64"
)
title  %dqwc% ���� assembly �������� %dqcd%17
echo.
echo  Assembly ���������Ѿ��Ƴ� ����3��󷵻����˵�
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:KSAP
if %OFFSYS% LSS 10240 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% ��ȫ��������һЩǿ�����õ�Ӧ��  %dqcd%18
echo.
echo      ΪWin10����ϵͳ��ȫ��������һЩǿ�����õ�Ӧ��  %dqcd%18
echo.
if exist %YCP%SystemAppslist.txt del /q /f %YCP%SystemAppslist.txt >nul
if exist %MOU%\Windows\HoloShell echo HoloShell>%YCP%SystemAppslist.txt
if exist %MOU%\Windows\SystemApps (dir /b /a "%MOU%\Windows\SystemApps">>%YCP%SystemAppslist.txt)
echo.
echo    ����������������������������������������������������������������������������������
echo      �����Ѿ��г�1703��ǰ����ǿ�����õ�Ӧ�� �������Ѿ��Ƴ�����Ŀ ����ΪĬ�ϱ�������
echo.
echo    �����ש����������������������������������ש����������������������������������ש���
echo    ��01��        ϵ  ͳ  ��  ��  ��        ��   Windows Cloud Experience Host  ����
echo    �ǩ��響���������������������������������響���������������������������������響��
echo    ��02��        ��   ��   ��   ��         ��     Parental       Controls      ����
echo    �ǩ��響���������������������������������響���������������������������������響��
echo    ��03��        ��   ��   ��   ��         ��      Shell  Experience  Host     ����
echo    �ǩ��響���������������������������������響���������������������������������響��
echo    ��04��        Edge     � �� ��         ��     Microsoft           Edge     ����
echo    �ǩ��響���������������������������������響���������������������������������響��
echo    ��05��        Cortana С�� ����         ��     Windows          Cortana     ����
echo    �ǩ��響���������������������������������響���������������������������������響��
echo    ��06��        Metro �� �� �� ��         ��     Content Delivery Manager     ����
echo    �����ߩ����������������������������������ߩ����������������������������������ߩ���
echo.
echo               ȷ�Ͼ�����ֱ�ӻس�                     �������밴N�س�����
echo    ����������������������������������������������������������������������������������
echo.
set ksya=Y
set /p ksya=��ȷ�����ѡ�񲢻س���
if /i "%ksya%"=="N" if exist %YCP%SystemAppslist.txt del /q /f %YCP%SystemAppslist.txt >nul &&GOTO MENU 
echo.
echo      ��ʼ��Ĭ�ϰ�ȫ�������о���ǿ�����õ�Ӧ��...    ���Ժ�
echo.
if exist %MOU%\Windows\HoloShell (
cmd.exe /c takeown /f "%MOU%\Windows\HoloShell" /r /d y && icacls "%MOU%\Windows\HoloShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\HoloShell"
)
set yc=%MOU%\Windows\SystemApps
findstr /i /V /C:".CloudExperienceHost_" "%YCP%SystemAppslist.txt"|findstr /i /V /C:"ParentalControls_" >"%YCP%Appslist.txt"
del /f /q %YCP%SystemAppslist.txt && Ren "%YCP%Appslist.txt" SystemAppslist.txt
findstr /i /V /C:"ShellExperienceHost_" "%YCP%SystemAppslist.txt"|findstr /i /V /C:".MicrosoftEdge_" >"%YCP%Appslist.txt"
del /f /q %YCP%SystemAppslist.txt && Ren "%YCP%Appslist.txt" SystemAppslist.txt
findstr /i /V /C:".Cortana_" "%YCP%SystemAppslist.txt"|findstr /i /V /C:".ContentDeliveryManager_" >"%YCP%Appslist.txt"
del /f /q %YCP%SystemAppslist.txt && Ren "%YCP%Appslist.txt" SystemAppslist.txt
for /f "delims=" %%i in (%YCP%SystemAppslist.txt) do (cmd.exe /c takeown /f "%YC%\%%i" /r /d y & icacls "%YC%\%%i" /grant administrators:F /t & RD /s/q "%YC%\%%i")
if exist %YCP%SystemAppslist.txt del /f /q %YCP%SystemAppslist.txt
echo.
title  %dqwc% ��ȫ��������һЩǿ�����õ�Ӧ��  %dqcd%18
echo.
echo   �Ѿ�Ϊ1703��ǰϵͳ��ȫ��������֪���Ծ����ǿ�����ò���Ӧ��
echo.
ping -n 10 127.1 >nul
cls
goto MENU

:NWMP
if %OFFSYS% LSS 9651 goto MENU
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% Ϊ Win10 N��ϵͳ��� Windows Media Player ����  %dqcd%19
echo.
echo   %dqwz% Ϊ Win10 N��ϵͳ��� Windows Media Player ����  %dqcd%19
echo.
if not exist "%MOU%\Program Files\Windows Media Player\wmplayer.exe" %YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%SSYS%WMP%Mbt%.CAB
if !errorlevel!==0 (
title  %dqwc% Ϊ Win10 N��ϵͳ��� Windows Media Player ����
echo.
echo   �ɹ���� Windows Media Player ����                    ���򷵻����˵�
echo.
) ELSE (
echo.
echo   ��������������� δ�ܳɹ���� Windows Media Player ���� ���򷵻�
echo.
)
ping -n 3 127.1 >nul
cls
goto MENU

:JCQD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% Ϊ��֪��δ֪Ӳ�� ��Ӽ���ר�û�ͨ����ɫ���� %dqcd%20-2
echo.
echo   %dqwz% Ϊ��֪��δ֪Ӳ�� ��Ӽ���ר�û�ͨ����ɫ���� %dqcd%20-2
echo.
echo   ע������е�ӳ��Ϊ%Mbt%��ȷ����Ҫ��ӵ�����Ҳ��%Mbt%���������ڹ����е�ӳ������ܼ���
echo.
echo   �뽫Ҫ���ɵ��������Ƶ�%YCP%%FSYS%%Mbt%QDĿ¼ ȷ��ΪINF��ʽ��������Ŀ¼���س���ʼ����
echo.
echo   �Ƽ����Ѱ�װ�õ�ϵͳWindows\System32\DriverStore\FileRepository\��ϵͳ�Դ�������Ŀ¼
echo.
echo   ����Ŀ¼���Ƶ�%YCP%%FSYS%%Mbt%QD ���ظ��ļ�����Ŀ¼ ��ȫ������һ�𱾳����Զ��������
echo.
if not exist %YCP%%FSYS%%Mbt%QD md %YCP%%FSYS%%Mbt%QD
pause>nul
echo.
echo  ��ʼ��������... ����������С�Ͷ��پ�����ʱ �����ĵȴ������������Զ���ʾ��һ������
if exist %YCP%%FSYS%%Mbt%QD\*  %YCDM% /Image:%MOU% /Add-Driver /Driver:%YCP%%FSYS%%Mbt%QD\ /Recurse /Forceunsigned
rem ����ṩ������û��ǩ����ʹ������Forceunsigned�Ĳ����������伯��
rem %YCDM% /Image:%MOU% /Add-Driver /Driver:%YCP%%FSYS%%Mbt%QD\ /Recurse /Forceunsigned
title  %dqwc% Ϊ��֪��δ֪Ӳ�� ��Ӽ���ר�û�ͨ����ɫ���� %dqcd%20-2
echo.
echo       %YCP%%FSYS%%Mbt%QDĿ¼������������ ����6����Զ��������˵������
echo.
ping -n 6 127.1>nul
cls
goto MENU

:WNQD
title  %dqwz% ���ɻ����������� %dqcd%20-1
echo.
echo   %dqwz% Ϊ�����Զ����߰�װ������Ŀ��Ӳ����ӻ򼯳�����
echo.
echo     1    �Ƽ���Ĭ������ ��������7^[����оƬ+����^]����
echo.
echo     2    Ϊ��֪��δ֪Ӳ�� ��Ӽ���ר�û�ͨ����ɫ����
echo.
echo   �Ͱ�ϵͳ������ͬPE��boot����USB3��SSD������֤˳����װ
echo.
set fsxz=1
set /p fsxz=��ѡ��ǰ�ṩ�Ĳ����˵�������� ֱ�ӻس�Ĭ��Ϊ1��
if /i %fsxz% equ 2 goto JCQD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if not exist %MOU%\Windows\Setup\Scripts md %MOU%\Windows\Setup\Scripts
if exist %YCP%ADXX\%FSYS%%Mbt% Xcopy /y /s %YCP%ADXX\%FSYS%%Mbt% %MOU%\Windows\Setup\Scripts\
if not exist %MOU%\Windows\Setup\Scripts\SetupComplete.cmd  Xcopy /y /s %YCP%MY\Setup\Scripts\SetupComplete.cmd  %MOU%\Windows\Setup\Scripts\
title  %dqwc% ������������7^[����оƬ+����^] %dqcd%20-1
echo.
echo   ������������7^[����оƬ+����^]��� ���򷵻����˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:SOFT
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% ������Ҫ���ϵ�ӳ���е���ɫ��� %dqcd%26
echo.
echo   %dqwz% ������Ҫ���ϵ�ӳ���е���ɫ��� %dqcd%26
echo.
echo  ��˵����
echo  ======================================================================================
echo      YCDISM��ּΪ������ȫ��ǿ�ҽ�ֹ���ñ����������ڰ�ȫ�����ĳ������ϵ�ӳ���У��ڼ���
echo.
echo  ��ɫ���ǰ��Ҫ����֪��������Խ�ѹ���ľ�Ĭִ�в���������������ֵ�ذ�װ����ʱ��ͣ������
echo.
echo  Ҫ�����һ����ѡͬ��Э�����ƵĻ�����װ�������������ֵ�ذ�װ�����Ч�ʣ������Ƽ�����
echo.
echo  ��ǰ����ɫ��������ƽ��м򻯺͹淶�������Ƽ��ü���޿ո���ĸ����Ӣ����������Ӧ��������
echo.
echo  x86�ܹ����������%YCP%MY\SOFT\x86Ŀ¼�� x64�ܹ����������%YCP%MY\SOFT\x64Ŀ¼��
echo.
echo                               ִ�д˲���ǰ���������ֵ�ز���
echo  ======================================================================================
echo.
if not exist %MOU%\Windows\Setup\Scripts\SetupComplete.cmd goto WRZS
if not exist %YCP%MY\SOFT\%Mbt%\*.exe (
echo.
echo  û�з���%YCP%MY\SOFT\%Mbt%Ŀ¼�´���EXE��������     ��ȷ������׼������������ִ�����ϲ���
echo.
ping -n 10 127.1>nul
cls
goto MENU
)
if exist %YCP%MY\SOFT\%Mbt%\*.exe (
cd /d %YCP%MY\SOFT\%Mbt% &&for %%i in (*.exe) do (echo if exist %%i start /wait %%i>>exelist.txt)
cd /d %YCP%
)
if exist %YCP%MY\SOFT\%Mbt%\exelist.txt (
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.txt del /q /f %YCP%MY\SOFT\%Mbt%\SetupComplete.txt
Copy /y %YCP%MY\SOFT\%Mbt%\SetupComplete.bak %YCP%MY\SOFT\%Mbt%\SetupComplete.txt
Type %YCP%MY\SOFT\%Mbt%\exelist.txt>>%YCP%MY\SOFT\%Mbt%\SetupComplete.txt
start %YCP%MY\SOFT\%Mbt%\SetupComplete.txt
)
echo.
echo      ���ڴ򿪵��ı�����ÿ�������ϸó���Ĭ���� ע���Сд���磺/S
echo.
echo      ȷ���Ѱ�Ҫ����ȷ��������뱣�沢�ر��ı�         ���س��������
echo.
pause>nul
echo del %%0 >>%YCP%MY\SOFT\%Mbt%\SetupComplete.txt
echo exit /q>>%YCP%MY\SOFT\%Mbt%\SetupComplete.txt
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd del /q /f %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.txt Ren %YCP%MY\SOFT\%Mbt%\SetupComplete.txt SetupComplete.cmd
if exist %YCP%MY\SOFT\%Mbt%\exelist.txt del /q /f %YCP%MY\SOFT\%Mbt%\exelist.txt
if exist %YCP%MY\SOFT\%Mbt%\*.exe Xcopy /y %YCP%MY\SOFT\%Mbt%\*.exe %MOU%\Windows\Setup\Scripts\
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd Copy /y %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd %MOU%\Windows\Setup\Scripts\SetupComplete.cmd
if exist %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd del /q /f %YCP%MY\SOFT\%Mbt%\SetupComplete.cmd
title  %dqwc% ������ɫ��� %dqcd%26
echo.
echo      ������ɫ�����ӳ��������                    ���򷵻����˵� 
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADVC
title  %dqwz% ��ӳ���VC NET Flash DirectX ���߰�װ���� %dqcd%21
echo.
echo   %dqwz% ��ӳ���VC NET Flash DirectX ���߰�װ���� %dqcd%21
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
Xcopy /d %YCP%MY\Setup\Scripts\SetupComplete.cmd  %MOU%\Windows\Setup\Scripts\
echo.
echo   VC+++2005\08\10\12\13\15...
if %Mbt% EQU x64 Xcopy /y %YCP%ADXX\VC??x86.exe %MOU%\Windows\Setup\Scripts\
Xcopy /Y %YCP%ADXX\VC??%Mbt%.exe %MOU%\Windows\Setup\Scripts\
if %OFFSYS% LEQ 9200 (
echo.
echo   ���NET4.6...
Xcopy /y %YCP%ADXX\N462.exe %MOU%\Windows\Setup\Scripts\
echo.
echo   ���FLASH...
Xcopy /y %YCP%ADXX\FLASH.exe %MOU%\Windows\Setup\Scripts\
)
echo.
echo   ���DirectX...
Copy /y %YCP%ADXX\DirectX%Mbt%.exe %MOU%\Windows\Setup\Scripts\DirectX.exe
title  %dqwc% ��ӳ���VC NET Flash DirectX ���߰�װ���� %dqcd%21
echo.
echo   VC NET Flash DirectX���߰�װ������������ ���򷵻����˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:MWEB
title  %dqwz% �滻ӳ��WebĿ¼����ͼƬ %dqcd%22
echo.
echo   %dqwz% �滻ӳ��WebĿ¼����ͼƬ %dqcd%22
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   ���������DIY��LOGO�ļ� �����滻��Ŀ��ϵͳ��
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Branding\Shellbrd" /r /d y && icacls "%MOU%\Windows\Branding\Shellbrd" /grant administrators:F /t
if exist %YCP%MY\%FSYS%Shellbrd.dll Copy /y %YCP%MY\%FSYS%Shellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
if %OFFSYS% GEQ 14295 (
if exist %YCP%MY\RSShellbrd.dll Copy /y %YCP%MY\%YCP%MY\RSShellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
)
echo.
echo   ��ȡ����������ݵ�Ȩ�޲��滻Ϊ%YCP%MY�е�����...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Themes" /r /d y && icacls "%MOU%\Windows\Resources\Themes" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Themes\aero" /r /d y && icacls "%MOU%\Windows\Resources\Themes\aero" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web" /r /d y && icacls "%MOU%\Windows\Web" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web\Wallpaper\Theme1" /r /d y && icacls "%MOU%\Windows\Web\Wallpaper\Theme1" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web\Wallpaper\Theme2" /r /d y && icacls "%MOU%\Windows\Web\Wallpaper\Theme2" /grant administrators:F /t
Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Windows\
if exist %MOU%\Windows\Web\Wallpaper\Architecture Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Architecture\
if exist %MOU%\Windows\Web\Wallpaper\Characters Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Characters\
if exist %MOU%\Windows\Web\Wallpaper\Landscapes Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Landscapes\
if exist %MOU%\Windows\Web\Wallpaper\Nature Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Nature\
if exist %MOU%\Windows\Web\Wallpaper\Scenes Xcopy /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Scenes\
if exist %MOU%\Windows\Web\Screen Xcopy /y /h /s /u %YCP%MY\IMG %MOU%\Windows\Web\Screen\
if exist %MOU%\Windows\Web\Wallpaper\Theme1 (
Xcopy /s /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Theme1\
)
if exist %MOU%\Windows\Web\Wallpaper\Theme2 (
Xcopy /s /y /u %YCP%MY\IMG %MOU%\Windows\Web\Wallpaper\Theme2\
)
if exist %MOU%\Windows\Web\4K RMDIR /S /Q "%MOU%\Windows\Web\4K"
title  %dqwc% �滻ӳ��WebĿ¼����ͼƬ %dqcd%22
echo.
echo   �滻ӳ��WebĿ¼����ͼƬ����� ��
echo.
ping -n 5 127.1>nul
cls
goto MENU

:USER
title  %dqwz% ���� ͼƬ ���� �ղؼ� ��Ƶ ����D���ĵ��� %dqcd%23
echo.
echo   %dqwz% ���� ͼƬ ���� �ղؼ� ��Ƶ ����D���ĵ��� %dqcd%23
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   ����ʼ�����û�������D�̵�ע�������
if %OFFSYS% LEQ 7601 (
Copy /y %YCP%Panther\W7YH.reg %MOU%\Windows\Setup\YCYH.reg >nul
 echo.
echo   ��ǰӳ��Ϊ %FSYS% ������Ĳ�ȷ���� ���ý������ڲ���ʱ������Ч
 echo.
) ELSE (
 echo.
 echo   ��ǰӳ��Ϊ %FSYS% ��ֱ�ӽ����ù̻���ӳ���в�������Ч...
 echo Windows Registry Editor Version 5.00>>%YCP%USER.reg
 echo Windows Registry Editor Version 5.00>>%YCP%USERS.reg
 echo.>>%YCP%USER.reg
 echo.>>%YCP%USERS.reg
 echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders]>>%YCP%USER.reg
 echo "Favorites"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USER.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,5c,00,46,00,61,00,76,00,6f,00,72,00,69,00,74,\>>%YCP%USER.reg
 echo   00,65,00,73,00,00,00>>%YCP%USER.reg
 echo "My Music"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USER.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,5c,00,4d,00,75,00,73,00,69,00,63,00,00,00>>%YCP%USER.reg
 echo "My Pictures"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,\>>%YCP%USER.reg
 echo   00,6d,00,65,00,6e,00,74,00,73,00,5c,00,50,00,69,00,63,00,74,00,75,00,72,00,\>>%YCP%USER.reg
 echo   65,00,73,00,00,00>>%YCP%USER.reg
 echo "My Video"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USER.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,5c,00,56,00,69,00,64,00,65,00,6f,00,73,00,00,\>>%YCP%USER.reg
 echo   00>>%YCP%USER.reg
 echo "Personal"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USER.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,00,00>>%YCP%USER.reg
 echo "{374DE290-123F-4565-9164-39C4925E467B}"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,\>>%YCP%USER.reg
 echo   20,00,44,00,6f,00,63,00,75,00,6d,00,65,00,6e,00,74,00,73,00,5c,00,44,00,6f,\>>%YCP%USER.reg
 echo   00,77,00,6e,00,6c,00,6f,00,61,00,64,00,73,00,00,00>>%YCP%USER.reg
 echo.>>%YCP%USER.reg
 reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
 regedit /s %YCP%USER.reg
 reg unload HKLM\0 >nul
 reg load HKLM\0 "%MOU%\Windows\System32\config\DEFAULT">nul
 regedit /s %YCP%USER.reg
 reg unload HKLM\0 >nul
 echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders]>>%YCP%USERS.reg
 echo "CommonPictures"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,\>>%YCP%USERS.reg
 echo   00,6d,00,65,00,6e,00,74,00,73,00,5c,00,50,00,69,00,63,00,74,00,75,00,72,00,\>>%YCP%USERS.reg
 echo   65,00,73,00,00,00>>%YCP%USERS.reg
 echo "CommonMusic"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USERS.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,5c,00,4d,00,75,00,73,00,69,00,63,00,00,00>>%YCP%USERS.reg
 echo "CommonVideo"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USERS.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,5c,00,56,00,69,00,64,00,65,00,6f,00,73,00,00,\>>%YCP%USERS.reg
 echo   00>>%YCP%USERS.reg
 echo "Common Documents"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USERS.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,00,00>>%YCP%USERS.reg
 echo "{3D644C9B-1FB8-4f30-9B45-F670235F79C0}"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,\>>%YCP%USERS.reg
 echo   20,00,44,00,6f,00,63,00,75,00,6d,00,65,00,6e,00,74,00,73,00,5c,00,44,00,6f,\>>%YCP%USERS.reg
 echo   00,77,00,6e,00,6c,00,6f,00,61,00,64,00,73,00,00,00>>%YCP%USERS.reg
 echo.>>%YCP%USERS.reg
 echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders]>>%YCP%USERS.reg
 echo "CommonPictures"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,\>>%YCP%USERS.reg
 echo   00,6d,00,65,00,6e,00,74,00,73,00,5c,00,50,00,69,00,63,00,74,00,75,00,72,00,\>>%YCP%USERS.reg
 echo   65,00,73,00,00,00>>%YCP%USERS.reg
 echo "CommonMusic"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USERS.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,5c,00,4d,00,75,00,73,00,69,00,63,00,00,00>>%YCP%USERS.reg
 echo "CommonVideo"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USERS.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,5c,00,56,00,69,00,64,00,65,00,6f,00,73,00,00,\>>%YCP%USERS.reg
 echo   00>>%YCP%USERS.reg
 echo "Common Documents"=hex^(2^)^:44,00,3a,00,5c,00,4d,00,79,00,20,00,44,00,6f,00,63,00,75,00,\>>%YCP%USERS.reg
 echo   6d,00,65,00,6e,00,74,00,73,00,00,00>>%YCP%USERS.reg
 reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
 regedit /s %YCP%USERS.reg
 reg unload HKLM\0 >nul
 echo.
 echo   ��ǰӳ��Ϊ %FSYS% �����Ѿ��ɹ��̻���ӳ�� Ĭ�Ϻ��½��˻� ������Ч ��
 Xcopy /y %YCP%Panther\YCYH.reg %MOU%\Windows\Setup\ >nul
)
if exist %YCP%USER.reg if exist %MOU%\Users\Administrator\NTUSER.DAT (
 echo.
 echo   ��ǰӳ�����Ϊ���η�װ��ӳ�� ��Ϊ Administrator �˻�������ͬ����
 echo.
 reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT">nul
 regedit /s %YCP%USER.reg
 reg unload HKLM\0 >nul
)
echo   ��ʼ����ӳ���еĲ���Ŀ¼��ֹ��װ�����������ͬ�ļ���
echo.
cmd.exe /c takeown /f "%MOU%ProgramData\Documents" /r /d y && icacls "%MOU%\ProgramData\Documents" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\ProgramData\Favorites" /r /d y && icacls "%MOU%\ProgramData\Favorites" /grant administrators:F /t
Rd /s /q "%MOU%\ProgramData\Favorites"
Rd /s /q "%MOU%ProgramData\Documents"
cmd.exe /c takeown /f "%MOU%\Users\Default\Saved Games" /r /d y && icacls "%MOU%\Users\Default\Saved Games" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\Documents" /r /d y && icacls "%MOU%\Users\Default\Documents" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\My Documents" /r /d y && icacls "%MOU%\Users\Default\My Documents" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\Favorites" /r /d y && icacls "%MOU%\Users\Default\Favorites" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\Music" /r /d y && icacls "%MOU%\Users\Default\Music" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\Pictures" /r /d y && icacls "%MOU%\Users\Default\Pictures" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\Links" /r /d y && icacls "%MOU%\Users\Default\Links" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\Videos" /r /d y && icacls "%MOU%\Users\Default\Videos" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Default\Downloads" /r /d y && icacls "%MOU%\Users\Default\Downloads" /grant administrators:F /t
Rd /s /q "%MOU%\Users\Default\Saved Games"
Rd /s /q "%MOU%\Users\Default\Documents"
Rd /s /q "%MOU%\Users\Default\Downloads"
Rd /s /q "%MOU%\Users\Default\My Documents"
Rd /s /q "%MOU%\Users\Default\Favorites"
Rd /s /q "%MOU%\Users\Default\Music"
Rd /s /q "%MOU%\Users\Default\Pictures"
Rd /s /q "%MOU%\Users\Default\Links"
Rd /s /q "%MOU%\Users\Default\Videos"
cmd.exe /c takeown /f "%MOU%\Users\Public\My Documents" /r /d y && icacls "%MOU%\Users\Public\My Documents" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Public\Videos" /r /d y && icacls "%MOU%\Users\Public\Videos" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Public\Music" /r /d y && icacls "%MOU%\Users\Public\Music" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Public\Pictures" /r /d y && icacls "%MOU%\Users\Public\Pictures" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Public\Links" /r /d y && icacls "%MOU%\Users\Public\Links" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Public\Documents" /r /d y && icacls "%MOU%\Users\Public\Documents" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Public\Favorites" /r /d y && icacls "%MOU%\Users\Public\Favorites" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Public\Downloads" /r /d y && icacls "%MOU%\Users\Public\Downloads" /grant administrators:F /t
Rd /s /q "%MOU%\Users\Public\Documents"
Rd /s /q "%MOU%\Users\Public\Downloads"
Rd /s /q "%MOU%\Users\Public\My Documents"
Rd /s /q "%MOU%\Users\Public\Favorites"
Rd /s /q "%MOU%\Users\Public\Music"
Rd /s /q "%MOU%\Users\Public\Pictures"
Rd /s /q "%MOU%\Users\Public\Links"
Rd /s /q "%MOU%\Users\Public\Videos"
if exist %MOU%\Users\Administrator (
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Documents" /r /d y && icacls "%MOU%\Users\Administrator\Documents" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Administrator\My Documents" /r /d y && icacls "%MOU%\Users\Administrator\My Documents" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Favorites" /r /d y && icacls "%MOU%\Users\Administrator\Favorites" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Music" /r /d y && icacls "%MOU%\Users\Administrator\Music" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Videos" /r /d y && icacls "%MOU%\Users\Administrator\Videos" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Links" /r /d y && icacls "%MOU%\Users\Administrator\Links" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Pictures" /r /d y && icacls "%MOU%\Users\Administrator\Pictures" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Downloads" /r /d y && icacls "%MOU%\Users\Administrator\Downloads" /grant administrators:F /t
Rd /s /q "%MOU%\Users\Administrator\Downloads"
Rd /s /q "%MOU%\Users\Administrator\Documents"
Rd /s /q "%MOU%\Users\Administrator\My Documents"
Rd /s /q "%MOU%\Users\Administrator\Favorites"
Rd /s /q "%MOU%\Users\Administrator\Music"
Rd /s /q "%MOU%\Users\Administrator\Pictures"
Rd /s /q "%MOU%\Users\Administrator\Links"
Rd /s /q "%MOU%\Users\Administrator\Videos"
)
echo   ��ʼ����ӳ���еĲ���Ŀ¼��� ��
echo.
if exist %YCP%USER.reg del /q /f %YCP%USER.reg
if exist %YCP%USERS.reg del /q /f %YCP%USERS.reg
echo.
title   %dqwc% ���� ͼƬ ���� �ղؼ� ��Ƶ ����D���ĵ��� %dqcd%23
echo.
echo   %dqwc% ���� ͼƬ ���� �ղؼ� ��Ƶ ����D���ĵ���   ���򷵻�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:WRZS
title  %dqwz% ��׼�ʻ�����ֵ�ذ�װͨ���Ż� %dqcd%24
echo.
echo   %dqwz% ��׼�ʻ�����ֵ�ذ�װͨ���Ż� %dqcd%24
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   ȫ��Ĭ���½���׼�ʻ� MyPC ������ �Զ���װ������ �ž������˻�ʹ��APPS��һЩ����
echo.
echo   ���ɸ����Լ�ϲ���ı��û����� ���� MyComputer �������û��� ������Ӣ�ĵ��ʻ�ƴд
echo.
ping -n 3 127.1>nul
echo   ��ʼ���ò�����������  ���Ժ�...
echo.
if not exist %MOU%\Windows\Panther md %MOU%\Windows\Panther
if not exist %YCP%Panther\%FSYS%%Mbt%otherunattend.xml Copy /y %YCP%Panther\%FSYS%%Mbt%Adminunattend.xml %MOU%\Windows\Panther\unattend.xml
Xcopy /y /s %YCP%MY\Setup %MOU%\Windows\Setup\
if %OFFSYS% LEQ 7601 (
Copy /y %YCP%Panther\W7YH.reg %MOU%\Windows\Setup\YCYH.reg >nul
Xcopy /y %YCP%MY\TOAC.exe %MOU%\Windows\Setup\Scripts\
) else (
Xcopy /y %YCP%Panther\YCYH.reg %MOU%\Windows\Setup\
)
echo.
echo   ��ʼΪ %FSYS% ϵͳ�ر���Դ�������еĿ���ղؼ�...
echo.
echo   ȥ����Դ�������еĿ��ٷ���...
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo [Version] >test.inf
echo Signature = "$Chicago$" >>test.inf
echo [Registry Keys] >>test.inf
echo "machine\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder", 0, "O:BA" >>test.inf
secedit /configure /db test.sdb /cfg test.inf /log test.log /quiet
del /f /q test.*
if exist regset.ini del /f/q regset.ini
echo HKLM\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder [1] >regset.ini
regini.exe regset.ini
del /f /q regset.ini
reg add "HKLM\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1 /f >nul
echo.
echo   ȥ����Դ�������еĿ��ٷ���������� ��
echo.
echo [Version] >test.inf
echo Signature = "$Chicago$" >>test.inf
echo [Registry Keys] >>test.inf
echo "machine\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder", 0, "O:BA" >>test.inf
secedit /configure /db test.sdb /cfg test.inf /log test.log /quiet
del /f /q test.*
if exist regset.ini del /f/q regset.ini
echo HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder [1] >regset.ini
echo HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder [1] >>regset.ini
regini.exe regset.ini >nul
del /f /q regset.ini
reg add "HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2962227469 /f >nul
reg add "HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 270880 /f >nul
reg add "HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2696937728 /f >nul
reg add "HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD  /d 1 /f >nul
reg unload HKLM\0 >nul
echo.
echo   �ɹ�Ϊ %FSYS% ϵͳ�ر���Դ�������еĿ���ղؼ� ��
echo.
if exist %MOU%\Windows\Setup\Scripts\TOAC.exe Xcopy /y %YCP%MY\Keys.ini %MOU%\Windows\Setup\Scripts\
if not exist %YCP%MY\System32\logo.bmp if exist %YCP%MY\logo.bmp Xcopy /y %YCP%MY\logo.bmp %YCP%MY\System32\
Xcopy /y %YCP%MY\System32 %MOU%\Windows\System32\
set adm=
if exist %YCP%Panther\%FSYS%%Mbt%otherunattend.xml (
echo.
echo   ��ǰϵͳΪWin10 Ĭ���Զ������ù���ԱAdmin��װ����¼ �����׼�˻��밴 0 �س�
echo.
echo   ˵�������Ҫ����ʹ��APPӦ�ú�΢���˻��밴0 û�л��߲�ʹ��APPӦ�� ��ֱ�ӻس�
echo.
set /p adm=��ѡ���������˻��Զ���װ����¼ ����0��ֱ�ӻس�ִ�в���
)
if "%adm%"=="0" (
Copy /y %YCP%Panther\%FSYS%%Mbt%Otherunattend.xml %MOU%\Windows\Panther\unattend.xml
if %OFFSYS% GEQ 15025 Copy /y %YCP%Panther\RS%FSYS%%Mbt%Otherunattend.xml %MOU%\Windows\Panther\unattend.xml
) ELSE (
Copy /y %YCP%Panther\%FSYS%%Mbt%Adminunattend.xml %MOU%\Windows\Panther\unattend.xml
if %OFFSYS% GEQ 15025 Copy /y %YCP%Panther\RS%FSYS%%Mbt%Adminunattend.xml %MOU%\Windows\Panther\unattend.xml
)
echo.
echo   ������ʾ �ҵĵ��� ����վ �û��ļ��� IEͼ��...
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\Software\Policies\Microsoft\Windows NT\Driver Signing" /v "BehaviorOnFailedVerify" /t REG_DWORD /d 0 /f >nul
reg delete "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons" /f >nul 2>nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{00000000-0000-0000-0000-100000000001}" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0 >nul
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE" >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\RunOnce" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\Setup\State\RunOnce.cmd" /f >nul
reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{00000000-0000-0000-0000-100000000001}" /t REG_DWORD /d 0 /f >nul
echo.
echo   ������ʾ �ҵĵ��� ����վ �û��ļ��� ͼ����� ��
echo.
echo   ����������������ʾ Internet Explorer ͼ��...
echo.
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{00000000-0000-0000-0000-100000000001}" /ve /t REG_SZ /d "Internet Explorer" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}" /ve /t REG_SZ /d "Internet Explorer" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\DefaultIcon" /ve /t REG_SZ /d "ieframe.dll,-190" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell" /ve /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\NoAddOns" /ve /t REG_SZ /d "�޼�����(&N)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\NoAddOns\Command" /ve /t REG_SZ /d "iexplore.exe -extoff" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Open" /ve /t REG_SZ /d "����ҳ(&H)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Open\Command" /ve /t REG_SZ /d "iexplore.exe" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Set" /ve /t REG_SZ /d "����(&R)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Set\Command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl" /f >nul
reg unload HKLM\0 >nul
echo.
echo   ��������ʾ Internet Explorer ͼ��������� ��
echo.
ping -n 6 127.1>nul
Xcopy /y %YCP%MY\RunOnce.cmd %MOU%\Windows\Setup\State\ >nul
if %SSYS% EQU %OFFSYS%S Copy /y %YCP%MY\SSRunOnce.cmd %MOU%\Windows\Setup\State\RunOnce.cmd >nul

:CSHP
set hp=http://www.2345.com/?k371057592
echo.
echo   ��ճ�����IE��ҳ��ַ�������򴰿ں�س� ����Ĭ��Ϊ�곿2345����
echo.
set /p hp=�������ֱ��ճ�����Լ�Ҫ���õ�IE��ҳ��ַ  �س���Ӧ�õ�ӳ����
echo.
echo   �����õ���ҳΪ %hp% ȷ��������ֱ�ӻس�
echo.
set hpqr=
set /p hpqr=���� N �س������޸�IE��ҳ��ַ
if /i "%hpqr%"=="N" GOTO CSHP
echo.
echo   ��%hp%����Ϊӳ��Ĭ�ϵ�IE��ҳ���������CSS��ʽ���γ������ ��
echo.
echo   �Ҽ������ʾ�������ļ�����չ��...
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">nul
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden" /ve /t REG_SZ /d "��ʾ�������ļ�����չ��" /f >nul
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden\Command" /ve /t REG_EXPAND_SZ /d "WScript.exe %%Windir%%\System32\SuperHidden.vbs" /f >nul
reg unload HKLM\0 >nul
Xcopy /y %YCP%MY\System32\SuperHidden.vbs %MOU%\Windows\System32\ >nul
echo.
echo   �Ҽ������ʾ�������ļ�����չ�� ��
echo.
echo   �����Ż� �Ƴ����� ��IE������ ��
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "AlwaysUnloadDll" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "RequireAdmin" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "ConfigVer" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Security" /v "BlockXBM" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions" /v "NoJITSetup" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "Enable AutoImageResize" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "NotifyDownloadComplete" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "DisableScriptDebuggerIE" /t REG_SZ /d "yes" /f  >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "Friendly http errors" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Microsoft\Internet Explorer\Main" /v "Error Dlg Displayed On Every Error" /t REG_SZ /d "no" /f >nul
reg unload HKLM\0>nul
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Enable AutoImageResize" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "NotifyDownloadComplete" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "DisableScriptDebuggerIE" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Friendly http errors" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Error Dlg Displayed On Every Error" /t REG_SZ /d "no" /f >nul
reg unload HKLM\0>nul
echo.
echo   �ر�Ӧ���Զ����ݹ��� ��
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Policies\Microsoft\Windows\SettingSync" /v "EnableBackupForWin8Apps" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0>nul
echo.
echo   �ر��˻����� ��
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0>nul
echo.
echo   ��ͼƬԤ����������Ϊ��ɫ ��
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Viewer" /v "BackGroundColor" /t REG_DWORD /d "4278255873" /f >nul
reg unload HKLM\0>nul
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows Photo Viewer\Viewer" /v "BackGroundColor" /t REG_DWORD /d "4278255873" /f >nul
reg unload HKLM\0 >nul 
echo.
echo   ��Դ������ʾ����·�� ��
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0 >nul 
echo.
echo   ��������ʾ�������� �����Ҽ����� ��
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Classes\*\shell\Notepad" /ve /t REG_SZ /d "�ü��±��򿪸��ļ�" /f >nul
reg add "HKLM\0\Classes\*\shell\Notepad\Command" /ve /t REG_SZ /d "notepad %%1" /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr" /ve /t REG_SZ /d "������" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\cleanmgr.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\cleanmgr.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig" /ve /t REG_SZ /d "ϵͳ����" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool" /ve /t REG_SZ /d "��ͼ����" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\SnippingTool.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\SnippingTool.exe" /f >nul
reg unload HKLM\0>nul
echo.
echo   �ҵĵ����Ҽ����볣�ù��߿�ݲ˵�...
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo [Version] >test.inf
echo Signature = "$Chicago$" >>test.inf
echo [Registry Keys] >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control\Command", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr\Command", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall\Command", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit\Command", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit\Command", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services\Command", 0, "O:BA" >>test.inf
secedit /configure /db test.sdb /cfg test.inf /log test.log /quiet
del test.*
if exist regset.ini del /f /q regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}[1] >regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control\command [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr\command [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall\command [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit\command [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit\command [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services\command [1] >>regset.ini
regini.exe regset.ini
del /f /q regset.ini
echo.
echo   �ҵĵ����Ҽ���ӡ�������塱
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /ve /t REG_SZ /d "�������(&C)" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /v "Icon" /t REG_SZ /d "shell32.dll,207" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe shell32.dll,Control_RunDLL" /f >nul
echo.
echo   �ҵĵ����Ҽ���ӡ��豸��������
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr" /ve /t REG_SZ /d "�豸������" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\devmgmt.msc" /f >nul
echo.
echo   �ҵĵ����Ҽ���ӡ���ӻ�ɾ������
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall" /ve /t REG_SZ /d "��ӻ�ɾ������" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl" /f >nul
echo.
echo   �ҵĵ����Ҽ���ӡ�����ԡ�
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit" /ve /t REG_SZ /d "�����" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\gpedit.msc" /f >nul
echo.
echo   �ҵĵ����Ҽ���ӡ�ע���༭����
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /ve /t REG_SZ /d "ע���༭��" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\regedit.exe" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\regedit.exe" /f >nul
echo.
echo   �ҵĵ����Ҽ���ӡ�����
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services" /ve /t REG_SZ /d "����(&V)" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe %%SystemRoot%%\system32\services.msc" /f >nul
echo.
echo   �ҵĵ����Ҽ�������Ͽ�ݲ˵���� ��
echo.
echo   �Ҽ���ӻ�ȡ����ԱȨ��...
echo.
reg add "HKLM\0\Classes\*\shell\runas" /ve /t REG_SZ /d "����Աȡ������Ȩ" /f >nul
reg add "HKLM\0\Classes\*\shell\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /ve /t REG_SZ /d "����Աȡ������Ȩ" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /ve /t REG_SZ /d "����Աȡ������Ȩ" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul
echo.
echo   �Ҽ���ӻ�ȡ����ԱȨ����� ��
echo.
echo   �Ҽ���ӡ������ļ�����Ŀ¼·����...
echo.
reg add "HKLM\0\Classes\*\shell\copypath" /ve /t REG_SZ /d "�����ļ�·��" /f >nul
reg add "HKLM\0\Classes\*\shell\copypath\command" /ve /t REG_SZ /d "mshta vbscript:clipboarddata.setdata(\"text\",\"%%1\")(close)" /f >nul
reg add "HKLM\0\Classes\Directory\shell\copypath" /ve /t REG_SZ /d "����Ŀ¼·��" /f >nul
reg add "HKLM\0\Classes\Directory\shell\copypath\command" /ve /t REG_SZ /d "mshta vbscript:clipboarddata.setdata(\"text\",\"%%1\")(close)" /f >nul
echo.
echo   �Ҽ���Ӹ���·����� ��
echo.
echo   ȥ��ݷ�ʽ��ͷ����ݷ�ʽ����������... 
echo.
reg add "HKLM\0\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "77" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f >nul
reg unload HKLM\0 >nul
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\NotePad" /v "StatusBar" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0 >nul
echo.
echo   ȥ��ݷ�ʽ��ͷ����ݷ�ʽ����������� ��
echo.
echo   �����������ͼ�꼰ϵͳ�Ż�������� ��
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Command Processor" /v "CompletionChar" /t REG_DWORD /d 64 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "ReportAndContinue" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "AlwaysUnloadDll" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "Max Cached Icons" /t REG_SZ /d "7500" /f >nul
echo   �ر�ϵͳ�Զ���ԭ ��
reg add "HKLM\0\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableSR" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "CreateFirstRunRp" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Dfrg\BootOptimizeFunction" /v "Enable" /t REG_SZ /d "Y" /f >nul
reg add "HKLM\0\Microsoft\Security Center" /v "UACDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Security Center" /v "AntiVirusDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Security Center" /v "FirewallDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Security Center" /v "UpdatesDisableNotify" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\OptimalLayout" /v "EnableAutoLayout" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SpecialColor" /t REG_DWORD /d "2716620" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCDBurning" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AlwaysShowClassicMenu" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0 >nul
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "LinksFolderName" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "Locked" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "ShowDiscussionButton" /t REG_SZ /d "Yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Connection Wizard" /v "Completed" /t REG_BINARY /d "01000000" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Connection Wizard" /v "DesktopChanged" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\MSUTB" /v "ShowDeskBand" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar" /v "ExtraIconsOnMinimized" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar" /v "DemoteLevel" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar\ItemState\{ED9D5450-EBE6-4255-8289-F8A31E687228}" /v "DemoteLevel" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCDBurning" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AlwaysShowClassicMenu" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SpecialColor" /t REG_DWORD /d "2716620" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Network\NetworkLocationWizard" /v "HideWizard" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\atapi\Parameters" /v "EnableBigLba" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 80 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "limitblankpassworduse" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "forceguest" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymous" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymoussam" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager" /v "AutoChkTimeOut" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\CurrentControlSet\Services\Messenger" /v "Start" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargePageMinimum" /t REG_DWORD /d "4294967295" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "SendAlert" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "CPUPriority" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "PCIConcur" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "FastDRAM" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "AGPConcur" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\FileSystem" /v "ConfigFileAllocSize" /t REG_DWORD /d 500 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "RemoteRegAccess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Windows" /v "NoPopUpsOnBoot" /t REG_SZ /d "0" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul
reg add "HKLM\0\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v "DesktopShortcut" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v "QuickLaunchShortcut" /t REG_SZ /d "no" /f >nul
reg unload HKLM\0 >nul
if exist %MOU%\Users\Administrator\NTUSER.DAT (
reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT ">nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "LinksFolderName" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "Locked" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Toolbar" /v "ShowDiscussionButton" /t REG_SZ /d "Yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Connection Wizard" /v "Completed" /t REG_BINARY /d "01000000" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Connection Wizard" /v "DesktopChanged" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\MSUTB" /v "ShowDeskBand" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar" /v "ExtraIconsOnMinimized" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar" /v "DemoteLevel" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\LangBar\ItemState\{ED9D5450-EBE6-4255-8289-F8A31E687228}" /v "DemoteLevel" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCDBurning" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AlwaysShowClassicMenu" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "ColorPrevalence" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SpecialColor" /t REG_DWORD /d "2716620" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul
reg add "HKLM\0\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v "DesktopShortcut" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\Software\Microsoft\MediaPlayer\Setup\UserOptions" /v "QuickLaunchShortcut" /t REG_SZ /d "no" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Network\NetworkLocationWizard" /v "HideWizard" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\atapi\Parameters" /v "EnableBigLba" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 128 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "limitblankpassworduse" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "forceguest" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymous" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "Restrictanonymoussam" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager" /v "AutoChkTimeOut" /t REG_DWORD /d 3 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\CurrentControlSet\Services\Messenger" /v "Start" /t REG_DWORD /d 4 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargePageMinimum" /t REG_DWORD /d "4294967295" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "SendAlert" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "CPUPriority" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "PCIConcur" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "FastDRAM" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "AGPConcur" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\FileSystem" /v "ConfigFileAllocSize" /t REG_DWORD /d 500 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "1000" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" /v "RemoteRegAccess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Windows" /v "NoPopUpsOnBoot" /t REG_SZ /d "0" /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0 >nul
)
echo.
title  %dqwc% ����ֵ�ذ�װͨ���Ż� %dqcd%24
echo.
echo   ����ֵ�ذ�װ�������Ż�������� ��
echo.
ping -n 5 127.1>nul
if %OFFSYS% GEQ 9200 (goto BLUE) ELSE (goto YCSZ)
cls

:BLUE
echo.
echo   ����ͼ�����ò�ɫ�������� ��
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareServer" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColor" /t REG_DWORD /d 3289414672 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationColorBalance" /t REG_DWORD /d 89 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglow" /t REG_DWORD /d 3289414672 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationAfterglowBalance" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationBlurBalance" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "EnableWindowColorization" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorizationGlassAttribute" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "AccentColor" /t REG_DWORD /d 4292311040 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "ColorPrevalence" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0>nul
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo [Version] >test.inf
echo Signature = "$Chicago$" >>test.inf
echo [Registry Keys] >>test.inf
echo "machine\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\ShellFolder", 0, "O:BA" >>test.inf
echo "machine\0\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder", 0, "O:BA" >>test.inf
echo "machine\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{289AF617-1CC3-42A6-926C-E6A863F0E3BA}", 0, "O:BA" >>test.inf
echo "machine\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{35786D3C-B075-49b9-88DD-029876E11C01}", 0, "O:BA" >>test.inf
echo "machine\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{9113A02D-00A3-46B9-BC5F-9C04DADDD5D7}", 0, "O:BA" >>test.inf
echo "machine\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{640167b4-59b0-47a6-b335-a6b3c0695aea}", 0, "O:BA" >>test.inf
echo "machine\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{b155bdf8-02f0-451e-9a26-ae317cfd7779}", 0, "O:BA" >>test.inf
secedit /configure /db test.sdb /cfg test.inf /log test.log /quiet
del /f /q test.*
if exist regset.ini del /f /q regset.ini
echo HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder [1] >regset.ini
echo HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\ShellFolder [1] >>regset.ini
echo HKLM\0\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder [1] >>regset.ini
echo HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{289AF617-1CC3-42A6-926C-E6A863F0E3BA} [1] >>regset.ini
echo HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{35786D3C-B075-49b9-88DD-029876E11C01} [1] >>regset.ini
echo HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{9113A02D-00A3-46B9-BC5F-9C04DADDD5D7} [1] >>regset.ini
echo HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{640167b4-59b0-47a6-b335-a6b3c0695aea} [1] >>regset.ini
echo HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{b155bdf8-02f0-451e-9a26-ae317cfd7779} [1] >>regset.ini
regini.exe regset.ini >nul
del /f /q regset.ini
reg add "HKLM\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\0\Classes\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2961178893 /f >nul
reg add "HKLM\0\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 270880 /f >nul
reg add "HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2692743424 /f >nul
reg add "HKLM\0\Classes\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2961441036 /f >nul
reg add "HKLM\0\Classes\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 270880 /f >nul
reg add "HKLM\0\Classes\CLSID\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2952790016 /f >nul
reg add "HKLM\0\Classes\CLSID\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1040 /f >nul
reg add "HKLM\0\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d 2953052260 /f >nul
reg add "HKLM\0\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "FolderValueFlags" /t REG_DWORD /d 1057344 /f >nul
reg delete "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{289AF617-1CC3-42A6-926C-E6A863F0E3BA}" /ve /t REG_SZ /d "DLNA Media Servers Data Source" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{35786D3C-B075-49b9-88DD-029876E11C01}" /ve /t REG_SZ /d "Portable Devices" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{640167b4-59b0-47a6-b335-a6b3c0695aea}" /ve /t REG_SZ /d "Portable Media Devices" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{9113A02D-00A3-46B9-BC5F-9C04DADDD5D7}" /ve /t REG_SZ /d "Enhanced Storage Data Source" /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{b155bdf8-02f0-451e-9a26-ae317cfd7779}" /ve /t REG_SZ /d "nethood delegate folder" /f >nul
reg unload HKLM\0 >nul
echo.
echo   ����ͼ��������� ���������ɲ������Զ����� ��
echo.
ping -n 3 127.1>nul
if %OFFSYS% GEQ 10240 (goto NRTM) ELSE (goto YCSZ)
cls

:NRTM
echo.
echo   Win10 IE �������úͽ��ÿͻ�������Ƽƻ���͸�������� ��
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo.
echo   ���� Cortana С�����������е�ͼ����ʾ ��
echo.
reg add "HKLM\0\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
reg unload HKLM\0>nul
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Xaml" /v "AllowFailFastOnAnyFailureF" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\BrowserEmulation" /v "MSCompatibilityMode" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0 >nul 
echo.
echo   Win10 Internet Explorer �������������� ��
echo.
if exist "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" if exist %YCP%MY\MUI\%OFFSYS%windows.storage.dll.mui (
echo.
echo   ���־߱����˵��Ըĳ��ҵĵ����ļ� �����Զ��滻�ļ� ���Ժ�...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\System32\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\System32\zh-CN\"
)
if exist "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" if exist %YCP%MY\MUI\%OFFSYS%windows.storage.dll.mui (
echo.
echo   64λϵͳ�����˵��Ըĳ��ҵĵ����ļ� �����Զ��滻�ļ� ���Ժ�...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
)
if %OFFSYS% GEQ 14393 if exist "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" (
echo.
echo   ���־߱����˵��Ըĳ��ҵĵ����ļ� �����Զ��滻�ļ� ���Ժ�...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\System32\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\System32\zh-CN\" >nul
)
if %OFFSYS% GEQ 14393 if exist "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" (
echo.
echo   64λϵͳ�����˵��Ըĳ��ҵĵ����ļ� �����Զ��滻�ļ� ���Ժ�...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\" >nul
)
ping -n 3 127.1>nul
echo.
echo   ���ô�ͳͼƬ�鿴��Ԥ��ͼƬ...
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Classes\Applications\photoviewer.dll\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul
reg add "HKLM\0\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul
reg add "HKLM\0\Classes\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
echo.
echo   ���ô�ͳͼƬ�鿴��Ԥ��ͼƬ������� ��
echo.
echo   Ϊ����ͼƬ��ʽ��������...
echo.
reg add "HKLM\0\Classes\SystemFileAssociations\image\shellex\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Classes\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Classes\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Classes\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Classes\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Classes\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Classes\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Classes\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".ico" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tga" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f >nul
reg unload HKLM\0 >nul
echo.
echo   Ϊ����ͼƬ��ʽ��������������� ��
echo.
if %OFFSYS% GEQ 14295 (goto RSTO) ELSE (goto YCSZ)
cls

:RSTO
echo.
echo   1607��ʹ�����������������ڿ�ʼ�˵���ʾ���鼰�ر���Ϸ¼�� ��
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9e1e078012000000" /f >nul
reg add "HKLM\0\Software\Microsoft\CTF\MSUTB" /v "Top" /t REG_DWORD /d 706 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "KGLRevision" /t REG_DWORD /d 1301 /f >nul
reg add "HKLM\0\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Streams" /v "Settings" /t REG_BINARY /d "080000000100000001000000e0d057007335cf11ae6908002b2e1262040000000200000043000000" /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\InputMethod\Settings\CHS" /v "Enable Cloud Candidate" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SOFTWARE\Microsoft\InputMethod\Settings\CHS" /v "Enable Fuzzy Input" /t REG_DWORD /d 1 /f >nul
echo Windows Registry Editor Version 5.00 >%YCP%yy.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Streams\Desktop]>>%YCP%yy.reg
echo "TaskbarWinXP"=hex^:0c,00,00,00,08,00,00,00,02,00,00,00,00,00,00,00,b0,e2,2b,\>>%YCP%yy.reg
echo   d8,64,57,d0,11,a9,6e,00,c0,4f,d7,05,a2,22,00,1c,00,0a,01,00,00,1a,00,00,00,\>>%YCP%yy.reg
echo   01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,4c,00,00,00,01,14,02,00,00,\>>%YCP%yy.reg
echo   00,00,00,c0,00,00,00,00,00,00,46,83,00,00,00,10,00,00,00,a0,b0,48,5e,89,8d,\>>%YCP%yy.reg
echo   bd,01,00,d8,9e,e4,2a,8d,bd,01,00,45,fe,5e,89,8d,bd,01,00,00,00,00,00,00,00,\>>%YCP%yy.reg
echo   00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,13,01,14,00,1f,0f,e0,4f,\>>%YCP%yy.reg
echo   d0,20,ea,3a,69,10,a2,d8,08,00,2b,30,30,9d,19,00,23,44,3a,5c,00,00,00,00,00,\>>%YCP%yy.reg
echo   00,00,00,00,00,00,00,00,00,00,00,00,cd,97,15,00,31,00,00,00,00,00,af,24,5c,\>>%YCP%yy.reg
echo   b9,10,80,57,69,6e,6e,74,00,00,20,00,31,00,00,00,00,00,af,24,a3,b9,10,00,50,\>>%YCP%yy.reg
echo   72,6f,66,69,6c,65,73,00,50,52,4f,46,49,4c,45,53,00,19,00,31,00,00,00,00,00,\>>%YCP%yy.reg
echo   c1,24,08,92,10,00,69,65,35,30,30,2e,30,30,30,00,00,28,00,31,00,00,00,00,00,\>>%YCP%yy.reg
echo   c1,24,08,92,10,00,41,70,70,6c,69,63,61,74,69,6f,6e,20,44,61,74,61,00,41,50,\>>%YCP%yy.reg
echo   50,4c,49,43,7e,31,00,21,00,31,00,00,00,00,00,c5,22,9d,91,10,00,4d,69,63,72,\>>%YCP%yy.reg
echo   6f,73,6f,66,74,00,4d,49,43,52,4f,53,7e,31,00,29,00,31,00,00,00,00,00,d3,22,\>>%YCP%yy.reg
echo   32,a6,10,00,49,6e,74,65,72,6e,65,74,20,45,78,70,6c,6f,72,65,72,00,49,4e,54,\>>%YCP%yy.reg
echo   45,52,4e,7e,31,00,24,00,31,00,00,00,00,00,db,22,76,ba,10,00,51,75,69,63,6b,\>>%YCP%yy.reg
echo   20,4c,61,75,6e,63,68,00,51,55,49,43,4b,4c,7e,31,00,00,00,8d,00,00,00,1c,00,\>>%YCP%yy.reg
echo   00,00,01,00,00,00,1c,00,00,00,36,00,00,00,0d,f0,ad,ba,8c,00,00,00,1a,00,00,\>>%YCP%yy.reg
echo   00,03,00,00,00,e7,18,2d,23,10,00,00,00,49,45,35,30,30,5f,58,31,43,00,43,3a,\>>%YCP%yy.reg
echo   5c,57,49,4e,4e,54,5c,50,72,6f,66,69,6c,65,73,5c,49,45,35,30,30,2e,30,30,30,\>>%YCP%yy.reg
echo   5c,41,70,70,6c,69,63,61,74,69,6f,6e,20,44,61,74,61,5c,4d,69,63,72,6f,73,6f,\>>%YCP%yy.reg
echo   66,74,5c,49,6e,74,65,72,6e,65,74,20,45,78,70,6c,6f,72,65,72,5c,51,75,69,63,\>>%YCP%yy.reg
echo   6b,20,4c,61,75,6e,63,68,00,00,10,00,00,00,05,00,00,a0,1a,00,00,00,a3,00,00,\>>%YCP%yy.reg
echo   00,00,00,00,00,08,00,00,00,02,00,00,00,cc,00,00,00,01,00,00,00,03,00,00,00,\>>%YCP%yy.reg
echo   4a,00,00,00,01,00,00,00,40,00,32,00,e6,01,00,00,c4,24,15,9f,20,00,4c,61,75,\>>%YCP%yy.reg
echo   6e,63,68,20,49,6e,74,65,72,6e,65,74,20,45,78,70,6c,6f,72,65,72,20,42,72,6f,\>>%YCP%yy.reg
echo   77,73,65,72,2e,6c,6e,6b,00,4c,41,55,4e,43,48,7e,32,2e,4c,4e,4b,00,00,00,40,\>>%YCP%yy.reg
echo   00,00,00,02,00,00,00,36,00,32,00,48,02,00,00,c4,24,15,9f,20,00,4c,61,75,6e,\>>%YCP%yy.reg
echo   63,68,20,4f,75,74,6c,6f,6f,6b,20,45,78,70,72,65,73,73,2e,6c,6e,6b,00,4c,41,\>>%YCP%yy.reg
echo   55,4e,43,48,7e,31,2e,4c,4e,4b,00,00,00,36,00,00,00,00,00,00,00,2c,00,32,00,\>>%YCP%yy.reg
echo   51,00,00,00,ec,22,46,39,20,00,53,68,6f,77,20,44,65,73,6b,74,6f,70,2e,73,63,\>>%YCP%yy.reg
echo   66,00,53,48,4f,57,44,45,7e,31,2e,53,43,46,00,00,00,52,00,00,00,e0,00,00,00,\>>%YCP%yy.reg
echo   00,00,00,00,16,00,00,00,00,00,00,00,00,00,00,00,16,00,00,00,00,00,00,00,01,\>>%YCP%yy.reg
echo   00,00,00,01,00,00,00,aa,4f,28,68,48,6a,d0,11,8c,78,00,c0,4f,d9,18,b4,37,02,\>>%YCP%yy.reg
echo   00,00,e0,00,00,00,00,00,00,00,16,00,00,00,00,00,00,00,00,00,00,00,16,00,00,\>>%YCP%yy.reg
echo   00,00,00,00,00,01,00,00,00>>%YCP%yy.reg
echo "Upgrade"=dword^:00000001>>%YCP%yy.reg
regedit /s %YCP%yy.reg >nul
reg unload HKLM\0 >nul 
if exist %YCP%yy.reg del /q %YCP%yy.reg
echo.
echo   ��ʹ�����������������ڿ�ʼ�˵���ʾ���鼰�ر���Ϸ¼�� ��
echo.
ping -n 3 127.1>nul

:YCSZ
echo   ��ʼ�˵��ȶ������ò������������...
echo.
echo   ���Զ�����������ѡ�Ĭ��������ܲ�ƽ������
echo.
echo   ����2 ������ܡ�1 Ϊ�����ۡ�0 �������
echo.
set pcxl=2
set /p pcxl=��ѡ������������ֻس���ֱ�ӻس�Ĭ��������ܣ�
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultApplied" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultValue" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\StigRegKey\typing\TaskbarAvoidanceEnabled" /v "Enabled" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0>nul
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
echo Windows Registry Editor Version 5.00>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Control Panel\Keyboard]>>%YCP%YCcmd.reg
echo "InitialKeyboardIndicators"="2">>%YCP%YCcmd.reg
echo "KeyboardDelay"="1">>%YCP%YCcmd.reg
echo "KeyboardSpeed"="31">>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
if %OFFSYS% GEQ 9600 (
echo [HKEY_LOCAL_MACHINE\0\Console]>>%YCP%YCcmd.reg
if %OFFSYS% GEQ 15021 echo "FaceName"="������">>%YCP%YCcmd.reg
echo "ScreenBufferSize"=dword^:002a0060>>%YCP%YCcmd.reg
echo "ScreenColors"=dword^:0000001f>>%YCP%YCcmd.reg
echo "WindowAlpha"=dword^:000000ce>>%YCP%YCcmd.reg
echo "WindowPosition"=dword^:000c023a>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Console\%%SystemRoot%%_System32_cmd.exe]>>%YCP%YCcmd.reg
if %OFFSYS% GEQ 15021 echo "FaceName"="������">>%YCP%YCcmd.reg
echo "ScreenBufferSize"=dword^:002a0060>>%YCP%YCcmd.reg
echo "ScreenColors"=dword^:0000001f>>%YCP%YCcmd.reg
echo "WindowAlpha"=dword^:000000ce>>%YCP%YCcmd.reg
echo "WindowPosition"=dword^:000c023a>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Keyboard Layout\Preload]>>%YCP%YCcmd.reg
echo "1"="00000409">>%YCP%YCcmd.reg
echo "2"="00000804">>%YCP%YCcmd.reg
echo "3"="00000804">>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Keyboard Layout\Substitutes]>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Keyboard Layout\Toggle]>>%YCP%YCcmd.reg
echo "Hotkey"="2">>%YCP%YCcmd.reg
echo "Language Hotkey"="2">>%YCP%YCcmd.reg
echo "Layout Hotkey"="3">>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Control Panel\International\User Profile]>>%YCP%YCcmd.reg
echo "Languages"=hex^(7^)^:65,00,6e,00,2d,00,55,00,53,00,00,00,7a,00,68,00,2d,00,48,00,\>>%YCP%YCcmd.reg
echo   61,00,6e,00,73,00,2d,00,43,00,4e,00,00,00>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Control Panel\International\User Profile\en-US]>>%YCP%YCcmd.reg
echo "0409:00000409"=dword^:00000001>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Control Panel\International\User Profile\zh-Hans-CN]>>%YCP%YCcmd.reg
echo "0804:00000804"=dword^:00000001>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Control Panel\International\User Profile System Backup]>>%YCP%YCcmd.reg
echo "Languages"=hex^(7^)^:65,00,6e,00,2d,00,55,00,53,00,00,00,7a,00,68,00,2d,00,48,00,\>>%YCP%YCcmd.reg
echo   61,00,6e,00,73,00,2d,00,43,00,4e,00,00,00>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Control Panel\International\User Profile System Backup\en-US]>>%YCP%YCcmd.reg
echo "0409:00000409"=dword^:00000001>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Control Panel\International\User Profile System Backup\zh-Hans-CN]>>%YCP%YCcmd.reg
echo "0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}"=dword:00000001>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}]>>%YCP%YCcmd.reg
echo "Default"="{00000000-0000-0000-0000-000000000000}">>%YCP%YCcmd.reg
echo "Profile"="{00000000-0000-0000-0000-000000000000}">>%YCP%YCcmd.reg
echo "KeyboardLayout"=dword^:04090409>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\Assemblies\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}]>>%YCP%YCcmd.reg
echo "Default"="{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}">>%YCP%YCcmd.reg
echo "Profile"="{FA550B04-5AD7-411F-A5AC-CA038EC515D7}">>%YCP%YCcmd.reg
echo "KeyboardLayout"=dword^:08040804>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\LangBar]>>%YCP%YCcmd.reg
echo "ShowStatus"=dword^:00000004>>%YCP%YCcmd.reg
echo "Transparency"=dword^:000000ff>>%YCP%YCcmd.reg
echo "Label"=dword^:00000000>>%YCP%YCcmd.reg>>%YCP%YCcmd.reg
echo "ExtraIconsOnMinimized"=dword^:00000001>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\SortOrder\AssemblyItem\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000]>>%YCP%YCcmd.reg
echo "CLSID"="{00000000-0000-0000-0000-000000000000}">>%YCP%YCcmd.reg
echo "KeyboardLayout"=dword^:04090409>>%YCP%YCcmd.reg
echo "Profile"="{00000000-0000-0000-0000-000000000000}">>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\SortOrder\AssemblyItem\0x00000804\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000]>>%YCP%YCcmd.reg
echo "CLSID"="{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}">>%YCP%YCcmd.reg
echo "KeyboardLayout"=dword^:00000000>>%YCP%YCcmd.reg
echo "Profile"="{FA550B04-5AD7-411F-A5AC-CA038EC515D7}">>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\SortOrder\Language]>>%YCP%YCcmd.reg
echo "00000000"="00000409">>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\TIP\{00000000-0000-0000-0000-000000000000}\LanguageProfile\0x00000409\{00000000-0000-0000-0000-000000000000}]>>%YCP%YCcmd.reg
echo "Enable"=dword^:00000001>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\TIP\{8613E14C-D0C0-4161-AC0F-1DD2563286BC}\LanguageProfile\0x0000ffff\{B37D4237-8D1A-412E-9026-538FE16DF216}]>>%YCP%YCcmd.reg
echo "Enable"=dword^:00000000>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\SOFTWARE\Microsoft\CTF\TIP\{F25E9F57-2FC8-4EB3-A41A-CCE5F08541E6}\LanguageProfile\0x0000ffff\{F2510000-2FC8-4EB3-A41A-CCE5F08541E6}]>>%YCP%YCcmd.reg
echo "Enable"=dword^:00000000>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
)
regedit /s %YCP%YCcmd.reg
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\RunOnce" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\Setup\State\RunOnce.cmd" /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d %pcxl% /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultApplied" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultValue" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AlwaysShowMenu" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AutoCheckSelect" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontPrettyPath" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d 0 /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Filter" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MapNetDrvBtn" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ServerAdminUI" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_SearchFiles" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCompColor" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTypeOverlay" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_NotifyNewApps" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuInit" /t REG_DWORD /d 4 /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowRun" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_AdminToolsRoot" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuAdminTools" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_LargeMFUIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_MinMFU" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_JumpListItems" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_PowerButtonAction" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSizeMove" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "WebView" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSecondsInSystemClock" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ExplorerStartupTraceRecorded" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main]" /v "HomeButtonPage" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "UseClearType" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Styles" /v "User Stylesheet" /t REG_EXPAND_SZ /d "%%windir%%\Setup\ad.css" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Styles" /v "Use My Stylesheet" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0>nul
if exist %MOU%\Users\Administrator\NTUSER.DAT (
echo.
echo   �����ǰ���ص�ӳ��Ϊ���η�װһ����Ч ��
echo.
reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT">nul
regedit /s %YCP%YCcmd.reg
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\RunOnce" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\Setup\State\RunOnce.cmd" /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultApplied" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultValue" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AlwaysShowMenu" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AutoCheckSelect" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontPrettyPath" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d 0 /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Filter" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MapNetDrvBtn" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ServerAdminUI" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_SearchFiles" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCompColor" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowStatusBar" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTypeOverlay" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_NotifyNewApps" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuInit" /t REG_DWORD /d 4 /f >nul
if %OFFSYS% GEQ 10240 reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowRun" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_AdminToolsRoot" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StartMenuAdminTools" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_LargeMFUIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_MinMFU" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_JumpListItems" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_PowerButtonAction" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSizeMove" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarGlomLevel" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "WebView" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSecondsInSystemClock" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "DesktopProcess" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ExplorerStartupTraceRecorded" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main]" /v "HomeButtonPage" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /t REG_SZ /d "%hp%" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "UseClearType" /t REG_SZ /d "yes" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Styles" /v "User Stylesheet" /t REG_EXPAND_SZ /d "%%windir%%\Setup\ad.css" /f >nul
reg add "HKLM\0\Software\Microsoft\Internet Explorer\Styles" /v "Use My Stylesheet" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0>nul
)
del /f /q %YCP%YCcmd.reg
Xcopy /y %YCP%MY\ad.css %MOU%\Windows\Setup\ >nul
echo.
echo   ����ͨ���Ż������Ի�������ɹ̻� �����Ƿ��������򷵻����˵�
echo.
ping -n 6 127.1>nul
if /i %SSYS% EQU %OFFSYS%S ( 
Copy /y %YCP%Panther\SSYH.reg %MOU%\Windows\Setup\YCYH.reg >nul
echo.
echo   ���ֵ�ǰװ��ӳ��Ϊ������ϵͳ ��Ϊ������ϵͳAdmin�˻�����ͨ������...
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Internet Explorer" /v "svcKBFWLink" /t REG_SZ /d "%hp%" /f >nul
echo Windows Registry Editor Version 5.00>%YCP%SSsz.reg
echo.>>%YCP%SSsz.reg
echo [-HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System]>>%YCP%SSsz.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System]>>%YCP%SSsz.reg
echo "ConsentPromptBehaviorAdmin"=dword^:00000005>>%YCP%SSsz.reg
echo "ConsentPromptBehaviorUser"=dword^:00000003>>%YCP%SSsz.reg
echo "DSCAutomationHostEnabled"=dword^:00000002>>%YCP%SSsz.reg
echo "EnableCursorSuppression"=dword^:00000001>>%YCP%SSsz.reg
echo "EnableInstallerDetection"=dword^:00000001>>%YCP%SSsz.reg
echo "EnableLUA"=dword^:00000000>>%YCP%SSsz.reg
echo "EnableSecureUIAPaths"=dword^:00000001>>%YCP%SSsz.reg
echo "EnableUIADesktopToggle"=dword^:00000000>>%YCP%SSsz.reg
echo "EnableVirtualization"=dword^:00000001>>%YCP%SSsz.reg
echo "PromptOnSecureDesktop"=dword^:00000001>>%YCP%SSsz.reg
echo "ValidateAdminCodeSignatures"=dword^:00000000>>%YCP%SSsz.reg
echo "dontdisplaylastusername"=dword^:00000000>>%YCP%SSsz.reg
echo "legalnoticecaption"=" ">>%YCP%SSsz.reg
echo "legalnoticetext"=" ">>%YCP%SSsz.reg
echo "scforceoption"=dword^:00000000>>%YCP%SSsz.reg
echo "shutdownwithoutlogon"=dword^:00000001>>%YCP%SSsz.reg
echo "ForceAutoLogon"=dword^:00000001>>%YCP%SSsz.reg
echo "undockwithoutlogon"=dword^:00000001>>%YCP%SSsz.reg
echo [-HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System\Audit]>>%YCP%SSsz.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System\Audit]>>%YCP%SSsz.reg
echo [-HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System\UIPI]>>%YCP%SSsz.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System\UIPI]>>%YCP%SSsz.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System\UIPI\Clipboard]>>%YCP%SSsz.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows\CurrentVersion\Policies\System\UIPI\Clipboard\ExceptionFormats]>>%YCP%SSsz.reg
echo "CF_BITMAP"=dword^:00000002>>%YCP%SSsz.reg
echo "CF_DIB"=dword^:00000008>>%YCP%SSsz.reg
echo "CF_DIBV5"=dword^:00000011>>%YCP%SSsz.reg
echo "CF_OEMTEXT"=dword^:00000007>>%YCP%SSsz.reg
echo "CF_PALETTE"=dword^:00000009>>%YCP%SSsz.reg
echo "CF_TEXT"=dword^:00000001>>%YCP%SSsz.reg
echo "CF_UNICODETEXT"=dword^:0000000d>>%YCP%SSsz.reg
echo.>>%YCP%SSsz.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows NT\CurrentVersion\Winlogon]>>%YCP%SSsz.reg
echo "ReportBootOk"="0">>%YCP%SSsz.reg
echo "Shell"="explorer.exe">>%YCP%SSsz.reg
echo "PreCreateKnownFolders"="{A520A1A4-1780-4FF6-BD18-167343C5AF16}">>%YCP%SSsz.reg
echo "Userinit"="%%SYSTEMROOT%%\\system32\\userinit.exe">>%YCP%SSsz.reg
echo "VMApplet"="SystemPropertiesPerformance.exe /pagefile">>%YCP%SSsz.reg
echo "AutoRestartShell"=dword^:00000001>>%YCP%SSsz.reg
echo "CachedLogonsCount"="10">>%YCP%SSsz.reg
echo "DebugServerCommand"="no">>%YCP%SSsz.reg
echo "ForceUnlockLogon"=dword^:00000000>>%YCP%SSsz.reg
echo "legalnoticecaption"=" ">>%YCP%SSsz.reg
echo "legalnoticetext"=" ">>%YCP%SSsz.reg
echo "PasswordExpiryWarning"=dword^:00000005>>%YCP%SSsz.reg
echo "PowerdownAfterShutdown"="0">>%YCP%SSsz.reg
echo "ShutdownWithoutLogon"="0">>%YCP%SSsz.reg
echo "WinStationsDisabled"="0">>%YCP%SSsz.reg
echo "DisableCAD"=dword^:00000001>>%YCP%SSsz.reg
echo "scremoveoption"="0">>%YCP%SSsz.reg
echo "ShutdownFlags"=dword^:0000002b>>%YCP%SSsz.reg
echo "AutoAdminLogon"="1">>%YCP%SSsz.reg
echo "ForceAutoLogon"=dword^:00000001>>%YCP%SSsz.reg
echo "DefaultUserName"="Administrator">>%YCP%SSsz.reg
echo "DefaultPassword"="">>%YCP%SSsz.reg
echo.>>%YCP%SSsz.reg
regedit /s %YCP%SSsz.reg >nul
if exist %YCP%SSsz.reg del /q %YCP%SSsz.reg
echo.
echo   ����IE��ǿ Ctrl+Alt+Del ��¼ǰ�ɹػ� Ϊ������������ �رշ���������������� ...
echo.
reg add "HKLM\0\Wow6432Node\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows NT\Reliability" /v "ShutdownreasonOn" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\policies\system" /v "shutdownwithoutlogon" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\ServerManager" /v "DoNotOpenServerManagerAtLogon" /t REG_DWORD /d 1 /f>nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul
reg add "HKLM\0\SYSTEM\ControlSet001\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\SYSTEM\CurrentControlSet\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0>nul
reg load HKLM\0 "%MOU%\Windows\System32\config\SYSTEM">nul
reg add "HKLM\0\ControlSet001\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\ControlSet002\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0>nul
echo.
echo   Ϊ������ϵͳ Administrator �˻���װ ������Ҫ�Զ��������¼��� ��
echo.
ping -n 6 127.1>nul
)
cls
goto MENU

:ZTSZ
title  %dqwz% ��������ΪĬ������ %dqcd%45
echo.
echo   %dqwz% ��������ΪĬ������ %dqcd%45
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   Win10ϵͳ ��������ΪĬ�������ָ�Ĭ���ź�����
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo Windows Registry Editor Version 5.00>%YCP%MRZT.reg
echo.>>%YCP%MRZT.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows NT\CurrentVersion\Fonts]>>%YCP%MRZT.reg
echo "Microsoft YaHei & Microsoft YaHei UI (TrueType)"="msyh.ttc">>%YCP%MRZT.reg
echo Windows Registry Editor Version 5.00>%YCP%ZTSZ.reg
echo.>>%YCP%ZTSZ.reg
echo [HKEY_LOCAL_MACHINE\0\Microsoft\Windows NT\CurrentVersion\Fonts]>>%YCP%ZTSZ.reg
echo "Microsoft YaHei & Microsoft YaHei UI (TrueType)"="simsun.ttc">>%YCP%ZTSZ.reg
set mrzt=0
set /p mrzt=Ҫ��ΪĬ�������밴1  �ָ�Ĭ���ź���ֱ�ӻس���
if "%mrzt%"=="0" regedit /s %YCP%MRZT.reg
if "%mrzt%"=="1" regedit /s %YCP%ZTSZ.reg
reg unload HKLM\0>nul
if exist %YCP%MRZT.reg del /q %YCP%MRZT.reg
if exist %YCP%ZTSZ.reg del /q %YCP%ZTSZ.reg
Xcopy /y %YCP%MY\�ָ�Ĭ������.reg %MOU%\Users\Public\Desktop\ 2>nul
title  %dqwc% ��������ΪĬ������
echo.
echo   ��������ΪĬ�������ָ�Ĭ���ź����������� ���򷵻����˵�
echo.
echo.
ping -n 5 127.1>nul
cls
goto MENU

:SDJJ
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% �����ʶȾ��� %dqcd%27
echo.
echo   %dqwz% �����ʶȾ��� %dqcd%27
echo.
echo  00  �Ƴ�WinSxS�в�������ʱ����...
echo.
if exist "%MOU%\Windows\System32\en-US\Licenses\_Default\%MEID%\license.rtf" Xcopy /y "%MOU%\Windows\System32\en-US\Licenses\_Default\%MEID%\license.rtf" %MOU%\Windows\System32\
if exist "%MOU%\Windows\System32\en-US\Licenses\Volume\%MEID%\license.rtf" Xcopy /y "%MOU%\Windows\System32\en-US\Licenses\Volume\%MEID%\license.rtf" %MOU%\Windows\System32\
if exist "%MOU%\Windows\System32\zh-CN\Licenses\_Default\%MEID%\license.rtf" (
Xcopy /y "%MOU%\Windows\System32\zh-CN\Licenses\_Default\%MEID%\license.rtf" %MOU%\Windows\System32\
) ELSE (
Xcopy /y "%MOU%\Windows\System32\zh-CN\Licenses\Volume\%MEID%\license.rtf" %MOU%\Windows\System32\
)
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell" (
cmd.exe /c takeown /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell" /r /d y && icacls "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"
)
if exist "%MOU%\ProgramData\Microsoft\Windows Live" (
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Live" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Live" /grant administrators:F /t
RMDIR /S /Q "%MOU%\ProgramData\Microsoft\Windows Live"
)
if exist "%MOU%\Logs" (
cmd.exe /c takeown /f "%MOU%\Logs" /r /d y && icacls "%MOU%\Logs" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Logs"
)
if exist %MOU%\Windows\WinSxS\ManifestCache (
cmd.exe /c takeown /f "%MOU%\Windows\WinSxS\ManifestCache" /r /d y && icacls "%MOU%\Windows\WinSxS\ManifestCache" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\WinSxS\ManifestCache"
)
if exist %MOU%\Users\Administrator\Favorites (
cmd.exe /c takeown /f "%MOU%\Users\Administrator\Favorites" /r /d y && icacls "%MOU%\Users\Administrator\Favorites" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Administrator\Favorites"
Rd /S /Q "%MOU%\Users\Administrator\Favorites"
cmd.exe /c takeown /f "%MOU%\Users\Public\Recorded TV\Sample Media" /r /d y && icacls "%MOU%\Users\Public\Recorded TV\Sample Media" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Recorded TV\Sample Media"
cmd.exe /c takeown /f "%MOU%\Users\Public\Videos\Sample Videos" /r /d y && icacls "%MOU%\Users\Public\Videos\Sample Videos" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Videos\Sample Videos"
cmd.exe /c takeown /f "%MOU%\Users\Public\Music\Sample Music" /r /d y && icacls "%MOU%\Users\Public\Music\Sample Music" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Music\Sample Music"
cmd.exe /c takeown /f "%MOU%\Users\Public\Pictures" /r /d y && icacls "%MOU%\Users\Public\Pictures" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Users\Public\Pictures"
)
echo.
echo  01  �Ƴ�BACKUP����...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\WinSxS\Backup" /r /d y && icacls "%MOU%\Windows\WinSxS\Backup" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\WinSxS\Backup"
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk" del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk"
if exist "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk" del /q /f "%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\Windows Defender.lnk"
if exist "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget" del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget"
cmd.exe /c takeown /f "%MOU%\Windows\Setup" /r /d y && icacls "%MOU%\Windows\Setup" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Branding\Shellbrd" /r /d y && icacls "%MOU%\Windows\Branding\Shellbrd" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\PerfLogs" /r /d y && icacls "%MOU%\PerfLogs" /grant administrators:F /t
RD /Q /S "%MOU%\PerfLogs"
RMDIR /S /Q "%MOU%\Users\Default\Links"
del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Help.lnk"
del /q /f "%MOU%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Windows.Defender.lnk"
echo.
echo  02  �Ƴ�Ӣ�ļ���������Ȼ���Լ��������뷨����...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\IME" /r /d y && icacls "%MOU%\Windows\IME" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\IME\IMEJP" /r /d y && icacls "%MOU%\Windows\IME\IMEJP" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\IME\IMEKR" /r /d y && icacls "%MOU%\Windows\IME\IMEKR" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\IME\IMETC" /r /d y && icacls "%MOU%\Windows\IME\IMETC" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\IME\IMEJP"
RMDIR /S /Q "%MOU%\Windows\IME\IMEKR"
RMDIR /S /Q "%MOU%\Windows\IME\IMETC"
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME" /r /d y && icacls "%MOU%\Windows\System32\IME" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME\IMEJP" /r /d y && icacls "%MOU%\Windows\System32\IME\IMEJP" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME\IMEKR" /r /d y && icacls "%MOU%\Windows\System32\IME\IMEKR" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\IME\IMETC" /r /d y && icacls "%MOU%\Windows\System32\IME\IMETC" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMEJP"
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMEKR"
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMETC"
if %OFFSYS% LEQ 7601 (
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMEJP10"
RMDIR /S /Q "%MOU%\Windows\System32\IME\imekr8"
RMDIR /S /Q "%MOU%\Windows\System32\IME\IMETC10"
RMDIR /S /Q "%MOU%\Windows\IME\IMEJP10"
RMDIR /S /Q "%MOU%\Windows\IME\imekr8"
RMDIR /S /Q "%MOU%\Windows\IME\IMETC10"
)
cmd.exe /c takeown /f "%MOU%\Windows\InputMethod" /r /d y && icacls "%MOU%\Windows\InputMethod" /grant administrators:F /t
if exist "%MOU%\Windows\zh-CN" RMDIR /S /Q "%MOU%\Windows\InputMethod\CHT"
RMDIR /S /Q "%MOU%\Windows\InputMethod\JPN"
RMDIR /S /Q "%MOU%\Windows\InputMethod\KOR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\InputMethod" /r /d y && icacls "%MOU%\Windows\System32\InputMethod" /grant administrators:F /t
if exist "%MOU%\Windows\zh-CN" RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\CHT"
RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\JPN"
RMDIR /S /Q "%MOU%\Windows\System32\InputMethod\KOR"
sif exist %MOU%\Windows\SysWOW64 (
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\IME" /r /d y && icacls "%MOU%\Windows\SysWOW64\IME" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMEJP"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMEKR"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMETC"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMEJP10"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\imekr8"
RMDIR /S /Q "%MOU%\Windows\SysWOW64\IME\IMETC10"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\InputMethod" /r /d y && icacls "%MOU%\Windows\SysWOW64\InputMethod" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\InputMethod\JPN"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\ar-SA" /r /d y && icacls "%MOU%\Windows\SysWOW64\ar-SA" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\ar-SA"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\bg-BG" /r /d y && icacls "%MOU%\Windows\SysWOW64\bg-BG" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\bg-BG"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\cs-CZ" /r /d y && icacls "%MOU%\Windows\SysWOW64\cs-CZ" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\cs-CZ"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\da-DK" /r /d y && icacls "%MOU%\Windows\SysWOW64\da-DK" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\da-DK"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\de-DE" /r /d y && icacls "%MOU%\Windows\SysWOW64\de-DE" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\de-DE"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\el-GR" /r /d y && icacls "%MOU%\Windows\SysWOW64\el-GR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\el-GR"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\en-GB" /r /d y && icacls "%MOU%\Windows\SysWOW64\en-GB" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\en-GB"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\es-ES" /r /d y && icacls "%MOU%\Windows\SysWOW64\es-ES" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\es-ES"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\et-EE" /r /d y && icacls "%MOU%\Windows\SysWOW64\et-EE" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\et-EE"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\es-MX" /r /d y && icacls "%MOU%\Windows\SysWOW64\es-MX" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\es-MX"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\fr-CA" /r /d y && icacls "%MOU%\Windows\SysWOW64\fr-CA" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\fr-CA"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\fi-FI" /r /d y && icacls "%MOU%\Windows\SysWOW64\fi-FI" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\fi-FI"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\fr-FR" /r /d y && icacls "%MOU%\Windows\SysWOW64\fr-FR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\fr-FR"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\he-IL" /r /d y && icacls "%MOU%\Windows\SysWOW64\he-IL" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\he-IL"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\hr-HR" /r /d y && icacls "%MOU%\Windows\SysWOW64\hr-HR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\hr-HR"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\hu-HU" /r /d y && icacls "%MOU%\Windows\SysWOW64\hu-HU" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\hu-HU"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\ja-JP" /r /d y && icacls "%MOU%\Windows\SysWOW64\ja-JP" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\ja-JP"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\ko-KR" /r /d y && icacls "%MOU%\Windows\SysWOW64\ko-KR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\ko-KR"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\it-IT" /r /d y && icacls "%MOU%\Windows\SysWOW64\it-IT" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\it-IT"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\lt-LT" /r /d y && icacls "%MOU%\Windows\SysWOW64\lt-LT" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\lt-LT"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\lv-LV" /r /d y && icacls "%MOU%\Windows\SysWOW64\lv-LV" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\lv-LV"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\nb-NO" /r /d y && icacls "%MOU%\Windows\SysWOW64\nb-NO" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\nb-NO"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\nl-NL" /r /d y && icacls "%MOU%\Windows\SysWOW64\nl-NL" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\nl-NL"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\pl-PL" /r /d y && icacls "%MOU%\Windows\SysWOW64\pl-PL" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\pl-PL"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\pt-BR" /r /d y && icacls "%MOU%\Windows\SysWOW64\pt-BR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\pt-BR"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\pt-PT" /r /d y && icacls "%MOU%\Windows\SysWOW64\pt-PT" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\pt-PT"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\ro-RO" /r /d y && icacls "%MOU%\Windows\SysWOW64\ro-RO" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\ro-RO"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\ru-RU" /r /d y && icacls "%MOU%\Windows\SysWOW64\ru-RU" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\ru-RU"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\sk-SK" /r /d y && icacls "%MOU%\Windows\SysWOW64\sk-SK" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\sk-SK"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\sl-SI" /r /d y && icacls "%MOU%\Windows\SysWOW64\sl-SI" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\sl-SI"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\sr-Latn-CS" /r /d y && icacls "%MOU%\Windows\SysWOW64\sr-Latn-CS" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\sr-Latn-CS"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\sr-Latn-RS" /r /d y && icacls "%MOU%\Windows\SysWOW64\sr-Latn-RS" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\sr-Latn-RS"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\sv-SE" /r /d y && icacls "%MOU%\Windows\SysWOW64\sv-SE" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\sv-SE"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\th-TH" /r /d y && icacls "%MOU%\Windows\SysWOW64\th-TH" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\th-TH"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\tr-TR" /r /d y && icacls "%MOU%\Windows\SysWOW64\tr-TR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\tr-TR"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\uk-UA" /r /d y && icacls "%MOU%\Windows\SysWOW64\uk-UA" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\uk-UA"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-HK" /r /d y && icacls "%MOU%\Windows\SysWOW64\zh-HK" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SysWOW64\zh-HK"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-TW" /r /d y && icacls "%MOU%\Windows\SysWOW64\zh-TW" /grant administrators:F /t
if exist "%MOU%\Windows\zh-CN" RMDIR /S /Q "%MOU%\Windows\SysWOW64\zh-TW"
)
cmd.exe /c takeown /f "%MOU%\Program Files\Common Files\microsoft shared\ink" /r /d y && icacls "%MOU%\Program Files\Common Files\microsoft shared\ink" /grant administrators:F /t
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\mshwchsr.dll"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\mraut.dll"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\chslm.wdic2.bin"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwrusash.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwrusalm.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwruksh.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\micaut.dll"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwruklm.dat"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\FlickAnimation.avi"
del /q /f "%MOU%\Program Files\Common Files\microsoft shared\ink\hwrusash.dat"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\ar-SA"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\bg-BG"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\cs-CZ"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\da-DK"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\de-DE"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\el-GR"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\en-GB"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\es-ES"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\et-EE"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\es-MX"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\fr-CA"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\fi-FI"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\fr-FR"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\he-IL"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\hr-HR"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\hu-HU"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\ja-JP"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\ko-KR"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\it-IT"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\lt-LT"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\lv-LV"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\nb-NO"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\nl-NL"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\pl-PL"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\pt-BR"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\pt-PT"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\ro-RO"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\ru-RU"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\sk-SK"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\sl-SI"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\sr-Latn-CS"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\sr-Latn-RS"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\sv-SE"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\th-TH"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\tr-TR"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\uk-UA"
RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\zh-HK"
if exist "%MOU%\Windows\zh-CN" RMDIR /S /Q "%MOU%\Program Files\Common Files\microsoft shared\ink\zh-TW"
cmd.exe /c takeown /f "%MOU%\Windows\System32\ar-SA" /r /d y && icacls "%MOU%\Windows\System32\ar-SA" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\ar-SA"
cmd.exe /c takeown /f "%MOU%\Windows\System32\bg-BG" /r /d y && icacls "%MOU%\Windows\System32\bg-BG" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\bg-BG"
cmd.exe /c takeown /f "%MOU%\Windows\System32\cs-CZ" /r /d y && icacls "%MOU%\Windows\System32\cs-CZ" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\cs-CZ
cmd.exe /c takeown /f "%MOU%\Windows\System32\da-DK" /r /d y && icacls "%MOU%\Windows\System32\da-DK" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\da-DK"
cmd.exe /c takeown /f "%MOU%\Windows\System32\de-DE" /r /d y && icacls "%MOU%\Windows\System32\de-DE" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\de-DE"
cmd.exe /c takeown /f "%MOU%\Windows\System32\el-GR" /r /d y && icacls "%MOU%\Windows\System32\el-GR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\el-GR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\en-GB" /r /d y && icacls "%MOU%\Windows\System32\en-GB" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\en-GB"
cmd.exe /c takeown /f "%MOU%\Windows\System32\es-ES" /r /d y && icacls "%MOU%\Windows\System32\es-ES" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\es-ES"
cmd.exe /c takeown /f "%MOU%\Windows\System32\es-MX" /r /d y && icacls "%MOU%\Windows\System32\es-MX" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\es-MX"
cmd.exe /c takeown /f "%MOU%\Windows\System32\et-EE" /r /d y && icacls "%MOU%\Windows\System32\et-EE" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\et-EE"
cmd.exe /c takeown /f "%MOU%\Windows\System32\fi-FI" /r /d y && icacls "%MOU%\Windows\System32\fi-FI" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\fi-FI"
cmd.exe /c takeown /f "%MOU%\Windows\System32\fr-CA" /r /d y && icacls "%MOU%\Windows\System32\fr-CA" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\fr-CA"
cmd.exe /c takeown /f "%MOU%\Windows\System32\fr-FR" /r /d y && icacls "%MOU%\Windows\System32\fr-FR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\fr-FR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\he-IL" /r /d y && icacls "%MOU%\Windows\System32\he-IL" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\he-IL"
cmd.exe /c takeown /f "%MOU%\Windows\System32\hr-HR" /r /d y && icacls "%MOU%\Windows\System32\hr-HR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\hr-HR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\hu-HU" /r /d y && icacls "%MOU%\Windows\System32\hu-HU" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\hu-HU"
cmd.exe /c takeown /f "%MOU%\Windows\System32\ja-JP" /r /d y && icacls "%MOU%\Windows\System32\ja-JP" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\ja-JP"
cmd.exe /c takeown /f "%MOU%\Windows\System32\ko-KR" /r /d y && icacls "%MOU%\Windows\System32\ko-KR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\ko-KR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\it-IT" /r /d y && icacls "%MOU%\Windows\System32\it-IT" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\it-IT"
cmd.exe /c takeown /f "%MOU%\Windows\System32\lt-LT" /r /d y && icacls "%MOU%\Windows\System32\lt-LT" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\lt-LT"
cmd.exe /c takeown /f "%MOU%\Windows\System32\lv-LV" /r /d y && icacls "%MOU%\Windows\System32\lv-LV" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\lv-LV"
cmd.exe /c takeown /f "%MOU%\Windows\System32\nb-NO" /r /d y && icacls "%MOU%\Windows\System32\nb-NO" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\nb-NO"
cmd.exe /c takeown /f "%MOU%\Windows\System32\nl-NL" /r /d y && icacls "%MOU%\Windows\System32\nl-NL" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\nl-NL"
cmd.exe /c takeown /f "%MOU%\Windows\System32\pl-PL" /r /d y && icacls "%MOU%\Windows\System32\pl-PL" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\pl-PL"
cmd.exe /c takeown /f "%MOU%\Windows\System32\pt-BR" /r /d y && icacls "%MOU%\Windows\System32\pt-BR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\pt-BR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\pt-PT" /r /d y && icacls "%MOU%\Windows\System32\pt-PT" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\pt-PT"
cmd.exe /c takeown /f "%MOU%\Windows\System32\ro-RO" /r /d y && icacls "%MOU%\Windows\System32\ro-RO" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\ro-RO"
cmd.exe /c takeown /f "%MOU%\Windows\System32\ru-RU" /r /d y && icacls "%MOU%\Windows\System32\ru-RU" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\ru-RU"
cmd.exe /c takeown /f "%MOU%\Windows\System32\sk-SK" /r /d y && icacls "%MOU%\Windows\System32\sk-SK" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\sk-SK"
cmd.exe /c takeown /f "%MOU%\Windows\System32\sl-SI" /r /d y && icacls "%MOU%\Windows\System32\sl-SI" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\sl-SI"
cmd.exe /c takeown /f "%MOU%\Windows\System32\sr-Latn-CS" /r /d y && icacls "%MOU%\Windows\System32\sr-Latn-CS" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\sr-Latn-CS"
cmd.exe /c takeown /f "%MOU%\Windows\System32\sr-Latn-RS" /r /d y && icacls "%MOU%\Windows\System32\sr-Latn-RS" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\sr-Latn-RS"
cmd.exe /c takeown /f "%MOU%\Windows\System32\sv-SE" /r /d y && icacls "%MOU%\Windows\System32\sv-SE" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\sv-SE"
cmd.exe /c takeown /f "%MOU%\Windows\System32\th-TH" /r /d y && icacls "%MOU%\Windows\System32\th-TH" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\th-TH"
cmd.exe /c takeown /f "%MOU%\Windows\System32\tr-TR" /r /d y && icacls "%MOU%\Windows\System32\tr-TR" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\tr-TR"
cmd.exe /c takeown /f "%MOU%\Windows\System32\uk-UA" /r /d y && icacls "%MOU%\Windows\System32\uk-UA" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\uk-UA"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-HK" /r /d y && icacls "%MOU%\Windows\System32\zh-HK" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\zh-HK"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-TW" /r /d y && icacls "%MOU%\Windows\System32\zh-TW" /grant administrators:F /t
if exist "%MOU%\Windows\zh-CN" RMDIR /S /Q "%MOU%\Windows\System32\zh-TW"
cmd.exe /c takeown /f "%MOU%\Windows\System32\en" /r /d y && icacls "%MOU%\Windows\System32\en" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\en"
echo.
echo  04 �����������...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Performance\WinSAT" /r /d y && icacls "%MOU%\Windows\Performance\WinSAT" /grant administrators:F /t
del /q /f %MOU%\Windows\Performance\WinSAT\*.mpg
del /q /f %MOU%\Windows\Performance\WinSAT\*.wmv
del /q /f %MOU%\Windows\Performance\WinSAT\*.mp4
echo.
echo  05 ɾ���߶Աȶ����⼰4K...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\ReSources" /r /d y && icacls "%MOU%\Windows\ReSources" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Themes" /r /d y && icacls "%MOU%\Windows\Resources\Themes" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Maps" /r /d y && icacls "%MOU%\Windows\Resources\Maps" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Resources\Maps"
cmd.exe /c takeown /f "%MOU%\Windows\Resources\Ease of Access Themes" /r /d y && icacls "%MOU%\Windows\Resources\Ease of Access Themes" /grant administrators:F /t
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hc1.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hc1.theme"
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hc2.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hc2.theme"
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hcblack.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hcblack.theme"
IF exist "%MOU%\Windows\Resources\Ease of Access Themes\hcwhite.theme" del /q /f "%MOU%\Windows\Resources\Ease of Access Themes\hcwhite.theme"
IF not exist "%MOU%\Windows\Resources\Ease of Access Themes\*.theme" RD /S /Q "%MOU%\Windows\Resources\Ease of Access Themes"
cmd.exe /c takeown /f "%MOU%\Windows\Web" /r /d y && icacls "%MOU%\Windows\Web" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\Web\4K" /r /d y && icacls "%MOU%\Windows\Web\4K" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Web\4K"
echo.
echo  06 ɾ�����������...
echo.
del /q /f %MOU%\Windows\Web\Screen\img101.png
del /q /f %MOU%\Windows\Web\Screen\img102.jpg
del /q /f %MOU%\Windows\Web\Screen\img103.png
del /q /f %MOU%\Windows\Web\Screen\img104.jpg
del /q /f %MOU%\Windows\Web\Screen\img105.jpg
if exist %MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg (
cmd.exe /c takeown /f MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg && icacls %MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg /grant administrators:F /t
copy /y %YCP%MY\IMG\img0.jpg %MOU%\Users\Administrator\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper.jpg
)
echo.
echo  07 �Ƴ�������豸������...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\BitLockerDiscoveryVolumeContents" /r /d y && icacls "%MOU%\Windows\BitLockerDiscoveryVolumeContents" /grant administrators:F /t
if not exist %YCP%BTG md %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\autorun.inf %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\BitLockerToGo.exe %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\en-US_BitLockerToGo.exe.mui %YCP%BTG
Xcopy /y /h "%MOU%\Windows\BitLockerDiscoveryVolumeContents\Read Me.url" %YCP%BTG
Xcopy /y /h %MOU%\Windows\BitLockerDiscoveryVolumeContents\zh-CN_BitLockerToGo.exe.mui %YCP%BTG
RMDIR /S /Q "%MOU%\Windows\BitLockerDiscoveryVolumeContents"
del /q /f %MOU%\Windows\BitLockerDiscoveryVolumeContents\*.*
if not exist %MOU%\Windows\BitLockerDiscoveryVolumeContents md %MOU%\Windows\BitLockerDiscoveryVolumeContents
Xcopy /y /h "%YCP%BTG\*.*" %MOU%\Windows\BitLockerDiscoveryVolumeContents\ &&attrib +s +h %MOU%\Windows\BitLockerDiscoveryVolumeContents
RMDIR /S /Q "%YCP%BTG"
if exist %MOU%\Windows\Globalization (
echo.
echo   08 �Ƴ��Դ��й���ֽ����...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Globalization\MCT\MCT-CN" /r /d y && icacls "%MOU%\Windows\Globalization\MCT\MCT-CN" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Globalization\MCT\MCT-CN"
)
if exist "%MOU%\Program Files\Microsoft Games" (
echo.
echo   09 �Ƴ���Ϸ����...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Globalization\MCT\MCT-CN" /r /d y && icacls "%MOU%\Windows\Globalization\MCT\MCT-CN" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Globalization\MCT\MCT-CN"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\Chess" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\Chess" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\Chess"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\FreeCell" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\FreeCell" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\FreeCell"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\Hearts" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\Hearts" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\Hearts"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\Mahjong" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\Mahjong" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\Mahjong"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\Minesweeper" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\Minesweeper" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\Minesweeper"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\More Games" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\More Games" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\More Games"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\Multiplayer" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\Multiplayer" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\Multiplayer"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\Purble Place" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\Purble Place" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\Purble Place"
cmd.exe /c takeown /f "%MOU%\Program Files\Microsoft Games\SpiderSolitaire" /r /d y && icacls "%MOU%\Program Files\Microsoft Games\SpiderSolitaire" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Microsoft Games\SpiderSolitaire"
)
if exist "%MOU%\Program Files\DVD Maker" (
echo.
echo   10 �Ƴ�DVD Maker�е�����...
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\DVD Maker" /r /d y && icacls "%MOU%\Program Files\DVD Maker" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\DVD Maker"
)
echo.
echo   11 �����Ա���ļ���ʼ�˵�...
echo.
if exist %MOU%\Windows\SystemApps\Microsoft.PPIProjection_cw5n1h2txyewy (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.PPIProjection_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.PPIProjection_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.PPIProjection_cw5n1h2txyewy"
)
if exist %MOU%\Windows\SystemApps\ContactSupport_cw5n1h2txyewy (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\ContactSupport_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\ContactSupport_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\ContactSupport_cw5n1h2txyewy"
)
if exist %MOU%\Windows\SystemApps\WindowsFeedback_cw5n1h2txyewy (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\WindowsFeedback_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\WindowsFeedback_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\WindowsFeedback_cw5n1h2txyewy"
)
if exist %MOU%\Windows\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy"
)
if exist %MOU%\Windows\SystemApps\Microsoft.XboxIdentityProvider_cw5n1h2txyewy (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.XboxIdentityProvider_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.XboxIdentityProvider_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.XboxIdentityProvider_cw5n1h2txyewy"
)
if exist %MOU%\Windows\SystemResources\Windows.UI.BioFeedback (
cmd.exe /c takeown /f "%MOU%\Windows\SystemResources\Windows.UI.BioFeedback" /r /d y && icacls "%MOU%\Windows\SystemResources\Windows.UI.BioFeedback" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemResources\Windows.UI.BioFeedback"
)
if exist %MOU%\Windows\SystemApps\InsiderHub_cw5n1h2txyewy (
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\InsiderHub_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\InsiderHub_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\InsiderHub_cw5n1h2txyewy"
)
echo.
echo   12 �������ķ�������...
echo.
cmd.exe /c takeown /f %MOU%\Windows\Fonts\mingliub.ttc && icacls %MOU%\Windows\Fonts\mingliub.ttc /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\msjhbd.ttc && icacls %MOU%\Windows\Fonts\msjhbd.ttc /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\msjhl.ttc && icacls %MOU%\Windows\Fonts\msjhl.ttc /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\calibrib.ttf && icacls %MOU%\Windows\Fonts\calibrib.ttf /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\malgunbd.ttf && icacls %MOU%\Windows\Fonts\malgunbd.ttf /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\msgothic.ttc && icacls %MOU%\Windows\Fonts\msgothic.ttc /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\msyhbd.ttc && icacls %MOU%\Windows\Fonts\msyhbd.ttc /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\NirmalaB.ttf && icacls %MOU%\Windows\Fonts\NirmalaB.ttf /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\Fonts\YuGothB.ttc && icacls %MOU%\Windows\Fonts\YuGothB.ttc /grant administrators:F /t
del /q /f %MOU%\Windows\Fonts\mingliub.ttc
del /q /f %MOU%\Windows\Fonts\msjhbd.ttc
del /q /f %MOU%\Windows\Fonts\msjhl.ttc
del /q /f %MOU%\Windows\Fonts\calibrib.ttf
del /q /f %MOU%\Windows\Fonts\malgunbd.ttf
del /q /f %MOU%\Windows\Fonts\msgothic.ttc
del /q /f %MOU%\Windows\Fonts\msyhbd.ttc
del /q /f %MOU%\Windows\Fonts\NirmalaB.ttf
del /q /f %MOU%\Windows\Fonts\YuGothB.ttc
echo.
echo   13 ɾ�����õ�����...
echo.
cmd.exe /c takeown /f %MOU%\Windows\System32\Mystify.scr && icacls %MOU%\Windows\System32\Mystify.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\System32\Ribbons.scr && icacls %MOU%\Windows\System32\Ribbons.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\System32\ssText3d.scr && icacls %MOU%\Windows\System32\ssText3d.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\System32\scrnsave.scr && icacls %MOU%\Windows\System32\scrnsave.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\System32\Bubbles.scr && icacls %MOU%\Windows\System32\Bubbles.scr /grant administrators:F /t
del /q /f %MOU%\Windows\System32\Mystify.scr >nul
del /q /f %MOU%\Windows\System32\Ribbons.scr >nul
del /q /f %MOU%\Windows\System32\ssText3d.scr >nul
del /q /f %MOU%\Windows\System32\Bubbles.scr >nul
del /q /f %MOU%\Windows\System32\scrnsave.scr >nul
if exist %MOU%\Windows\SysWOW64 (
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\Mystify.scr && icacls %MOU%\Windows\SysWOW64\Mystify.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\Ribbons.scr && icacls %MOU%\Windows\SysWOW64\Ribbons.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\ssText3d.scr && icacls %MOU%\Windows\SysWOW64\ssText3d.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\scrnsave.scr && icacls %MOU%\Windows\SysWOW64\scrnsave.scr /grant administrators:F /t
cmd.exe /c takeown /f %MOU%\Windows\SysWOW64\Bubbles.scr && icacls %MOU%\Windows\SysWOW64\Bubbles.scr /grant administrators:F /t
del /q /f %MOU%\Windows\SysWOW64\Mystify.scr >nul
del /q /f %MOU%\Windows\SysWOW64\Ribbons.scr >nul
del /q /f %MOU%\Windows\SysWOW64\ssText3d.scr >nul
del /q /f %MOU%\Windows\SysWOW64\Bubbles.scr >nul
del /q /f %MOU%\Windows\SysWOW64\scrnsave.scr >nul
)
for /r %MOU%\Windows\WinSxS %%i in (mingliub.ttc msjhbd.ttc msjhl.ttc calibrib.ttf malgunbd.ttf msgothic.ttc msyhbd.ttc YuGothB.ttc) do (if exist %%i del "%%i" /q /f )
if exist %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml (
echo.
echo   14 ͳһ����ͼ��...
echo.
cmd.exe /c takeown /f %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml && icacls %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml /grant administrators:F /t
)
if exist %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml (
cmd.exe /c takeown /f %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml && icacls %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml /grant administrators:F /t
del /f /q %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml
)
if exist %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg (
echo.
echo   15 �滻Ĭ��������ֽ...
echo.
cmd.exe /c takeown /f %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg && icacls %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg /grant administrators:F /t
Xcopy /y %YCP%MY\IMG\asset.jpg %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\
)
echo.
echo   16 ����һЩ���õ�������ʾ����...
echo.
set File=%MOU%\Windows\Boot\Fonts
cmd.exe /c takeown /f "%MOU%\Windows\Boot\Fonts" /r /d y && icacls "%MOU%\Windows\Boot\Fonts" /grant administrators:F /t
for /f %%i in ('dir /a-d /b %File%\*_*.ttf') do echo %%i |findstr /i "chs_boot wgl4_boot msyh seg" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & del %File%\%%i /f /q)
set File=%MOU%\Windows\Boot\PCAT
cmd.exe /c takeown /f "%MOU%\Windows\Boot\PCAT" /r /d y && icacls "%MOU%\Windows\Boot\PCAT" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "zh-CN en-US qps-ploc" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
set File=%MOU%\Windows\Boot\EFI
cmd.exe /c takeown /f "%MOU%\Windows\Boot\EFI" /r /d y && icacls "%MOU%\Windows\Boot\EFI" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "zh-CN en-US qps-ploc" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
set File=%MOU%\Windows\Boot\PXE
cmd.exe /c takeown /f "%MOU%\Windows\Boot\PXE" /r /d y && icacls "%MOU%\Windows\Boot\PXE" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "zh-CN en-US qps-ploc" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
set File=%MOU%\Windows\Boot\Resources
cmd.exe /c takeown /f "%MOU%\Windows\Boot\Resources" /r /d y && icacls "%MOU%\Windows\Boot\Resources" /grant administrators:F /t
for /f %%i in ('dir /ad /b %File%\*-*') do echo %%i |findstr /i "zh-CN en-US qps-ploc" || (cmd.exe /c takeown /f %File%\%%i /r /d y & icacls %File%\%%i /grant administrators:f /t & rd %File%\%%i /s /q)
if exist %MOU%\Windows\Help (
echo.
echo   17 ������� HELP ����...
echo.
cmd.exe /c takeown /f %MOU%\Windows\HelpPane.exe && icacls %MOU%\Windows\HelpPane.exe /grant administrators:F /t
del /f /q %MOU%\Windows\HelpPane.exe
cmd.exe /c takeown /f "%MOU%\Windows\Help" /r /d y && icacls "%MOU%\Windows\Help" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Help"
)
if %OFFSYS% GEQ 14393 (
echo.
echo   18 Ϊ1703��������������...
echo.
cmd.exe /c takeown /f %MOU%\Windows\System32\drivers\etc\hosts && icacls %MOU%\Windows\System32\drivers\etc\hosts /grant administrators:F /t
Xcopy /y %YCP%MY\hosts %MOU%\Windows\System32\drivers\etc\
cmd.exe /c takeown /f "%MOU%\Program Files\Windows Security" /r /d y && icacls "%MOU%\Program Files\Windows Security" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\Windows Security"
cmd.exe /c takeown /f "%MOU%\ProgramData\WindowsHolographicDevices" /r /d y && icacls "%MOU%\ProgramData\WindowsHolographicDevices" /grant administrators:F /t
RMDIR /S /Q "%MOU%\ProgramData\WindowsHolographicDevices"
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Storage Health" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Storage Health" /grant administrators:F /t
RMDIR /S /Q "%MOU%\ProgramData\Microsoft\Storage Health"
cmd.exe /c takeown /f "%MOU%\Windows\System32\WinBioPlugIns" /r /d y && icacls "%MOU%\Windows\System32\WinBioPlugIns" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\WinBioPlugIns"
)
title  %dqwc% �����ʶȾ��� %dqcd%27
echo.
echo        ͨ�õ��ʶ��������������                   ���򷵻����˵�
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:ZDJJ
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% ��ʽ��ϵͳ��������+�����Ӽ��޾��� %dqcd%28 
echo.
echo  %dqwz% ��ʽ��ϵͳ��������+�����Ӽ��޾��� %dqcd%28  
echo.
echo   1  ����ϡ�����������������Լ�С��� ������Ӱ��������װ  ����ʱ��ϳ������ĵȴ�
echo.
echo        �ռ����ݹ���CPU���ڴ�ռ�ýϴ�  ���ޱ�Ҫ�������������� ��ʼ�ռ��������...
echo.
echo   2 ��Ҫ����MSԭ��ISO�� boot.wim �е������滻  Ӱ���������� ֻ�Ƽ������޾������  
echo.
echo        ȷ��Ҫִ�в�������������������       ��س���ʼִ���ռ���ȫ������������
echo.
echo  *** ��Ҫע����ǣ�װ��ISO״ֱ̬��ִ�з�������ȡISO\Sources\boot.wim �� %YCP% ***
echo.
set frfa=1
set /p frfa=��ѡ����Ҫʹ�õ��������򷽰�1��2 ֱ��Ĭ��1���������밴0�س���
if "%frfa%"=="2" goto BTFR
if "%frfa%"=="1" goto SFFR
if "%frfa%"=="0" goto MENU

:SFFR
title  %dqwz% ��ʽ��ϵͳ�����������޾��� %dqcd%28-1
cls
echo.
echo   1  ����ϡ�����������������Լ�С��� ������Ӱ��������װ  ����ʱ��ϳ������ĵȴ�
echo.
echo        �ռ����ݹ���CPU���ڴ�ռ�ýϴ�  ���ޱ�Ҫ�������������� ��ʼ�ռ��������...
echo.
echo   ��һ�׶�  �ռ�����ϡ��������ı�������
echo.
if exist %YCP%FileRepository (RMDIR /S /Q "%YCP%FileRepository") ELSE (md %YCP%FileRepository )
if not exist %YCP%FileRepository md %YCP%FileRepository
dir /b /ad "%MOU%\Windows\System32\DriverStore\FileRepository">%YCP%tmp.txt
set yd=%MOU%\Windows\System32\DriverStore\FileRepository
findstr /i /V /C:"1394." "%YCP%tmp.txt"|findstr /i /V /C:"61883."|findstr /i /V /C:"acpi"|findstr /i /V /C:"adp"|findstr /i /V /C:"af9035bda." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"agp." "%YCP%tmp.txt"|findstr /i /V /C:"amds"|findstr /i /V /C:"angel"|findstr /i /V /C:"arc"|findstr /i /V /C:"ati" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"avc." "%YCP%tmp.txt"|findstr /i /V /C:"aver"|findstr /i /V /C:"avmx64c."|findstr /i /V /C:"battery."|findstr /i /V /C:"bda." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"blbdrive." "%YCP%tmp.txt"|findstr /i /V /C:"brmf"|findstr /i /V /C:"bth"|findstr /i /V /C:"cdrom."|findstr /i /V /C:"circlass." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"compositebus." "%YCP%tmp.txt"|findstr /i /V /C:"cpu."|findstr /i /V /C:"crcdisk."|findstr /i /V /C:"cxfa"|findstr /i /V /C:"dc21x4vm." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"digitalmediadevice." "%YCP%tmp.txt"|findstr /i /V /C:"disk."|findstr /i /V /C:"display."|findstr /i /V /C:"divac"|findstr /i /V /C:"dot4" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"eaphost." "%YCP%tmp.txt"|findstr /i /V /C:"ehstor"|findstr /i /V /C:"elxstor."|findstr /i /V /C:"faxc"|findstr /i /V /C:"fdc." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"flpydisk." "%YCP%tmp.txt"|findstr /i /V /C:"gameport."|findstr /i /V /C:"hal."|findstr /i /V /C:"hcw"|findstr /i /V /C:"hdaud" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"hid" "%YCP%tmp.txt"|findstr /i /V /C:"hpoa1"|findstr /i /V /C:"hpsamd."|findstr /i /V /C:"iastorv."|findstr /i /V /C:"igdlh." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"iirsp." "%YCP%tmp.txt"|findstr /i /V /C:"iirsp2."|findstr /i /V /C:"image."|findstr /i /V /C:"input."|findstr /i /V /C:"ipmidrv." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"iscsi." "%YCP%tmp.txt"|findstr /i /V /C:"keyboard."|findstr /i /V /C:"ks."|findstr /i /V /C:"kscaptur."|findstr /i /V /C:"ksfilter." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"lsi_" "%YCP%tmp.txt"|findstr /i /V /C:"machine."|findstr /i /V /C:"mchgr."|findstr /i /V /C:"mcx2."|findstr /i /V /C:"mdmbtmdm." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"megasas" "%YCP%tmp.txt"|findstr /i /V /C:"megasr."|findstr /i /V /C:"memory."|findstr /i /V /C:"mf."|findstr /i /V /C:"modemcsa." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"monitor." "%YCP%tmp.txt"|findstr /i /V /C:"mpio."|findstr /i /V /C:"msclmd."|findstr /i /V /C:"msdri."|findstr /i /V /C:"msdsm." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"msdv." "%YCP%tmp.txt"|findstr /i /V /C:"mshdc."|findstr /i /V /C:"msmouse."|findstr /i /V /C:"msports."|findstr /i /V /C:"mstape." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"mtconfig." "%YCP%tmp.txt"|findstr /i /V /C:"multiprt."|findstr /i /V /C:"net"|findstr /i /V /C:"nfrd960."|findstr /i /V /C:"ntprint." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"nulhpopr." "%YCP%tmp.txt"|findstr /i /V /C:"nvraid."|findstr /i /V /C:"nv_"|findstr /i /V /C:"pcmcia."|findstr /i /V /C:"prnep" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"qd3" "%YCP%tmp.txt"|findstr /i /V /C:"ql"|findstr /i /V /C:"ramdisk."|findstr /i /V /C:"rawsilo."|findstr /i /V /C:"rdlsbuscbs." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"rdpbus." "%YCP%tmp.txt"|findstr /i /V /C:"rdvgwddm."|findstr /i /V /C:"ricoh."|findstr /i /V /C:"rndiscmp."|findstr /i /V /C:"sbp2." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"scrawpdo." "%YCP%tmp.txt"|findstr /i /V /C:"scsidev."|findstr /i /V /C:"sdbus."|findstr /i /V /C:"sensorsalsdriver."|findstr /i /V /C:"sffdisk." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"sisraid" "%YCP%tmp.txt"|findstr /i /V /C:"smartcrd."|findstr /i /V /C:"stexstor."|findstr /i /V /C:"sti."|findstr /i /V /C:"synth3dvsc." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"tape." "%YCP%tmp.txt"|findstr /i /V /C:"tdibth."|findstr /i /V /C:"term"|findstr /i /V /C:"tpm."|findstr /i /V /C:"transfercable." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"tsgenericusbdriver." "%YCP%tmp.txt"|findstr /i /V /C:"tsprint."|findstr /i /V /C:"tsusbhub"|findstr /i /V /C:"ts_generic."|findstr /i /V /C:"ts_wpdmtp." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"umbus." "%YCP%tmp.txt"|findstr /i /V /C:"umpass."|findstr /i /V /C:"unknown."|findstr /i /V /C:"usb"|findstr /i /V /C:"vhdmp." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"volsnap." "%YCP%tmp.txt"|findstr /i /V /C:"volume."|findstr /i /V /C:"vsmraid."|findstr /i /V /C:"v_mscdsc."|findstr /i /V /C:"wave." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"wceisvista." "%YCP%tmp.txt"|findstr /i /V /C:"wd."|findstr /i /V /C:"wdm"|findstr /i /V /C:"windowssideshowenhanceddriver."|findstr /i /V /C:"wnetvsc."|findstr /i /V /C:"prnms00" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"wpd" "%YCP%tmp.txt"|findstr /i /V /C:"ws"|findstr /i /V /C:"bus"|findstr /i /V /C:"wvmic."|findstr /i /V /C:"xcbdav."|findstr /i /V /C:"xnacc." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
echo.
echo   ���������ռ���� ��ȡȨ�޿�ʼ����ϡ�õ��������� ���Ժ�...
echo.
ping -n 3 127.1>nul
for /f "delims=" %%i in (%YCP%tmp.txt) do (cmd.exe /c takeown /f "%yd%\%%i" /r /d y & icacls "%yd%\%%i" /grant administrators:F /t & RD "%yd%\%%i" /s /q)
if exist "%YCP%tmp.txt" del /f/q "%YCP%tmp.txt"
title    %dqwc% ��ʽ��ϵͳ�����������޾��� %dqcd%28-1
echo.
echo   ϡ������������� Ϊ��ֹ��������ӳ� �ӳ�3���Ա�����
echo.
ping -n 3 127.1 >nul
cls
goto ABLY

:BTFR
title  %dqwz% ��ʽ��ϵͳ�����������޾��� %dqcd%28-2
cls
echo.
echo   2 ��Ҫ����MSԭ��ISO�� boot.wim �е������滻  Ӱ���������� ֻ�Ƽ������޾������  
echo.
echo        ȷ��Ҫִ�в�������������������       ��س���ʼִ���ռ���ȫ������������
echo.
echo   *** ��Ҫע����ǣ�װ��ISO״ֱ̬��ִ�з�������ȡISO\Sources\boot.wim �� %YCP% ***
echo.
echo   ��ʼ����Ȩ�޲�ִ���ռ���ȫ�������徫�����... ���Ժ򣡣���
echo.
if not exist %SOUR%boot.wim (
echo.
echo   ���ݴ����û�з��� %SOUR%boot.wim ��ȷ�����������ִ��  ���򷵻�
echo.
ping -n 5 127.1 >nul
cls
goto MENU
)
echo.
echo   �������������Կ�����ԭʼ����...
echo.
if not exist %YCP%FileRepositoryB md %YCP%FileRepositoryB
dir /b /ad "%MOU%\Windows\System32\DriverStore\FileRepository">>%YCP%Adfile.txt
set yc=%MOU%\Windows\System32\DriverStore\FileRepository
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "hdaudbus.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "hdaudio.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "hdaudss.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "display.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
for /f "delims=" %%a in (%YCP%Adfile.txt) do (echo "%%a"|find /i "displayoverride.inf_" &&Xcopy /y /e /k /h %yc%\%%a %YCP%FileRepositoryB\%%a\)
cmd.exe /c takeown /f "%MOU%\Windows\System32\DriverStore\FileRepository" /r /d y && icacls "%MOU%\Windows\System32\DriverStore\FileRepository" /grant administrators:F /t
cmd.exe /c takeown /f "%YCP%1\Windows\System32\DriverStore\FileRepository" /r /d y && icacls "%YCP%1\Windows\System32\DriverStore\FileRepository" /grant administrators:F /t
%YCP%TOOL\7z\7z x %SOUR%boot.wim -o.\ 1\Windows\System32\DriverStore\FileRepository>nul
if exist %YCP%1\Windows\System32\DriverStore\FileRepository XCOPY /y /S %YCP%1\Windows\System32\DriverStore\FileRepository\* FileRepository\
Xcopy /y /s %YCP%FileRepositoryB FileRepository\
rd /q /s %YCP%1
rd /q /s %YCP%FileRepositoryB
cmd.exe /c takeown /f "%MOU%\Windows\System32\DriverStore\FileRepository" /r /d y && icacls "%MOU%\Windows\System32\DriverStore\FileRepository" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\DriverStore\FileRepository"
cmd.exe /c takeown /f "%MOU%\Windows\System32\DriverStore" /r /d y && icacls "%MOU%\Windows\System32\DriverStore" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\System32\DriverStore\FileRepository"
move /y %YCP%FileRepository %MOU%\Windows\System32\DriverStore\
del /q /f %YCP%Adfile.txt
title  %dqwc% ��ʽ��ϵͳ�����������޾��� %dqcd%28-2
echo.
echo   ������������ɹ���� Ϊ��ֹ��������ӳ� �ӳ�3���Ա�����
echo.
ping -n 3 127.1>nul
cls
goto ABLY

:ABLY
cls
title  %dqwz% ��ʽ��ϵͳ���������Ӿ��� %dqcd%28-3
echo.
echo   �ڶ��׶�  ��ʼ��ȫ���������������ݲ�Ӱ�����в�����װ ���Ժ�...
echo.
echo   ���Ŀ¼��д���� ����ʼ������������ ���Ժ�...
echo.
if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v2.0.50727_64"
)
if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_32"
)
if exist %MOU%\Windows\SysWOW64 if exist "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" (
cmd.exe /c takeown /f "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /r /d y && icacls "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\assembly\NativeImages_v4.0.30319_64"
)
title  ��������Ԥ������� ���Ժ�...
cls
echo.
echo   �����׶� ��������Ԥ������� ���Ժ�...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\inf" /r /d y && icacls "%MOU%\Windows\inf" /grant administrators:F /t
del /q /f %MOU%\Windows\inf\*.PNF
for /r %MOU%\Windows\inf %%i in (*.pnf) do (if exist %%i del "%%i" /q /f )
cls
title  %dqwc% ��ʽ��ϵͳ�����������Ӽ��޾��� %dqcd%28-3
echo.
echo   ======================= �� ==================== �� =============================
echo.
echo    ����������Ϊֹ��Ϊ��ȫ������� ��ʱ�������˵���������ɱ�֤�������������в���
echo.
echo    ������������WinSxS���޾������ʧ�󲿷����   �������������ù��ܼ���������
echo.
echo    ȷ�ϼ����������WinSxS���޾���ֱ�ӻس� ��0�س����������˵� ���Ƽ�������������
echo.
set /p mqr=�����濼�ǲ�ȷ�Ͻ���β��� 0 ���ز˵� ȷ�ϼ����������WinSxS���޾���ֱ�ӻس���
if "%mqr%"=="0" goto MENU

:LITE
cls
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% WinSxS���޾��� %dqcd%29
echo.
echo   %dqwz% WinSxS���޾��� %dqcd%29
echo.
echo   ���ڽ���WinSxS���޾��������ռ�... 
echo.
echo   �������Ѿ���ȫϵͳ����ͨ�� ��������Ӱ�쵽����������װ ����ʱ��ϳ������ĵȴ��������
echo.
echo   �ռ����ݹ���CPU���ڴ�ռ�ýϴ�  ���ޱ�Ҫ�������������� ��ʼ�ռ��������...  ���Ժ򣡣���
echo.
dir /b /ad "%MOU%\Windows\WinSxS">%YCP%tmp.txt
set yc=%MOU%\Windows\WinSxS
if %OFFSYS% GTR 7601 goto LIT2

:LIT1
echo.
echo   Ϊ Windows 7 ����ϵͳ������������... ���Ժ�
echo.
findstr /i /V /C:"_acpi.inf_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-cmiadapter_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-cmitrustinfoinstallers_1122334455667788_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-f..allconfig-installer_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-g..decacheclean-canada_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-i..-setieinstalleddate_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-i..eoptionalcomponents_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-i..rnational-timezones_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-i..rnational-timezones_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-ie-gc-registeriepkeys_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-ie-iecleanup_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-ie-pdm-configuration_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-ie-pdm_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-ie-pdm_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-msmpeg2adec_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-msmpeg2enc.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-msmpeg2enc_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-msmpeg2vdec_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-r..s-regkeys-component_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-security-spp-installer_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-cmiplugin_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnss-api.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnss-api_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnss-publicapi_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnss-service_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnss-ux.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnss-ux_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmpnssui.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmpnssui_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_windowssearchcomponent_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.s...smart_card_library_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.s..rt_driver.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.s..se.scsi_port_driver_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.s..se.scsi_port_driver_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt

:LIT2
echo.
echo   ���� Windows 7 ����ϵͳͨ������... ���Ժ�
echo.
findstr /i /V /C:"_microsoft.vc80." "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.vc90." >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-com-dtc-runtime_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-cmisetup_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-cmisetup_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-cmi_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-dynamicvolumemanager_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-desktoptileresources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-deltacompressionengine_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-deltapackageexpander_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-drvstore_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-d..t-services-unattend_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-anytime-upgrade_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.gdiplus.systemcopy_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-help-datalayer_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-i..ntrolpanel.appxmain_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-luainstaller_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-msxml60_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-setup-unattend_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-shell32_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-m..tion-isolationlayer_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-naturallanguage6-base_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-p..ncetoolscommandline_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-naturallanguage6-base_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-packagemanager_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-pantherengine_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-security-spp-installer_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-servicingstack_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-t..platform-comruntime_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.c..ration.online.setup_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.c..-controls.resources_6595b64144ccf1df_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.common-controls_6595b64144ccf1df_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.gdiplus_6595b64144ccf1df_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.i..utomation.proxystub_6595b64144ccf1df_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft.windows.isolationautomation_6595b64144ccf1df_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-oobe-firstlogonanim_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-oobe-firstlogonanimexe_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft.windows.s..ation.badcomponents_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-s..cingstack.resources_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-s..icing-adm.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-s..stack-msg.resources_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-shell32_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-smi-engine_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-store-licensemanager_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-uiribbon_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-uiribbon.resources_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-core-fastprox-dll_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmi-core-repdrvfs-dll_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-core-wbemcomn-dll_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmi-core-wbemcore-dll_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-wmi-core_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_microsoft-windows-wmi-mofinstaller_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_microsoft-windows-xmllite_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_system.runtime.seri..ion.formatters.soap_b03f5f7f11d50a3a_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"_wcf-m_sm_cfg_ins_exe_31bf3856ad364e35_" "%YCP%tmp.txt"|findstr /i /V /C:"_wcf-m_sm_cfg_ins_exe_31bf3856ad364e35_" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"Catalogs" "%YCP%tmp.txt"|findstr /i /V /C:"FileMaps" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
findstr /i /V /C:"ManifestCache" "%YCP%tmp.txt"|findstr /i /V /C:"Manifests"|findstr /i /V /C:"InstallTemp" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
for /f "delims=" %%i in (%YCP%tmp.txt) do (cmd.exe /c takeown /f "%yc%\%%i" /r /d y & icacls "%yc%\%%i" /grant administrators:F /t & RD /s/q "%yc%\%%i")
if exist "%YCP%tmp.txt" del /f/q "%YCP%tmp.txt"
dir /b /a-d "%MOU%\Windows\WinSxS">%YCP%tmp.txt
findstr /i /V /C:"migration.xml" "%YCP%tmp.txt"|findstr /i /V /C:"reboot.xml"|findstr /i /V /C:"poqexec.log" >"%YCP%temp.txt"
del /f/q "%YCP%tmp.txt" && Ren "%YCP%temp.txt" tmp.txt
for /f "delims=" %%i in (%YCP%tmp.txt) do (cmd.exe /c takeown /f "%yc%\%%i" /r /d y & icacls "%yc%\%%i" /grant administrators:F /t & del /f/q "%yc%\%%i")
if exist "%YCP%tmp.txt" del /f/q "%YCP%tmp.txt"
ping -n 5 127.1 >nul
echo.
echo       ��ѡ���Ƿ�ر������ڴ�
echo.
echo   �ر�����1�س�   ���ر�ֱ�ӻس�����
echo.
set xnlc=0
set /p xnlc=����������ѡ��س�ִ�У�
if /i "%xnlc%"=="1" (
reg load HKLM\0 "%MOU%\Windows\system32\config\SYSTEM">nul
reg add "HKLM\0\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "" /f
reg unload HKLM\0 >nul
)
echo.
title   %dqwc% WinSxS���޾��� %dqcd%29 
echo.
echo  WinSxS���޾��������  6����Զ��������˵��Ƽ���������ӳ��
echo.
ping -n 6 127.1 >nul
cls
goto MENU

:KLNK
title  %dqwz% ȥ��ݷ�ʽ��ͷ������������ͼ�� %dqcd%34
echo.
echo   %dqwz% ȥ��ݷ�ʽ��ͷ������������ͼ�� %dqcd%34
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   ��ʼ׼��ȥ��ݷ�ʽ��ͷ����������...
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\DEFAULT">nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "77" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f
reg unload HKLM\0>nul
echo.
title  %dqwc% ȥ��ݷ�ʽ��ͷ������������ͼ�� %dqcd%34
echo.
echo   ȥ��ݷ�ʽ��ͷ�������������  5�����򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:XSYC
title  %dqwz% �Ҽ������ʾ���ز˵� %dqcd%57
echo.
echo   %dqwz% �Ҽ������ʾ���ز˵� %dqcd%57
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   ���Ʊ����ͨ�ýű�...
Xcopy /y %YCP%MY\System32\SuperHidden.vbs %MOU%\Windows\System32\
echo.
echo   ��ʼ׼������...
echo.
echo   �Ҽ������ʾ�������ļ�����չ��...
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 2 /f >nul
reg unload HKLM\0 >nul
if exist %MOU%\Users\Administrator\NTUSER.DAT (
reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT">nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 2 /f >nul
reg unload HKLM\0 >nul
)
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">nul
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden" /ve /t REG_SZ /d "��ʾ�������ļ�����չ��" /f
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden\Command" /ve /t REG_EXPAND_SZ /d "WScript.exe %%windir%%\System32\SuperHidden.vbs" /f
reg unload HKLM\0 >nul
title  %dqwc% �Ҽ������ʾ���ز˵� %dqcd%57
echo.
echo   �Ҽ������ʾ���ز˵��������  5�����򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:GTZN
title  %dqwz% ��ȡ���ú������� %dqcd%41
echo.
echo   %dqwz% ��ȡ���ú������� %dqcd%41
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\zh-CN (
echo.
echo   �����е�ϵͳ�����Ѿ������İ����躺��  ���򷵻�
echo.
ping -n 6 127.1>nul
cls
goto MENU
)
echo.
echo   �����뺺��������Դ�����̷�  �����ǵ�ǰϵͳ����Ҳ������VHDϵͳ����
echo.
echo   ������Դϵͳλ������Ϊ%Mbt%���ҽӽ�����ϵͳ�İ汾���������ӳ��
echo.
echo   Ҳ�ɴӹ���Ŀ¼��༶Ŀ¼��ȡ����D:\MYZNCN\XXX  ע��·�������пո�
echo.
echo   D:\MYZNCN\XXXĿ¼�б����Ǻ�������ϵͳ����Ŀ¼�ṹ  ����֤������Ч
echo.
set SJF=C:
set /p SJF=ֱ�ӻس�Ĭ��������ԴΪC����ϵͳ ���������밴0�س��������˵�:
If "%SJF%"=="0" Goto MENU
if not exist "%SJF%\Windows\zh-CN" (
echo.
echo  %SJF%������ϵͳ������������ϵͳӴ �����������
echo.
ping -n 5 127.1>nul
cls
GOTO GETZN
)
if exist %YCP%TOOL\%FSYS%ZNCN.WIM (
if not exist %YCP%ZNCN\%Mbt% md %YCP%ZNCN\%Mbt%
echo.
echo  ��ʼ����ӳ��ܹ��ͷ�%Mbt%�ĺ�����������... ���Ժ�
echo.
if %Mbt% equ x86 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:1 /ApplyDir:%YCP%ZNCN\%Mbt%
if %Mbt% equ x64 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:2 /ApplyDir:%YCP%ZNCN\%Mbt%
)
if not exist "%YCP%ZNCN\%Mbt%\zh-CN" (
echo.
echo  û���������� ����곿DISM���������� %FSYS%ZNCN.WIM ����%YCP%TOOLĿ¼�����²���
echo.
ping -n 5 127.1>nul
cls
GOTO GETZN
)
echo.
echo  ��ʼ���������ϵͳ�������º�������...
echo.
xcopy /y /h /s /u %SJF% %YCP%ZNCN\%Mbt%\
title  %dqwc% ��ȡ���ú������� %dqcd%41
echo.
echo   ���µ�����Ϊ %Mbt% ֻ�����ں��� %Mbt% ��ϵͳ
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADZN
title  %dqwz% ������ǰ����ϵͳ %dqcd%42
echo.
echo   %dqwz% ������ǰ����ϵͳ %dqcd%42
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\zh-CN (
echo.
echo   �����е�ϵͳ�����Ѿ������İ����躺�����Ѿ����뺺������  ���򷵻�
echo.
ping -n 5 127.1>nul
cls
goto MENU
) 
if not exist %YCP%TOOL\%FSYS%ZNCN.WIM (
echo.
echo   û���ҵ�%FSYS%ZNCN.WIM����ʵսȺ�������������ز�����%YCP%TOOL��
echo.
ping -n 5 127.1>nul
cls
goto MENU
)
echo.
echo   ��ʼӦ�ú�������... ��������Ϊ�����滻������������Ƿ�����������
echo.
echo   �� ����15052����RS2 CN15051����  �� ����10587����TH1 CN10586����
echo.
echo   �뾡�����ܲ��÷�֧��ͬ�Ұ汾��ӽ��Ĺٷ�ԭ�������Ա�����������
echo       ��������    ��������  ����������  ������������ 
ping -n 6 127.1>nul
echo.
echo   Ӧ�ú�������...
echo.
if %Mbt% equ x86 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:1 /ApplyDir:%MOU%
if %Mbt% equ x64 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:2 /ApplyDir:%MOU%
echo.
echo   ��ȫ���뺺������...
echo.
xcopy %YCP%MY\ZNCN.reg %MOU%\Windows\Setup\Scripts\
title  %dqwc% ������ǰ����ϵͳ %dqcd%42
echo.
echo   ���������Ѽ��벢��Ӧ������  �������������Ա����������� ���򷵻�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:GTQD
title  %dqwz% ��ȡ��ǰϵͳ������� %dqcd%43 
echo.
echo   %dqwz% ��ȡ��ǰϵͳ������� %dqcd%43 
echo.
echo      ������ȡ��%YCP%%TheOS%%Obt%QD�� �Ա�Ϊ��ͬӲ����ͬ�ܹ���ϵͳִ�м��ɲ���
if not exist %YCP%%TheOS%%Obt%QD md %YCP%%TheOS%%Obt%QD
set AZFQ=C
dism /online /export-driver /destination:%YCP%%TheOS%%Obt%QD\
echo.
echo      Ĭ�ϻ�ȡC��������  ������������������̷���ĸ�������%TheOS%%Obt%�����Ӧ����
echo.
set /p AZFQ=������Ҫ��ȡ���������ϵͳ�����̷���ĸ����ð��Ĭ��ΪC:
echo.
echo      Ҫ��ȡ��ϵͳ����Ϊ %AZFQ%
echo.
set /p AZRQ=������Ҫ��ȡ���������ϵͳ��װʱ��  ��ʽΪ ����������������:
echo.
echo      ������İ�װ����Ϊ %AZRQ%
echo.
echo      ������������ݴ�����ʼ��ȡ
echo.
xcopy /y /S /D:%AZRQ% %AZFQ%:\Windows\System32\DriverStore\FileRepository %YCP%%TheOS%%Obt%QD\
title  %dqwc% ��ȡ��ǰϵͳ������� %dqcd%43 
echo.
echo           %AZFQ% �����������ȡ��� ������ %Obt% �ܹ���ϵͳ
echo.
echo      �������������Ѿ���ȡ��%YCP%%TheOS%%Obt%QD ����6����Զ��������˵������
echo.
ping -n 6 127.1>nul
cls
goto MENU

:OFUP
title  %dqwz% Windows 10 ר�ùر�ǿ���Զ���������  %dqcd%40
echo.
echo   %dqwz% Windows 10 ר�ùر�ǿ���Զ���������  %dqcd%40
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d 1 /f
reg unload HKLM\0>nul
echo.
title  %dqwc% Windows 10 ר�ùر�ǿ���Զ���������  %dqcd%40
echo.
echo    ���°� Windows 10 ��΢���Ѿ���ֹ�û������Զ���������   ����6���
echo.
echo    ��������  �����Ѿ��ɹ������˹���ϵͳ�е��Զ���������   �������˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:MOEM
title  %dqwz% �滻����Ӹ��Ե� OEM ���ݻ��ļ� %dqcd%25
echo.
echo   %dqwz% �滻����Ӹ��Ե� OEM ���ݻ��ļ� %dqcd%25
echo.
echo.
echo   ��ǰ����ֻ�ṩ�滻����� �ҵĵ��� �Ҽ� ���� �е���Ϣ����
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   ���������DIY�ĸ��� OEM ���ݻ��ļ� �����滻��Ŀ��ϵͳ��
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Branding\Shellbrd" /r /d y && icacls "%MOU%\Windows\Branding\Shellbrd" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\systemcpl.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\systemcpl.dll.mui" /grant administrators:F /t
cmd.exe /c takeown /f "%MOU%\Windows\System32\oobe\zh-CN\msoobeFirstLogonAnim.dll.mui" && icacls "%MOU%\Windows\System32\oobe\zh-CN\systemcpl.dll.mui" /grant administrators:F /t
if exist %YCP%MY\shellbrd\%FSYS%Shellbrd.dll Copy /y %YCP%MY\shellbrd\%FSYS%Shellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
if exist %YCP%MY\MUI\%OFFSYS%systemcpl.dll.mui Copy /y %YCP%MY\MUI\%OFFSYS%systemcpl.dll.mui "%MOU%\Windows\System32\zh-CN\systemcpl.dll.mui"
if exist %YCP%MY\MUI\%OFFSYS%msoobeFirstLogonAnim.dll.mui Copy /y %YCP%MY\MUI\%OFFSYS%msoobeFirstLogonAnim.dll.mui "%MOU%\Windows\System32\oobe\zh-CN\msoobeFirstLogonAnim.dll.mui"
if %OFFSYS% GTR 10587 (
if exist %YCP%MY\shellbrd\%MRS%Shellbrd.dll Copy /y %YCP%MY\shellbrd\%MRS%Shellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
if exist %YCP%MY\MUI\RSsystemcpl.dll.mui Copy /y %YCP%MY\MUI\RSsystemcpl.dll.mui "%MOU%\Windows\System32\zh-CN\systemcpl.dll.mui"
if exist %YCP%MY\MUI\RSmsoobeFirstLogonAnim.dll.mui Copy /y %YCP%MY\MUI\RSmsoobeFirstLogonAnim.dll.mui "%MOU%\Windows\System32\oobe\zh-CN\msoobeFirstLogonAnim.dll.mui"
)
title  %dqwc% �滻����Ӹ��Ե� OEM ���ݻ��ļ� %dqcd%25
echo.
echo     �滻����Ӹ��Ե� OEM ���ݻ��ļ���� ���򷵻����˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADMI
title  %dqwz% ���������û�ʹ��APPS��׼ģʽ %dqcd%35
echo.
echo   %dqwz% ��������Administrator�û�ʹ��APPS %dqcd%35
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d 5 /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d 1 /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d 1 /f
reg unload HKLM\0>nul
echo.
title  %dqwc% ���������û�ʹ��APPS��׼ģʽ %dqcd%35
echo.
echo   ����Administrator�û�ʹ��APPS���������þ���� ���򷵻����˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:WDUP
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% �������¹���ϵͳWindows Defender������ %dqcd%36
echo.
echo   %dqwz% �������¹���ϵͳWindows Defender������ %dqcd%36
echo.
echo   Ŀǰֻ�Ƽ��� Windows 10 ����ϵͳ��ʹ�ñ�����  ��˵ȫ�µĹٷ�
echo.
echo   Windows Defender ɱ������������ǿ  ���µ����ݰ���Լ120MB����
echo.
echo   �Ժ������Զ������������������� �뽫������ɵ�mpam-fe.exe
echo.
echo   ���Ƶ�%YCP%Ŀ¼�� ȷ�����糩ͨ���س��������ݰ� ��0�������˵�
echo.
set wd=YD
set /p wd= ȷ���������²������ݰ���س� �����밴0�س�
if "%wd%"=="0" goto MENU
echo.  
echo   ����������...�뾡��ָ������λ��Ϊ%YCP%Ŀ¼�Ա�ֱ��ʹ��
echo.
start "" "http://go.microsoft.com/fwlink/?LinkID=121721&arch=%Mbt%"
echo   ȷ��������ɲ��Ѱ�Ҫ�������ֱ�ӻس�ִ�����ݿ����
echo.
pause>nul
echo   ����������ò���������ʼִ�и���  ���Ժ�...
if not exist "%YCP%mpam-fe.exe" (
echo.
echo    ���ݰ�û��׼������ ��ȷ�Ϻ�����ִ�м��ɲ��� ���򷵻����˵�
echo.
ping -n 3 127.1>nul
cls
goto MENU
)

:ZHIJ
if not exist "%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates" (
echo.
echo    ����ϵͳ�����Ѿ�������Windows Defender ��ȷ�Ϻ�����ִ�м��ɲ��� ���򷵻�
echo.
ping -n 3 127.1>nul
cls
goto MENU
)
"%YCP%mpam-fe.exe" /extract:"%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates"
del /q /f "%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates\MPSigStub.exe"
if not exist "%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates\mpavbase.vdm" (
echo.
echo    ���� Windows Defender ������ʧ�� ��ȷ�����ݻ򻷾���Ч������     ���򷵻�
echo.
ping -n 3 127.1>nul
cls
goto MENU
)
title  %dqwc% �������¹���ϵͳWindows Defender������ %dqcd%36
echo.
echo   �������¹���ϵͳWindows Defender����������ɹ����  ���򷵻����˵�
echo.
ping -n 5 127.1>nul
if exist "%YCP%mpam-fe.exe" del /q "%YCP%mpam-fe.exe"
cls
goto MENU

:YKMS
title  %dqwz% �������KMS�������������Win10����ϵͳ�뼯��Net4.6 %dqcd%37
echo.
echo   %dqwz% �������KMS�������������Win10����ϵͳ�뼯��Net4.6 %dqcd%37
echo.
echo    ���򽫰�������������������ŵ��û�����   �û����о����Ƿ�ʹ��
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
Xcopy /s /y %YCP%MY\KMS %MOU%\Windows\Setup\Scripts\ >nul
echo.
echo   �Ѿ�Ϊӳ�����KMS�������������ɫ����
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADTG
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
cls
title  %dqwz% �����Լ�����ϼ� %dqcd%38
echo.
echo   %dqwz% �����Լ�����ϼ� %dqcd%38
echo.
echo   �� �� �� �� �� �� ˵ ����
echo  �ԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡ�
echo.
echo             ���ı��ĵĽ�������������ϵͳ�Ƿ�ʱ���Ե����飬�������뵼����ҳ�����ڲ׺�һ��
echo.
echo         Ϊ���ø�������������֮��Ҳ�ܻ��΢���ر������ڱ�������������ƹ�ӿ��Իر����ǵ�
echo.
echo         ����������ر�֤����ȫ�������к��š�ľ����桢�������ӵ�ڸ�������򽫳е�����
echo.
echo         ���Σ��ش˾��棡����(TGDY.CMDΪͨ�õ��ü�������� ����ɾ�������)
echo.
echo         ��֪����������뽫Ҫ�ƹ�ĳ���������÷ŵ� %YCP%MY\TuiGuang\ ���س���ʼ
echo.
echo  �ԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡԡ�
pause >nul
set xz=1
if not exist %YCP%MY\TuiGuang\*.exe if not exist %YCP%MY\TuiGuang\TGDY.CMD (
echo.
echo   %YCP%MY\TuiGuangû��EXE���� �����س�����ִ�м����ƹ���� ��0�س��������˵�
echo.
set /p xz=��ѡ������������
)
if %xz% NEQ 1 goto :MENU
if not exist %YCP%MY\TuiGuang goto :MENU
if exist %YCP%MY\TuiGuang\*.* if not exist %MOU%\TuiGuang md %MOU%\Windows\TuiGuang
Xcopy /y %YCP%MY\TuiGuang\*.* %MOU%\Windows\TuiGuang\
echo.
echo   ��ʼ�����ƹ�������Ч��װ�ӿ�ע�����...
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "@tg" /t REG_EXPAND_SZ /d "%%SystemRoot%%\TuiGuang\TGDY.CMD" /f >nul
reg unload HKLM\0 >NUL
if exist %MOU%\Users\Administrator\NTUSER.DAT (
reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "@tg" /t REG_EXPAND_SZ /d "%%SystemRoot%%\TuiGuang\TGDY.CMD" /f >nul
reg unload HKLM\0 >NUL
)
title  %dqwc% �����Լ����ƹ����� %dqcd%38
echo.
echo   �����ƹ�������Ч��װ�ӿ�ע�������� ���򷵻����˵�
echo.
ping -n 5 127.1>nul
cls
goto MENU

:OFFC
title   %dqwz% ���� Office2016 �� Office2007 ��ɫ����3��1���� %dqcd%39
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   %dqwz% ���� Office2016 �� Office2007 ��ɫ����3��1���� %dqcd%39
echo.
echo   Office2016��Ҫ��Win7SP1����ϵͳ����ʹ�ò�Ҫ����Ӧ�����п�֧��
echo.
echo   ����ǰ�ṩ���ּ���ѡ��           ������Լ�ʵ�����ѡ������
echo.
echo   1  ����Office2007����3��1           2  ����Office2016����3��1
echo.
set OFXZ=0
set /p OFXZ=��ѡ��������Ҫ����������� ��3�س����� ֱ�ӻس�����������ϣ�
if "%OFXZ%"=="3" GOTO MENU
if "%OFXZ%"=="2" GOTO OF16
if "%OFXZ%"=="1" GOTO OF07
if "%OFXZ%"=="0" GOTO AUTO
echo.
echo                 �����������������
echo.
ping -n 6 127.1>nul
cls
goto OFFC

:AUTO
if %OFFSYS% LSS 7601 (goto OF07) ELSE (goto OF16)

:OF07
title   ����Office2007����3��1
echo.
echo  Ϊװ���е�ӳ�񼯳�Office2007����3��1 ����ʼ�������...
echo.
if /i %Mbt% EQU x64 ( 
if not exist "%MOU%\Program Files (x86)\Office2007" md "%MOU%\Program Files (x86)\Office2007"
Xcopy /y /s /h %YCP%ADXX\Office2007 "%MOU%\Program Files (x86)\Office2007\"
echo start "%%ProgramFiles(x86)%%\Office2007\Setup.exe" >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
) ELSE (
if not exist "%MOU%\Program Files\Office2007" md "%MOU%\Program Files\Office2007"
Xcopy /y /s /h %YCP%ADXX\Office2007 "%MOU%\Program Files\Office2007\"
echo start "%%ProgramFiles%%\Office2007\Setup.exe" >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
)
echo.
echo   �ر��˻����Ʒ�ֹ�̻������̻�ʧ�� ��
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
reg unload HKLM\0>nul
echo.
title   %dqwc% ����Office2007 ��ɫ����3��1���� %dqcd%39-1
echo.
echo   ��ɫ���� Office2007 3��1 ���ݼ������ ���򷵻����˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:OF16
title   ����Office2016����3��1
if %OFFSYS% LEQ 9600 (
echo.
echo   ��ǰװ��ϵͳΪ Windows8.1 ����ϵͳ ��Ҫ�������Office2016����Ĳ���
echo.
echo   ���װ��ϵOffice2016ͳ�������   �����Խ����벹�����ɵ�װ��ӳ����
echo.
echo   ��ʼ���Լ���%YCP%ADXX\OfficeMSU\%SSYS%\%Mbt%�Ĳ���...
echo.
if exist %YCP%ADXX\OfficeMSU\%SSYS%\%Mbt% %YCDM% /image:%MOU% /add-package /packagepath:%YCP%ADXX\OfficeMSU\%SSYS%\%Mbt%
echo.
echo   ������� %YCP%ADXX\OfficeMSU\%SSYS% ���ɲ����������
echo.
ping -n 6 127.1>nul
)
echo.
echo   ����ʼ����������ݲ������Զ������̻�����...
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
if /i %Mbt% EQU x64 ( 
if not exist "%MOU%\Program Files (x86)\Office2016" md "%MOU%\Program Files (x86)\Office2016"
Xcopy /y /s %YCP%ADXX\Office2016 "%MOU%\Program Files (x86)\Office2016\"
echo start cmd.exe /c "%%ProgramFiles(x86)%%\Office2016\Setup.cmd" >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
) ELSE (
if not exist "%MOU%\Program Files\Office2016" md "%MOU%\Program Files\Office2016"
Xcopy /y /s %YCP%ADXX\Office2016 "%MOU%\Program Files\Office2016\"
echo start cmd.exe /c "%%ProgramFiles%%\Office2016\Setup.cmd" >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
echo del %%0 >>"%MOU%\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\0green.cmd"
)
if exist %MOU%\Windows\Setup\Scripts\KMS.cmd (
echo.
echo   ��ǰӳ�����Ѿ�������KMS���� ���򽫺ϲ�ִ��
echo.
del /f /q %MOU%\Windows\Setup\Scripts\KMS.cmd
Rmdir /q /s "%MOU%\Windows\Setup\Scripts\32-bit"
Rmdir /q /s "%MOU%\Windows\Setup\Scripts\64-bit"
)
echo   �ر��˻����Ʒ�ֹ�̻������̻�ʧ�� ��
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
reg unload HKLM\0>nul
echo.
title   %dqwc% ����Office2016 ��ɫ����3��1���� %dqcd%39-2
echo.
echo    �������� Office2016 3��1 ���ݼ������ ���򷵻����˵�
echo.
ping -n 6 127.1>nul
cls
goto MENU

:YJYX
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz%ж�����з��������� ʹӳ���ֱ�����������ԭ %dqcd%44
echo.
echo   %dqwz% һ��ж�����з��������� ʹӳ���ֱ�����������ԭ %dqcd%44
echo.
SET Q=0
if exist %MOU%\Windows\inf\OEM%Q%.inf (
echo.
echo   ����ӳ�����������������Ϣ �������������ʼ����ж��...
echo.
)
if exist %MOU%\Windows\inf\OEM%Q%.inf %YCDM% /Image:%MOU% /Remove-Driver /Driver:OEM%Q%.inf

:QT
set /a Q=%Q%+1
if exist %MOU%\Windows\inf\OEM%Q%.inf %YCDM% /Image:%MOU% /Remove-Driver /Driver:OEM%Q%.inf &GOTO QT
title   %dqwc%ж�����з��������� ʹӳ���ֱ�����������ԭ %dqcd%44
echo.
echo   ���ӳ������������������Ѿ�ȫ��ж�ػ�û������ Ӧ�ÿ��������������
echo.
echo   Ҫ�Զ���ж���������˵�����01�س�      ����6����Զ��������˵������
echo.
ping -n 5 127.1>nul
cls
goto MENU

:YCQD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% �Զ���ж�ط��������� %dqcd%47
echo.
echo   %dqwz% �Զ���ж�ط��������� %dqcd%47 ��ʼ��ȡ�����������б�... ���Ժ�
echo.
%YCDM% /Image:%MOU% /Get-Drivers>%YCP%Drivers.txt
start %YCP%Drivers.txt
:HYYS
echo. 
echo   �����ȷ��Ҫɾ��ӳ���е���������븴�ƴ��ı��е�����Ӣ�� XXX.inf ճ�������򴰿�
echo.
echo   �󰴻س�ִ��ж�ز���             ����㲻�˽�ɾ������������Ӱ������ִ��ɾ������
echo.
set /p scqd=ճ�������������򴰿ڲ��س�ִ��ɾ������ ����벻����ֱ�ӷ������˵�������0�س�:
echo.
if "%scqd%"=="0" (
cls
del /q /f %YCP%Drivers.txt
GOTO MENU
)
echo.
echo  ӳ�����������%scqd%������������������ж��  ���ڳ���ж��...
echo.
%YCDM% /Image:%MOU% /Remove-Driver /Driver:%scqd%
echo.
set /p hym=��������%scqd%������ж�� ����ж���밴Y�س�  ֱ�ӻس����������˵�
if /i "%hym%"=="Y" GOTO HYYS
title   %dqwc% �Զ���ж�ط��������� %dqcd%47
echo.
echo           ����ж�ز������      ����6����Զ��������˵������
echo.
ping -n 6 127.1>nul
cls
del /q /f %YCP%Drivers.txt
goto MENU

:YCYY
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% ɾ�����Ի������ %dqcd%46
echo.
echo   %dqwz% ɾ�����Ի������ %dqcd%46
echo.
echo   ���ڲ�ѯ���ܰ�...������Ż��жϳ�������        ��������Զ���ʾ��һ������
echo.
%YCDM% /Image:%MOU% /Get-packages>%YCP%packages.txt
start %YCP%packages.txt
:JXSC
echo.
echo   �븴�ƴ򿪵��ı���[�������ʶ��: ���Ƶ����� ]��Ӣ�Ĳ���ճ�������̴��ڻس�
echo                                    ����������
echo   ���棺����㲻�˽�ɾ�����Ӱ���뾡����Ҫ����ִ��ɾ����������������¼�����
echo.
echo   �������԰��ɰ�ȫɾ��Ӣ�ĺ�����Language Pack���ʵ�����OnDemand Pack��en-us
echo.
echo   ���ڻ������ԣ������ɾ�� �����ա����������뷨�Լ���д���ԵȾ����԰�ȫɾ��
echo.
set scyy=0
set /p scyy=ճ��Ҫɾ���ĳ����ʶ���������ڻس�ִ��ɾ�� ֱ�ӻس������κβ������������˵�:
if "%scyy%"=="0" (
del %YCP%packages.txt
cls
goto MENU
)
echo.
%YCDM% /image:%MOU% /Remove-Package /PackageName:%scyy%
echo.
set jx=1
set /p jx=����ִ��ɾ��������ֱ�ӻس� ����������0�س�
if "%jx%"=="0" (
title   %dqwc% ɾ�����Ի������ %dqcd%46
del /q /f %YCP%packages.txt
cls
goto MENU
)
cls
goto JXSC

:SJBB
title   %dqwz% ����ӳ��汾 %dqcd%48
echo.
echo   %dqwz% ����ӳ��汾 %dqcd%48
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\servicing\Editions\%MEID%Edition.xml if exist %MOU%\Windows\%MEID%.xml del /q /f %MOU%\Windows\%MEID%.xml
echo.
echo     ��ǰ����ϵͳΪ^:%MOS% ��������³���ϵͳ�汾ͼ������ѡ��Ŀ��汾
echo.
echo    ���������������������ש������������������ש������������������ש�������������������
echo    ��   Ԥ�������˵�   �� Windows 7 (SP1)  ��  Windows 8 (.1)  ��    Windows 10    ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 7  ������������  ��        ��        ��     Education    ��     Education    ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 6  ��������ҵ��  �� Enterprise Only  ��     Enterprise   ��     Enterprise   ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 5  רҵý������  ��         ��       ��  ProfessionalWMC ��         ��       ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 4  �������콢��  ��      Ultimate    ��         ��       ��         ��       ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 33 ��ʯרҵ�����橯        ��        ��        ��        ��Pro for Education ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 3  ������רҵ��  ��    Professional  ��    Professional  ��    Professional  ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 2  ����ͥ�߼���  ��    HomePremium   ��         ��       ��         ��       ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 1  ����ͥ������  ��      HomeBasic   ��         ��       ��         ��       ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� 0  �����׺��İ�  ��Starter x86 Only  ��        Core      ��   Core  ��ͥ��   ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��    ��ͥ���İ�    ��        ��        ��         ��       ��Home China �й��� ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��    �����԰汾    �� EnterpriseG  888 ��         ��       ��CoreSingleLanguage��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    �� Windows 10 N ��  �� ProN רҵN�� 333 �� EntN ��ҵN�� 666 �� EduN ����N�� 777 ��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��  S1 ������ϵͳ   ��ServerStandardCore���� �� �� �� �� �� ServerDatacenterCore��
echo    �ǩ������������������響�����������������響�����������������響������������������
echo    ��  S2 ������ϵͳ   ��  ServerStandard  ���� �� �� �� �� �� �� ServerDatacenter ��
echo    ���������������������ߩ������������������ߩ������������������ߩ�������������������
echo.
set v=
%YCDM% /Image:%MOU% /Get-CurrentEdition
%YCDM% /Image:%MOU% /Get-TargetEditions
set /p v=������Ԥ�ò����˵��������(0~888) ����������������δԤ�õ������˵���Ŀ��汾�򷵻�:
if /i "%v%"=="S1" (
echo.
echo    ��������������Core��...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ServerDatacenterCore
if !errorlevel!==0 goto :SCBY
)

if /i "%v%"=="S2" (
echo.
echo    �������������İ�...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ServerDatacenter
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="777" (
echo.
echo    ������������N��...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Education
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="7" (
echo.
echo    �����������汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Education
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="666" (
echo.
echo    ��������ҵN�汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:EnterpriseN
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="888" (
echo.
echo    ������ ��ҵ G �汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:EnterpriseG
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="6" (
echo.
echo    ��������ҵ�汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Enterprise
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="5" (
echo.
echo    ������PWMC�汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ProfessionalWMC
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="4" (
echo.
echo    �������콢�汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Ultimate
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="333" (
echo.
echo    ������רҵN��...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ProfessionalN
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="33" (
echo.
echo    ������רҵ������...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ProfessionalEducation
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="3" (
echo.
echo    ������רҵ��...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Professional
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="2" (
echo.
echo    ��������ͥ�߼��汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:HomePremium
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="1" (
echo.
echo    ��������ͥ�����汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:HomeBasic
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="0" (
echo.
echo    ��������ͥ���İ汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Core
if !errorlevel!==0 goto :SCBY
)

:ZDSJ
set zdbb=0
set /p zdbb=����Ԥ�������˵����⵫���ڵĿ�����Ŀ��汾Ӣ�����ƻ�ֱ�ӷ������˵�:
if "%zdbb%"=="0" goto MENU
echo.
echo    ���������� %zdbb% �汾...
echo.
%YCDM% /Image:%MOU% /Set-Edition:%zdbb%
if !errorlevel!==0 goto :SCBY
echo.
echo              ����������������ȷ����  ����3����Զ��������˵�...
echo.
ping -n 3 127.1 >nul
cls
goto ZDSJ

:SCBY
cls
echo.
echo    Ϊ��������������Ҫ�Ĺ��� ��ɺ��Զ��������˵�
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "ProductName"') do set MOS=%%a
set MOS=%MOS:~29%
for /f "skip=2 delims=" %%a in ('reg QUERY "HKLM\0\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set MEID=%%a
set MEID=%MEID:~27%
reg unload HKLM\0 >NUL
echo set MOS=!MOS! >%MEID%ZL.cmd
goto MENU

:CLEA
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% ��ȫ����ǹ���״̬�Ĳ��������Լ������ %dqcd%49
echo.
echo   %dqwz% ��ȫ����ǹ���״̬�Ĳ��������Լ������ %dqcd%49
echo.
%YCDM% /image:YCMOU /Cleanup-Image /StartComponentCleanup &&%YCDM% /image:YCMOU /Cleanup-Image /StartComponentCleanup /ResetBase
title   %dqwc% ��ȫ����ǹ���״̬�Ĳ��������Լ������ %dqcd%49
echo.
echo   �����ʾ�����쳣����ڹ���״̬���ɺ��Լ�����������  ����3��󷵻�
echo.
ping -n 3 127.1 >nul
cls
GOTO MENU

:NOPG
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% �ر�ϵͳ�����ڴ����ϵͳ����Ӳ��ռ�ÿռ� %dqcd%33
echo.
echo    %dqwz% �ر�ϵͳ�����ڴ����ϵͳ����Ӳ��ռ�ÿռ� %dqcd%33
echo.
echo   ����Ŀǰֻ�ṩ�رղ����������ṩ�����ѡ���� ���س�ִ��
echo.
pause>nul
reg load HKLM\0 "%MOU%\Windows\system32\config\SYSTEM">nul
reg add "HKLM\0\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "" /f
reg unload HKLM\0 >nul
echo.
title   %dqwc% �ر�ϵͳ�����ڴ����ϵͳ����Ӳ��ռ�ÿռ� %dqcd%33
echo.
echo   ���û����������Ѿ�Ϊ���ر��������ڴ� ���򷵻����˵�
echo.
ping -n 5 127.1 >nul
cls
GOTO MENU

:SAVE
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% ����ӳ��... %dqcd%30
echo.
echo   %dqwz% ����ӳ�� %dqcd%30
echo.
%YCDM% /Commit-Image /MountDir:%MOU%
ping -n 3 127.1 >nul
title   %dqwc% ����ӳ��
cls
GOTO MENU

:ZLBC
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% ��������... %dqcd%31
echo.
echo   %dqwz% �������� %dqcd%31 
echo.
%YCDM% /Commit-Image /MountDir:%MOU% /Append
set /a INDEX=%INDEX%+1
echo set INDEX=!INDEX!>INDEXset.cmd
title   %dqwc% ��������
ping -n 3 127.1 >nul
cls
GOTO MENU

:UNMO
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% ж��ӳ��... %dqcd%32
echo.
echo   %dqwz% ж��ӳ�� %dqcd%32
echo.
Set s=1
Set /p s=����0�س��� ������ֱ��ж��ӳ��  ���ֱ�ӻس��� ���沢ж�� ӳ��
If "%s%"=="0" ( %YCDM% /Unmount-Image /MountDir:%MOU% /discard ) ELSE (%YCDM% /Unmount-Image /MountDir:%MOU% /commit)
cmd.exe /c takeown /f "%YCP%YCMOU" /r /d y && icacls "%YCP%YCMOU" /grant administrators:F /t
if exist %YCP%Default.reg (
attrib -r %YCP%Default.reg
if exist %YCP%Default.reg del /q %YCP%Default.reg
)
if exist INDEXset.cmd del /f /q INDEXset.cmd
if exist %YCP%YCMOU RMDIR /Q /S "%YCP%YCMOU" >nul
title   %dqwc% ж��ӳ��
echo.
if exist %YCP%YCMOU (
echo   ����Ŀ¼������ȫж�� ж��ע���HKEY_LOCAL_MACHINE�¶���� ��ɾ��YCMOU
echo.
echo   �����������༭����ӳ���밴J�س��������˵�  ֱ�ӻس��������������ӳ
echo.
)
set fh=S
set /p fh=ֱ�ӻس����������ӳ    �� J �س��������˵�����������������
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %YCP%����װ���е�ӳ��.cmd del /q /f %YCP%����װ���е�ӳ��.cmd
if not exist %YCP%����װ���е�ӳ��.cmd del /q /f %YCP%�쳣�жϺ�����������װ��ӳ��.cmd
cls
if /i "%fh%"=="J" GOTO MENU

:SHCH
cls
if "%INDEX%"=="" (set n=1) else (set n=%INDEX%)

:SHX
cls
title   %dqwz% �������������ӳ��
echo.
echo   %dqwz% �������������ӳ��
echo.
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
%YCDM% /Get-Wiminfo /WimFile:%YCP%YCSINS.WIM
set /a SY=%ZS%-%n%
if %SY% equ 0 (set yxm=1) else (set yxm=1��%ZS%) 
echo.
echo   �������������������汾�������ӳ�����������   �����������ͬ�ļ���ӳ����
echo.
echo   ��ǰ%YCP%YCSINS.WIM��%ZS%����ӳ��  ������������ֱ�ӱ�������Ƽ��������ӳ��
echo.
echo   �˲���������ӳ���в�������   ��Ҫ�Ǿ����������������ĳ����ڹ���״̬�Ķ�������
echo.
echo   ���մ���ӳ���ļ�Ϊ%YCP%install.wim ��ֱ���滻ԭʼ ISO\Sources ����漴��
echo.
set /p n=������Ҫ����������ӳ���������� %yxm% ֱ�ӻس�Ĭ��%ZS%�˳���T ֱ�������E�س���
if /i %n% equ T Goto :TUIC
if /i %n% equ E Goto :ERSC
if %SY% LSS 0 (
echo.
echo   %YCP%install.wim �в����ڵ�%n%����ӳ�� ���������룡����
echo.
ping -n 3 127.1 >nul
GOTO :SHX
)
for /f "delims=" %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Name"') do set MOS=%%a
set MOS=%MOS:~7%
for /f "tokens=3 delims=." %%b in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Version"') do set DmVer=%%b
for /f "delims=" %%b in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Edition"') do set MEID=%%b
set MEID=%MEID:~10%
for /f "tokens=3 delims= " %%c in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM /index:%n% ^| find /i "Architecture"') do set Mbt=%%c
if exist %MEID%ZL.cmd call %MEID%ZL.cmd
echo. 
echo   ��ʼΪ��%n%�Ӹ�ӳ�� ����������������  
echo.
echo   Ĭ������Ϊ^: %MOS%
echo.
set /p MOS=������ӳ�����ƣ�������Ҫ��ճ�������ڣ��󰴻س�������
echo.
set ABT=%MOS% %Mbt% %DmVer% ������%DATE%
echo.
echo   Ĭ������Ϊ^: %ABT%
echo.
set /p ABT=�������������ݣ�������Ҫ��ճ�������ڣ��󰴻س�������
echo.

:NOIEXE
if not exist %YCP%TOOL\14393\%Obt%\Dism\imagex.exe (
echo.
echo   û�ҵ� TOOL\14393\%Obt%\Dism\imagex.exe �������� ��ȷ�Ϻ����¿�ʼ
echo.
pause >nul
GOTO :NOIEXE
)
echo   ��ʼ�������� %n% ����ӳ��   ���Ժ�...
echo.
%YCP%TOOL\14393\%Obt%\Dism\imagex /info %YCP%YCSINS.WIM %n% "%MOS%" "%ABT%"
echo.
echo   Ϊ��%n%����ӳ������������������������ ֱ�ӻس��������� ����밴 E 
echo.
if exist %MEID%ZL.cmd del /f /q %MEID%ZL.cmd
set YE=Y
set SCXM=0
set /p YE=��ѡ����Ҫ�Ĳ��� �������� �� ��ʼ���
if /i %YE% EQU Y Goto SHX

:ERSC
echo.
echo   �����Զ���������ڵ���ӳ��  Ĭ��Ϊ��%n%��
echo.
set /p n=������Ҫ�������ӳ��������� Ĭ���ǵ�%n%��
echo.
echo   ��ʼ����� %n% ����ӳ��Ĵ���ӳ��   ���Ժ�...
%YCDM% /Export-Image /SourceImageFile:%YCP%YCSINS.WIM /SourceIndex:%n% /DestinationImageFile:%YCP%install.wim
set /a SCXM=%SCXM%+1
set /a pds=%ZS%-%SCXM%
title   �����%n%����ӳ��Ĵ���ӳ��
set ag=0
echo.
echo   ��������밴1 �س� ֱ�ӻس�ɨβ���� ���������밴 R
echo.
set /p ag=ֱ�ӻس� ִ��ɨβ����       �� 1 �س����������
if /i %ag% equ R Goto SHX
if %ag% equ 0 Goto SAOW
if %pds% equ 0 (
echo.
echo   ��ǰӳ������Ϊ%ZS% �Ѿ����%SCXM%�� ����Ĭ�Ͻ���ɨβ����
echo.
ping -n 3 127.1 >nul
cls
Goto SAOW
)
Goto ERSC

:SAOW
title   %dqwz% �������ӳ����� ɨβ��...
if not exist %YCP%install.wim goto ER1
if exist %YCP%install.wim REN %YCP%YCSINS.WIM YCSINS.OLD
echo.
echo   ���ǵ��������̿��ܴ����쳣   ����û��Ĭ��ɾ�����ļ� %YCP%YCSINS.OLD
echo.
echo   %YCP%install.wim������ %YCP%YCSINS.OLD�Զ��Ƿ�ɾ�� 3��󷵻����˵�
echo.
title   %dqwc% ���������������ӳ�� ɨβ������� �������˵�
ping -n 3 127.1 >nul
cls
goto MENU

:ER1
CLS
ECHO.
ECHO  �������ӳ��û�гɹ���� ȷ�ϳ������û�жϻ��쳣 3����ٴγ����������ӳ�� 
echo.
ping -n 3 127.1 >nul
goto ERSC

:ER2
cd..
CLS 
ECHO.
ECHO  ���ṩ��IE���򱾳�����ʶ��������������ִ�м��ɲ���
ECHO.
PAUSE>NUL
GOTO MENU

:ER3
CLS
ECHO.
ECHO  δ֪����  �밴�س��������˵�
echo.
PAUSE>NUL
GOTO MENU

:CheckWE
CLS
echo.
echo  ��ܰ���ѣ�
echo.
echo  û�з���%SOUR%install.wim^(��esd^)��YCSINS.WIM ӳ���ļ�  ��ȷ�Ϻ� ���س��������г���
echo.
echo  ��ֱ�ӽ� WIM��ESD^(�޼���)��ʽ��ӳ�� ���Ƶ�%SOUR%Ŀ¼ ��������Ϊ YCSINS.WIM ����ʹ��
echo.
PAUSE>NUL
cls
call %0

:ER4
CLS
ECHO.
ECHO   û���ҵ�����Ԥ�������ֵ���ļ� ��ȷ����û����ɾ���ƶ������ ����ʧ���������������
echo.
pause>nul
goto MENU

:IEER
CLS
ECHO.
ECHO     �˲���ֻ������Win7ϵͳ  ��������������˵�
echo.
pause>nul
goto MENU

:BBER
CLS
ECHO.
ECHO     �˲���ֻ������Win81��Win10ϵͳ ��������������˵� 
echo.
pause>nul
goto MENU

:DMER
echo.
echo   �������곿�ṩԭʼYCDISM\TOOLĿ¼���ݲ��ŵ� %YCP%�°����������
echo.
pause>nul
cls
call %0
exit /q

:ERR
CLS
ECHO.
ECHO   �곿������  û�з����ṩ����ĺ����ļ� ȷ��û�б���ɾ�������κθ��� ����3����Զ��˳�
echo.
ping -n 3 127.1 >nul
exit /q

:ERQX
CLS
ECHO.
ECHO   ����  ��ǰ�û�����û�м�������Ȩ�޻� %~dp0 λ�ò���д ����3����Զ��˳�
echo.
ping -n 3 127.1 >nul
exit /q

:TUIC
if exist %YCP%YCMOU if not exist %YCP%YCMOU\Windows\system32\config\SOFTWARE (
cmd.exe /c takeown /f "%YCP%YCMOU" /r /d y && icacls "%YCP%YCMOU" /grant administrators:F /t
RMDIR /Q /S "%YCP%YCMOU">nul
)
echo.
echo   %dqwz% �˳����رճ��� ��ӭ�ٴ�ʹ�ã��ټ�������%dqcd%0
echo.
ping -n 2 127.1 >nul
exit /q

:NT52
if not exist EXE md EXE
if not exist NT52 md NT52
echo.
echo   �뽫���õ�EXE������NET���ڱ�����EXEĿ¼ ��ȡXP��2003ISO����������NT52Ŀ¼��س�ִ��
echo.
pause>nul
FOR /F usebackq %%i IN (`dir EXE\*.exe /b`) DO start /wait EXE\%%i /integrate:NT52\ /passive