@echo off
title UnistallContext

REM Проверка на запуск от имени администратора
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
  title UnistallContext - Error
  echo Run this file as an administrator!
  pause>nul
  exit /b
)

set "ExportTo=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ExportTo"
set "SFA=HKEY_CLASSES_ROOT\SystemFileAssociations\.vtf\shell\ExportTo"

REM Точно стереть ассоциации?
title UnistallContext - Waiting for input...
echo [Y/N] - Uninstall context?
choice /c yn /n
if %errorlevel% == 1 (
  REM Удаляем
  title UnistallContext - Installing...
  REG DELETE "%ExportTo%JPG" /f
  REG DELETE "%ExportTo%BMP" /f
  REG DELETE "%ExportTo%PNG" /f
  REG DELETE "%ExportTo%TGA" /f
  REG DELETE "%SFA%" /f

  REM Всё готово!
  title UnistallContext - Uninstalling complete!
  echo To delete the program files, simply delete the "%~dp0" folder
  echo For the changes to take effect, you may need to restart your computer!
  pause>nul
) else (
  exit /b
)