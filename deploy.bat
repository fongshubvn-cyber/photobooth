@echo off
chcp 65001 >nul
setlocal enableextensions enabledelayedexpansion

:: Add Git to PATH
set "PATH=C:\Program Files\Git\cmd;%PATH%"

cd /d "%~dp0"

echo ========================================================
echo   NCTTX PHOTOBOOTH (MAIN) - DEPLOY TO GITHUB
echo   Repo: https://github.com/fongshubvn-cyber/photobooth
echo   Link: https://fongshubvn-cyber.github.io/photobooth/
echo ========================================================
echo.

:: Ensure git repository and remote are configured
if not exist ".git" (
    echo [0/3] Khoi tao Git repository...
    git init
    git remote add origin https://github.com/fongshubvn-cyber/photobooth.git
    git fetch origin
    git branch -M main
)

:: Ensure git author identity is configured
git config user.name >nul 2>&1
if %errorlevel% neq 0 (
    git config user.name "fongshubvn-cyber"
    git config user.email "fongshubvn-cyber@users.noreply.github.com"
)

echo [1/3] Kiem tra thay doi trong du an...
git status -s
echo.

set "msg=%~1"
if "%msg%"=="" (
    set /p "msg=Nhap ghi chu cap nhat (Nhan Enter de dung mac dinh): "
)
if "!msg!"=="" (
    set "msg=Update version %date% %time%"
)

echo.
echo [2/3] Dang dong goi thay doi (Commit: "!msg!")...
git add -A
git diff --cached --quiet
if %errorlevel% equ 0 (
    echo Khong co thay doi nao moi de commit. Dang kiem tra dong bo voi GitHub...
) else (
    git commit -m "!msg!"
    if !errorlevel! neq 0 (
        echo.
        echo [LOI] Commit that bai. Vui long kiem tra lai!
        pause
        exit /b !errorlevel!
    )
)

echo.
echo [3/3] Dang day phien ban moi len GitHub (branch: main)...
git push -u origin main
if %errorlevel% neq 0 (
    echo.
    echo [LOI] Push len GitHub that bai. Vui long kiem tra ket noi mang hoac quyen truy cap GitHub!
    pause
    exit /b !errorlevel!
)

echo.
echo ========================================================
echo   THANH CONG! Da deploy phien ban CHINH (MAIN) len GitHub!
echo   Web: https://fongshubvn-cyber.github.io/photobooth/
echo   Admin: https://fongshubvn-cyber.github.io/photobooth/admin.html
echo   Download: https://fongshubvn-cyber.github.io/photobooth/download.html
echo   (Luu y: GitHub Pages co the mat 1-2 phut de cap nhat)
echo ========================================================
echo.
pause
