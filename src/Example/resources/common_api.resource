*** Settings ***
Documentation       A common resource file for apis.

Library             Collections
Library             RequestsLibrary
Library             RPA.JSON
Variables           ../variables/common.py
Resource            common.resource


*** Keywords ***
Send A Get Request
    [Documentation]
    ...    Sends a GET request to the given endpoint: ${endpoint} of the given service: ${base_url}.
    ...
    ...    Expecting a response with the given status: ${expected_status} (default:200).
    ...
    ...    Returns the response.
    [Arguments]
    ...    ${endpoint}
    ...    ${base_url}
    ...    ${data}=${EMPTY}
    ...    ${json}=${EMPTY}
    ...    ${params}=${EMPTY}
    ...    ${headers}=${EMPTY}
    ...    ${files}=${EMPTY}
    ...    ${allow_redirects}=${EMPTY}
    ...    ${timeout}=${EMPTY}
    ...    ${expected_status}=200
    ${kwargs}    Create Arguments Dictionary    data=${data}    json=${json}
    ...    params=${params}    headers=${headers}    files=${files}
    ...    allow_redirects=${allow_redirects}    timeout=${timeout}
    ${response}    GET
    ...    ${base_url}${endpoint}
    ...    expected_status=${expected_status}
    ...    &{kwargs}
    RETURN    ${response}

Send A Post Request
    [Documentation]
    ...    Sends a POST request to the given endpoint: ${endpoint} of the given service: ${base_url}.
    ...
    ...    Expecting a response with the given status: ${expected_status} (default:200).
    ...
    ...    Returns the response.
    [Arguments]
    ...    ${endpoint}
    ...    ${base_url}
    ...    ${data}=${EMPTY}
    ...    ${json}=${EMPTY}
    ...    ${params}=${EMPTY}
    ...    ${headers}=${EMPTY}
    ...    ${files}=${EMPTY}
    ...    ${allow_redirects}=${EMPTY}
    ...    ${timeout}=${EMPTY}
    ...    ${expected_status}=200
    ${kwargs}    Create Arguments Dictionary    data=${data}    json=${json}
    ...    params=${params}    headers=${headers}    files=${files}
    ...    allow_redirects=${allow_redirects}    timeout=${timeout}
    ${response}    POST
    ...    ${base_url}${endpoint}
    ...    expected_status=${expected_status}
    ...    &{kwargs}
    RETURN    ${response}

Send A Patch Request
    [Documentation]
    ...    Sends a PATCH request to the given endpoint: ${endpoint} of the given service: ${base_url}.
    ...
    ...    Expecting a response with the given status: ${expected_status} (default:200).
    ...
    ...    Returns the response.
    [Arguments]
    ...    ${endpoint}
    ...    ${base_url}
    ...    ${data}=${EMPTY}
    ...    ${json}=${EMPTY}
    ...    ${params}=${EMPTY}
    ...    ${headers}=${EMPTY}
    ...    ${files}=${EMPTY}
    ...    ${allow_redirects}=${EMPTY}
    ...    ${timeout}=${EMPTY}
    ...    ${expected_status}=200
    ${kwargs}    Create Arguments Dictionary    data=${data}    json=${json}
    ...    params=${params}    headers=${headers}    files=${files}
    ...    allow_redirects=${allow_redirects}    timeout=${timeout}
    ${response}    PATCH
    ...    ${base_url}${endpoint}
    ...    expected_status=${expected_status}
    ...    &{kwargs}
    RETURN    ${response}

Send A Delete Request
    [Documentation]
    ...    Sends a DELETE request to the given endpoint: ${endpoint} of the given service: ${base_url}.
    ...
    ...    Expecting a response with the given status: ${expected_status} (default:200).
    ...
    ...    Returns the response.
    [Arguments]
    ...    ${endpoint}
    ...    ${base_url}
    ...    ${data}=${EMPTY}
    ...    ${json}=${EMPTY}
    ...    ${params}=${EMPTY}
    ...    ${headers}=${EMPTY}
    ...    ${files}=${EMPTY}
    ...    ${allow_redirects}=${EMPTY}
    ...    ${timeout}=${EMPTY}
    ...    ${expected_status}=200
    ${kwargs}    Create Arguments Dictionary    data=${data}    json=${json}
    ...    params=${params}    headers=${headers}    files=${files}
    ...    allow_redirects=${allow_redirects}    timeout=${timeout}
    ${response}    DELETE
    ...    ${base_url}${endpoint}
    ...    expected_status=${expected_status}
    ...    &{kwargs}
    RETURN    ${response}

Create Arguments Dictionary
    [Documentation]    Creates and returns a dictionary with the available request arguments.
    [Arguments]
    ...    ${data}=${EMPTY}
    ...    ${json}=${EMPTY}
    ...    ${params}=${EMPTY}
    ...    ${headers}=${EMPTY}
    ...    ${files}=${EMPTY}
    ...    ${allow_redirects}=${EMPTY}
    ...    ${timeout}=${EMPTY}
    ${kwargs}    Create Dictionary
    ${hasValue}    Run Keyword and return status    Should not be empty    ${headers}
    IF    ${hasValue}    Set To Dictionary    ${kwargs}    headers=${headers}
    ${hasValue}    Run Keyword and return status    Should not be empty    ${timeout}
    IF    ${hasValue}    Set To Dictionary    ${kwargs}    timeout=${timeout}
    ${hasValue}    Run Keyword and return status    Should not be empty    ${data}
    IF    ${hasValue}    Set To Dictionary    ${kwargs}    data=${data}
    ${hasValue}    Run Keyword and return status    Should not be empty    ${params}
    IF    ${hasValue}    Set To Dictionary    ${kwargs}    params=${params}
    ${hasValue}    Run Keyword and return status    Should not be empty    ${files}
    IF    ${hasValue}    Set To Dictionary    ${kwargs}    files=${files}
    ${hasValue}    Run Keyword and return status    Should not be empty    ${allow_redirects}
    IF    ${hasValue}
        Set To Dictionary    ${kwargs}    allow_redirects=${allow_redirects}
    END
    ${hasValue}    Run Keyword and return status    Should not be empty    ${json}
    IF    ${hasValue}    Set To Dictionary    ${kwargs}    json=${json}
    RETURN    ${kwargs}
