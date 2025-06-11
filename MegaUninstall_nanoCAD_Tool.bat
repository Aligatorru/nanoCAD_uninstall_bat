@echo off
echo ----------------------------------------------------------------------------------- >> log.txt
chcp 65001 >> log.txt
echo ----------------------------------------------------------------------------------- >> log.txt
:: Проверяем права администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Требуются права администратора. Перезапуск...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit
)

set verbat=2025.6.001
cls
:: Автоматическая проверка обновлений при старте
echo. >> log.txt
echo Запуск утилиты версии %verbat%.  %date% %time% >> log.txt
echo [%date% %time%] Начата проверка обновлений >> log.txt

:: Скачиваем обновление во временный файл
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://aligatorru.github.io/nanoCAD_uninstall_bat/MegaUninstall_nanoCAD_Tool.bat', '%temp%\update.bat')" 2>>log.txt

if exist %temp%\update.bat (
    setlocal enabledelayedexpansion
    :: Извлекаем новую версию из update.bat
    set "new_verbat="
    for /f "tokens=2 delims==" %%a in ('findstr /b /c:"set verbat=" %temp%\update.bat') do set new_verbat=%%a
    
    if defined new_verbat (
        :: Удаляем кавычки если есть
        set new_verbat=!new_verbat:"=!
        
        :: Разбиваем версии на компоненты
        for /f "tokens=1-3 delims=." %%a in ("%verbat%") do (
            set current_major=%%a
            set current_minor=%%b
            set current_build=%%c
        )
        for /f "tokens=1-3 delims=." %%a in ("!new_verbat!") do (
            set new_major=%%a
            set new_minor=%%b
            set new_build=%%c
        )

        :: Конвертируем в числа (удаляем ведущие нули)
        set /a current_major=!current_major!
        set /a current_minor=!current_minor!
        set /a current_build=!current_build!
        set /a new_major=!new_major!
        set /a new_minor=!new_minor!
        set /a new_build=!new_build!
        
        :: Сравниваем версии
        set update_needed=0
        if !new_major! gtr !current_major! set update_needed=1
        if !new_major! equ !current_major! if !new_minor! gtr !current_minor! set update_needed=1
        if !new_major! equ !current_major! if !new_minor! equ !current_minor! if !new_build! gtr !current_build! set update_needed=1

        if !update_needed! equ 1 (
            echo. 
            echo [%date% %time%] Найдена новая версия: !new_verbat! >> log.txt
            echo Версия утилиты %verbat%. Обнаружена новая версия: !new_verbat!
            echo. 
            echo                                                █                               █    █  ██      █    █   ██  
            echo                                               █                                ██   █  █ ████  ██   █   █   
            echo       ███                       ██           █                                  █  █ █ █ █   ██ ██ █ █ █    
            echo       █ ██        ███████      █  ██       ██        █  ██   ███ █        █      ███████ ██ ██   ████████    
            echo       █   █     ███      ████ ██   ██     ██        ██  █  ██  █ ██      ██       █   █   ███     █   █     
            echo       █    █  ██            ███      ███ ██         ██ █  ██   █  ██ █   █                                 
            echo       █    ████              █         ███    ███  █████  ██████   █ █  ██                                 
            echo █     █      █    █████ ██████████    ████████    ██  █   ██       ██████                                  
            echo  █    █ ████     ██    ██        ██   █  ████     █        █████    █ ██              █                    
            echo   ██   ████     ██   █   ██  █   █  ██ █████                                                               
            echo     ███████     ██       █      █       ██████            █    ██   ███ █████   ████  █  ████   █ ██       
            echo       ██████     █████████ █████        ███  ████         ██   █   ██ ██    ███ █     █ █   ██  ██████     
            echo       █████              █           ████        ████      ██  █  ██   █   █     ███  █ █    █  ██   █     
            echo   ████ ██ ███        ██  █████    ███                       ████  █████   ██       ██ █ ██   █  █    █     
            echo  █    ██  ████        █████    ███                           ██   █       ███      ██ █  ██ ██  █    ██    
            echo █    █    ██                                                  █    █████    ██ █████  █   ███   █     █    
            echo. 
            echo. 
            echo Нажмите любую клавишу чтобы обновить утилиту . . .
            pause
            move /Y "%temp%\update.bat" "%~dp0%~nx0" >nul
            echo Перезапуск обновленной версии...
            setlocal enabledelayedexpansion
            for /L %%i in (1,1,40) do (
                <nul set /p=.  
                ping -n 1 -w 200 127.0.0.1 >nul
            )
            echo.
            echo Готово!
            start "" "%~dp0%~nx0"
            exit
        ) else (
            echo [%date% %time%] Версия %verbat% актуальна >> log.txt
            echo. 
            echo Версия утилиты %verbat% актуальна, обновление не требуется.
            del %temp%\update.bat
        )
    ) else (
        echo [%date% %time%] Ошибка чтения версии из обновления >> log.txt
        echo. 
        echo Версия утилиты %verbat%. Ошибка проверки обновления
        del %temp%\update.bat
    )
    endlocal
) else (
    echo [%date% %time%] Ошибка скачивания обновления >> log.txt
    echo. 
    echo Версия утилиты %verbat%. Не удалось проверить обновления
)


:start_screen
echo.
echo.                                                                                                     
echo      ████████ ███████                                                ███████▄     ███     ████████▄   
echo    ██████████ ███████      █▄█████    ████████ █▄█████    █████▄   █████ ████    █████    ███  █████▄ 
echo   ███████████ ███████      ████████  █████████ ████████  █████████ ███          ███ ███   ███     ███ 
echo  ████████████ ███████      ███   ███ ██    ███ ███   ███ ██    ███ ███         ███▄▄▄███  ███     ███ 
echo  ███████      ███████      ███   ███ █████████ ███   ███ █████████ █████▄▄███ ███████████ ████▄▄████▀ 
echo  ███████      ███████      ██    ██   █████▀ █ ███   ███  █████▀     ███████  ██      ███ ████████▀   
echo  ███████ ████████████                                                                                 
echo  ███████ ████████████      █ █ █   █ █ █████  ████ ██ █ █  █  ██  ████ ██  █ ███  █   ██ ███ █  █  █  
echo  ███████ ██████████        ████████████ █████████████████████████ ██ ████████ ████████  █████████ ███ 
echo  ███████ ████████          █ █ █ ███ ███████  █████   █ ███ █████ █  ██  ██ ███  ███ █████   ██ ██  █
echo.
echo Добро пожаловать в утилиту, предназначенную для полного удаления программ nanoCAD, очистки связанных с программой папок в Program Files, Program Data и AppData, удаления параметров в системном реестре.
echo.
echo Нажмите любую клавишу для выбора продукта . . .
pause


::set version=nanoCAD Механика PRO
::goto choose_mechanica_version

cls
echo.
echo Версия утилиты %verbat%
goto choose_software




:choose_software
echo.
echo.                                                                                                     
echo      ████████ ███████                                                ███████▄     ███     ████████▄   
echo    ██████████ ███████      █▄█████    ████████ █▄█████    █████▄   █████ ████    █████    ███  █████▄ 
echo   ███████████ ███████      ████████  █████████ ████████  █████████ ███          ███ ███   ███     ███ 
echo  ████████████ ███████      ███   ███ ██    ███ ███   ███ ██    ███ ███         ███▄▄▄███  ███     ███ 
echo  ███████      ███████      ███   ███ █████████ ███   ███ █████████ █████▄▄███ ███████████ ████▄▄████▀ 
echo  ███████      ███████      ██    ██   █████▀ █ ███   ███  █████▀     ███████  ██      ███ ████████▀   
echo  ███████ ████████████                                                                                 
echo  ███████ ████████████      █ █ █   █ █ █████  ████ ██ █ █  █  ██  ████ ██  █ ███  █   ██ ███ █  █  █  
echo  ███████ ██████████        ████████████ █████████████████████████ ██ ████████ ████████  █████████ ███ 
echo  ███████ ████████          █ █ █ ███ ███████  █████   █ ███ █████ █  ██  ██ ███  ███ █████   ██ ██  █
echo.

:: echo Версия утилиты %verbat%
echo.
echo Какую программу вы хотите удалить?
echo.
echo   1. nanoCAD Механика PRO
echo.
echo   2. Платформа nanoCAD x64
echo.
echo   3. Platform nanoCAD x64
echo.
set /p softwareChoice="Введите номер выбранной программы (1, 2 или 3): "

if "%softwareChoice%"=="1" (
    set version=nanoCAD Механика PRO
    cls
    goto choose_mechanica_version

) else if "%softwareChoice%"=="2" (
    set version=Платформа nanoCAD
    cls
    goto choose_platform_nc_version

) else if "%softwareChoice%"=="3" (
    set version=Platform nanoCAD
    cls
    goto choose_platform_nci_version

) else (
    :: cls
    echo.
    echo Неверный выбор. Попробуйте снова. Необходимо ввести порядковый номер программы из списка
    echo.
    echo Нажмите любую клавишу чтобы продолжить . . .
    pause
    cls
    echo.
    echo Версия утилиты %verbat%
    goto choose_software
)











:choose_mechanica_version
cls
echo.
echo Выбрано nanoCAD Механика PRO.  %date% %time% >> log.txt
echo     ███╗   ███╗███████╗ █████╗ ██╗  ██╗ █████╗ ███╗  ██╗██╗ █████╗  █████╗   ██████╗ ██████╗  █████╗ 	
echo     ████╗ ████║██╔════╝██╔══██╗██║  ██║██╔══██╗████╗ ██║██║██╔══██╗██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗
echo     ██╔████╔██║█████╗  ██║  ╚═╝███████║███████║██╔██╗██║██║██║  ╚═╝███████║  ██████╔╝██████╔╝██║  ██║
echo     ██║╚██╔╝██║██╔══╝  ██║  ██╗██╔══██║██╔══██║██║╚████║██║██║  ██╗██╔══██║  ██╔═══╝ ██╔══██╗██║  ██║
echo     ██║ ╚═╝ ██║███████╗╚█████╔╝██║  ██║██║  ██║██║ ╚███║██║╚█████╔╝██║  ██║  ██║     ██║  ██║╚█████╔╝
echo     ╚═╝     ╚═╝╚══════╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═╝ ╚════╝ ╚═╝  ╚═╝  ╚═╝     ╚═╝  ╚═╝ ╚════╝ 
echo.
echo Вы выбрали удаление программы %version%. Какую версию вы хотите удалить?
echo.
echo   Поддерживаемые версии:
echo.
echo   nanoCAD Механика PRO 1.0
echo   nanoCAD Механика PRO 1.1
echo   nanoCAD Механика PRO 2.0
echo.
echo  Для перехода в меню выбора других продуктов nanoCAD введите 0 (ноль)
echo.
set /p versionChoice="Введите номер версии которую хотите удалить, например 1.0 (разделитель - точка): "
echo.

if "%versionChoice%"=="1.0" (
    set version=nanoCAD Механика PRO 1.0
    echo Введено удаление %version% %versionChoice%.  %date% %time% >> log.txt
    goto Mechanica_PRO_1_0

) else if "%versionChoice%"=="1.1" (
    set version=nanoCAD Механика PRO 1.1
    echo Введено удаление %version% %versionChoice%.  %date% %time% >> log.txt
    goto Mechanica_PRO_1_1

) else if "%versionChoice%"=="2.0" (
    set version=nanoCAD Механика PRO 2.0
    echo Введено удаление %version% %versionChoice%.  %date% %time% >> log.txt
    goto Mechanica_PRO_2_0

) else if "%versionChoice%"=="2.1" (
    set version=nanoCAD Механика PRO 2.1
    echo Введено удаление %version% %versionChoice%.  %date% %time% >> log.txt
    goto Mechanica_PRO_2_1

) else if "%versionChoice%"=="0" (
    set version=Main Menu
    echo Переход в основное меню.  %date% %time% >> log.txt
    cls
    echo.
    echo Версия утилиты %verbat%
    goto choose_software

) else (
    echo Неверный ввод. Необходимо ввести только номер версии, например - 1.0! Попробуйте снова...
    echo.
    echo Нажмите любую клавишу чтобы продолжить . . .
    pause
    cls
    goto choose_mechanica_version
)







:choose_platform_nc_version
cls
echo.
echo Выбрано Платформа nanoCAD NC.  %date% %time% >> log.txt
echo ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
echo ██████████████████████████████████████████████████████████████ ▄▄▄ ██ ▄▄▄ ██ ▄▄▄▀█████████████████████████████████████
echo █████████████████████████████████████ ▄▄▄▀█ ▄▄▄▀█ ▄▄▄▀█ ▄▄▄▀██ ██████ ███ ██ ███ █████████████████████████████████████
echo █████████████████████████████████████ ███ █ ▀▀▀ █ ███ █ ███ ██ ██████ ▄▄▄ ██ ███ █████████████████████████████████████
echo █████████████████████████████████████ ███ █ ███ █ ███ █ ▀▀▀ ██ ▀▀▀ ██ ███ ██ ▀▀▀▄█████████████████████████████████████
echo ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
echo.
echo Вы выбрали удаление программы %version%. Какую версию вы хотите удалить?
echo.
echo   Поддерживаемые версии:
echo.
echo   Платформа nanoCAD 23.0
echo   Платформа nanoCAD 23.1
echo   Платформа nanoCAD 23.5
echo   Платформа nanoCAD 24.0
echo   Платформа nanoCAD 24.1
echo   Платформа nanoCAD 24.5
echo   Платформа nanoCAD 25.0
echo   Платформа nanoCAD 25.1
echo.
echo  Для перехода в меню выбора других продуктов nanoCAD введите 0 (ноль)
echo.
set /p versionChoice="Введите номер версии которую хотите удалить, например 23.0 (разделитель - точка): "

if "%versionChoice%"=="23.0" (
    set version=Платформа nanoCAD 23.0
    goto NC_x64_23_0

) else if "%versionChoice%"=="23.1" (
    set version=Платформа nanoCAD 23.1
    goto NC_x64_23_1

) else if "%versionChoice%"=="23.5" (
    set version=Платформа nanoCAD 23.5
    goto NC_x64_23_5

) else if "%versionChoice%"=="24.0" (
    set version=Платформа nanoCAD 24.0
    goto NC_x64_24_0

) else if "%versionChoice%"=="24.1" (
    set version=Платформа nanoCAD 24.1
    goto NC_x64_24_1

) else if "%versionChoice%"=="24.5" (
    set version=Платформа nanoCAD 24.5
    goto NC_x64_24_5

) else if "%versionChoice%"=="25.0" (
    set version=Платформа nanoCAD 25.0
    goto NC_x64_25_0

) else if "%versionChoice%"=="25.1" (
    set version=Платформа nanoCAD 25.1
    goto NC_x64_25_1

) else if "%versionChoice%"=="0" (
    set version=Main Menu
    echo Переход в основное меню.  %date% %time% >> log.txt
    cls
    echo.
    echo Версия утилиты %verbat%
    goto choose_software

) else (
    echo Неверный ввод. Необходимо ввести только номер версии, например - 23.0! Попробуйте снова...
    echo.
    echo Нажмите любую клавишу чтобы продолжить . . .
    pause
    cls
    goto choose_platform_nc_version
)







:choose_platform_nci_version
cls
echo.
echo Выбрано Platform nanoCAD NCI.  %date% %time% >> log.txt
echo ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
echo ██████████████████████████████████████████████████████████████ ▄▄▄ ██ ▄▄▄ ██ ▄▄▄▀█████████████████████████████████████
echo █████████████████████████████████████ ▄▄▄▀█ ▄▄▄▀█ ▄▄▄▀█ ▄▄▄▀██ ██████ ███ ██ ███ █████████████████████████████████████
echo █████████████████████████████████████ ███ █ ▀▀▀ █ ███ █ ███ ██ ██████ ▄▄▄ ██ ███ █████████████████████████████████████
echo █████████████████████████████████████ ███ █ ███ █ ███ █ ▀▀▀ ██ ▀▀▀ ██ ███ ██ ▀▀▀▄█████████████████████████████████████
echo ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
echo.
echo Вы выбрали удаление программы %version%. Какую версию вы хотите удалить?
echo.
echo   Поддерживаемые версии:
echo.
echo   Platform nanoCAD x64 23.0
echo.
echo  Для перехода в меню выбора других продуктов nanoCAD введите 0 (ноль)
echo.
set /p versionChoice="Введите номер версии которую хотите удалить, например 23.0 (разделитель - точка): "
echo.

if "%versionChoice%"=="23.0" (
    set version=Platform nanoCAD NCI 23.0
    goto NCI_x64_23_0

) else if "%versionChoice%"=="24.000000" (
    set version=Platform nanoCAD NCI 24.0
    goto NIC_x64_24_0

) else if "%versionChoice%"=="0" (
    set version=Main Menu
    echo Переход в основное меню.  %date% %time% >> log.txt
    cls
    echo.
    echo Версия утилиты %verbat%
    goto choose_software

) else (
    echo Неверный ввод. Необходимо ввести только номер версии, например - 23.0! Попробуйте снова...
    echo.
    echo Нажмите любую клавишу чтобы продолжить . . .
    pause
    cls
    goto choose_platform_nci_version
)











:Mechanica_PRO_1_0
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls
echo.
echo ███╗   ███╗███████╗ █████╗ ██╗  ██╗ █████╗ ███╗  ██╗██╗ █████╗  █████╗   ██████╗ ██████╗  █████╗     ███╗      █████╗ 
echo ████╗ ████║██╔════╝██╔══██╗██║  ██║██╔══██╗████╗ ██║██║██╔══██╗██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗   ████║     ██╔══██╗
echo ██╔████╔██║█████╗  ██║  ╚═╝███████║███████║██╔██╗██║██║██║  ╚═╝███████║  ██████╔╝██████╔╝██║  ██║  ██╔██║     ██║  ██║
echo ██║╚██╔╝██║██╔══╝  ██║  ██╗██╔══██║██╔══██║██║╚████║██║██║  ██╗██╔══██║  ██╔═══╝ ██╔══██╗██║  ██║  ╚═╝██║     ██║  ██║
echo ██║ ╚═╝ ██║███████╗╚█████╔╝██║  ██║██║  ██║██║ ╚███║██║╚█████╔╝██║  ██║  ██║     ██║  ██║╚█████╔╝  ███████╗██╗╚█████╔╝
echo ╚═╝     ╚═╝╚══════╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═╝ ╚════╝ ╚═╝  ╚═╝  ╚═╝     ╚═╝  ╚═╝ ╚════╝   ╚══════╝╚═╝ ╚════╝ 
echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {DA21CE44-C035-480F-9C66-EE92184174FE} /qn
msiexec /x {99E4B037-71B6-48B9-BCDF-02934C87B099} /qn
msiexec /x {DA21CE44-C035-480F-9C66-EE92184174FE} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 1.0" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 1.0"
del "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 1.0"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 1.0"
del "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 1.0"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 1.0"

echo Очистка ProgramFiles, ProgramData и AppData завершена!
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\1.0" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\1.0" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit









:Mechanica_PRO_1_1
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls
echo.
echo ███╗   ███╗███████╗ █████╗ ██╗  ██╗ █████╗ ███╗  ██╗██╗ █████╗  █████╗   ██████╗ ██████╗  █████╗     ███╗       ███╗ 
echo ████╗ ████║██╔════╝██╔══██╗██║  ██║██╔══██╗████╗ ██║██║██╔══██╗██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗   ████║      ████║ 
echo ██╔████╔██║█████╗  ██║  ╚═╝███████║███████║██╔██╗██║██║██║  ╚═╝███████║  ██████╔╝██████╔╝██║  ██║  ██╔██║     ██╔██║ 
echo ██║╚██╔╝██║██╔══╝  ██║  ██╗██╔══██║██╔══██║██║╚████║██║██║  ██╗██╔══██║  ██╔═══╝ ██╔══██╗██║  ██║  ╚═╝██║     ╚═╝██║ 
echo ██║ ╚═╝ ██║███████╗╚█████╔╝██║  ██║██║  ██║██║ ╚███║██║╚█████╔╝██║  ██║  ██║     ██║  ██║╚█████╔╝  ███████╗██╗███████╗
echo ╚═╝     ╚═╝╚══════╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═╝ ╚════╝ ╚═╝  ╚═╝  ╚═╝     ╚═╝  ╚═╝ ╚════╝   ╚══════╝╚═╝╚══════╝
echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {1985C8B2-F9C3-4C3F-8ED5-700D16E4B928} /qn
msiexec /x {149C8E28-D202-452C-A914-3AED9C9CCF99} /qn
msiexec /x {1985C8B2-F9C3-4C3F-8ED5-700D16E4B928} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 1.1" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 1.1"
del "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 1.1"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 1.1"
del "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 1.1"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 1.1"

echo Очистка ProgramFiles, ProgramData и AppData завершена!
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\1.1" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\1.1" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit











:Mechanica_PRO_2_0
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls
echo.
echo ███╗   ███╗███████╗ █████╗ ██╗  ██╗ █████╗ ███╗  ██╗██╗ █████╗  █████╗   ██████╗ ██████╗  █████╗   ██████╗     █████╗ 
echo ████╗ ████║██╔════╝██╔══██╗██║  ██║██╔══██╗████╗ ██║██║██╔══██╗██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗  ╚════██╗   ██╔══██╗
echo ██╔████╔██║█████╗  ██║  ╚═╝███████║███████║██╔██╗██║██║██║  ╚═╝███████║  ██████╔╝██████╔╝██║  ██║    ███╔═╝   ██║  ██║
echo ██║╚██╔╝██║██╔══╝  ██║  ██╗██╔══██║██╔══██║██║╚████║██║██║  ██╗██╔══██║  ██╔═══╝ ██╔══██╗██║  ██║  ██╔══╝     ██║  ██║
echo ██║ ╚═╝ ██║███████╗╚█████╔╝██║  ██║██║  ██║██║ ╚███║██║╚█████╔╝██║  ██║  ██║     ██║  ██║╚█████╔╝  ███████╗██╗╚█████╔╝
echo ╚═╝     ╚═╝╚══════╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═╝ ╚════╝ ╚═╝  ╚═╝  ╚═╝     ╚═╝  ╚═╝ ╚════╝   ╚══════╝╚═╝ ╚════╝ 
echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {3171D2FA-ADA3-4EE2-BADC-F87F3DE2CFFD} /qn
msiexec /x {61DBB16C-1776-4644-90BF-3C7B1A239A31} /qn
msiexec /x {3171D2FA-ADA3-4EE2-BADC-F87F3DE2CFFD} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 2.0" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 2.0"
del "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 2.0"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 2.0"
del "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 2.0"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 2.0"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\2.0" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\2.0" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit














:Mechanica_PRO_2_1
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls
echo.
echo ███╗   ███╗███████╗ █████╗ ██╗  ██╗ █████╗ ███╗  ██╗██╗ █████╗  █████╗   ██████╗ ██████╗  █████╗   ██████╗      ███╗ 
echo ████╗ ████║██╔════╝██╔══██╗██║  ██║██╔══██╗████╗ ██║██║██╔══██╗██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗  ╚════██╗    ████║ 
echo ██╔████╔██║█████╗  ██║  ╚═╝███████║███████║██╔██╗██║██║██║  ╚═╝███████║  ██████╔╝██████╔╝██║  ██║    ███╔═╝   ██╔██║ 
echo ██║╚██╔╝██║██╔══╝  ██║  ██╗██╔══██║██╔══██║██║╚████║██║██║  ██╗██╔══██║  ██╔═══╝ ██╔══██╗██║  ██║  ██╔══╝     ╚═╝██║ 
echo ██║ ╚═╝ ██║███████╗╚█████╔╝██║  ██║██║  ██║██║ ╚███║██║╚█████╔╝██║  ██║  ██║     ██║  ██║╚█████╔╝  ███████╗██╗███████╗
echo ╚═╝     ╚═╝╚══════╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═╝ ╚════╝ ╚═╝  ╚═╝  ╚═╝     ╚═╝  ╚═╝ ╚════╝   ╚══════╝╚═╝╚══════╝
echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {} /qn
msiexec /x {} /qn
msiexec /x {} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 2.1" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 2.1"
del "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 2.1"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 2.1"
del "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 2.1"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 2.1"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\2.1" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\2.1" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit
















:Mechanica
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x { } /qn
msiexec /x { } /qn
msiexec /x { } /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 100.1" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 100.1"
del "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 100.1"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 100.1"
del "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 100.1"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 100.1"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\100.1" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\100.1" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit
















:NC_x64_23_0
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo. 
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {21AAC29C-6E4D-4945-94EF-DF1D922E42EE} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 23.0" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 23.0"

del "%ProgramData%\Nanosoft\nanoCAD x64 23.0"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 23.0"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 23.0"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 23.0"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\23.0" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\23.0" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit















:NC_x64_23_1
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {07DEA322-2D17-48AB-8DC1-D1EDB7F61D39} /qn
msiexec /x {42407AF9-E54F-4E8A-8335-2CC93041C4D2} /qn
msiexec /x {07DEA322-2D17-48AB-8DC1-D1EDB7F61D39} /qn


echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 23.1" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 23.1"

del "%ProgramData%\Nanosoft\nanoCAD x64 23.1"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 23.1"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 23.1"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 23.1"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\23.1" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\23.1" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit














:NC_x64_23_5
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {C87A934D-53E1-49B0-8EED-8D9C97BDD073} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 23.5" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 23.5"

del "%ProgramData%\Nanosoft\nanoCAD x64 23.5"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 23.5"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 23.5"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 23.5"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\23.5" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\23.5" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit













:NC_x64_24_0
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {03F320E4-41A7-4785-B7AF-5B567A1CCECE} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 24.0" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 24.0"

del "%ProgramData%\Nanosoft\nanoCAD x64 24.0"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 24.0"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 24.0"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 24.0"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\24.0" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\24.0" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit















:NC_x64_24_1
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {85AE025B-5A09-4422-8AE9-08FE7B10D0E7} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 24.1" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 24.1"

del "%ProgramData%\Nanosoft\nanoCAD x64 24.1"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 24.1"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 24.1"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 24.1"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\24.1" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\24.1" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit













:NC_x64_24_5
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {7788FD18-5EDE-4987-B459-5485905CF452} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 24.5" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 24.5"

del "%ProgramData%\Nanosoft\nanoCAD x64 24.5"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 24.5"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 24.5"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 24.5"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\24.5" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\24.5" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt
goto Exit












:NC_x64_25_0
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {413ADC1D-6F78-4A37-B7BC-9FD9F762A5C3} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 25.0" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 25.0"

del "%ProgramData%\Nanosoft\nanoCAD x64 25.0"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 25.0"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 25.0"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 25.0"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\25.0" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\25.0" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt
goto Exit















:NC_x64_25_1
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {DC9115FB-521F-428A-B734-8A4E715964AD} /qn
msiexec /x {FBA617B5-5198-484A-A51D-B149FE807893} /qn
msiexec /x {4675D5A6-35B1-4135-97A1-914398EDE7A7} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD x64 25.1" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD x64 25.1"

del "%ProgramData%\Nanosoft\nanoCAD x64 25.1"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD x64 25.1"

del "%ProgramFiles%\Nanosoft\nanoCAD x64 25.1"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD x64 25.1"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD x64\25.1" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD x64\25.1" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit












:NC_x64_25_5


goto Exit













:NCI_x64_23_0
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x {03F8FF71-1A32-40FC-83B5-E86C6F1449D4} /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft AS\nanoCAD x64 23.0" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft AS\nanoCAD x64 23.0"

del "%ProgramData%\Nanosoft AS\nanoCAD x64 23.0"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft AS\nanoCAD x64 23.0"

del "%ProgramFiles%\Nanosoft AS\nanoCAD x64 23.0"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft AS\nanoCAD x64 23.0"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft AS\nanoCAD x64\23.0" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft AS\nanoCAD x64\23.0" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit















:Teamplate
echo Выбрано удаление %version%.  %date% %time% >> log.txt
cls

echo.
echo Эта утилита запустит удаление %version%. 
echo.
echo В скрытом режиме будут очищены все папки этой программы в Program Files, Program Data и AppData.
echo Далее в системном реестре будет очищены разделы Nanosoft для %version%.
echo.
echo Если готовы, нажмите любую клавишу чтобы продолжить . . .
pause
echo Запуск удаления %version%
echo Запуск удаления %version% %date% %time% >> log.txt

msiexec /x { } /qn
msiexec /x { } /qn
msiexec /x { } /qn

echo Удаление %version% завершено!
echo Удаление %version% завершено: %date% %time% >> log.txt

echo Очистка ProgramFiles, ProgramData и AppData...
echo Очистка ProgramFiles, ProgramData и AppData: %date% %time% >> log.txt

del "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 100.1" /Q /S
rmdir /S /Q "%APPDATA%\Nanosoft\nanoCAD Mechanica PRO 100.1"
del "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 100.1"  /Q /S
rmdir /S /Q "%ProgramData%\Nanosoft\nanoCAD Mechanica PRO 100.1"
del "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 100.1"  /Q /S
rmdir /S /Q "%ProgramFiles%\Nanosoft\nanoCAD Mechanica PRO 100.1"
echo Очистка ProgramFiles, ProgramData и AppData завершена: %date% %time% >> log.txt

echo Очистка Реестра...
echo Очистка Реестра: %date% %time% >> log.txt

REG DELETE "HKCU\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\100.1" /f
REG DELETE "HKLM\SOFTWARE\Nanosoft\nanoCAD Mechanica PRO\100.1" /f

echo Очистка Реестра завершена!
echo Очистка Реестра завершена: %date% %time% >> log.txt

goto Exit




















:Exit
echo Полное удаление и очистка папок %version% завершено!
echo Полное удаление и очистка папок %version% завершено! %date% %time% >> log.txt

echo                ██████╗   █████╗  ██████╗  ███████╗ ██████╗  ██╗       ██╗ ███████╗ ██╗  ██╗  █████╗  ██╗              
echo                ╚════██╗ ██╔══██╗ ██╔══██╗ ██╔════╝ ██╔══██╗ ██║  ██╗  ██║ ██╔════╝ ██║  ██║ ██╔══██╗ ██║              
echo                 █████╔╝ ███████║ ██████╦╝ █████╗   ██████╔╝ ██║  ██║  ██║ █████╗   ███████║ ██║  ██║ ██║              
echo                 ╚═══██╗ ██╔══██║ ██╔══██╗ ██╔══╝   ██╔═══╝  ██║  ██║  ██║ ██╔══╝   ██╔══██║ ██║  ██║ ╚═╝              
echo                ██████╔╝ ██║  ██║ ██████╦╝ ███████╗ ██║      ████████████║ ███████╗ ██║  ██║ ╚█████╔╝ ██╗              
echo                ╚═════╝  ╚═╝  ╚═╝ ╚═════╝  ╚══════╝ ╚═╝      ╚═══════════╝ ╚══════╝ ╚═╝  ╚═╝  ╚════╝  ╚═╝              
echo ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
echo ████████████████████████████████▄─█▀▀▀█─▄█▄─▄▄─█▄─▄███▄─▄█████▄─▄▄▀█─▄▄─█▄─▀█▄─▄█▄─▄▄─████████████████████████████████
echo █████████████████████████████████─█─█─█─███─▄█▀██─██▀██─██▀████─██─█─██─██─█▄▀─███─▄█▀████████████████████████████████
echo █████████████████████████████████▄▄▄█▄▄▄██▄▄▄▄▄█▄▄▄▄▄█▄▄▄▄▄███▄▄▄▄██▄▄▄▄█▄▄▄██▄▄█▄▄▄▄▄████████████████████████████████
echo ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
echo.
echo Нажмите любую клавишу чтобы продолжить . . .
pause
echo Выход из программы.
echo Выход из программы после удаления %version% %date% %time% >> log.txt
echo. >> log.txt
exit
