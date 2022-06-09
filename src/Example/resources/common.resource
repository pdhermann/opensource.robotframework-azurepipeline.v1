*** Settings ***
Documentation       A resource file with core reusable keywords and variables.

Library             DateTime
Library             String
Library             RPA.Robocorp.Vault
Library             pabot.PabotLib
Library             ../libraries/UrlKeywords.py
Variables           ../variables/translation.py


*** Keywords ***
Generate UUID String
    [Documentation]    Generates and returns an UUID
    ${uuid}    Evaluate    str(uuid.uuid4())    modules=uuid
    RETURN    ${uuid}
