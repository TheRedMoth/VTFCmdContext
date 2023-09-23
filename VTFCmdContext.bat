@echo off
title VTFCmdContext

REM Проверка на запуск от имени администратора
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
  title VTFCmdContext - Error
  echo Run this file as an administrator!
  pause>nul
  exit /b
)

REM Существует ли VTFCmd.exe?
if not exist "%~dp0\bin" (
  title VTFCmdContext - Error
  echo Could not find VTFCmd.exe!
  pause>nul
  exit /b
)

REM Задаем вопрос о разрядности OS
title VTFCmdContext - Waiting for input...
echo [Y] - Install x64
echo [N] - Install x86
choice /c yn /n
if %errorlevel% == 1 (
  REM Установить x64 версию
  set x64=true
) else (
  REM Установить x86 версию
  set x64=false
)
title VTFCmdContext - Installing...

set "ExportTo=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ExportTo"
set "SFA=HKEY_CLASSES_ROOT\SystemFileAssociations\.vtf\shell\ExportTo"
set "x64p=%ProgramFiles%\VTFCmdContext"
set "x86p=%ProgramFiles(x86)%\VTFCmdContext"

if %x64% == true (
  REM Создание папки %ProgramFiles%\VTFCmdContext, если она не существует
  title VTFCmdContext - Creating folder "%x64p%"...
  if not exist "%x64p%" mkdir "%x64p%"
  REM Перенос .exe файла в %ProgramFiles%\VTFCmdContext
  title VTFCmdContext - Moving "bin\x64\VTFCmd.exe" to "%x64p%"...
  copy /Y "%~dp0\bin\x64\VTFCmd.exe" "%x64p%"
  copy /Y "%~dp0\bin\x64\DevIL.dll" "%x64p%"
  copy /Y "%~dp0\bin\x64\VTFLib.dll" "%x64p%"
  copy /Y "%~dp0\bin\icon.ico" "%x64p%"
) else (
  REM Создание папки %ProgramFiles(x86)%\VTFCmdContext, если она не существует
  title VTFCmdContext - Creating folder "%x86p%"...
  if not exist "%x86p%" mkdir "%x86p%"
  REM Перенос .exe файла в %ProgramFiles(x86)%\VTFCmdContext
  title VTFCmdContext - Moving "bin\x86\VTFCmd.exe" to "%x86p%"...
  copy /Y "%~dp0\bin\x86\VTFCmd.exe" "%x86p%"
  copy /Y "%~dp0\bin\x64\DevIL.dll" "%x86p%"
  copy /Y "%~dp0\bin\x64\VTFLib.dll" "%x86p%"
  copy /Y "%~dp0\bin\icon.ico" "%x86p%"
)

REM Теперь присваеваем открытие этого файла
title VTFCmdContext - Adding context menu folder...
REG ADD "%SFA%" /v "MUIVerb" /t REG_SZ /d "Export to..." /f
REG ADD "%SFA%" /v "SubCommands" /t REG_SZ /d "ExportToBMP;ExportToJPG;ExportToPNG;ExportToTGA" /f

title VTFCmdContext - Assign icon...
REM Применяем иконки
if %x64% == true (
  REG ADD "%SFA%" /v "Icon" /d "%x64p%\icon.ico" /f
) else (
  REG ADD "%SFA%" /v "Icon" /d "%x86p%\icon.ico" /f
)

REM Добавляем кнопочки
title VTFCmdContext - Adding context menu items...
REG ADD "%ExportTo%BMP" /ve /d "Export to .bmp" /f
REG ADD "%ExportTo%JPG" /ve /d "Export to .jpg" /f
REG ADD "%ExportTo%PNG" /ve /d "Export to .png" /f
REG ADD "%ExportTo%TGA" /ve /d "Export to .tga" /f

REM Добавляем команды к кнопочкам
title VTFCmdContext - Adding context menu commands...
if %x64% == true (
  REG ADD "%ExportTo%JPG\command" /ve /d "%x64p%\vtfcmd.exe -silent -file \"%%V\" -exportformat jpg" /f
  REG ADD "%ExportTo%BMP\command" /ve /d "%x64p%\vtfcmd.exe -silent -file \"%%V\" -exportformat bmp" /f
  REG ADD "%ExportTo%PNG\command" /ve /d "%x64p%\vtfcmd.exe -silent -file \"%%V\" -exportformat png" /f
  REG ADD "%ExportTo%TGA\command" /ve /d "%x64p%\vtfcmd.exe -silent -file \"%%V\" -exportformat tga" /f
) else (
  REG ADD "%ExportTo%BMP\command" /ve /d "%x86p%\vtfcmd.exe -silent -file \"%%V\" -exportformat bmp" /f
  REG ADD "%ExportTo%JPG\command" /ve /d "%x86p%\vtfcmd.exe -silent -file \"%%V\" -exportformat jpg" /f
  REG ADD "%ExportTo%PNG\command" /ve /d "%x86p%\vtfcmd.exe -silent -file \"%%V\" -exportformat png" /f
  REG ADD "%ExportTo%TGA\command" /ve /d "%x86p%\vtfcmd.exe -silent -file \"%%V\" -exportformat tga" /f
)

REM Всё готово!
title VTFCmdContext - Installing complete!
echo For the changes to take effect, you may need to restart your computer!

pause>nul
