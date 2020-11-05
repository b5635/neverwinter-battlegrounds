del /f server\config\common.env
del /f server\modules\PvP.mod
del /f server\settings.tml
rmdir /s /q  server\override
copy modules\PvP.mod server\modules\PvP.mod
copy config\common.env server\config\common.env
copy settings.tml server\settings.tml
copy docker-compose.yml server\docker-compose.yml
robocopy override server\override
PAUSE