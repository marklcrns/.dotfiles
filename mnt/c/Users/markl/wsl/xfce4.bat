:: Consolestate https://www.robvanderwoude.com/battech_hideconsole.php
C:\wsl\ConsoleState /Hide
:: DEPRECATED: X410 or GWSL runs on startup
:: start /B x410.exe /desktop /public
:: DEPRECATED: Latest Windows 11 build includes pulseaudio in WSLg
:: start "" /B C:\wsl\pulse\pulseaudio.exe -F C:\wsl\pulse\config.pa
ubuntu.exe run "if [ -z \"$(pidof xfce4-session)\" ]; then HOST_IP=$(host `hostname` | grep 192. | tail -1 | awk '{ print $NF }' | tr -d '\r'); export DISPLAY=$HOST_IP:0.0; export PULSE_SERVER=tcp:$HOST_IP; xfce4-session; pkill '(gpg|ssh)-agent'; taskkill.exe /IM x410.exe; taskkill.exe /IM pulseaudio.exe /F; fi;"