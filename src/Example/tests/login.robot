*** Settings ***
Documentation       A test suite with tests for the user authentification functionality.
...
...                 This test-suite has a workflow that is created using keywords in
...                 the imported resource files.
Metadata            Version    1.0
Metadata            More Info    For more information about *Robot Framework* see http://robotframework.org with *Browser Library* see https://robotframework-browser.org/
Metadata            Executed with    *${BROWSER_LIB}*. Note: For executed at url, take a look at the test/task-documentation.
Metadata            Pabot data    _Index: *${PABOTQUEUEINDEX}*_, Pool-ID: *${PABOTEXECUTIONPOOLID}*, _Number of processes: *${PABOTNUMBEROFPROCESSES}*_

Library             ImapLibrary2
Resource            ../resources/example.resource

Suite Setup         Run Setup Only Once    Run Keywords    Acquire Suite Lock    Open Browser Parallel
Suite Teardown      Run Keywords    Close Context And Browser    Release Locks

Force Tags          login    scheduled    scheduled-daily


*** Tasks ***
Login User
    [Documentation]    This test logs in a user.
    ...
    ...    It opens the browser and navigate to Login page.
    ...
    ...    Accept the cookie settings.
    ...
    ...    Enter the user data and submit them.
    ...
    ...    Checks if the user is succcessfully logged in.
    ...
    ...    Closes the browser.
    ...
    ...    Executet at *${LOGIN_URL}*.
    Enter User Data
    Assert Logged In


*** Keywords ***
Enter User Data
    [Documentation]    Insert the user data and click on the Anmelden button
    [Arguments]    ${email}=${TESTUSER_2}[username]    ${pwd}=${TESTUSER_2}[password]    ${birthdate}=${TESTUSER_2}[birthdate]
    IF    ${DEBUG_MODE}
        Set Log Level    INFO
    ELSE
        Set Log Level    NONE
    END
    Sleep    1 s
    IF    '${USER_AGENT}' != ''
        Click    xpath=//button[text()="${LOGIN_BUTTON_TEXT}"]
    END
    Type Text    xpath=//*[@id="loginForm"]/div[2]/div/input    ${email}
    Get Text    xpath=//*[@id="loginForm"]/div[2]/div/input    ==    ${email}
    Type Secret    xpath=//*[@id="loginForm"]/div[3]/div/input    $pwd
    Set Log Level    INFO
    Take Screenshot    ${SCREENSHOT_FILE_NAME}    fullPage=false    fileType=jpeg    quality=20
    Wait Until Keyword Succeeds    3 x    10 seconds    Click    xpath=//*[@id="loginForm"]/button
    ${login_has_failed}=    Run Keyword And Return Status
    ...    Get Element States
    ...    //*[@id="LazyRoute:/:language?/login"]//div[@class="alert alert--error"]
    ...    contains
    ...    visible
    IF    ${login_has_failed}
        On Failure
        Fail    Login failed!
    END

Assert Logged In
    [Documentation]    Assertion if the user has successfully logged in
    ${on_my_account}=    Run Keyword And Return Status    Get Url    ==    ${MY_ACCOUNT_URL}
    IF    not ${on_my_account}
        Wait For Navigation    ${MY_ACCOUNT_URL}    15 seconds
    END
    Wait Until Keyword Succeeds    3 x    10 seconds    Get Title    ==    ${MY_ACCOUNT_TITLE}
    Get Title    ==    ${MY_ACCOUNT_TITLE}
