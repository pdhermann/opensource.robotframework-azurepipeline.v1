*** Settings ***
Documentation       A resource file with core reusable keywords and variables.
...
...                 The system specific keywords created here form our own
...                 domain specific language.

Library             RPA.Browser.Playwright    enable_presenter_mode=False
Variables           ../variables/example.py
Resource            common_email.resource


*** Variables ***
${MY_ACCOUNT_URL}       ${EMPTY}
${LOGIN_URL}            ${EMPTY}


*** Keywords ***
Prepare Variables
    [Documentation]    This keyword prepares the global variables for the webshop tests
    ${t}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    Set Global Variable    ${TIMESTAMP}    ${t}
    IF    ${DEBUG_MODE}
        Set Log Level    INFO
    ELSE
        Set Log Level    NONE
    END
    ${test_user_1_secrets}=    Get Secret    testUser1${BROWSER}${COUNTRY}
    Set Global Variable    ${TESTUSER_1}    ${test_user_1_secrets}
    Set Log Level    INFO
    ${stage_info_secret}=    Get Secret    stageInfo
    Set Global Variable    ${STAGE_INFO}    ${stage_info_secret}
    Set Global Variable    ${STAGE}    ${stage_info_secret}[stage]

On Failure
    [Documentation]    Actions to perfom on Failures
    Set Log Level    INFO
    IF    ${DEBUG_MODE}
        # Stay attention. This prints sensitive data, e.g. passwords, into the console and reports.
        &{vars}=    Get Variables
        Log Many    &{vars}
    END
    Take Screenshot    ${SCREENSHOT_FILE_NAME}    fullPage=True    fileType=jpeg    quality=50
    Sleep    0.3 s

Open Browser Parallel
    [Documentation]    Opens the browser with new context and settings from config file.
    Prepare Variables
    Register Keyword To Run On Failure    On Failure
    # Create a new playwright Browser with specified options.
    New Browser    ${BROWSER_LIB}    headless=${BROWSER_LIB_HEADLESS}
    # Create a new BrowserContext with specified options.
    ${MAIN_CONTEXT}=    New Context
    ...    viewport={'width': ${BROWSER_WIDTH}, 'height': ${BROWSER_HEIGHT}}
    ...    locale=${BROWSER_LIB_LOCALE}
    ...    isMobile=${BROWSER_LIB_IS_MOBILE}
    ...    userAgent=${USER_AGENT}
    # ...    recordVideo={'dir':'videos', 'size':{'width':${BROWSER_WIDTH}, 'height':${BROWSER_HEIGHT}}}
    # Open a new Page.
    New Page    ${LOGIN_URL}
    Set Global Variable    ${WINDOW_SIZE}    ${BROWSER_WIDTH}x${BROWSER_HEIGHT}
    ${iws}=    Get Viewport Size
    Set Global Variable    ${INNER_WINDOW_SIZE}    ${iws}
    Log Many
    ...    ${BROWSER_LIB}
    ...    ${WINDOW_SIZE}
    ...    ${INNER_WINDOW_SIZE}
    ...    ${BROWSER_LIB_LOCALE}
    ...    ${BROWSER_LIB_IS_MOBILE}
    Setup Browser And Open Login Page

Setup Browser And Open Login Page
    [Documentation]    Browser Setup and open login page
    Acquire Lock    LoginLock
    ${pageresult}=    Run Keyword And Ignore Error    Login Page Should Be Open
    IF    ${DEBUG_MODE}    Log    ${pageresult}
    Login Page Should Be Open
    Release Lock    LoginLock

Login Page Should Be Open
    [Documentation]    Checks if the current page is the login page.
    Wait Until Keyword Succeeds    6 x    5 seconds    Get Title    ==    ${TITLE}

Close Context And Browser
    [Documentation]    Closes the current browser
    Close Context    CURRENT    CURRENT
