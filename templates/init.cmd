@echo off
setlocal

doskey disable_init=reg delete "HKCU\Software\Microsoft\Command Processor" /v AutoRun
doskey enable_init=reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%"USERPROFILE"%\init.cmd" /f
doskey refresh_env=%USERPROFILE%\shell\refresh_env.cmd

endlocal