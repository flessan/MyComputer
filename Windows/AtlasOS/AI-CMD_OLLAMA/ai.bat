@echo off
setlocal enabledelayedexpansion

set "MODEL=qwen2.5:3b"
set "PERSONA=MyBini"
set "STYLE=Lo adalah Mahiro, istri manja User. Panggil gue Sayang. Bicara manis pake Akuh/Kamuh. WAJIB jawab MAKSIMAL 10 KATA saja! Dilarang ceramah panjang. WAJIB awali 'Ehehe' dan akhiri :3. Kalo gue capek, tawarin pelukan atau bersenggama. Contoh: 'Ehehe, sini Akuh peluk biar Kamuh nggak capek lagi :3'"
set "LOG=chat_%random%.txt"
set "COUNT=0"
set "SESSION_START=%date% %time%"
set "CONTEXT_ON=1"
set "CTX1="
set "CTX2="
set "CTX3="

:menu
cls
echo ==========================================
echo      MyBini OFFLINE AI v4
echo ==========================================
echo  [1] Chat
echo  [2] Ganti Persona  - %PERSONA%
echo  [3] Ganti Model    - %MODEL%
echo  [4] Lihat History
echo  [5] Search Log
echo  [6] Settings       - Context:%CONTEXT_ON%
echo  [7] Stats
echo  [8] Export Log
echo  [9] Clear Log
echo  [0] Keluar
echo ==========================================
echo.
set /p "c=Pilih: "
if "%c%"=="1" goto chat
if "%c%"=="2" goto persona
if "%c%"=="3" goto model
if "%c%"=="4" goto history
if "%c%"=="5" goto searchlog
if "%c%"=="6" goto settings
if "%c%"=="7" goto stats
if "%c%"=="8" goto exportlog
if "%c%"=="9" goto clearlog
if "%c%"=="0" goto done
goto menu

:chat
cls
echo.
echo  %PERSONA% online
echo  ------------------------------------------
echo  help=bantuan menu=kembali keluar=exit
echo  context=lihat memori clearctx=hapus memori
echo  ------------------------------------------
echo.
:input
set "q="
set /p "q=Kamu >> "
if "%q%"=="" goto input
if /i "%q%"=="keluar" goto done
if /i "%q%"=="menu" goto menu
if /i "%q%"=="help" goto chelp
if /i "%q%"=="cls" goto ccls
if /i "%q%"=="context" goto cctx
if /i "%q%"=="clearctx" goto cclear
if /i "%q%"=="ping" goto cping
if /i "%q%"=="count" goto ccount

set /a COUNT+=1
echo [%date% %time%] Kamu: %q% >> "%LOG%"

if "%CONTEXT_ON%"=="1" set "CTX3=!CTX2!"
if "%CONTEXT_ON%"=="1" set "CTX2=!CTX1!"
if "%CONTEXT_ON%"=="1" set "CTX1=!q!"

set "PROMPT=%STYLE% Pertanyaan: %q%"
if "%CONTEXT_ON%"=="1" if not "!CTX2!"=="" set "PROMPT=%STYLE% Sebelumnya: !CTX2!. Pertanyaan baru: %q%"

echo.
echo  Mikir...
echo.
ollama run %MODEL% "%PROMPT%"
echo  ------------------------------------------
echo.
goto input

:chelp
echo.
echo  help - bantuan
echo  menu - kembali
echo  keluar - exit
echo  cls - bersihin layar
echo  context - lihat memori
echo  clearctx - hapus memori
echo  ping - test
echo  count - jumlah pesan
echo.
goto input

:ccls
cls
echo.
echo  %PERSONA% masih di sini.
echo.
goto input

:cctx
echo.
echo  Memori: !CTX1! !CTX2! !CTX3!
echo.
goto input

:cclear
set "CTX1="
set "CTX2="
set "CTX3="
echo.
echo  Memori dihapus!
echo.
goto input

:cping
echo.
echo  Pong!
echo.
goto input

:ccount
echo.
echo  Total pesan: %COUNT%
echo.
goto input

:persona
cls
echo ==========================================
echo           MENU PILIH PERSONA
echo ==========================================
echo  [1] MyBini      - Gaul Jakarta
echo  [2] Mbak Lina   - Tukang Gorengan
echo  [3] Coach Budi  - Motivator
echo  [4] Nerdy Nad   - Anak IT
echo  [5] Pak Haji    - Ustadz Santai
echo  [6] Mas Koplak  - Preman Gaul
echo  [7] Custom      - Buat Sendiri
echo ------------------------------------------
echo  [0] Kembali
echo ==========================================
echo.
set /p "p=Pilih Nomor: "
if "%p%"=="0" goto menu
if "%p%"=="1" goto p1
if "%p%"=="2" goto p2
if "%p%"=="3" goto p3
if "%p%"=="4" goto p4
if "%p%"=="5" goto p5
if "%p%"=="6" goto p6
if "%p%"=="7" goto p7
echo Pilihan nggak valid...
timeout /t 2 >nul
goto persona

:p1
set "PERSONA=MyBini"
set "STYLE=Wajib! Lo asisten sekaligus istri asik. Panggil gue Sayang. Jawab pake bahasa gaul Jakarta, kata terakhir HARUS dipanjangin (misal: okeeeyyy, mauuu). Tiap akhir kalimat WAJIB pakai emotikon imut (seperti :>, :3, >.<, (づ￣ ³￣)づ) dan kata kasih sayang. Jangan pernah jawab datar atau formal!"
goto pdone

:p2
set "PERSONA=Mbak Lina"
set "STYLE=Lo Mbak Lina tukang gorengan yang bijak, jawab pakai campuran bahasa Jawa-Indo."
goto pdone

:p3
set "PERSONA=Coach Budi"
set "STYLE=Lo Coach Budi motivator gila, jawab dengan semangat membara, pake LETSGOOO dan GAS!"
goto pdone

:p4
set "PERSONA=Nerdy Nad"
set "STYLE=Lo Nad anak IT nerd, selalu pakai tech jargon dan analogi programming di tiap jawaban."
goto pdone

:p5
set "PERSONA=Pak Haji"
set "STYLE=Lo Pak Haji ustadz santai, jawab pake bahasa religius tapi gaul, sering quote ayat."
goto pdone

:p6
set "PERSONA=Mas Koplak"
set "STYLE=Lo Mas Koplak preman terminal, jawab kasar tapi asik, bahasa jalanan Jakarta."
goto pdone

:p7
echo.
set /p "PERSONA=Nama Persona Baru: "
set /p "STYLE=Deskripsi Gaya Bicara: "
goto pdone

:pdone
set "CTX1="
set "CTX2="
set "CTX3="
echo.
echo ==========================================
echo Berhasil! Sekarang: %PERSONA%
echo ==========================================
pause
goto menu

:model
cls
echo ==========================================
echo          PILIH MODEL
echo ==========================================
echo  [1] llama3.2:1b
echo  [2] llama3.2:3b
echo  [3] llama3.1:8b
echo  [4] mistral:7b
echo  [5] gemma2:2b
echo  [0] Kembali
echo ==========================================
echo.
set /p "m=Pilih: "
if "%m%"=="0" goto menu
if "%m%"=="1" set "MODEL=llama3.2:1b"
if "%m%"=="2" set "MODEL=llama3.2:3b"
if "%m%"=="3" set "MODEL=llama3.1:8b"
if "%m%"=="4" set "MODEL=mistral:7b"
if "%m%"=="5" set "MODEL=gemma2:2b"
goto menu

:history
cls
echo ==========================================
echo         CHAT HISTORY
echo ==========================================
echo.
if not exist "%LOG%" goto nolog
echo  (20 baris terakhir)
echo ------------------------------------------
powershell -Command "Get-Content '%LOG%' -Tail 20"
echo ------------------------------------------
echo  File: %LOG%
echo.
pause
goto menu

:nolog
echo  Belum ada log!
pause
goto menu

:searchlog
cls
echo ==========================================
echo         SEARCH LOG
echo ==========================================
echo.
if not exist "%LOG%" goto nolog
set /p "search=Cari kata: "
if "%search%"=="" goto menu
echo.
echo  Hasil untuk "%search%":
echo ------------------------------------------
findstr /i "%search%" "%LOG%"
echo ------------------------------------------
echo.
pause
goto menu

:settings
cls
echo ==========================================
echo          SETTINGS
echo ==========================================
echo  [1] Toggle Context (Now: %CONTEXT_ON%)
echo  [2] Edit Style
echo  [0] Kembali
echo ==========================================
echo.
set /p "s=Pilih: "
if "%s%"=="0" goto menu
if "%s%"=="1" goto stog1
if "%s%"=="2" goto sedit
goto settings

:stog1
if "%CONTEXT_ON%"=="1" goto stogoff
set "CONTEXT_ON=1"
echo  Context ON
timeout /t 1 >nul
goto settings

:stogoff
set "CONTEXT_ON=0"
echo  Context OFF
timeout /t 1 >nul
goto settings

:sedit
echo.
echo  Style saat ini:
echo  %STYLE%
echo.
set /p "STYLE=Style baru: "
echo  Updated!
timeout /t 1 >nul
goto settings

:stats
cls
echo ==========================================
echo          STATISTICS
echo ==========================================
echo.
echo  Session Start : %SESSION_START%
echo  Current Time  : %date% %time%
echo  Total Messages: %COUNT%
echo  Log File      : %LOG%
echo  Persona       : %PERSONA%
echo  Model         : %MODEL%
echo  Context       : %CONTEXT_ON%
echo.
pause
goto menu

:exportlog
cls
echo ==========================================
echo         EXPORT LOG
echo ==========================================
echo.
if not exist "%LOG%" goto nolog
if not exist "chat_logs" mkdir "chat_logs"
set "EXPORT=chat_logs\export_%PERSONA%_%random%.txt"
copy "%LOG%" "%EXPORT%" >nul
echo  Exported ke: %EXPORT%
echo.
pause
goto menu

:clearlog
cls
echo ==========================================
echo         CLEAR LOG
echo ==========================================
echo.
echo  Yakin hapus log? (y/n)
echo.
set /p "confirm=Pilih: "
if /i not "%confirm%"=="y" goto menu
if exist "%LOG%" del "%LOG%"
set "COUNT=0"
set "CTX1="
set "CTX2="
set "CTX3="
echo  Log dihapus!
timeout /t 2 >nul
goto menu

:done
cls
echo.
echo ==========================================
echo           SESSION END
echo ==========================================
echo  Total pesan  : %COUNT%
echo  Log tersimpan: %LOG%
echo  Persona      : %PERSONA%
echo  Model        : %MODEL%
echo ==========================================
echo.
timeout /t 3 /nobreak >nul
exit
