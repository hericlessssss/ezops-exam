@echo off
setlocal

:: Get the first argument
set COMMAND=%1

:: If no command provided, show help
if "%COMMAND%"=="" goto help

:: Match commands
if "%COMMAND%"=="up" (
    docker-compose up -d
) else if "%COMMAND%"=="down" (
    docker-compose down
) else if "%COMMAND%"=="build" (
    docker-compose up --build -d
) else if "%COMMAND%"=="logs" (
    docker-compose logs -f
) else if "%COMMAND%"=="test" (
    docker-compose run --rm backend npm test
) else if "%COMMAND%"=="scan" (
    echo Scanning ports...
    echo Frontend: http://localhost:8080
    echo Backend: http://localhost:5000
) else (
    echo Unknown command: %COMMAND%
    goto help
)

goto :eof

:help
echo Usage: make [command]
echo.
echo Commands:
echo   up      Run containers in background
echo   down    Stop and remove containers
echo   build   Build and run containers
echo   logs    Follow container logs
echo   test    Run backend tests in container
echo   scan    Check local service ports
goto :eof
