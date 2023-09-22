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

if %x64% == true (
  REM Создание папки %ProgramFiles%\VTFCmdContext, если она не существует
  title VTFCmdContext - Creating folder "%ProgramFiles%\VTFCmdContext"...
  if not exist "%ProgramFiles%\VTFCmdContext" mkdir "%ProgramFiles%\VTFCmdContext"
  REM Перенос .exe файла в %ProgramFiles%\VTFCmdContext
  title VTFCmdContext - Moving "bin\x64\VTFCmd.exe" to "%ProgramFiles%\VTFCmdContext"...
  copy /Y "%~dp0\bin\x64\VTFCmd.exe" "%ProgramFiles%\VTFCmdContext"
  copy /Y "%~dp0\bin\x64\DevIL.dll" "%ProgramFiles%\VTFCmdContext"
  copy /Y "%~dp0\bin\x64\VTFLib.dll" "%ProgramFiles%\VTFCmdContext"
  copy /Y "%~dp0\bin\icon.ico" "%ProgramFiles%\VTFCmdContext"
) else (
  REM Создание папки %ProgramFiles(x86)%\VTFCmdContext, если она не существует
  title VTFCmdContext - Creating folder "%ProgramFiles(x86)%\VTFCmdContext"...
  if not exist "%ProgramFiles(x86)%\VTFCmdContext" mkdir "%ProgramFiles(x86)%\VTFCmdContext"
  REM Перенос .exe файла в %ProgramFiles(x86)%\VTFCmdContext
  title VTFCmdContext - Moving "bin\x86\VTFCmd.exe" to "%ProgramFiles(x86)%\VTFCmdContext"...
  copy /Y "%~dp0\bin\x86\VTFCmd.exe" "%ProgramFiles(x86)%\VTFCmdContext"
  copy /Y "%~dp0\bin\x64\DevIL.dll" "%ProgramFiles(x86)%\VTFCmdContext"
  copy /Y "%~dp0\bin\x64\VTFLib.dll" "%ProgramFiles(x86)%\VTFCmdContext"
  copy /Y "%~dp0\bin\icon.ico" "%ProgramFiles(x86)%\VTFCmdContext"
)

REM Теперь присваеваем открытие этого файла
title VTFCmdContext - Adding context menu folder...
REG ADD "HKEY_CLASSES_ROOT\SystemFileAssociations\.vtf\shell\ExportTo" /v "MUIVerb" /t REG_SZ /d "Export to..." /f
REG ADD "HKEY_CLASSES_ROOT\SystemFileAssociations\.vtf\shell\ExportTo" /v "SubCommands" /t REG_SZ /d "ExportToBMP;ExportToJPG;ExportToPNG;ExportToTGA" /f

title VTFCmdContext - Assign icon...
REM Применяем иконки
if %x64% == true (
  REG ADD "HKEY_CLASSES_ROOT\SystemFileAssociations\.vtf\shell\ExportTo" /v "Icon" /d "%ProgramFiles%\VTFCmdContext\icon.ico" /f
) else (
  REG ADD "HKEY_CLASSES_ROOT\SystemFileAssociations\.vtf\shell\ExportTo" /v "Icon" /d "%ProgramFiles(x86)%\VTFCmdContext\icon.ico" /f
)

title VTFCmdContext - Adding context menu items...
REG ADD "%ExportTo%BMP" /ve /d "Export to .bmp" /f
REG ADD "%ExportTo%JPG" /ve /d "Export to .jpg" /f
REG ADD "%ExportTo%PNG" /ve /d "Export to .png" /f
REG ADD "%ExportTo%TGA" /ve /d "Export to .tga" /f

title VTFCmdContext - Adding context menu commands...
if %x64% == true (
  REG ADD "%ExportTo%BMP\command" /ve /d "%ProgramFiles%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat bmp" /f
  REG ADD "%ExportTo%JPG\command" /ve /d "%ProgramFiles%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat jpg" /f
  REG ADD "%ExportTo%PNG\command" /ve /d "%ProgramFiles%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat png" /f
  REG ADD "%ExportTo%TGA\command" /ve /d "%ProgramFiles%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat tga" /f
) else (
  REG ADD "%ExportTo%BMP\command" /ve /d "%ProgramFiles(x86)%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat bmp" /f
  REG ADD "%ExportTo%JPG\command" /ve /d "%ProgramFiles(x86)%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat jpg" /f
  REG ADD "%ExportTo%PNG\command" /ve /d "%ProgramFiles(x86)%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat png" /f
  REG ADD "%ExportTo%TGA\command" /ve /d "%ProgramFiles(x86)%\VTFCmdContext\vtfcmd.exe\" -silent -file \"%%V\" -exportformat tga" /f
)

REM Всё готово!
title VTFCmdContext - Installing complete!
echo For the changes to take effect, you may need to restart your computer!

pause>nul