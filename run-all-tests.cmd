@echo off
setlocal EnableDelayedExpansion
echo "Install the latest versions by running these commands in a console window, from the root of this repository."
echo "pip install -r requirements.txt --user"
echo "npm install chromedriver edgedriver geckodriver playwright"
echo "npx playwright install-deps"
echo "For the next two commands you have to switch the folder in the command line."
echo "This folder depends on your installation. You can find it at log output from the pip install command."
echo "It Looks like c:\users\YOUR.USERNAME\appdata\roaming\python\python39..."
echo "cd %APPDATA%\python\python39"
echo "rfbrowser clean-node"
echo "rfbrowser init"

for /f "delims=" %%i in ('dir /a:d /b src') do (
    set count=0
    set argfiles=
    set directory=%%i
    @REM echo !directory!
    for /f "delims=" %%a in ('dir /b "src\!directory!\configs"') do (
        set filename=%%a
        @REM echo !filename!
        if  "!filename:~0,1!"=="_" (
            echo "!filename! starts with _ and is skipped."
        ) else (
            set /a count=count+1
            @REM echo !count!
            set "argfiles=!argfiles!--argumentfile!count! src\!directory!\configs\!filename! "
            @REM echo !argfiles!
        )
    )
    if "!argfiles!"=="" (
        echo "!directory!: Nothing to do!"
    ) else (
        echo "pabot --pabotlib --processes 2 !argfiles!--report NONE --outputdir \"output\!directory!\" --logtitle \"Example !directory! log\" -x xunitreport.xml --exclude not-ready --exclude no-pipeline --exclude need-assistant --runemptysuite \"src\!directory!\tests\""
        pabot --pabotlib --processes 2 !argfiles!--report NONE --outputdir "output\!directory!" --logtitle "Example !directory! log" -x xunitreport.xml --exclude not-ready --exclude no-pipeline --exclude need-assistant --runemptysuite "src\!directory!\tests"
    )
    if not exist "output\!directory!\" mkdir "output\!directory!"
    echo "robocop --output \"output\!directory!\robocop.log\" --configure return_status:quality_gate:E=0:W=0:I=-1 \"src\!directory!\""
    robocop --output "output\!directory!\robocop.log" --configure return_status:quality_gate:E=0:W=0:I=-1 "src\!directory!"
)
