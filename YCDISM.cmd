@echo off
color 1F
chcp 936 >nul
mode con cols=96 lines=42
set title= ***** 雨晨终极 MS ISO挂载精简升级制作 [YCDISM NT6-10 正式版 2017-03-31] *****
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
echo   请确认你是在 Windows 7 以上系统下运行本程序 6秒后将自动退出
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
echo       当前系统^:%OOS% %Obt% %OUI%  发行号^:%ORS%  版本号^:%OMD%  补丁号^:%OZD%
echo.
echo                                   今天日期^:%date%
echo.
echo.
echo                程序开始工作前请确定工作分区必须为NTFS格式并大于30G自由可写空间
echo.
echo                本程序推荐放在分区根下 目录名称尽量不要包含^:空格/中文或特殊符号
echo.
echo                INSTALL.WIM、ESD（加密ESD请用TOOL\ESDtoISO\ESDtoISO.CMD解密转换）
echo.
echo                在和程序互动时请保持输入法状态为英文 以免操作造成意外退出或终止
echo.
echo                当前本程序运行的位置为 %~dp0如果不符合继续条件请移动或更改
:SISO
echo.
echo                请装载或输入已装载ISO的盘符字母并输入冒号有些操作需使用其中数据 
echo.
echo                比如启用NetFx3需要ISO中数据支持或当前系统DISM不适用操作当前映像 
echo.
if !TheOS! equ Win7 (
echo                当前为Win7系统    程序自动调用UltraISO程序为您装载ISO镜像后继续
echo.
start %YCP%TOOL\UltraISO\UltraISO.EXE
)
if !TheOS! equ Vista (
echo                当前为Vista系统   程序自动调用UltraISO程序为您装载ISO镜像后继续
echo.
start %YCP%TOOL\UltraISO\UltraISO.EXE
)
set ISO=%YCP%
SET /P ISO=请输入ISO装载分区的盘符  需要输入冒号 按回车继续：
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
echo                如果存在%DmVer%ADK组件则优先使用  否则使用ISO中的DISM执行后续操作
echo.
ping -n 3 127.1>nul
if exist %YCP%TOOL\%DmVer%\%Obt%\Dism\dism.exe set ADK=%DmVer%
goto BYDM

:BYDM
if %DmVer% LEQ 10240 (
echo                当前部署映像服务和管理工具%DmVer%  程序默认启用10240的ADK继续进行
echo.
ping -n 6 127.1>nul
SET YCDM=%YCP%TOOL\10240\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\10240\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% EQU 10586 (
echo                当前部署映像服务和管理工具%DmVer% 10587以下启用%ADK%的ADK继续进行
echo.
ping -n 3 127.1>nul
SET YCDM=%YCP%TOOL\10586\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\10586\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% EQU 14295 (
echo                当前部署映像服务和管理工具%DmVer% 14295以下启用%ADK%的ADK继续进行
echo.
ping -n 3 127.1>nul
SET YCDM=%YCP%TOOL\14295\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\14295\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% EQU 14393 (
echo                当前部署映像服务和管理工具%DmVer% 14393以下启用%ADK%的ADK继续进行
echo.
ping -n 3 127.1>nul
SET YCDM=%YCP%TOOL\14393\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\14393\%Obt%\Dism\dism.exe goto DMER
)
if %DmVer% GTR 14393 (
if !TheOS! EQU Win7 (
echo                当前 !TheOS! 系统处理高于 14393 映像使用10240 ADK的DISM继续进行操作
echo.
SET YCDM=%YCP%TOOL\10240\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\10240\%Obt%\Dism\dism.exe goto DMER
) ELSE (
echo                当前部署映像服务和管理工具%DmVer% 15063以下启用%ADK%的ADK继续进行
echo.
SET YCDM=%YCP%TOOL\15063\%Obt%\Dism\dism.exe
if not exist %YCP%TOOL\15063\%Obt%\Dism\dism.exe goto DMER
)
)
if %DmVer% GTR 15063 (
echo                当前部署映像服务和管理工具为%DmVer%高于15063使用ISO自带的DISM操作
echo.
ping -n 3 127.1>nul
if exist %ISO%\Sources\dism.exe SET YCDM=%ISO%\Sources\dism.exe
)

echo                为保证后续制作的映像纯净      程序默认执行清理后继续进行 请稍候...
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
SET /P INDEX=请输入要制作 %SOUR%%WEfile% 中的子映像索引数字共%ZS%个子映像 直接回车默认为1: 
%YCDM% /Export-Image /SourceImageFile:%SOUR%%WEfile% /SourceIndex:%INDEX% /DestinationImageFile:%YCP%YCSINS.WIM
cls
if not exist %YCP%YCSINS.WIM goto EXPO

:MENU
cls
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\System32 if not exist %MOU%\Windows\SysWOW64 (set Mbt=x86) ELSE (set Mbt=amd64)
if not exist %MOU%\Windows\System32 set GMOS=准备工作就绪 请装载映像
echo.
echo         %title%
echo.
echo     今天日期^:%date%
echo     当前系统^:%OOS% %Obt% %OUI%  发行号^:%ORS%  版本号^:%OMD%  补丁号^:%OZD%
set dqwz=  您好^！YCDISM2017㊣在进行...
set dqwc=  您好^！YCDISM2017已经完成
set dqcd=  主菜单序号^:
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
echo     当前装载^:%MOS% %Mbt% %MUI%  发行号^:%MRS%  版本号^:%MMD%  补丁号^:%MZD%
Goto MMMM

:NM
echo                                                                    %GMOS%
:MMMM
ECHO     ┏*━*━*━*━*━*━*━*━*━┳************************┳━*━*━*━*━*━*━*━*━*┓
ECHO     ┣***    雨  晨  绿  软   ***  YCDISM 正式版 2017-03-31 ***    纯  净  安  全    ***┫
ECHO     ┣***┳*━*━*━*━*━*━*━*┛************************┏*━*━*━*━*━*━*━*┳***┫
ECHO     ┃ 1 ┋ 2 →移除部分可选功能 ┏ 50 →重命名或输出映像**┋ 集成绿色软件数据← 26┋ 0 ┃
ECHO     ┣***┫ 3 →卸载部分内置APPS ┣*******                 ┋ 通用安全适度精简← 27┋   ┃
ECHO     ┃   ┋ 4 →按需启用禁用功能 ┋    YCDISM是雨晨基于DISM┋ 驱动虚链极限精简← 28┋ 保┃
ECHO     ┃装 ┋ 5 →集成添加 UI 语言 ┋                        ┋ WinSxS  极限精简← 29┋   ┃
ECHO     ┃   ┋ 6 →集成补丁或者功能 ┋及相关批处理程序组合的纵┋ 保存已改变的映像← 30┋ 持┃
ECHO     ┃载 ┋ 7 →Win7集成IE9 10 11┋                        ┋ 增量保存装载映像← 31┋   ┃
ECHO     ┃   ┋ 8 →手动集成安装密钥 ┋向及横向强大的延伸扩展。┋ 自选卸载装载映像← 32┋ 现┃
ECHO     ┃即 ┋ 9 →自动集成系统密钥 ┋                        ┋ 关闭系统虚拟内存← 33┋   ┃
ECHO     ┃   ┋10 →移除系统还原映像 ┋菜单直观、互动界面通俗易┋ 去非管理用户盾牌← 34┋ 状┃
ECHO     ┃将 ┋11 →移除杀毒 WD 数据 ┋                        ┋ 管理员批准的模式← 35┋   ┃
ECHO     ┃   ┋12 →移除OneDrive数据 ┋用、程序智能、通用、实用┋ 更新杀毒定义数据← 36┋ 安┃
ECHO     ┃制 ┋13 →移除内置Edge数据 ┋                        ┋ 添加联网 KMS程序← 37┋   ┃
ECHO     ┃   ┋14 →移除 Cortan 数据 ┋功能全面，简单互动即可实┋ 加入自己软件合集← 38┋ 全┃
ECHO     ┃作 ┋15 →移除 Speech 数据 ┋                        ┋ 添加Office绿色版← 39┋   ┃
ECHO     ┃   ┋16 →安全精简Font字体 ┋现精简、增强、优化固化、┋ 关闭系统自动更新← 40┋ 退┃
ECHO     ┃的 ┋17 →精简Assembly数据 ┋                        ┋ 获取通用汉化数据← 41┋   ┃
ECHO     ┃   ┋18 →移除部分强制应用 ┋设置固化的纯净系统、所见┋ 汉化装载中的映像← 42┋ 出┃
ECHO     ┃WIM┋19 →N版添加 WMPlayer ┋                        ┋ 提取系统分区驱动← 43┋   ┃
ECHO     ┃   ┋20 →集成或者整合驱动 ┋所得、安全、绿色、稳定并┋ 卸载非内置的驱动← 44┋ 程┃
ECHO     ┃映 ┋21 →加VC DirectX数据 ┋                        ┋ 设置默认宋体字体← 45┋   ┃
ECHO     ┃   ┋22 →替换个性主题锁屏 ┋可靠、支持NT6至NT10系统 ┋ 自选移除部分功能← 46┋ 序┃
ECHO     ┃像 ┋23 →将用户文档设 D盘 ┋                        ┋ 自选卸载部分驱动← 47┋   ┃
ECHO     ┃   ┋24 →添加无人值守优化 ┋做系统，就这么简单！！！┋ 提升装载映像版本← 48┣***┫
ECHO     ┃ 1 ┋25 →替换添加 OEM文件 ┋     *******************┛ 清理非挂启的残留← 49┋ 0 ┃
ECHO     ┣***┻*━*━*━*━*━*━*━*┛************************━*━*━*━*━*━*━*━*┻***┫
ECHO     ┃程序编写及数据收集整合 雨 晨 YCDISM 实战QQ群 392016099  博 客  ycgsotf.lofter.com ┃
ECHO     ┗*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*━*┛
ECHO.
Set m=N
Set /p m=请输入你要操作的菜单序号数字(0-50) 按回车执行操作:
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
echo    你的输入有误 程序并未提供该项操作及相关的序号 请重新输入程序所提供的菜单序号！！！
echo.
ping -n 3 127.1>nul
cls
Goto MENU

:GZYX
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\System32\config\SOFTWARE (
echo.
echo   已经装载映像 请不要重复装载 如果已经装载的映像损坏请先执行废除操作
echo.
ping -n 3 127.1>nul
cls
Goto MENU
)
title  %dqwz% 装载%YCP%YCSINS.WIM映像 %dqcd%1
echo.
echo   %dqwz% 装载%YCP%YCSINS.WIM映像 %dqcd%1
echo.
%YCDM% /Get-Wiminfo /WimFile:%YCP%YCSINS.WIM
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
set INDEX=1
set /p INDEX=请输入%YCP%YCSINS.WIM中要操作的索引序号共%ZS%个子映像 直接回车默认为1:
%YCDM% /Mount-Image /ImageFile:%YCP%YCSINS.WIM /Index:%INDEX% /MountDir:%MOU% 2>nul
if %errorlevel% EQU 11 (
cls
echo.
echo      温馨提醒：
echo.
echo          当前即将装载的映像其真实格式为ESD格式    需转换成WIM格式继续  
echo.
echo          如果无加密或错误 程序将尝试转换成标准的WIM映像以继续执行操作
echo.
echo          开始转换 不可中断或影响转换过程，可能需要一些时间 请稍候！！！
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
echo    %YCP%YCSINS.WIM 中不存在您输入的索引 %INDEX% 请输入存在的的索引序号 
echo.
ping -n 6 127.1>nul
cls
Goto MENU
)
echo @echo off>%YCP%废弃装载中的映像.cmd
echo color 1f>>%YCP%废弃装载中的映像.cmd
echo %YCDM% /Unmount-Image /MountDir:%YCP%YCMOU /DISCARD>>%YCP%废弃装载中的映像.cmd
echo @echo off>%YCP%异常中断后重新启用已装载映像.cmd
echo color 1f>>%YCP%异常中断后重新启用已装载映像.cmd
echo %YCDM% /Remount-wim /MountDIR:%YCP%YCMOU>>%YCP%异常中断后重新启用已装载映像.cmd
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
title  %dqwc% 装载%YCP%YCSINS.WIM映像%INDEX% %dqcd%1
echo.
echo               %MOS% 映像装载完成程序3秒后自动进入下一步操作
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:MCAN
title  %dqwz% 部分可以卸载数据 %dqcd%2
echo.
echo   %dqwz% 部分可以卸载数据 %dqcd%2
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if %FSYS% NEQ Win10 (
echo.
echo          本功能只限定在 Windows 10 系统下使用 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU
)
echo.
echo   如果存在 程序只提供和推荐卸载或移除以下功能或数据 包括【中国 美国 国际 通用】
echo   ============================================================================
%YCDM% /Image:%MOU% /English /Get-packages>%YCP%packages.txt
::for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-InsiderHub-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-RetailDemo-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Prerelease-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Speech-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-TextToSpeech-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-OCR-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
:: 不是平板可移除手写功能 默认保留 如需移除请去年下行首双冒号
::for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Handwriting-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-Fonts-Hans-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-DeveloperMode-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-ContactSupport-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
if %OFFSYS% LEQ 14393 for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "-QuickAssist-" &&%YCDM% /image:%MOU% /Remove-Package /PackageName:%%a)
echo.
echo   如果是多语言系统程序将删除 %MUI% 以外语言包数据 开始查询并处理...请稍候
echo.
for /f "tokens=4 delims= " %%a in (%YCP%packages.txt) do (echo "%%a"|find /i "LanguageFeatures-Basic-" &&echo %%a>>%YCP%Languagelist.txt)
for /f %%i in (%YCP%Languagelist.txt) do echo %%i |findstr /i "%MUI%" || %YCDM% /image:%MOU% /Remove-Package /PackageName:%%i
del /f /q %YCP%packages.txt
del /f /q %YCP%Languagelist.txt
title  %dqwc% 卸载部分可以卸载数据 %dqcd%2
echo.
echo   只要系统组件完整   这些卸载的功能都可在安装完成后按需要随时添加   请放心使用
echo   ============================================================================
echo.
echo   永久程序包不能卸载请略过 如果还要卸载其它 请使用主菜单 46 进行操作  程序返回
echo.
ping -n 6 127.1>nul
cls
goto MENU

:XZYY
if not exist "%MOU%\Program Files\WindowsApps"  GOTO MENU
title  %dqwz% 卸载自带应用 %dqcd%3
echo.
echo   %dqwz% 卸载自带应用 %dqcd%3
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
echo           如果存在可卸载自带应用  雨晨DISM程序默认推荐以下自带应用经典卸载方案
echo  ======================================================================================
echo                     卸载过程中如出现系统找不到指定的文件表示已经卸载
echo    ┏┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┓
echo    ┋              目 前 程 序 可 卸 载 已 知 自 带 应 用 方 案 规 则              ┋
echo    ┣┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┫
echo    ┋  A 默 认 卸 载   ┋  B 保 留 方 案   ┋  C 保 留 方 案   ┋  D 保 留 方 案   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋HelpAndTips       ┋Reader            ┋WindowsScan       ┋XboxApp           ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋Getstarted        ┋ZuneVideo         ┋3DBuilder         ┋BingFinance       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋MicrosoftOfficeHub┋ZuneMusic         ┋DesktopAppInstalle┋BingSports        ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋People            ┋Photos            ┋OneConnect        ┋BingWeather       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋FeedbackHub       ┋SkypeApp          ┋OneNote           ┋BingNews          ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋Office Sway       ┋Camera            ┋SolitaireCollectio┋communicationsapps┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋                  ┋WindowsCalculator ┋StickyNotes       ┋WindowsMaps       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋  E 默 认 保 留   ┋Microsoft3DViewer ┋Wallet            ┋XboxGameOverlay   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋WindowsStore      ┋WindowsPhone      ┋Messaging         ┋StorePurchaseApp  ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋WindowsAlarms     ┋SoundRecorder     ┋Appconnector      ┋XboxLIVEGames     ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋                  ┋MSPaint           ┋CommsPhone        ┋ConnectivityStore ┋
echo    ┣┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┫
echo    ┋              F 全 部 卸 载           ┋           G 自 定 义 卸 载           ┋
echo    ┗┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┛
echo          温馨提醒： 本操作不适用于二次封装和已被破坏或已被强删过的二次挂载映像
echo  ======================================================================================      
set XZFA=
set /p XZFA=请选择并输入你要执行的方案字母不分大小写 ABCDEFG 按0回车不做任何操作并返回主菜单
if "%XZFA%"=="0" goto XZFAO
if /i "%XZFA%"=="A" goto XZFAE
if /i "%XZFA%"=="B" goto XZFAE
if /i "%XZFA%"=="C" goto XZFAE
if /i "%XZFA%"=="D" goto XZFAE
if /i "%XZFA%"=="E" goto XZFAE
if /i "%XZFA%"=="F" goto XZFAE
if /i "%XZFA%"=="G" goto XZFAG
echo.
echo   输入有误  请重新输入
echo.
ping -n 3 127.1>nul
cls
goto XZFA

:XZFAE
echo.
echo  %XZFA%方案自带应用卸载操作...
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
echo   %XZFA% 方案自带应用卸载操作完成
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
title  %dqwc% %XZFA% 方案卸载自带应用 %dqcd%3
echo.
echo  %XZFA% 方案自带应用卸载操作完成           程序3秒后返回主菜单
echo.
ping -n 3 127.1>nul
goto XZFAO

:XZFAG
echo.
echo  开始执行 %XZFA% 方案自带应用卸载操作...
echo.
echo   请将打开的Applist.TXT每行前的 Microsoft.按 CTRL+H 键替换为改为%%un%%保存
echo.
echo   如果想保留一些应用 请将其所在的一整行从记事本中删除并保存并关闭记事本即可
echo.
start %YCP%Applist.txt
set hhcd=1
set /p hhcd= 确认按要求准备就绪直接回车执行卸载  按0回车不做任何操作并返回主菜单:
if "%hhcd%"=="0" goto XZFAO
set un= %YCDM% /image:%MOU% /Remove-ProvisionedAppxPackage /PackageName:Microsoft.
Type %YCP%applist.txt>>%YCP%unapp.cmd
ping -n 1 127.1>nul
call %YCP%unapp.cmd
title  %dqwc% %XZFA% 方案卸载自带应用 %dqcd%3
echo.
echo        自定义自带应用卸载操作完成           程序3秒后返回主菜单
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
title  %dqwz% 启用或禁用功能 %dqcd%4
echo.
echo   %dqwz% 启用或禁用功能 %dqcd%4
echo.
echo                         雨晨DISM 默认的通用禁用、启用功能详细列表
echo  ======================================================================================
echo   通常为原始系统默认状态相反的状态 但又是安装完需要禁用或开启的一系列功能 下表仅供参考
echo    ┏┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┓
echo    ┋            默认禁用功能列表          ┋            默认启用功能列表          ┋
echo    ┣┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┫
echo    ┋ 1  所有游戏功能  ┋Windows7(SP1) Only┋ 1  Net3.5 功能   ┋     NetFx3.5     ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 2  传统组件功能  ┋ LegacyComponents ┋ 2  Net4.5+ ASP+  ┋   ASPNetFx4.5+   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 3  媒体播放功能  ┋    MediaPlayer   ┋ 3  打印扫描功能  ┋ScanManagementCon.┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 4  媒体备份功能  ┋    MediaBckup    ┋ 4  旧版组件功能  ┋    DirectPlay    ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 5  Power  Shell  ┋    PowerShell    ┋ 5  目录服务功能  ┋ DirectoryServices┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 6  自带杀毒功能  ┋ Windows Defender ┋ 6  打印扫描功能  ┋ScanManagementCon.┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 7  PDF 打印功能  ┋PrintToPDFServices┋ 7  SmbDirect直通 ┋     SmbDirect    ┋
echo    ┗┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┛
echo   如需自定义操作 请直接复制打开的功能列表 复制 英文功能名称 粘贴 到本程序窗口 回车即可
echo  ======================================================================================
echo         要自定义禁用按1  自定义启用按2 如果功能名称包含有空格请在前后加上双引号        
echo.
:CXGN
set zd=3
set /p zd=请选择如何操作 直接回车将按默认方案进行启用和禁用 按0 回车 返回主菜单:
If "%zd%"=="0" Goto MENU
If "%zd%"=="1" Goto JYGN
If "%zd%"=="2" Goto QYGN
If "%zd%"=="3" Goto TYFA
echo.
echo   输入有误  请重新输入
echo.
ping -n 2 127.1>nul
cls
set zd=
goto CXGN

:TYFA
title  正在按通用默认方案进行禁用和启用...请稍候
echo.
echo   正在按通用默认方案进行禁用和启用...请稍候
echo.
%YCDM% /Image:%MOU% /english /Get-Features>%YCP%Features.txt
if %OFFSYS% LEQ 7601 (
echo.
echo   为Win7系统禁用所有游戏
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
title  正在在行默认的功能禁用...
echo.
echo   以下功能默认禁用
echo.
if %OFFSYS% GEQ 9868 for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "SearchEngine" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "WindowsPowerShell" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
if exist "%MOU%\Program Files\WindowsPowerShell" (
echo.
echo   默认禁用并移除 WindowsPowerShell 及主体数据
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
title  正在在行默认的功能启用...
echo.
echo   以下功能默认启用
echo.
if %OFFSYS% GTR 7601 if exist %SOUR%sxs (
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "NetFx3" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /source:%SOUR%sxs /All /LimitAccess)
) ELSE (
echo.
echo   没发现sxs数据 不添加启用NET3.5功能或者是Win7以下系统默认已启用了该功能
echo.
ping -n 3 127.1>nul
)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "NetFx4" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /source:%SOUR%sxs /LimitAccess)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "DirectoryServices" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "DirectPlay" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "ScanManagementConsole" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "SmbDirect" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a /all)
for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Telnet" &&%YCDM% /image:%MOU% /enable-feature /Featurename:%%a)
title  正在行部分新增启用功能启用...
echo.
echo                     部分新增启用功能 如果当前装载映像中存在
echo.
echo                                            设备锁定组及键盘筛选等共7项是否启用？
echo.
echo    ┏┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┓
echo    ┋  KeyboardFilter  ┋ DeviceLockdown   ┋ EmbeddedBootExp  ┋    Containers    ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋UnifiedWriteFilter┋Emb..ShellLauncher┋ EmbeddedLogon    ┋ 禁用 IE浏览器可选┋
echo    ┗┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┛
echo.
echo                  是  请按 Y 回车                           否  请直接回车
echo.
set ENF=N
set /p ENF=请确认列表中新增的7项功能是否启用：
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
echo   如果可以 为只使用其它浏览器或Edge浏览器用户禁用 Internet Explorer
echo.
set jyie=N
set /p jyie=不禁用直接回车     禁用按 Y 回车：
echo.
if %jyie% equ Y for /f "tokens=4 delims= " %%a in (%YCP%Features.txt) do (echo "%%a"|find /i "Internet-Explorer-" &&%YCDM% /image:%MOU% /Disable-Feature /Featurename:%%a)
title  %dqwc% 通用启用和禁用功能 %dqcd%4
echo.
echo   通用启用和禁用功能完成 3秒后返回主菜单并由您选择下一步操作
echo.
ping -n 5 127.1 >nul
cls
del /q %YCP%Features.txt
goto MENU

:JYGN
echo.
echo                        开始查询装载映像中的功能... 
echo.
%YCDM% /Image:%MOU% /Get-Features>%YCP%Features.txt
ping -n 1 127.1>nul
start %YCP%Features.txt
:JYJY
echo.
echo   请复制Features文本中启用状态的功能名称冒号后的英文粘贴到本程序窗口按Enter键
echo.
echo   如果您不熟悉相关功能禁用后的影响请不要随意禁用     以免给您带去不必要的麻烦
echo.
set /p jy=请将要禁用功能的英文名称粘贴到程序窗口中回车开始执行 按0回车 返回主菜单:
if "%jy%"=="0" del %YCP%Features.txt &&goto MENU
%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%jy%" ||%YCDM% /image:%MOU% /Disable-Feature /Featurename:"%jy%" /all
echo.
echo                            执行完毕 继续操作...
echo.
ping -n 1 127.1 >nul
cls
goto JYJY

:QYGN
echo.
echo             开始查询装载映像中的功能... 完成后自动打开功能列表
echo.
%YCDM% /Image:%MOU% /Get-Features>%YCP%Features.txt
ping -n 1 127.1>nul
start %YCP%Features.txt
:QYQY
echo.
echo   请复制Features文本中禁用状态的功能名称冒号后的英文粘贴到本程序窗口按Enter键
echo.
set /p qy=请将要启用功能的英文名称粘贴到程序窗口中 回车开始执行 按0回车 返回主菜单:
if "%qy%"=="0" del %YCP%Features.txt &&goto MENU
if /i "%qy%"=="NetFx3" (set gn=%qy% /all /source:%SOUR%sxs /LimitAccess) else (set gn=%qy% /all /LimitAccess)
%YCDM% /image:%MOU% /Enable-feature /Featurename:%gn% 2>nul
echo.
echo  执行完毕 继续操作...
echo.
ping -n 1 127.1 >nul
cls
goto QYQY

:ULAN
title  %dqwz% 集成语言包 汉化系统必须执行 %dqcd%5
echo.
echo   %dqwz% 集成语言包 汉化系统必须执行 %dqcd%5
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo    为挂载中的映像集成语言包后可将映像国际设置设置默认成相应语言界面
echo.
echo    请将名称为%SSYS%%Mbt%LP.cab放到%YCP%PCAB目录 如果没有将视为汉化操作
echo.
echo    直接回车本程序默认为设置成中文  如果不是请在下面直接输入其它语言
echo.
set ul=ZH-CN
set /p ul=输入你想将映像中存在并能设置成默认的区域名称比如中文则输入 ZH-CN 回车即可:
if not exist %YCP%PCAB\%SSYS%%Mbt%LP.cab goto ULST
echo.
echo    发现指定目录存在数据如果适用程序开始尝试添加...
echo.
%YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%SSYS%%Mbt%LP.cab
if !errorlevel!==0 (
echo.
echo    %SSYS%%Mbt%LP.cab 添加成功  程序继续
echo.
ping -n 2 127.1>nul
cls
goto ULST
) ELSE (
echo.
echo   指定位置语言包不适用或损坏 程序继续进行默认区域设置
echo.
ping -n 5 127.1>nul
cls
goto ULST
)

:ULST
echo.
echo   获取装载映像中配置语言并设置为:%ul% 开始获取并进行设置请稍候...
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
title  %dqwc% 集成语言包
echo.
echo   目前只提供完整简体中文操作 其它语言请修改相应内容 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
GOTO MENU

:JCBD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 集成MSU更新或CAB功能 %dqcd%6
echo.
echo   %dqwz% 集成MSU更新或CAB功能 %dqcd%6
echo.
echo   如现有补丁数据存在更新  请及时从MS官网获取相应更新保证作品最新并同步
echo.
echo   请确认%YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU中补丁数据正确无误回车执行操作
echo.
if %OFFSYS% equ 7600 (
echo   当前挂载系统为Win7 请将%YCP%MSU中的%SSYS%目录改名为7600 另需SP1补丁
echo.
)
set qr=
set /p qr= 确认集成补丁直接回车 不做操作返回请按N回车 打开MS官网请按G回车
if /i "%qr%"=="N" goto MENU
if /i "%qr%"=="G" Start http://catalog.update.microsoft.com/v7/site/home.aspx &&goto MENU
echo.
echo   开始尝试集成%YCP%MSU\%FSYS%\%SSYS%的补丁...
if exist %YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU %YCDM% /image:%MOU% /add-package /packagepath:%YCP%MSU\%SSYS%\%FSYS%%Mbt%MSU
title  %dqwc% 集成MSU更新或CAB功能 %dqcd%6
echo.
echo   如果无误%YCP%MSU\%SSYS%中%FSYS%的MSU或CAB已完成集成 程序6秒后自动返回主菜单
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
title  %dqwz% Win7(sp1)专用 自定义集成IE %dqcd%7
echo.
echo   %dqwz% Win7(sp1)专用 自定义集成IE %dqcd%7
echo.
echo   请选择要集成的IE版本 注意此操作需要雨晨提供标准配套或相同规范数据支持
echo.
echo         1  集成 IE9         2  集成 IE10          3  集成 IE11
echo.
set /p i=请输入你要集成的IE版本菜单序号数字 直接回车或输入错误将不做任何操作返回主菜单:
if "%i%"=="1" goto NINE
if "%i%"=="2" goto TENT
if "%i%"=="3" goto OTEN
echo.
echo  输入有误 程序返回主菜单
echo.
ping -n 3 127.1>nul
cls
goto MENU

:NINE
title  %dqwz% 映像集成IE9...请稍候
echo.
echo   开始为映像集成IE9...请稍候
echo.
echo   第1阶段       添加集成 IE9 必须补丁
if exist %YCP%IE\IEJB\%Mbt%\* %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IEJB\%Mbt%
echo.
echo   第2阶段       集成更新 IE9 核心数据
if exist %YCP%IE\IE9%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE9%Mbt%
echo.
echo   第3阶段       添加集成 IE9 修复补丁
if exist %YCP%IE\IE9%Mbt%H\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE9%Mbt%H
title  %dqwc% 映像集成IE9...请继续
echo.
echo   如果数据无误 IE9 已经成功集成到映像 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:TENT
title  %dqwz% 映像集成IE10...请稍候
echo.
echo   开始为映像集成IE10...请稍候
echo.
echo   第1阶段       添加集成 IE10 必须补丁
if exist %YCP%IE\IEJB\%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IEJB\%Mbt%
echo.
echo   第2阶段       集成更新 IE10 核心数据
if exist %YCP%IE\IE10%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE10%Mbt%
echo.
echo   第3阶段       添加集成 IE10 修复补丁
if exist %YCP%IE\IE10%Mbt%H\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE10%Mbt%H
title  %dqwc% 映像集成IE10...请继续
echo.
echo   如果数据无误 IE10已经成功集成到映像 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:OTEN
title  %dqwz% 映像集成IE11...请稍候
echo.
echo   开始为映像集成IE11...请稍候
echo.
echo   第1阶段       添加集成 IE11 必须补丁
if exist %YCP%IE\IEJB\%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IEJB\%Mbt%
echo.
echo   第2阶段       集成更新 IE11 核心数据
if exist %YCP%IE\IE11%Mbt%\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE11%Mbt%
echo.
echo   第3阶段       添加集成 IE11 修复补丁
if exist %YCP%IE\IE11%Mbt%H\*  %YCDM% /image:%MOU% /add-package /packagepath:%YCP%IE\IE11%Mbt%H
title  %dqwc% 映像集成IE11...请继续
echo.
echo   如果数据无误 IE11已经成功集成到映像 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:JKEY
title  %dqwz% 集成 %MOS% 安装密钥 %dqcd%9
echo.
echo   %dqwz% 集成 %MOS% 安装密钥 %dqcd%9
echo.
echo        程序只提供部分常用Win81和Win10提供安装密钥 安装时可跳过输入KEY
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo       检测到挂载系统为 %MOS% 程序将为下列版本自动集成安装密钥

if %OFFSYS% LSS 9600 (
echo.
echo        Windows 8.1 以下系统无需集成安装密钥 程序返回主菜单继续执行其它操作
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
echo        01 Core                    (家庭版)    02 Professional              (专业版)
echo.
echo        03 Enterprise              (企业版)    04 Edition                   (教育版)
echo.
echo        05 CoreCountrySpecific (家庭中文版)    06 EnterpriseS           (企业版LTSB) 
echo.
echo        07 EnterpriseSN       (企业版LTSBN)    08 EducationN               (教育版N)
echo.
echo        09 EnterpriseSEval     (企业评估版)    10 EnterpriseG           (企业版 G版)
echo.
echo        11 ServerStandardCore  (标准核心版)    12 ServerStandard        (标准普通版)
echo.
echo        13 ServerDatacenterCore  (数据核心)    14 ServerDatacenter        (数据中心) 
echo. 
echo        15 ProfessionalStudent (学生专业版)    16 ProfessionalStudentN (学生专业版N)
echo.
echo     ====================================================================================
echo.
if exist %MOU%\Windows\servicing\Editions\ProfessionalStudentNEdition.xml (
echo.
echo    开始安装 ProfessionalStudentN 学生专业版N密钥
%YCDM% /Image:%MOU% /Set-ProductKey:QJFNY-8Q8BQ-6WQH8-9J3K6-CGXVJ
echo.
echo             学生专业版N密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ProfessionalStudentEdition.xml (
echo.
echo    开始安装 ProfessionalStudent 学生专业版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:V3NH2-P462J-VT4G4-XD8DD-B973P
echo.
echo             学生专业版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerDatacenterEdition.xml (
echo.
echo    开始安装 ServerDatacenter 数据中心版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:CB7KF-BWN84-R7R2Y-793K2-8XDDG
echo.
echo             数据中心版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerDatacenterCoreEdition.xml (
echo.
echo    开始安装 ServerDatacenterCore 数据核心版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:CB7KF-BWN84-R7R2Y-793K2-8XDDG
echo.
echo             数据核心版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerStandardEdition.xml (
echo.
echo    开始安装 ServerStandard 标准普通版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
echo.
echo             标准普通版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\ServerStandardCoreEdition.xml (
echo.
echo    开始安装 ServerStandardCore 标准核心版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
echo.
echo             标准核心版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\EnterpriseGEdition.xml (
echo.
echo    开始安装 EnterpriseG 企业版 G 版 GVL 密钥
%YCDM% /Image:%MOU% /Set-ProductKey:YYVX9-NTFWV-6MDM3-9PT4T-4M68B
echo.
echo           企业版G密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\EnterpriseSEvalEdition.xml (
echo.
echo    开始安装 EnterpriseSEval 企业评估版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:D3M8K-4YN49-89KYG-4F3DR-TVJW3
echo.
echo           企业评估版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\CoreCountrySpecificEdition.xml (
echo.
echo    开始安装 Home China 中国版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:N2434-X9D7W-8PF6X-8DV9T-8TYMD
echo.
echo                                中国版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\CoreEdition.xml (
echo.
echo    开始安装 Home 家庭版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:YTMG3-N6DKC-DKB77-7M9GH-8HVX7
echo.
echo                                家庭版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalEdition.xml (
echo.
echo    开始安装 Professional 专业版密钥 
%YCDM% /Image:%MOU% /Set-ProductKey:VK7JG-NPHTM-C97JM-9MPGT-3V66T
echo.
echo                                专业版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalEducationEdition.xml (
echo.
echo    开始安装 Professional 专业教育版密钥 
%YCDM% /Image:%MOU% /Set-ProductKey:48FWV-TNW4T-CQ6F4-KVGQB-K3D3X
echo.
echo                                专业教育版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseEdition.xml (
echo.
echo    安装企业版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:XGVPP-NMH47-7TTHJ-W3FW7-8HV2C
echo.
echo                                企业版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseSEdition.xml (
echo.
echo    安装企业版LTSB GVL密钥
%YCDM% /Image:%MOU% /Set-ProductKey:DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
echo.
echo                             企业版LTSB GVL密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseSNEdition.xml (
echo.
echo    安装企业版LTSBN密钥
%YCDM% /Image:%MOU% /Set-ProductKey:RW7WN-FMT44-KRGBK-G44WK-QV7YK
echo.
echo                                企业版LTSBN密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EducationEdition.xml (
echo.
echo    安装教育版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
echo.
echo                                教育版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %MOU%\Windows\servicing\Editions\EducationNEdition.xml (
echo.
echo    安装教育版N密钥
%YCDM% /Image:%MOU% /Set-ProductKey:84NGF-MHBT6-FXBX8-QWJK7-DRR8H
echo.
echo                                教育版N密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
if exist %ISO%\sources\product.ini start %ISO%\sources\product.ini
echo.
echo             程序当前没有为装载中系统提供安装密钥 自动转到手动添加安装密钥
echo.
echo             如果存在 程序已经为您打开%ISO%\sources\product.ini进行手动集成
echo.
ping -n 5 127.1 >nul
cls
goto SDMY

:Win81
echo.
echo             =============================================================
echo.
echo             1 Core         (核心版)     2 ProfessionalWMC (专业含媒体中心)
echo.
echo             3 Professional (专业版)     4 Professional VL   (大客户专业版)
echo.
echo             5 Enterprise   (企业版)     6 Corecountryspecific     (中国版)
echo.
echo             7 Embedded Pro (工业版)     8 CoreSingleLanguage    (单语言版)
echo.
echo             ==============================================================
echo.
if exist %MOU%\Windows\servicing\Editions\CoreEdition.xml (
echo.
echo    开始安装 Core 核心版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:Y9NXP-XT8MV-PT9TG-97CT3-9D6TC
echo.
echo                                核心版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalWMCEdition.xml (
echo.
echo    开始安装 ProfessionalWMC版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:GBFNG-2X3TC-8R27F-RMKYB-JK7QT
echo.
echo                        专业含媒体中心版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\ProfessionalEdition.xml (
echo.
echo    开始安装 Professional 专业版密钥 
%YCDM% /Image:%MOU% /Set-ProductKey:GBFNG-2X3TC-8R27F-RMKYB-JK7QT
echo.
echo                                专业版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\gvlkProfessionalEdition.xml (
echo.
echo    开始安装 Professional 大客户专业版密钥 
%YCDM% /Image:%MOU% /Set-ProductKey:GCRJD-8NW9H-F2CDX-CCM8D-9D6T9
echo.
echo                          大客户专业版密钥 安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EnterpriseEdition.xml (
echo.
echo    安装企业版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:FHQNR-XYXYC-8PMHT-TV4PH-DRQ3H
echo.
echo                                企业版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\CoreCountrySpecificEdition.xml (
echo.
echo    安装中国版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:TNH8J-KG84C-TRMG4-FFD7J-VH4WX
echo.
echo                                中国版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\EmbeddedIndustryEdition.xml (
echo.
echo    安装工业版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:NDXXJ-YX29Q-JDY6B-C93G8-TQ6WH
echo.
echo                                工业版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)

if exist %MOU%\Windows\servicing\Editions\CoreSingleLanguageEdition.xml (
echo.
echo    安装单语言版密钥
%YCDM% /Image:%MOU% /Set-ProductKey:NDXXJ-YX29Q-JDY6B-C93G8-TQ6WH
echo.
echo                                单语言版密钥安装完成
echo.
ping -n 3 127.1 >nul
cls
goto MENU
)
echo.
echo      程序当前没有为挂载中的系统提供安装密钥 自动转到手动添加安装密钥
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
title  %dqwz% 手动输入密钥 %dqcd%8
echo.
echo   %dqwz% 自备安装密钥 %dqcd%8
echo.
echo    为 %MOS% 手动输入安装密钥 不集成请按N回车返回主菜单
echo.
echo    如装载系统和当前系统版本相同且仍使用当前系统的安装密钥回车即可
echo.
echo    当前系统 %OOS% 的安装密钥为：%KEY%
echo.
set /p KEY=请正确输入一组您的安装密钥 包括中间的短划线回车执行操作:
if /i "%key%"=="N" GOTO MENU
%YCDM% /Image:%MOU% /Set-ProductKey:%KEY%
if %errorlevel% NEQ 0 (
echo.
echo     密钥安装失败  请确认你提供的密钥输入正确和适用后重新执行集成
echo.
ping -n 3 127.1>nul
cls
goto MENU
)
title  %dqwc% 手动输入密钥 %dqcd%8
echo.
echo   密钥安装操作完成 如果是您购买的正版密钥安装完成联网将自动永久激活
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KWNR
title  %dqwz% 移除Recovery 系统还原数据 %dqcd%10
echo.
echo   %dqwz% 移除Recovery 系统还原数据 %dqcd%10
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
title  %dqwc% 移除Recovery 系统还原数据 %dqcd%10
echo.
echo   系统自带还原映像数据已移除 在需要时可随时还原启用 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KLWD
title  %dqwz% 禁用或移除Defender %dqcd%11 
echo.
echo   %dqwz% 禁用或移除Defender %dqcd%11 
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   1 只禁用而不移除数据    直接回车禁用并移除 Windows Defender
echo.
set kwdm=2
set /p kwdm=默认直接回车移除Windows Defender数据 按  1 禁用 0 返回主菜单
if /i "%kwdm%"=="0" (
 echo.
 echo   程序将不执行任何操作返回主菜单
 echo.
 ping -n 5 127.1>nul
 cls
 goto MENU
) ELSE (
 echo.
 echo   程序开始设置禁用映像中的 Windows Defender 及安全中心...
 echo.
 reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
 reg add "HKLM\0\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul
 reg unload HKLM\0 >nul
 title  %dqwc% 禁用Defender %dqcd%11-1
 echo.
 echo   成功设置禁用映像中的 Windows Defender 注册表 √
 echo.
 ping -n 5 127.1>nul
if /i %kwdm% EQU 1 CLS &&Goto MENU
)
echo.
echo    查询映像 Windows Defender 功能是否提供禁用并进行相应操作...
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
echo    默认移除 SecurityHealthService 主程序
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\Windows Defender Advanced Threat Protection" /r /d y && icacls "%MOU%\Program Files\Windows Defender Advanced Threat Protection" /grant administrators:F /t
rd /S /Q "%MOU%\Program Files\Windows Defender Advanced Threat Protection"
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Defender Advanced Threat Protection"
)
if exist "%MOU%\Windows\System32\SecurityHealthService.exe" (
echo.
echo    安全关闭安全中心主程序及开始菜单中的图标
echo.
cmd.exe /c takeown /f "%MOU%\ProgramData\Microsoft\Windows Security Health" /r /d y && icacls "%MOU%\ProgramData\Microsoft\Windows Security Health" /grant administrators:F /t
rd /S /Q "%MOU%\ProgramData\Microsoft\Windows Security Health"
cmd.exe /c takeown /f %MOU%\Windows\System32\SecurityHealthService.exe && icacls %MOU%\Windows\System32\SecurityHealthService.exe /grant administrators:F /t
ren %MOU%\Windows\System32\SecurityHealthService.exe SecurityHealthService.bak
)
echo.
echo    安全关闭 smartscreen 主程序
echo.
if exist "%MOU%\Windows\System32\smartscreen.exe" (
cmd.exe /c takeown /f %MOU%\Windows\System32\smartscreen.exe && icacls %MOU%\Windows\System32\smartscreen.exe /grant administrators:F /t
ren %MOU%\Windows\System32\smartscreen.exe smartscreen.bak
)
title  %dqwc% 移除 Windows Defender %dqcd%11 
echo.
echo    系统自带杀毒主体 Windows Defender 数据已移除 程序返回
echo.
ping -n 5 127.1>nul
cls
goto MENU

:KONE
title  %dqwz% 移除OneDrive或SkyDrive或Win10升级助手 %dqcd%12
echo.
echo   %dqwz% 移除OneDrive或SkyDrive或Win10升级助手 %dqcd%12
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
echo   处理注册表中的登录启动项  之前此接口的设置包括推广全部清空
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
title  %dqwc% 移除OneDrive或SkyDrive或Win10升级助手 %dqcd%12
echo.
echo   OneDrive或SkyDrive数据数据已移除 程序返回主菜单
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
title  %dqwz% 精简 Edge 浏览器 %dqcd%13
echo.
echo   %dqwz% 精简 Edge 浏览器 %dqcd%13
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
title  %dqwc% 精简 Edge 浏览器 %dqcd%13
echo.
echo  Edge 数据已经移除 程序3秒后返回主菜单
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
title  %dqwz% 精简 Cortana 小娜 %dqcd%14
echo.
echo   %dqwz% 精简 Cortana 小娜 %dqcd%14
echo.
echo   强烈建议您使用 主菜单 46 进行卸载或禁用相关功能而非本暴力删除操作
echo.
ping -n 3 127.1>nul
echo   Cortana 小娜 注册表禁用设置
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
echo   移除 Cortana 小娜数据
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" /r /d y && icacls "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy"
title  %dqwc% 精简 Cortana 小娜 %dqcd%14
echo.
echo  Cortana 小娜数据已经移除 程序3秒后返回主菜单
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
title  %dqwz% 移除 Speech 语音包括 TTS 数据 %dqcd%15
echo.
echo   %dqwz% 移除 Speech 语音包括 TTS 数据 %dqcd%15
echo.
echo   强烈建议您使用 主菜单 46 进行 15000后移除将影响系统安装部署
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
title  %dqwc% 移除 Speech 语音包括 TTS 数据 %dqcd%15
echo.
echo  Speech 语音数据已经强制删除 程序3秒后返回主菜单
echo.
ping -n 3 127.1 >nul
cls
goto MENU

:PEFT
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 精简字体 %dqcd%16 
echo.
echo   %dqwz% 精简字体 %dqcd%16 
echo.
echo   采用WINPE字体作为保留样本 经实际测试不影响OFFICE2016正式版安装
echo.
echo   使用 boot.wim 中字体库 Fonts 并补充UI字体只推荐做极限精简测试
echo.
echo   1 默认采用PE字体为样本精简     2 使用PE字体并补充UI字体 骨头版
echo.
set ftfa=1
set /p ftfa=请选择你要的方案1或2 不做操作返回请输入0回车：
if "%ftfa%"=="2" goto BTFT
if "%ftfa%"=="1" goto SFFT
if "%ftfa%"=="0" goto MENU

:SFFT
echo.
echo   采用WINPE字体作为保留样本 经实际测试不影响OFFICE2016正式版安装
echo.
echo   开始处理权限并精简字体... 请稍候！
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
title  %dqwc% 精简字体 %dqcd%16-1
echo.
echo   字体精简操作完成  5秒后程序返回主菜单
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:BTFT
echo.
echo   使用 boot.wim 中字体库 Fonts 并补充UI字体只推荐做极限精简测试
echo.
echo   装载ISO状态直接执行否则请提取ISO\Sources\boot.wim 到 %YCP%
echo.
echo   开始处理权限并执行终极安全极限字体精简操作... 请稍候！！！
echo.
if not exist %SOUR%boot.wim (
echo.
echo   没有发现 %SOUR%boot.wim 请确认无误后重新执行 程序返回
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
title  %dqwc% 精简字体 %dqcd%16-2
echo.
echo   使用 boot.wim 中字体库 Fonts 并补充UI字体操作完成  5秒后返回
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
title  %dqwz% 精简 assembly 部分数据 %dqcd%17
echo.
echo   %dqwz% 精简 assembly 部分数据 %dqcd%17
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
title  %dqwc% 精简 assembly 部分数据 %dqcd%17
echo.
echo  Assembly 部分数据已经移除 程序3秒后返回主菜单
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
title  %dqwz% 安全精简其它一些强制内置的应用  %dqcd%18
echo.
echo      为Win10以上系统安全精简其它一些强制内置的应用  %dqcd%18
echo.
if exist %YCP%SystemAppslist.txt del /q /f %YCP%SystemAppslist.txt >nul
if exist %MOU%\Windows\HoloShell echo HoloShell>%YCP%SystemAppslist.txt
if exist %MOU%\Windows\SystemApps (dir /b /a "%MOU%\Windows\SystemApps">>%YCP%SystemAppslist.txt)
echo.
echo    ┏┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┓
echo      以下已经列出1703以前部分强制内置的应用 不包括已经移除的项目 以下为默认保留部分
echo.
echo    ┏┅┳┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┳┅┓
echo    ┋01┋        系  统  云  主  机        ┋   Windows Cloud Experience Host  ┋●┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋02┋        家   长   控   制         ┋     Parental       Controls      ┋●┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋03┋        外   壳   主   机         ┋      Shell  Experience  Host     ┋●┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋04┋        Edge     浏 览 器         ┋     Microsoft           Edge     ┋◎┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋05┋        Cortana 小娜 语音         ┋     Windows          Cortana     ┋◎┋
echo    ┣┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅╋┅┫
echo    ┋06┋        Metro 锁 屏 管 理         ┋     Content Delivery Manager     ┋◎┋
echo    ┗┅┻┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┻┅┛
echo.
echo               确认精简请直接回车                     不精简请按N回车返回
echo    ┗┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┛
echo.
set ksya=Y
set /p ksya=请确定你的选择并回车：
if /i "%ksya%"=="N" if exist %YCP%SystemAppslist.txt del /q /f %YCP%SystemAppslist.txt >nul &&GOTO MENU 
echo.
echo      开始按默认安全方案进行精简强制内置的应用...    请稍候
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
title  %dqwc% 安全精简其它一些强制内置的应用  %dqcd%18
echo.
echo   已经为1703以前系统安全精简了已知可以精简的强制内置部分应用
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
title  %dqwz% 为 Win10 N版系统添加 Windows Media Player 功能  %dqcd%19
echo.
echo   %dqwz% 为 Win10 N版系统添加 Windows Media Player 功能  %dqcd%19
echo.
if not exist "%MOU%\Program Files\Windows Media Player\wmplayer.exe" %YCDM% /image:%MOU% /add-package /packagepath:%YCP%PCAB\%SSYS%WMP%Mbt%.CAB
if !errorlevel!==0 (
title  %dqwc% 为 Win10 N版系统添加 Windows Media Player 功能
echo.
echo   成功添加 Windows Media Player 功能                    程序返回主菜单
echo.
) ELSE (
echo.
echo   操作有误或程序包损坏 未能成功添加 Windows Media Player 功能 程序返回
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
title  %dqwz% 为已知或未知硬件 添加集成专用或通用绿色驱动 %dqcd%20-2
echo.
echo   %dqwz% 为已知或未知硬件 添加集成专用或通用绿色驱动 %dqcd%20-2
echo.
echo   注意挂载中的映像为%Mbt%请确认你要添加的驱动也是%Mbt%并且适用于挂载中的映像否则不能继续
echo.
echo   请将要集成的驱动复制到%YCP%%FSYS%%Mbt%QD目录 确认为INF格式完整驱动目录按回车开始集成
echo.
echo   推荐在已安装好的系统Windows\System32\DriverStore\FileRepository\除系统自带的驱动目录
echo.
echo   将新目录复制到%YCP%%FSYS%%Mbt%QD 无重复文件名或目录 可全部放在一起本程序自动搜索添加
echo.
if not exist %YCP%%FSYS%%Mbt%QD md %YCP%%FSYS%%Mbt%QD
pause>nul
echo.
echo  开始集成驱动... 根据驱动大小和多少决定耗时 请耐心等待程序操作完成自动提示下一步操作
if exist %YCP%%FSYS%%Mbt%QD\*  %YCDM% /Image:%MOU% /Add-Driver /Driver:%YCP%%FSYS%%Mbt%QD\ /Recurse /Forceunsigned
rem 如果提供的驱动没有签名请使用下面Forceunsigned的参数单独将其集成
rem %YCDM% /Image:%MOU% /Add-Driver /Driver:%YCP%%FSYS%%Mbt%QD\ /Recurse /Forceunsigned
title  %dqwc% 为已知或未知硬件 添加集成专用或通用绿色驱动 %dqcd%20-2
echo.
echo       %YCP%%FSYS%%Mbt%QD目录中驱动添加完成 程序6秒后自动返回主菜单后继续
echo.
ping -n 6 127.1>nul
cls
goto MENU

:WNQD
title  %dqwz% 集成或者整合驱动 %dqcd%20-1
echo.
echo   %dqwz% 为不能自动在线安装驱动的目标硬件添加或集成驱动
echo.
echo     1    推荐并默认整合 万能驱动7^[主板芯片+网卡^]部分
echo.
echo     2    为已知或未知硬件 添加集成专用或通用绿色驱动
echo.
echo   低版系统建议连同PE或boot集成USB3及SSD驱动保证顺利安装
echo.
set fsxz=1
set /p fsxz=请选择当前提供的操作菜单序号数字 直接回车默认为1：
if /i %fsxz% equ 2 goto JCQD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if not exist %MOU%\Windows\Setup\Scripts md %MOU%\Windows\Setup\Scripts
if exist %YCP%ADXX\%FSYS%%Mbt% Xcopy /y /s %YCP%ADXX\%FSYS%%Mbt% %MOU%\Windows\Setup\Scripts\
if not exist %MOU%\Windows\Setup\Scripts\SetupComplete.cmd  Xcopy /y /s %YCP%MY\Setup\Scripts\SetupComplete.cmd  %MOU%\Windows\Setup\Scripts\
title  %dqwc% 整合万能驱动7^[主板芯片+网卡^] %dqcd%20-1
echo.
echo   整合万能驱动7^[主板芯片+网卡^]完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:SOFT
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 加入想要整合到映像中的绿色软件 %dqcd%26
echo.
echo   %dqwz% 加入想要整合到映像中的绿色软件 %dqcd%26
echo.
echo  简单说明：
echo  ======================================================================================
echo      YCDISM宗旨为纯净安全，强烈禁止利用本程序加入存在安全隐患的程序整合到映像中！在加入
echo.
echo  绿色软件前需要您须知该软件或自解压包的静默执行参数，否则在无人值守安装部署时将停留在需
echo.
echo  要点击下一步或勾选同意协议类似的互动安装界面而导致无人值守安装部署的效率，程序推荐在整
echo.
echo  合前将绿色软件的名称进行简化和规范，名称推荐用简洁无空格字母或者英文命名以适应所有语言
echo.
echo  x86架构程序请放在%YCP%MY\SOFT\x86目录中 x64架构程序请放在%YCP%MY\SOFT\x64目录中
echo.
echo                               执行此操作前请完成无人值守操作
echo  ======================================================================================
echo.
if not exist %MOU%\Windows\Setup\Scripts\SetupComplete.cmd goto WRZS
if not exist %YCP%MY\SOFT\%Mbt%\*.exe (
echo.
echo  没有发现%YCP%MY\SOFT\%Mbt%目录下存在EXE程序数据     请确认数据准备就绪后重新执行整合操作
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
echo      请在打开的文本下面每行最后加上该程序静默参数 注意大小写比如：/S
echo.
echo      确认已按要求正确操作完毕请保存并关闭文本         按回车加入调用
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
title  %dqwc% 整合绿色软件 %dqcd%26
echo.
echo      整合绿色软件到映像操作完成                    程序返回主菜单 
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADVC
title  %dqwz% 添加常用VC NET Flash DirectX 离线安装程序 %dqcd%21
echo.
echo   %dqwz% 添加常用VC NET Flash DirectX 离线安装程序 %dqcd%21
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
echo   添加NET4.6...
Xcopy /y %YCP%ADXX\N462.exe %MOU%\Windows\Setup\Scripts\
echo.
echo   添加FLASH...
Xcopy /y %YCP%ADXX\FLASH.exe %MOU%\Windows\Setup\Scripts\
)
echo.
echo   添加DirectX...
Copy /y %YCP%ADXX\DirectX%Mbt%.exe %MOU%\Windows\Setup\Scripts\DirectX.exe
title  %dqwc% 添加常用VC NET Flash DirectX 离线安装程序 %dqcd%21
echo.
echo   VC NET Flash DirectX离线安装程序已添加完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:MWEB
title  %dqwz% 替换映像Web目录所有图片 %dqcd%22
echo.
echo   %dqwz% 替换映像Web目录所有图片 %dqcd%22
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   如果存在自DIY的LOGO文件 程序将替换到目标系统中
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Branding\Shellbrd" /r /d y && icacls "%MOU%\Windows\Branding\Shellbrd" /grant administrators:F /t
if exist %YCP%MY\%FSYS%Shellbrd.dll Copy /y %YCP%MY\%FSYS%Shellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
if %OFFSYS% GEQ 14295 (
if exist %YCP%MY\RSShellbrd.dll Copy /y %YCP%MY\%YCP%MY\RSShellbrd.dll %MOU%\Windows\Branding\Shellbrd\Shellbrd.dll
)
echo.
echo   获取主题相关数据的权限并替换为%YCP%MY中的数据...
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
title  %dqwc% 替换映像Web目录所有图片 %dqcd%22
echo.
echo   替换映像Web目录所有图片已完成 √
echo.
ping -n 5 127.1>nul
cls
goto MENU

:USER
title  %dqwz% 音乐 图片 下载 收藏夹 视频 放在D盘文档内 %dqcd%23
echo.
echo   %dqwz% 音乐 图片 下载 收藏夹 视频 放在D盘文档内 %dqcd%23
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   程序开始生成用户数据设D盘的注册表并导入
if %OFFSYS% LEQ 7601 (
Copy /y %YCP%Panther\W7YH.reg %MOU%\Windows\Setup\YCYH.reg >nul
 echo.
echo   当前映像为 %FSYS% 因变量的不确定性 设置将安排在部署时导入生效
 echo.
) ELSE (
 echo.
 echo   当前映像为 %FSYS% 将直接将设置固化到映像中并立即生效...
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
 echo   当前映像为 %FSYS% 设置已经成功固化到映像 默认和新建账户 并已生效 √
 Xcopy /y %YCP%Panther\YCYH.reg %MOU%\Windows\Setup\ >nul
)
if exist %YCP%USER.reg if exist %MOU%\Users\Administrator\NTUSER.DAT (
 echo.
 echo   当前映像可能为二次封装的映像 将为 Administrator 账户启用相同设置
 echo.
 reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT">nul
 regedit /s %YCP%USER.reg
 reg unload HKLM\0 >nul
)
echo   开始清理映像中的残留目录防止安装后存在两个相同文件夹
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
echo   开始清理映像中的残留目录完成 √
echo.
if exist %YCP%USER.reg del /q /f %YCP%USER.reg
if exist %YCP%USERS.reg del /q /f %YCP%USERS.reg
echo.
title   %dqwc% 音乐 图片 下载 收藏夹 视频 放在D盘文档内 %dqcd%23
echo.
echo   %dqwc% 音乐 图片 下载 收藏夹 视频 放在D盘文档内   程序返回
echo.
ping -n 6 127.1>nul
cls
goto MENU

:WRZS
title  %dqwz% 标准帐户无人值守安装通用优化 %dqcd%24
echo.
echo   %dqwz% 标准帐户无人值守安装通用优化 %dqcd%24
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   全新默认新建标准帐户 MyPC 无密码 自动安装至桌面 杜绝内置账户使用APPS的一些问题
echo.
echo   您可根据自己喜欢改变用户名称 比如 MyComputer 或其他用户名 尽量以英文单词或拼写
echo.
ping -n 3 127.1>nul
echo   开始设置并添加相关数据  请稍候...
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
echo   开始为 %FSYS% 系统关闭资源管理导航中的库和收藏夹...
echo.
echo   去掉资源管理器中的快速访问...
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
echo   去掉资源管理器中的快速访问设置完成 √
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
echo   成功为 %FSYS% 系统关闭资源管理导航中的库和收藏夹 √
echo.
if exist %MOU%\Windows\Setup\Scripts\TOAC.exe Xcopy /y %YCP%MY\Keys.ini %MOU%\Windows\Setup\Scripts\
if not exist %YCP%MY\System32\logo.bmp if exist %YCP%MY\logo.bmp Xcopy /y %YCP%MY\logo.bmp %YCP%MY\System32\
Xcopy /y %YCP%MY\System32 %MOU%\Windows\System32\
set adm=
if exist %YCP%Panther\%FSYS%%Mbt%otherunattend.xml (
echo.
echo   当前系统为Win10 默认自动以内置管理员Admin安装并登录 如需标准账户请按 0 回车
echo.
echo   说明：如果要完美使用APP应用和微软账户请按0 没有或者不使用APP应用 请直接回车
echo.
set /p adm=请选择以哪种账户自动安装并登录 输入0或直接回车执行操作
)
if "%adm%"=="0" (
Copy /y %YCP%Panther\%FSYS%%Mbt%Otherunattend.xml %MOU%\Windows\Panther\unattend.xml
if %OFFSYS% GEQ 15025 Copy /y %YCP%Panther\RS%FSYS%%Mbt%Otherunattend.xml %MOU%\Windows\Panther\unattend.xml
) ELSE (
Copy /y %YCP%Panther\%FSYS%%Mbt%Adminunattend.xml %MOU%\Windows\Panther\unattend.xml
if %OFFSYS% GEQ 15025 Copy /y %YCP%Panther\RS%FSYS%%Mbt%Adminunattend.xml %MOU%\Windows\Panther\unattend.xml
)
echo.
echo   桌面显示 我的电脑 回收站 用户文件夹 IE图标...
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
echo   桌面显示 我的电脑 回收站 用户文件夹 图标完成 √
echo.
echo   增加设置在桌面显示 Internet Explorer 图标...
echo.
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{00000000-0000-0000-0000-100000000001}" /ve /t REG_SZ /d "Internet Explorer" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}" /ve /t REG_SZ /d "Internet Explorer" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\DefaultIcon" /ve /t REG_SZ /d "ieframe.dll,-190" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell" /ve /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\NoAddOns" /ve /t REG_SZ /d "无加载项(&N)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\NoAddOns\Command" /ve /t REG_SZ /d "iexplore.exe -extoff" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Open" /ve /t REG_SZ /d "打开主页(&H)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Open\Command" /ve /t REG_SZ /d "iexplore.exe" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Set" /ve /t REG_SZ /d "属性(&R)" /f >nul
reg add "HKLM\0\Classes\CLSID\{00000000-0000-0000-0000-100000000001}\Shell\Set\Command" /ve /t REG_SZ /d "rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl" /f >nul
reg unload HKLM\0 >nul
echo.
echo   在桌面显示 Internet Explorer 图标设置完成 √
echo.
ping -n 6 127.1>nul
Xcopy /y %YCP%MY\RunOnce.cmd %MOU%\Windows\Setup\State\ >nul
if %SSYS% EQU %OFFSYS%S Copy /y %YCP%MY\SSRunOnce.cmd %MOU%\Windows\Setup\State\RunOnce.cmd >nul

:CSHP
set hp=http://www.2345.com/?k371057592
echo.
echo   请粘贴你的IE首页网址到本程序窗口后回车 否则默认为雨晨2345导航
echo.
set /p hp=请输入或直接粘贴你自己要设置的IE主页网址  回车后将应用到映像中
echo.
echo   你设置的主页为 %hp% 确认无误请直接回车
echo.
set hpqr=
set /p hpqr=输入 N 回车重新修改IE主页网址
if /i "%hpqr%"=="N" GOTO CSHP
echo.
echo   将%hp%设置为映像默认的IE主页并添加启用CSS样式屏蔽常见广告 √
echo.
echo   右键添加显示或隐藏文件或扩展名...
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">nul
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden" /ve /t REG_SZ /d "显示或隐藏文件及扩展名" /f >nul
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden\Command" /ve /t REG_EXPAND_SZ /d "WScript.exe %%Windir%%\System32\SuperHidden.vbs" /f >nul
reg unload HKLM\0 >nul
Xcopy /y %YCP%MY\System32\SuperHidden.vbs %MOU%\Windows\System32\ >nul
echo.
echo   右键添加显示或隐藏文件或扩展名 √
echo.
echo   部分优化 推迟升级 和IE等设置 √
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
echo   关闭应用自动备份功能 √
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Policies\Microsoft\Windows\SettingSync" /v "EnableBackupForWin8Apps" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0>nul
echo.
echo   关闭账户控制 √
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f >nul
reg unload HKLM\0>nul
echo.
echo   将图片预览背景设置为黑色 √
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Windows Photo Viewer\Viewer" /v "BackGroundColor" /t REG_DWORD /d "4278255873" /f >nul
reg unload HKLM\0>nul
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows Photo Viewer\Viewer" /v "BackGroundColor" /t REG_DWORD /d "4278255873" /f >nul
reg unload HKLM\0 >nul 
echo.
echo   资源管理显示完整路径 √
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d 1 /f >nul
reg unload HKLM\0 >nul 
echo.
echo   任务栏显示触摸键盘 桌面右键工具 √
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Classes\*\shell\Notepad" /ve /t REG_SZ /d "用记事本打开该文件" /f >nul
reg add "HKLM\0\Classes\*\shell\Notepad\Command" /ve /t REG_SZ /d "notepad %%1" /f >nul
reg add "HKLM\0\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\TabletTip\1.7" /v "TipbandDesiredVisibility" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr" /ve /t REG_SZ /d "清理工具" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\cleanmgr.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\cleanmgr\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\cleanmgr.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig" /ve /t REG_SZ /d "系统配置" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\msconfig\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\msconfig.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool" /ve /t REG_SZ /d "截图工具" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\SnippingTool.exe" /f >nul
reg add "HKLM\0\Classes\DesktopBackground\Shell\SnippingTool\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\SnippingTool.exe" /f >nul
reg unload HKLM\0>nul
echo.
echo   我的电脑右键加入常用工具快捷菜单...
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
echo   我的电脑右键添加“控制面板”
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /ve /t REG_SZ /d "控制面板(&C)" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control" /v "Icon" /t REG_SZ /d "shell32.dll,207" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\control\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe shell32.dll,Control_RunDLL" /f >nul
echo.
echo   我的电脑右键添加“设备管理器”
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr" /ve /t REG_SZ /d "设备管理器" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\DevMgr\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\devmgmt.msc" /f >nul
echo.
echo   我的电脑右键添加“添加或删除程序”
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall" /ve /t REG_SZ /d "添加或删除程序" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Dezinstall\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl" /f >nul
echo.
echo   我的电脑右键添加“组策略”
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit" /ve /t REG_SZ /d "组策略" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\NGpEdit\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe /s %%SystemRoot%%\system32\gpedit.msc" /f >nul
echo.
echo   我的电脑右键添加“注册表编辑器”
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /ve /t REG_SZ /d "注册表编辑器" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\regedit.exe" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\Regedit\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\regedit.exe" /f >nul
echo.
echo   我的电脑右键添加“服务”
echo.
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services" /ve /t REG_SZ /d "服务(&V)" /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services" /v "SuppressionPolicy" /t REG_DWORD /d 1073741884 /f >nul
reg add "HKLM\0\Classes\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\services\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\mmc.exe %%SystemRoot%%\system32\services.msc" /f >nul
echo.
echo   我的电脑右键添加以上快捷菜单完成 √
echo.
echo   右键添加获取管理员权限...
echo.
reg add "HKLM\0\Classes\*\shell\runas" /ve /t REG_SZ /d "管理员取得所有权" /f >nul
reg add "HKLM\0\Classes\*\shell\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /ve /t REG_SZ /d "管理员取得所有权" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\exefile\shell\runas2\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /ve /t REG_SZ /d "管理员取得所有权" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /v "Icon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\imageres.dll,-79" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul
reg add "HKLM\0\Classes\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f >nul
echo.
echo   右键添加获取管理员权限完成 √
echo.
echo   右键添加“复制文件或复制目录路径”...
echo.
reg add "HKLM\0\Classes\*\shell\copypath" /ve /t REG_SZ /d "复制文件路径" /f >nul
reg add "HKLM\0\Classes\*\shell\copypath\command" /ve /t REG_SZ /d "mshta vbscript:clipboarddata.setdata(\"text\",\"%%1\")(close)" /f >nul
reg add "HKLM\0\Classes\Directory\shell\copypath" /ve /t REG_SZ /d "复制目录路径" /f >nul
reg add "HKLM\0\Classes\Directory\shell\copypath\command" /ve /t REG_SZ /d "mshta vbscript:clipboarddata.setdata(\"text\",\"%%1\")(close)" /f >nul
echo.
echo   右键添加复制路径完成 √
echo.
echo   去快捷方式箭头及快捷方式字样等设置... 
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
echo   去快捷方式箭头及快捷方式字样设置完成 √
echo.
echo   允许更改主题图标及系统优化相关设置 √
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Microsoft\Command Processor" /v "CompletionChar" /t REG_DWORD /d 64 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "ReportAndContinue" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "AlwaysUnloadDll" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\0\Microsoft\Windows\Windows Error Reporting\Assert Filtering Policy" /v "Max Cached Icons" /t REG_SZ /d "7500" /f >nul
echo   关闭系统自动还原 √
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
title  %dqwc% 无人值守安装通用优化 %dqcd%24
echo.
echo   无人值守安装及部分优化操作完成 √
echo.
ping -n 5 127.1>nul
if %OFFSYS% GEQ 9200 (goto BLUE) ELSE (goto YCSZ)
cls

:BLUE
echo.
echo   桌面图标设置彩色标题栏等 √
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
echo   桌面图标设置完成 程序继续完成操作后自动返回 √
echo.
ping -n 3 127.1>nul
if %OFFSYS% GEQ 10240 (goto NRTM) ELSE (goto YCSZ)
cls

:NRTM
echo.
echo   Win10 IE 兼容设置和禁用客户体验改善计划及透明任务栏 √
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
echo.
echo   隐藏 Cortana 小娜在任务栏中的图标显示 √
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
echo   Win10 Internet Explorer 兼容相关设置完成 √
echo.
if exist "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" if exist %YCP%MY\MUI\%OFFSYS%windows.storage.dll.mui (
echo.
echo   发现具备将此电脑改成我的电脑文件 程序自动替换文件 请稍候...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\System32\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\System32\zh-CN\"
)
if exist "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" if exist %YCP%MY\MUI\%OFFSYS%windows.storage.dll.mui (
echo.
echo   64位系统　将此电脑改成我的电脑文件 程序自动替换文件 请稍候...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
)
if %OFFSYS% GEQ 14393 if exist "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" (
echo.
echo   发现具备将此电脑改成我的电脑文件 程序自动替换文件 请稍候...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\System32\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\System32\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\System32\zh-CN\" >nul
)
if %OFFSYS% GEQ 14393 if exist "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" (
echo.
echo   64位系统　将此电脑改成我的电脑文件 程序自动替换文件 请稍候...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\windows.storage.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\windows.storage.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\"
cmd.exe /c takeown /f "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" && icacls "%MOU%\Windows\SysWOW64\zh-CN\shell32.dll.mui" /grant administrators:F /t
Xcopy /y %YCP%MY\MUI\shell32.dll.mui "%MOU%\Windows\SysWOW64\zh-CN\" >nul
)
ping -n 3 127.1>nul
echo.
echo   采用传统图片查看器预览图片...
echo.
reg load HKLM\0 "%MOU%\Windows\System32\config\SOFTWARE">nul
reg add "HKLM\0\Classes\Applications\photoviewer.dll\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f >nul
reg add "HKLM\0\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f >nul
reg add "HKLM\0\Classes\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f >nul
echo.
echo   采用传统图片查看器预览图片设置完成 √
echo.
echo   为常见图片格式建立关联...
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
echo   为常见图片格式建立关联设置完成 √
echo.
if %OFFSYS% GEQ 14295 (goto RSTO) ELSE (goto YCSZ)
cls

:RSTO
echo.
echo   1607不使用桌面语言栏及不在开始菜单显示建议及关闭游戏录制 √
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
echo   不使用桌面语言栏及不在开始菜单显示建议及关闭游戏录制 √
echo.
ping -n 3 127.1>nul

:YCSZ
echo   开始菜单等多项设置并启用最佳性能...
echo.
echo   请自定义计算机性能选项　默认最佳性能并平滑字体
echo.
echo   　　2 最佳性能　1 为最佳外观　0 最佳设置
echo.
set pcxl=2
set /p pcxl=请选择输入序号数字回车　直接回车默认最佳性能：
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
if %OFFSYS% GEQ 15021 echo "FaceName"="新宋体">>%YCP%YCcmd.reg
echo "ScreenBufferSize"=dword^:002a0060>>%YCP%YCcmd.reg
echo "ScreenColors"=dword^:0000001f>>%YCP%YCcmd.reg
echo "WindowAlpha"=dword^:000000ce>>%YCP%YCcmd.reg
echo "WindowPosition"=dword^:000c023a>>%YCP%YCcmd.reg
echo.>>%YCP%YCcmd.reg
echo [HKEY_LOCAL_MACHINE\0\Console\%%SystemRoot%%_System32_cmd.exe]>>%YCP%YCcmd.reg
if %OFFSYS% GEQ 15021 echo "FaceName"="新宋体">>%YCP%YCcmd.reg
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
echo   如果当前挂载的映像为二次封装一样有效 √
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
echo   所有通用优化和人性化设置完成固化 若不是服务器程序返回主菜单
echo.
ping -n 6 127.1>nul
if /i %SSYS% EQU %OFFSYS%S ( 
Copy /y %YCP%Panther\SSYH.reg %MOU%\Windows\Setup\YCYH.reg >nul
echo.
echo   发现当前装载映像为服务器系统 将为服务器系统Admin账户进行通用设置...
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
echo   禁用IE增强 Ctrl+Alt+Del 登录前可关机 为程序启用性能 关闭服务管理面板随机启动 ...
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
echo   为服务器系统 Administrator 账户安装 可能需要自定义密码登录完成 √
echo.
ping -n 6 127.1>nul
)
cls
goto MENU

:ZTSZ
title  %dqwz% 设置宋体为默认字体 %dqcd%45
echo.
echo   %dqwz% 设置宋体为默认字体 %dqcd%45
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   Win10系统 设置宋体为默认字体或恢复默认雅黑字体
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
set /p mrzt=要设为默认宋体请按1  恢复默认雅黑请直接回车：
if "%mrzt%"=="0" regedit /s %YCP%MRZT.reg
if "%mrzt%"=="1" regedit /s %YCP%ZTSZ.reg
reg unload HKLM\0>nul
if exist %YCP%MRZT.reg del /q %YCP%MRZT.reg
if exist %YCP%ZTSZ.reg del /q %YCP%ZTSZ.reg
Xcopy /y %YCP%MY\恢复默认字体.reg %MOU%\Users\Public\Desktop\ 2>nul
title  %dqwc% 设置宋体为默认字体
echo.
echo   设置宋体为默认字体或恢复默认雅黑字体操作完成 程序返回主菜单
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
title  %dqwz% 完美适度精简 %dqcd%27
echo.
echo   %dqwz% 完美适度精简 %dqcd%27
echo.
echo  00  移除WinSxS中产生的临时数据...
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
echo  01  移除BACKUP数据...
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
echo  02  移除英文简中以外自然语言及多余输入法数据...
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
echo  04 性能体验相关...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Performance\WinSAT" /r /d y && icacls "%MOU%\Windows\Performance\WinSAT" /grant administrators:F /t
del /q /f %MOU%\Windows\Performance\WinSAT\*.mpg
del /q /f %MOU%\Windows\Performance\WinSAT\*.wmv
del /q /f %MOU%\Windows\Performance\WinSAT\*.mp4
echo.
echo  05 删除高对比度主题及4K...
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
echo  06 删除多余的屏保...
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
echo  07 移除多余的设备锁数据...
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
echo   08 移除自带中国壁纸主题...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\Globalization\MCT\MCT-CN" /r /d y && icacls "%MOU%\Windows\Globalization\MCT\MCT-CN" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Globalization\MCT\MCT-CN"
)
if exist "%MOU%\Program Files\Microsoft Games" (
echo.
echo   09 移除游戏数据...
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
echo   10 移除DVD Maker中的数据...
echo.
cmd.exe /c takeown /f "%MOU%\Program Files\DVD Maker" /r /d y && icacls "%MOU%\Program Files\DVD Maker" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Program Files\DVD Maker"
)
echo.
echo   11 清理会员中心及开始菜单...
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
echo   12 保留核心繁体字体...
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
echo   13 删除无用的屏保...
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
echo   14 统一磁铁图标...
echo.
cmd.exe /c takeown /f %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml && icacls %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\ExpandedDefaultLayouts.xml /grant administrators:F /t
)
if exist %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml (
cmd.exe /c takeown /f %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml && icacls %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml /grant administrators:F /t
del /f /q %MOU%\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml
)
if exist %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg (
echo.
echo   15 替换默认锁屏壁纸...
echo.
cmd.exe /c takeown /f %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg && icacls %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\asset.jpg /grant administrators:F /t
Xcopy /y %YCP%MY\IMG\asset.jpg %MOU%\Windows\SystemApps\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\Experiences\LockScreen\
)
echo.
echo   16 清理一些无用的启动显示字体...
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
echo   17 精简帮助 HELP 数据...
echo.
cmd.exe /c takeown /f %MOU%\Windows\HelpPane.exe && icacls %MOU%\Windows\HelpPane.exe /grant administrators:F /t
del /f /q %MOU%\Windows\HelpPane.exe
cmd.exe /c takeown /f "%MOU%\Windows\Help" /r /d y && icacls "%MOU%\Windows\Help" /grant administrators:F /t
RMDIR /S /Q "%MOU%\Windows\Help"
)
if %OFFSYS% GEQ 14393 (
echo.
echo   18 为1703补充清理部分数据...
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
title  %dqwc% 完美适度精简 %dqcd%27
echo.
echo        通用的适度完美精简已完成                   程序返回主菜单
echo.
ping -n 5 127.1 >nul
cls
goto MENU

:ZDJJ
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 正式版系统进行驱动+虚链接极限精简 %dqcd%28 
echo.
echo  %dqwz% 正式版系统进行驱动+虚链接极限精简 %dqcd%28  
echo.
echo   1  精简稀用驱动及虚链数据以减小体积 基本不影响驱动安装  处理时间较长请耐心等待
echo.
echo        收集数据过程CPU和内存占用较大  如无必要请勿做其它工作 开始收集相关数据...
echo.
echo   2 主要采用MS原生ISO中 boot.wim 中的驱动替换  影响桌面体验 只推荐做极限精简测试  
echo.
echo        确认要执行操作并且所需条件满足       请回车开始执行终极安全极限驱动精简
echo.
echo  *** 需要注意的是：装载ISO状态直接执行否则请提取ISO\Sources\boot.wim 到 %YCP% ***
echo.
set frfa=1
set /p frfa=请选择你要使用的驱动精简方案1或2 直接默认1方案返回请按0回车：
if "%frfa%"=="2" goto BTFR
if "%frfa%"=="1" goto SFFR
if "%frfa%"=="0" goto MENU

:SFFR
title  %dqwz% 正式版系统进行驱动极限精简 %dqcd%28-1
cls
echo.
echo   1  精简稀用驱动及虚链数据以减小体积 基本不影响驱动安装  处理时间较长请耐心等待
echo.
echo        收集数据过程CPU和内存占用较大  如无必要请勿做其它工作 开始收集相关数据...
echo.
echo   第一阶段  收集精简稀用驱动后的保留数据
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
echo   精简驱动收集完成 获取权限开始处理稀用的驱动数据 请稍候...
echo.
ping -n 3 127.1>nul
for /f "delims=" %%i in (%YCP%tmp.txt) do (cmd.exe /c takeown /f "%yd%\%%i" /r /d y & icacls "%yd%\%%i" /grant administrators:F /t & RD "%yd%\%%i" /s /q)
if exist "%YCP%tmp.txt" del /f/q "%YCP%tmp.txt"
title    %dqwc% 正式版系统进行驱动极限精简 %dqcd%28-1
echo.
echo   稀用驱动精简完成 为防止程序操作延迟 延迟3秒以保无误
echo.
ping -n 3 127.1 >nul
cls
goto ABLY

:BTFR
title  %dqwz% 正式版系统进行驱动极限精简 %dqcd%28-2
cls
echo.
echo   2 主要采用MS原生ISO中 boot.wim 中的驱动替换  影响桌面体验 只推荐做极限精简测试  
echo.
echo        确认要执行操作并且所需条件满足       请回车开始执行终极安全极限驱动精简
echo.
echo   *** 需要注意的是：装载ISO状态直接执行否则请提取ISO\Sources\boot.wim 到 %YCP% ***
echo.
echo   开始处理权限并执行终极安全极限字体精简操作... 请稍候！！！
echo.
if not exist %SOUR%boot.wim (
echo.
echo   数据错误或没有发现 %SOUR%boot.wim 请确认无误后重新执行  程序返回
echo.
ping -n 5 127.1 >nul
cls
goto MENU
)
echo.
echo   补充桌面体验显卡声卡原始驱动...
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
title  %dqwc% 正式版系统进行驱动极限精简 %dqcd%28-2
echo.
echo   驱动处理操作成功完成 为防止程序操作延迟 延迟3秒以保无误
echo.
ping -n 3 127.1>nul
cls
goto ABLY

:ABLY
cls
title  %dqwz% 正式版系统进行虚链接精简 %dqcd%28-3
echo.
echo   第二阶段  开始安全处理部分虚链接数据不影响所有补丁安装 请稍候...
echo.
echo   解除目录读写限制 并开始处理虚链数据 请稍候...
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
title  清理驱动预编译残留 请稍候...
cls
echo.
echo   第三阶段 清理驱动预编译残留 请稍候...
echo.
cmd.exe /c takeown /f "%MOU%\Windows\inf" /r /d y && icacls "%MOU%\Windows\inf" /grant administrators:F /t
del /q /f %MOU%\Windows\inf\*.PNF
for /r %MOU%\Windows\inf %%i in (*.pnf) do (if exist %%i del "%%i" /q /f )
cls
title  %dqwc% 正式版系统驱动和虚链接极限精简 %dqcd%28-3
echo.
echo   ======================= 警 ==================== 告 =============================
echo.
echo    本操作至此为止均为安全精简底限 此时返回主菜单增量保存可保证能正常更新所有补丁
echo.
echo    继续进行最后的WinSxS极限精简后将损失大部分组件   不能正常启禁用功能及完美更新
echo.
echo    确认继续进行组件WinSxS极限精简直接回车 按0回车将返回主菜单 并推荐进行增量保存
echo.
set /p mqr=请认真考虑并确认将如何操作 0 返回菜单 确认继续进行组件WinSxS极限精简直接回车：
if "%mqr%"=="0" goto MENU

:LITE
cls
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% WinSxS极限精简 %dqcd%29
echo.
echo   %dqwz% WinSxS极限精简 %dqcd%29
echo.
echo   正在进行WinSxS极限精简数据收集... 
echo.
echo   本方案已经过全系统测试通过 基本不会影响到所有驱动安装 处理时间较长请耐心等待程序完成
echo.
echo   收集数据过程CPU和内存占用较大  如无必要请勿做其它工作 开始收集相关数据...  请稍候！！！
echo.
dir /b /ad "%MOU%\Windows\WinSxS">%YCP%tmp.txt
set yc=%MOU%\Windows\WinSxS
if %OFFSYS% GTR 7601 goto LIT2

:LIT1
echo.
echo   为 Windows 7 以下系统保留独有数据... 请稍候
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
echo   保留 Windows 7 以上系统通用数据... 请稍候
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
echo       请选择是否关闭虚拟内存
echo.
echo   关闭输入1回车   不关闭直接回车即可
echo.
set xnlc=0
set /p xnlc=请输入您的选择回车执行：
if /i "%xnlc%"=="1" (
reg load HKLM\0 "%MOU%\Windows\system32\config\SYSTEM">nul
reg add "HKLM\0\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "" /f
reg unload HKLM\0 >nul
)
echo.
title   %dqwc% WinSxS极限精简 %dqcd%29 
echo.
echo  WinSxS极限精简已完成  6秒后自动返回主菜单推荐增量保存映像
echo.
ping -n 6 127.1 >nul
cls
goto MENU

:KLNK
title  %dqwz% 去快捷方式箭头及字样及盾牌图标 %dqcd%34
echo.
echo   %dqwz% 去快捷方式箭头及字样及盾牌图标 %dqcd%34
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   开始准备去快捷方式箭头及字样设置...
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\DEFAULT">nul
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "77" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\imageres.dll,197" /f
reg unload HKLM\0>nul
echo.
title  %dqwc% 去快捷方式箭头及字样及盾牌图标 %dqcd%34
echo.
echo   去快捷方式箭头及字样操作完成  5秒后程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:XSYC
title  %dqwz% 右键添加显示隐藏菜单 %dqcd%57
echo.
echo   %dqwz% 右键添加显示隐藏菜单 %dqcd%57
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   复制必须的通用脚本...
Xcopy /y %YCP%MY\System32\SuperHidden.vbs %MOU%\Windows\System32\
echo.
echo   开始准备设置...
echo.
echo   右键添加显示或隐藏文件或扩展名...
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
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden" /ve /t REG_SZ /d "显示或隐藏文件及扩展名" /f
reg add "HKLM\0\Classes\Directory\background\shell\SuperHidden\Command" /ve /t REG_EXPAND_SZ /d "WScript.exe %%windir%%\System32\SuperHidden.vbs" /f
reg unload HKLM\0 >nul
title  %dqwc% 右键添加显示隐藏菜单 %dqcd%57
echo.
echo   右键添加显示隐藏菜单操作完成  5秒后程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:GTZN
title  %dqwz% 获取适用汉化数据 %dqcd%41
echo.
echo   %dqwz% 获取适用汉化数据 %dqcd%41
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\zh-CN (
echo.
echo   挂载中的系统好像已经是中文版无需汉化  程序返回
echo.
ping -n 6 127.1>nul
cls
goto MENU
)
echo.
echo   请输入汉化数据来源分区盘符  可以是当前系统分区也可以是VHD系统分区
echo.
echo   数据来源系统位数必须为%Mbt%并且接近挂载系统的版本否则可能损坏映像
echo.
echo   也可从挂载目录或多级目录获取比如D:\MYZNCN\XXX  注意路径不得有空格
echo.
echo   D:\MYZNCN\XXX目录中必须是含有完整系统语言目录结构  并保证数据有效
echo.
set SJF=C:
set /p SJF=直接回车默认数据来源为C分区系统 不做操作请按0回车返回主菜单:
If "%SJF%"=="0" Goto MENU
if not exist "%SJF%\Windows\zh-CN" (
echo.
echo  %SJF%好像不是系统分区或不是中文系统哟 请重新输入吧
echo.
ping -n 5 127.1>nul
cls
GOTO GETZN
)
if exist %YCP%TOOL\%FSYS%ZNCN.WIM (
if not exist %YCP%ZNCN\%Mbt% md %YCP%ZNCN\%Mbt%
echo.
echo  开始根据映像架构释放%Mbt%的汉化数据样本... 请稍候
echo.
if %Mbt% equ x86 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:1 /ApplyDir:%YCP%ZNCN\%Mbt%
if %Mbt% equ x64 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:2 /ApplyDir:%YCP%ZNCN\%Mbt%
)
if not exist "%YCP%ZNCN\%Mbt%\zh-CN" (
echo.
echo  没有样本数据 请从雨晨DISM分享中下载 %FSYS%ZNCN.WIM 放入%YCP%TOOL目录中重新操作
echo.
ping -n 5 127.1>nul
cls
GOTO GETZN
)
echo.
echo  开始从你输入的系统分区更新汉化数据...
echo.
xcopy /y /h /s /u %SJF% %YCP%ZNCN\%Mbt%\
title  %dqwc% 获取适用汉化数据 %dqcd%41
echo.
echo   最新的数据为 %Mbt% 只能用于汉化 %Mbt% 的系统
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADZN
title  %dqwz% 汉化当前挂载系统 %dqcd%42
echo.
echo   %dqwz% 汉化当前挂载系统 %dqcd%42
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\zh-CN (
echo.
echo   挂载中的系统好像已经是中文版无需汉化或已经加入汉化数据  程序返回
echo.
ping -n 5 127.1>nul
cls
goto MENU
) 
if not exist %YCP%TOOL\%FSYS%ZNCN.WIM (
echo.
echo   没有找到%FSYS%ZNCN.WIM请在实战群共享链接中下载并放在%YCP%TOOL下
echo.
ping -n 5 127.1>nul
cls
goto MENU
)
echo.
echo   开始应用汉化数据... 汉化方法为数据替换操作不可逆除非放弃保存重来
echo.
echo   如 汉化15052请用RS2 CN15051数据  如 汉化10587请用TH1 CN10586数据
echo.
echo   请尽最大可能采用分支相同且版本最接近的官方原版数据以保汉化后正常
echo       ＝＝＝＝    ＝＝＝＝  ＝＝＝＝＝  ＝＝＝＝＝＝ 
ping -n 6 127.1>nul
echo.
echo   应用汉化数据...
echo.
if %Mbt% equ x86 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:1 /ApplyDir:%MOU%
if %Mbt% equ x64 %YCDM% /Apply-Image /ImageFile:%YCP%TOOL\%FSYS%ZNCN.WIM /Index:2 /ApplyDir:%MOU%
echo.
echo   安全加入汉化设置...
echo.
xcopy %YCP%MY\ZNCN.reg %MOU%\Windows\Setup\Scripts\
title  %dqwc% 汉化当前挂载系统 %dqcd%42
echo.
echo   汉化数据已加入并已应用设置  建议增量保存以保修正后再试 程序返回
echo.
ping -n 6 127.1>nul
cls
goto MENU

:GTQD
title  %dqwz% 提取当前系统外加驱动 %dqcd%43 
echo.
echo   %dqwz% 提取当前系统外加驱动 %dqcd%43 
echo.
echo      驱动获取到%YCP%%TheOS%%Obt%QD下 以便为相同硬件相同架构的系统执行集成操作
if not exist %YCP%%TheOS%%Obt%QD md %YCP%%TheOS%%Obt%QD
set AZFQ=C
dism /online /export-driver /destination:%YCP%%TheOS%%Obt%QD\
echo.
echo      默认获取C分区驱动  其它分区请输其分区盘符字母如果不是%TheOS%%Obt%请改相应名称
echo.
set /p AZFQ=请输入要提取外加驱动的系统分区盘符字母无需冒号默认为C:
echo.
echo      要提取的系统分区为 %AZFQ%
echo.
set /p AZRQ=请输入要提取外加驱动的系统安装时间  格式为 月月日日年年年年:
echo.
echo      您输入的安装日期为 %AZRQ%
echo.
echo      如果分区或数据存在则开始提取
echo.
xcopy /y /S /D:%AZRQ% %AZFQ%:\Windows\System32\DriverStore\FileRepository %YCP%%TheOS%%Obt%QD\
title  %dqwc% 提取当前系统外加驱动 %dqcd%43 
echo.
echo           %AZFQ% 中外加驱动提取完成 适用于 %Obt% 架构的系统
echo.
echo      如无意外驱动已经获取到%YCP%%TheOS%%Obt%QD 程序6秒后自动返回主菜单后继续
echo.
ping -n 6 127.1>nul
cls
goto MENU

:OFUP
title  %dqwz% Windows 10 专用关闭强制自动更新设置  %dqcd%40
echo.
echo   %dqwz% Windows 10 专用关闭强制自动更新设置  %dqcd%40
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d 1 /f
reg unload HKLM\0>nul
echo.
title  %dqwc% Windows 10 专用关闭强制自动更新设置  %dqcd%40
echo.
echo    从新版 Windows 10 起微软已经禁止用户禁用自动更新设置   程序6秒后
echo.
echo    如无意外  程序已经成功禁用了挂载系统中的自动更新设置   返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:MOEM
title  %dqwz% 替换或添加个性的 OEM 数据或文件 %dqcd%25
echo.
echo   %dqwz% 替换或添加个性的 OEM 数据或文件 %dqcd%25
echo.
echo.
echo   当前程序只提供替换或添加 我的电脑 右键 属性 中的信息数据
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   如果存在自DIY的个性 OEM 数据或文件 程序将替换到目标系统中
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
title  %dqwc% 替换或添加个性的 OEM 数据或文件 %dqcd%25
echo.
echo     替换或添加个性的 OEM 数据或文件完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:ADMI
title  %dqwz% 开启内置用户使用APPS批准模式 %dqcd%35
echo.
echo   %dqwz% 开启内置Administrator用户使用APPS %dqcd%35
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
title  %dqwc% 开启内置用户使用APPS批准模式 %dqcd%35
echo.
echo   内置Administrator用户使用APPS功能已启用经完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:WDUP
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title  %dqwz% 联网更新挂载系统Windows Defender病毒库 %dqcd%36
echo.
echo   %dqwz% 联网更新挂载系统Windows Defender病毒库 %dqcd%36
echo.
echo   目前只推荐在 Windows 10 最新系统中使用本功能  据说全新的官方
echo.
echo   Windows Defender 杀毒防毒能力加强  最新的数据包大约120MB左右
echo.
echo   稍后程序会自动打开最新数据下载链接 请将下载完成的mpam-fe.exe
echo.
echo   复制到%YCP%目录下 确认网络畅通按回车下载数据包 按0返回主菜单
echo.
set wd=YD
set /p wd= 确认下载最新病毒数据包请回车 返回请按0回车
if "%wd%"=="0" goto MENU
echo.  
echo   打开下载链接...请尽量指定下载位置为%YCP%目录以便直接使用
echo.
start "" "http://go.microsoft.com/fwlink/?LinkID=121721&arch=%Mbt%"
echo   确认下载完成并已按要求放置请直接回车执行数据库更新
echo.
pause>nul
echo   如果数据适用并完整程序开始执行更新  请稍候...
if not exist "%YCP%mpam-fe.exe" (
echo.
echo    数据包没有准备就绪 请确认后重新执行集成操作 程序返回主菜单
echo.
ping -n 3 127.1>nul
cls
goto MENU
)

:ZHIJ
if not exist "%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates" (
echo.
echo    挂载系统可能已经精简了Windows Defender 请确认后重新执行集成操作 程序返回
echo.
ping -n 3 127.1>nul
cls
goto MENU
)
"%YCP%mpam-fe.exe" /extract:"%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates"
del /q /f "%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates\MPSigStub.exe"
if not exist "%MOU%\ProgramData\Microsoft\Windows Defender\Definition Updates\Updates\mpavbase.vdm" (
echo.
echo    更新 Windows Defender 病毒库失败 请确认数据或环境有效或适用     程序返回
echo.
ping -n 3 127.1>nul
cls
goto MENU
)
title  %dqwc% 联网更新挂载系统Windows Defender病毒库 %dqcd%36
echo.
echo   联网更新挂载系统Windows Defender病毒库操作成功完成  程序返回主菜单
echo.
ping -n 5 127.1>nul
if exist "%YCP%mpam-fe.exe" del /q "%YCP%mpam-fe.exe"
cls
goto MENU

:YKMS
title  %dqwz% 添加联网KMS激活批处理程序Win10以下系统请集成Net4.6 %dqcd%37
echo.
echo   %dqwz% 添加联网KMS激活批处理程序Win10以下系统请集成Net4.6 %dqcd%37
echo.
echo    程序将把联网激活的批处理程序放到用户桌面   用户自行决定是否使用
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
Xcopy /s /y %YCP%MY\KMS %MOU%\Windows\Setup\Scripts\ >nul
echo.
echo   已经为映像加入KMS批量激活程序绿色数据
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
title  %dqwz% 加入自己软件合集 %dqcd%38
echo.
echo   %dqwz% 加入自己软件合集 %dqcd%38
echo.
echo   加 入 软 件 合 集 说 明：
echo  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
echo.
echo             将心比心的讲，制作并分享系统是费时费脑的事情，单纯加入导航主页无异于沧海一粟
echo.
echo         为了让更多朋友在辛苦之余也能获得微薄回报，特在本程序加入特殊推广接口以回报我们的
echo.
echo         付出。请勿必保证程序安全，不得有后门、木马、广告、恶意链接等诟病，否则将承担法律
echo.
echo         责任，特此警告！！！(TGDY.CMD为通用调用及清理程序 请勿删除或改名)
echo.
echo         须知以上条款后请将要推广的程序包及配置放到 %YCP%MY\TuiGuang\ 按回车开始
echo.
echo  ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
pause >nul
set xz=1
if not exist %YCP%MY\TuiGuang\*.exe if not exist %YCP%MY\TuiGuang\TGDY.CMD (
echo.
echo   %YCP%MY\TuiGuang没有EXE数据 请检查后回车重新执行加入推广操作 按0回车返回主菜单
echo.
set /p xz=请选择怎样继续：
)
if %xz% NEQ 1 goto :MENU
if not exist %YCP%MY\TuiGuang goto :MENU
if exist %YCP%MY\TuiGuang\*.* if not exist %MOU%\TuiGuang md %MOU%\Windows\TuiGuang
Xcopy /y %YCP%MY\TuiGuang\*.* %MOU%\Windows\TuiGuang\
echo.
echo   开始加入推广程序包有效安装接口注册表项...
echo.
reg load HKLM\0 "%MOU%\Users\Default\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "@tg" /t REG_EXPAND_SZ /d "%%SystemRoot%%\TuiGuang\TGDY.CMD" /f >nul
reg unload HKLM\0 >NUL
if exist %MOU%\Users\Administrator\NTUSER.DAT (
reg load HKLM\0 "%MOU%\Users\Administrator\NTUSER.DAT">nul
reg add "HKLM\0\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "@tg" /t REG_EXPAND_SZ /d "%%SystemRoot%%\TuiGuang\TGDY.CMD" /f >nul
reg unload HKLM\0 >NUL
)
title  %dqwc% 加入自己的推广程序包 %dqcd%38
echo.
echo   加入推广程序包有效安装接口注册表项完成 程序返回主菜单
echo.
ping -n 5 127.1>nul
cls
goto MENU

:OFFC
title   %dqwz% 加入 Office2016 或 Office2007 绿色精简3合1数据 %dqcd%39
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
echo.
echo   %dqwz% 加入 Office2016 或 Office2007 绿色精简3合1数据 %dqcd%39
echo.
echo   Office2016需要在Win7SP1以上系统方可使用并要求相应的运行库支持
echo.
echo   程序当前提供两种集成选择           请根据自己实际情况选定集成
echo.
echo   1  集成Office2007精简3合1           2  集成Office2016精简3合1
echo.
set OFXZ=0
set /p OFXZ=请选择并输入你要操作序号数字 按3回车返回 直接回车智能添加整合：
if "%OFXZ%"=="3" GOTO MENU
if "%OFXZ%"=="2" GOTO OF16
if "%OFXZ%"=="1" GOTO OF07
if "%OFXZ%"=="0" GOTO AUTO
echo.
echo                 输入错误请重新输入
echo.
ping -n 6 127.1>nul
cls
goto OFFC

:AUTO
if %OFFSYS% LSS 7601 (goto OF07) ELSE (goto OF16)

:OF07
title   集成Office2007精简3合1
echo.
echo  为装载中的映像集成Office2007精简3合1 程序开始添加数据...
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
echo   关闭账户控制防止绿化程序绿化失败 √
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
reg unload HKLM\0>nul
echo.
title   %dqwc% 加入Office2007 绿色精简3合1数据 %dqcd%39-1
echo.
echo   绿色精简 Office2007 3合1 数据加入完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:OF16
title   集成Office2016精简3合1
if %OFFSYS% LEQ 9600 (
echo.
echo   当前装载系统为 Windows8.1 以下系统 需要额外添加Office2016必须的补丁
echo.
echo   如果装载系Office2016统组件完整   程序尝试将必须补丁集成到装载映像中
echo.
echo   开始尝试集成%YCP%ADXX\OfficeMSU\%SSYS%\%Mbt%的补丁...
echo.
if exist %YCP%ADXX\OfficeMSU\%SSYS%\%Mbt% %YCDM% /image:%MOU% /add-package /packagepath:%YCP%ADXX\OfficeMSU\%SSYS%\%Mbt%
echo.
echo   如果无误 %YCP%ADXX\OfficeMSU\%SSYS% 集成补丁操作完成
echo.
ping -n 6 127.1>nul
)
echo.
echo   程序开始添加主体数据并加入自动调用绿化程序...
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
echo   当前映像中已经集成了KMS数据 程序将合并执行
echo.
del /f /q %MOU%\Windows\Setup\Scripts\KMS.cmd
Rmdir /q /s "%MOU%\Windows\Setup\Scripts\32-bit"
Rmdir /q /s "%MOU%\Windows\Setup\Scripts\64-bit"
)
echo   关闭账户控制防止绿化程序绿化失败 √
echo.
reg load HKLM\0 "%MOU%\Windows\system32\config\SOFTWARE">NUL
reg add "HKLM\0\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
reg unload HKLM\0>nul
echo.
title   %dqwc% 加入Office2016 绿色精简3合1数据 %dqcd%39-2
echo.
echo    自助激活 Office2016 3合1 数据加入完成 程序返回主菜单
echo.
ping -n 6 127.1>nul
cls
goto MENU

:YJYX
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz%卸载所有非内置驱动 使映像可直接用于异机还原 %dqcd%44
echo.
echo   %dqwz% 一键卸载所有非内置驱动 使映像可直接用于异机还原 %dqcd%44
echo.
SET Q=0
if exist %MOU%\Windows\inf\OEM%Q%.inf (
echo.
echo   发现映像中疑似外加驱动信息 如果数据完整开始将其卸载...
echo.
)
if exist %MOU%\Windows\inf\OEM%Q%.inf %YCDM% /Image:%MOU% /Remove-Driver /Driver:OEM%Q%.inf

:QT
set /a Q=%Q%+1
if exist %MOU%\Windows\inf\OEM%Q%.inf %YCDM% /Image:%MOU% /Remove-Driver /Driver:OEM%Q%.inf &GOTO QT
title   %dqwc%卸载所有非内置驱动 使映像可直接用于异机还原 %dqcd%44
echo.
echo   如果映像完整所有外加驱动已经全部卸载或没有驱动 应该可以用于异机部署
echo.
echo   要自定义卸载请在主菜单输入01回车      程序6秒后自动返回主菜单后继续
echo.
ping -n 5 127.1>nul
cls
goto MENU

:YCQD
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 自定义卸载非内置驱动 %dqcd%47
echo.
echo   %dqwz% 自定义卸载非内置驱动 %dqcd%47 开始获取非内置驱动列表... 请稍候
echo.
%YCDM% /Image:%MOU% /Get-Drivers>%YCP%Drivers.txt
start %YCP%Drivers.txt
:HYYS
echo. 
echo   如果你确认要删除映像中的相关驱动请复制打开文本中的驱动英文 XXX.inf 粘贴到程序窗口
echo.
echo   后按回车执行卸载操作             如果你不了解删除相关驱动后的影响请勿执行删除操作
echo.
set /p scqd=粘贴驱动名到程序窗口并回车执行删除操作 如果想不操作直接返回主菜单请输入0回车:
echo.
if "%scqd%"=="0" (
cls
del /q /f %YCP%Drivers.txt
GOTO MENU
)
echo.
echo  映像中如果包含%scqd%驱动并且完整程序将其卸载  正在尝试卸载...
echo.
%YCDM% /Image:%MOU% /Remove-Driver /Driver:%scqd%
echo.
set /p hym=如无意外%scqd%驱动已卸载 继续卸载请按Y回车  直接回车将返回主菜单
if /i "%hym%"=="Y" GOTO HYYS
title   %dqwc% 自定义卸载非内置驱动 %dqcd%47
echo.
echo           驱动卸载操作完成      程序6秒后自动返回主菜单后继续
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
title   %dqwz% 删除语言或程序功能 %dqcd%46
echo.
echo   %dqwz% 删除语言或程序功能 %dqcd%46
echo.
echo   正在查询功能包...请勿干扰或中断程序运行        操作完成自动提示下一步操作
echo.
%YCDM% /Image:%MOU% /Get-packages>%YCP%packages.txt
start %YCP%packages.txt
:JXSC
echo.
echo   请复制打开的文本中[程序包标识符: 复制的内容 ]纯英文部分粘贴到本程窗口回车
echo                                    ˉˉˉˉˉ
echo   警告：如果你不了解删除后的影响请尽量不要随意执行删除操作，正常情况下集成了
echo.
echo   中文语言包可安全删除英文和其它Language Pack性质的语言OnDemand Pack的en-us
echo.
echo   属于基础语言，请谨慎删除 其它日、韩包括输入法以及手写语言等均可以安全删除
echo.
set scyy=0
set /p scyy=粘贴要删除的程序标识符到本窗口回车执行删除 直接回车不做任何操作并返回主菜单:
if "%scyy%"=="0" (
del %YCP%packages.txt
cls
goto MENU
)
echo.
%YCDM% /image:%MOU% /Remove-Package /PackageName:%scyy%
echo.
set jx=1
set /p jx=继续执行删除操作请直接回车 返回请输入0回车
if "%jx%"=="0" (
title   %dqwc% 删除语言或程序功能 %dqcd%46
del /q /f %YCP%packages.txt
cls
goto MENU
)
cls
goto JXSC

:SJBB
title   %dqwz% 提升映像版本 %dqcd%48
echo.
echo   %dqwz% 提升映像版本 %dqcd%48
echo.
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
if exist %MOU%\Windows\servicing\Editions\%MEID%Edition.xml if exist %MOU%\Windows\%MEID%.xml del /q /f %MOU%\Windows\%MEID%.xml
echo.
echo     当前挂载系统为^:%MOS% 请参照以下常用系统版本图表向上选择目标版本
echo.
echo    ┏┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┳┅┅┅┅┅┅┅┅┅┓
echo    ┋   预置提升菜单   ┋ Windows 7 (SP1)  ┋  Windows 8 (.1)  ┋    Windows 10    ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 7  提升到教育版  ┋        无        ┋     Education    ┋     Education    ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋ 6  提升到企业版  ┋ Enterprise Only  ┋     Enterprise   ┋     Enterprise   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋ 5  专业媒体中心  ┋         无       ┋  ProfessionalWMC ┋         无       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋ 4  提升到旗舰版  ┋      Ultimate    ┋         无       ┋         无       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ 33 红石专业教育版┋        无        ┋        无        ┋Pro for Education ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋ 3  提升到专业版  ┋    Professional  ┋    Professional  ┋    Professional  ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋ 2  到家庭高级版  ┋    HomePremium   ┋         无       ┋         无       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋ 1  到家庭初级版  ┋      HomeBasic   ┋         无       ┋         无       ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋ 0  到简易核心版  ┋Starter x86 Only  ┋        Core      ┋   Core  家庭版   ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅↑┅┅┅┅┅┅┅┫
echo    ┋    家庭中文版    ┋        无        ┋         无       ┋Home China 中国版 ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋    单语言版本    ┋ EnterpriseG  888 ┋         无       ┋CoreSingleLanguage┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋ Windows 10 N 版  ┋ ProN 专业N版 333 ┋ EntN 企业N版 666 ┋ EduN 教育N版 777 ┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋  S1 服务器系统   ┋ServerStandardCore┋→ → → → → → ServerDatacenterCore┋
echo    ┣┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅╋┅┅┅┅┅┅┅┅┅┫
echo    ┋  S2 服务器系统   ┋  ServerStandard  ┋→ → → → → → ┋ ServerDatacenter ┋
echo    ┗┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┻┅┅┅┅┅┅┅┅┅┛
echo.
set v=
%YCDM% /Image:%MOU% /Get-CurrentEdition
%YCDM% /Image:%MOU% /Get-TargetEditions
set /p v=请输入预置操作菜单序号数字(0~888) 或输入其它则升到未预置到操作菜单的目标版本或返回:
if /i "%v%"=="S1" (
echo.
echo    升级到数据中心Core版...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ServerDatacenterCore
if !errorlevel!==0 goto :SCBY
)

if /i "%v%"=="S2" (
echo.
echo    升级到数据中心版...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ServerDatacenter
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="777" (
echo.
echo    升级到教育版N本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Education
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="7" (
echo.
echo    升级到教育版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Education
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="666" (
echo.
echo    升级到企业N版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:EnterpriseN
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="888" (
echo.
echo    升级到 企业 G 版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:EnterpriseG
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="6" (
echo.
echo    升级到企业版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Enterprise
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="5" (
echo.
echo    升级到PWMC版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ProfessionalWMC
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="4" (
echo.
echo    升级到旗舰版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Ultimate
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="333" (
echo.
echo    升级到专业N版...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ProfessionalN
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="33" (
echo.
echo    升级到专业教育版...
echo.
%YCDM% /Image:%MOU% /Set-Edition:ProfessionalEducation
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="3" (
echo.
echo    升级到专业版...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Professional
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="2" (
echo.
echo    升级到家庭高级版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:HomePremium
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="1" (
echo.
echo    升级到家庭初级版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:HomeBasic
if !errorlevel!==0 goto :SCBY
)

if "%v%"=="0" (
echo.
echo    升级到家庭核心版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:Core
if !errorlevel!==0 goto :SCBY
)

:ZDSJ
set zdbb=0
set /p zdbb=输入预置提升菜单以外但存在的可提升目标版本英文名称或直接返回主菜单:
if "%zdbb%"=="0" goto MENU
echo.
echo    尝试提升到 %zdbb% 版本...
echo.
%YCDM% /Image:%MOU% /Set-Edition:%zdbb%
if !errorlevel!==0 goto :SCBY
echo.
echo              输入有误请重新正确输入  程序3秒后自动返回主菜单...
echo.
ping -n 3 127.1 >nul
cls
goto ZDSJ

:SCBY
cls
echo.
echo    为后续重命名做需要的工作 完成后自动返回主菜单
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
title   %dqwz% 安全清理非挂启状态的残余数据以减少体积 %dqcd%49
echo.
echo   %dqwz% 安全清理非挂启状态的残余数据以减少体积 %dqcd%49
echo.
%YCDM% /image:YCMOU /Cleanup-Image /StartComponentCleanup &&%YCDM% /image:YCMOU /Cleanup-Image /StartComponentCleanup /ResetBase
title   %dqwc% 安全清理非挂启状态的残余数据以减少体积 %dqcd%49
echo.
echo   如果提示清理异常或存在挂启状态均可忽略继续其它操作  程序3秒后返回
echo.
ping -n 3 127.1 >nul
cls
GOTO MENU

:NOPG
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 关闭系统虚拟内存减少系统分区硬盘占用空间 %dqcd%33
echo.
echo    %dqwz% 关闭系统虚拟内存减少系统分区硬盘占用空间 %dqcd%33
echo.
echo   程序目前只提供关闭操作后续将提供更多可选方案 按回车执行
echo.
pause>nul
reg load HKLM\0 "%MOU%\Windows\system32\config\SYSTEM">nul
reg add "HKLM\0\ControlSet001\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "" /f
reg unload HKLM\0 >nul
echo.
title   %dqwc% 关闭系统虚拟内存减少系统分区硬盘占用空间 %dqcd%33
echo.
echo   如果没有意外程序已经为您关闭了虚拟内存 程序返回主菜单
echo.
ping -n 5 127.1 >nul
cls
GOTO MENU

:SAVE
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 保存映像... %dqcd%30
echo.
echo   %dqwz% 保存映像 %dqcd%30
echo.
%YCDM% /Commit-Image /MountDir:%MOU%
ping -n 3 127.1 >nul
title   %dqwc% 保存映像
cls
GOTO MENU

:ZLBC
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 增量保存... %dqcd%31
echo.
echo   %dqwz% 增量保存 %dqcd%31 
echo.
%YCDM% /Commit-Image /MountDir:%MOU% /Append
set /a INDEX=%INDEX%+1
echo set INDEX=!INDEX!>INDEXset.cmd
title   %dqwc% 增量保存
ping -n 3 127.1 >nul
cls
GOTO MENU

:UNMO
if not exist %YCP%YCMOU md %YCP%YCMOU
SET MOU=%YCP%YCMOU
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %MOU%\Windows\SysWOW64 (set Mbt=x64) ELSE (set Mbt=x86)
if not exist %MOU%\Windows\System32 goto GZYX
title   %dqwz% 卸载映像... %dqcd%32
echo.
echo   %dqwz% 卸载映像 %dqcd%32
echo.
Set s=1
Set /p s=输入0回车将 不保存直接卸载映像  如果直接回车将 保存并卸载 映像
If "%s%"=="0" ( %YCDM% /Unmount-Image /MountDir:%MOU% /discard ) ELSE (%YCDM% /Unmount-Image /MountDir:%MOU% /commit)
cmd.exe /c takeown /f "%YCP%YCMOU" /r /d y && icacls "%YCP%YCMOU" /grant administrators:F /t
if exist %YCP%Default.reg (
attrib -r %YCP%Default.reg
if exist %YCP%Default.reg del /q %YCP%Default.reg
)
if exist INDEXset.cmd del /f /q INDEXset.cmd
if exist %YCP%YCMOU RMDIR /Q /S "%YCP%YCMOU" >nul
title   %dqwc% 卸载映像
echo.
if exist %YCP%YCMOU (
echo   挂载目录不能完全卸载 卸载注册表HKEY_LOCAL_MACHINE下多出项 再删除YCMOU
echo.
echo   如果您想继续编辑其它映像请按J回车返回主菜单  直接回车将进入输出纯净映
echo.
)
set fh=S
set /p fh=直接回车将输出纯净映    按 J 回车返回主菜单继续进行其它操作
if exist %YCP%Features.txt del /q /f %YCP%Features.txt
if exist %YCP%废弃装载中的映像.cmd del /q /f %YCP%废弃装载中的映像.cmd
if not exist %YCP%废弃装载中的映像.cmd del /q /f %YCP%异常中断后重新启用已装载映像.cmd
cls
if /i "%fh%"=="J" GOTO MENU

:SHCH
cls
if "%INDEX%"=="" (set n=1) else (set n=%INDEX%)

:SHX
cls
title   %dqwz% 重命名输出纯净映像
echo.
echo   %dqwz% 重命名输出纯净映像
echo.
for /f "tokens=3 delims= " %%a in ('%YCDM% /english /get-wiminfo /wimfile:%YCP%YCSINS.WIM ^| find /i "index"') do set ZS=%%a
%YCDM% /Get-Wiminfo /WimFile:%YCP%YCSINS.WIM
set /a SY=%ZS%-%n%
if %SY% equ 0 (set yxm=1) else (set yxm=1至%ZS%) 
echo.
echo   如果有增量保存或提升版本操作请对映像进行重命名   否则不能输出到同文件名映像中
echo.
echo   当前%YCP%YCSINS.WIM共%ZS%个子映像  如有两次以上直接保存操作推荐输出纯净映像
echo.
echo   此操作可清理映像中残余数据   主要是经反复操作而产生的除存在挂启状态的多余数据
echo.
echo   最终纯净映像文件为%YCP%install.wim 可直接替换原始 ISO\Sources 中另存即可
echo.
set /p n=请输入要重命名的子映像索引数字 %yxm% 直接回车默认%ZS%退出按T 直接输出按E回车：
if /i %n% equ T Goto :TUIC
if /i %n% equ E Goto :ERSC
if %SY% LSS 0 (
echo.
echo   %YCP%install.wim 中不存在第%n%个子映像 请重新输入！！！
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
echo   开始为第%n%子个映像 进行重命名和描述  
echo.
echo   默认名称为^: %MOS%
echo.
set /p MOS=请输入映像名称（中文需要制粘进本窗口）后按回车继续：
echo.
set ABT=%MOS% %Mbt% %DmVer% 制作于%DATE%
echo.
echo   默认描述为^: %ABT%
echo.
set /p ABT=请输入描述内容（中文需要制粘进本窗口）后按回车继续：
echo.

:NOIEXE
if not exist %YCP%TOOL\14393\%Obt%\Dism\imagex.exe (
echo.
echo   没找到 TOOL\14393\%Obt%\Dism\imagex.exe 命名程序 请确认后重新开始
echo.
pause >nul
GOTO :NOIEXE
)
echo   开始重命名第 %n% 个子映像   请稍候...
echo.
%YCP%TOOL\14393\%Obt%\Dism\imagex /info %YCP%YCSINS.WIM %n% "%MOS%" "%ABT%"
echo.
echo   为第%n%个子映像进行重命名和描述操作完成 直接回车继续命名 输出请按 E 
echo.
if exist %MEID%ZL.cmd del /f /q %MEID%ZL.cmd
set YE=Y
set SCXM=0
set /p YE=请选择你要的操作 继续命名 或 开始输出
if /i %YE% EQU Y Goto SHX

:ERSC
echo.
echo   可以自定义输出存在的子映像  默认为第%n%个
echo.
set /p n=请输入要输出的子映像序号数字 默认是第%n%个
echo.
echo   开始输出第 %n% 个子映像的纯净映像   请稍候...
%YCDM% /Export-Image /SourceImageFile:%YCP%YCSINS.WIM /SourceIndex:%n% /DestinationImageFile:%YCP%install.wim
set /a SCXM=%SCXM%+1
set /a pds=%ZS%-%SCXM%
title   输出第%n%个子映像的纯净映像
set ag=0
echo.
echo   继续输出请按1 回车 直接回车扫尾返回 返回命名请按 R
echo.
set /p ag=直接回车 执行扫尾工作       按 1 回车继续输出：
if /i %ag% equ R Goto SHX
if %ag% equ 0 Goto SAOW
if %pds% equ 0 (
echo.
echo   当前映像总数为%ZS% 已经输出%SCXM%次 程序默认进入扫尾工作
echo.
ping -n 3 127.1 >nul
cls
Goto SAOW
)
Goto ERSC

:SAOW
title   %dqwz% 输出纯净映像完成 扫尾中...
if not exist %YCP%install.wim goto ER1
if exist %YCP%install.wim REN %YCP%YCSINS.WIM YCSINS.OLD
echo.
echo   考虑到导出过程可能存在异常   所以没有默认删除旧文件 %YCP%YCSINS.OLD
echo.
echo   %YCP%install.wim输出完成 %YCP%YCSINS.OLD自定是否删除 3秒后返回主菜单
echo.
title   %dqwc% 重命名并输出纯净映像 扫尾工作完成 返回主菜单
ping -n 3 127.1 >nul
cls
goto MENU

:ER1
CLS
ECHO.
ECHO  输出纯净映像没有成功完成 确认程序操作没中断或异常 3秒后将再次尝试输出纯净映像 
echo.
ping -n 3 127.1 >nul
goto ERSC

:ER2
cd..
CLS 
ECHO.
ECHO  你提供的IE程序本程序不能识别或损坏请检查后重新执行集成操作
ECHO.
PAUSE>NUL
GOTO MENU

:ER3
CLS
ECHO.
ECHO  未知错误  请按回车返回主菜单
echo.
PAUSE>NUL
GOTO MENU

:CheckWE
CLS
echo.
echo  温馨提醒：
echo.
echo  没有发现%SOUR%install.wim^(或esd^)或YCSINS.WIM 映像文件  请确认后 按回车重新运行程序
echo.
echo  可直接将 WIM或ESD^(无加密)格式的映像 复制到%SOUR%目录 重新命名为 YCSINS.WIM 即可使用
echo.
PAUSE>NUL
cls
call %0

:ER4
CLS
ECHO.
ECHO   没有找到程序预设的无人值守文件 请确认你没有误删、移动或改名 操作失败请检查后重新运行
echo.
pause>nul
goto MENU

:IEER
CLS
ECHO.
ECHO     此操作只适用于Win7系统  按任意键返回主菜单
echo.
pause>nul
goto MENU

:BBER
CLS
ECHO.
ECHO     此操作只适用于Win81和Win10系统 按任意键返回主菜单 
echo.
pause>nul
goto MENU

:DMER
echo.
echo   请下载雨晨提供原始YCDISM\TOOL目录数据并放到 %YCP%下按任意键继续
echo.
pause>nul
cls
call %0
exit /q

:ERR
CLS
ECHO.
ECHO   雨晨提醒您  没有发现提供必须的核心文件 确定没有被误删除或做任何更改 程序3秒后自动退出
echo.
ping -n 3 127.1 >nul
exit /q

:ERQX
CLS
ECHO.
ECHO   警告  当前用户可能没有继续操作权限或 %~dp0 位置不可写 程序3秒后自动退出
echo.
ping -n 3 127.1 >nul
exit /q

:TUIC
if exist %YCP%YCMOU if not exist %YCP%YCMOU\Windows\system32\config\SOFTWARE (
cmd.exe /c takeown /f "%YCP%YCMOU" /r /d y && icacls "%YCP%YCMOU" /grant administrators:F /t
RMDIR /Q /S "%YCP%YCMOU">nul
)
echo.
echo   %dqwz% 退出并关闭程序 欢迎再次使用，再见！！！%dqcd%0
echo.
ping -n 2 127.1 >nul
exit /q

:NT52
if not exist EXE md EXE
if not exist NT52 md NT52
echo.
echo   请将适用的EXE补丁或NET放于本程序EXE目录 提取XP或2003ISO所有数据在NT52目录后回车执行
echo.
pause>nul
FOR /F usebackq %%i IN (`dir EXE\*.exe /b`) DO start /wait EXE\%%i /integrate:NT52\ /passive