@echo off
title Cong Cu Tu Dong Cap Nhat Tien Ich - KEY-TOOL
color 0B

echo ===============================================================================
echo     DANG TAI BAN CAP NHAT MOI NHAT TU YEU CAU HE THONG...
echo ===============================================================================
echo.

:: 1. Don dep tan du cu neu co
if exist "update.zip" del /f /q "update.zip"
if exist "unzip.vbs" del /f /q "unzip.vbs"

echo Dang tai xuong... Vui long khong tat cua so nay.

:: Kiem tra xem co curl tren may khong
:: Tao timestamp de bypass Cloudflare CDN cache (tranh tai file cu bi cache 30 ngay)
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set DT=%%a
set CACHE_BUST=%DT:~0,14%

where curl >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Phat hien Windows 10 hoac 11 - Su dung trinh tai toc do cao...
    curl -L -k -X GET "https://hoanghuy68.site/updates_new/update.zip?t=%CACHE_BUST%" -H "Cache-Control: no-cache, no-store, must-revalidate" -H "Pragma: no-cache" -H "Expires: 0" -o "update.zip"
) else (
    echo [INFO] Phat hien Windows doi cu - Su dung che do tai tuong thich...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://hoanghuy68.site/updates_new/update.zip?t=%CACHE_BUST%' -Headers @{'Cache-Control'='no-cache, no-store, must-revalidate'; 'Pragma'='no-cache'; 'Expires'='0'} -OutFile 'update.zip'"
)

:: Kiem tra tai thanh cong khong
if not exist "update.zip" (
    color 0C
    echo.
    echo [ERROR] Khong the tai xuong ban cap nhat tu he thong!
    echo Vui long kiem tra lai ket noi mang thiet bi cua ban hoac lien he Ho Tieu de xu ly.
    pause
    exit /b
)

echo.
echo ===============================================================================
echo     DANG GIAI NEN VA AP DUNG BAN CAP NHAT...
echo ===============================================================================
echo.

:: Giai nen
where tar >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Bung nen truc tiep tren he dieu hanh moi...
    tar -xf "update.zip"
) else (
    echo [INFO] Bung nen tren he dieu hanh cu - Vui long doi trong giay lat...
    echo Set objShell = CreateObject^("Shell.Application"^) > unzip.vbs
    echo Set objFSO = CreateObject^("Scripting.FileSystemObject"^) >> unzip.vbs
    echo strZipFile = objFSO.GetAbsolutePathName^("update.zip"^) >> unzip.vbs
    echo strDestFolder = objFSO.GetAbsolutePathName^("."^) >> unzip.vbs
    echo Set objZipItems = objShell.NameSpace^(strZipFile^).Items >> unzip.vbs
    echo objShell.NameSpace^(strDestFolder^).CopyHere objZipItems, 4 ^+ 16 >> unzip.vbs
    cscript //nologo unzip.vbs
    del /f /q "unzip.vbs"
)

:: 4. Don dep rac
if exist "update.zip" del /f /q "update.zip"

color 0A
echo.
echo ===============================================================================
echo     [ OK ] CAP NHAT THANH CONG 100%%
echo.
echo     Phien ban moi nhat cua phan mem da duoc ap dung.
echo     Ban co the tat cua so nay va MO LAI CHROME de bat dau lam viec ngay!
echo ===============================================================================
echo.
pause
