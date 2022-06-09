*** Settings ***
Documentation       A resource file with reusable keywords and variables for email communication.

Library             ImapLibrary2
Library             RPA.Email.ImapSmtp
Resource            common_api.resource
Variables           ../variables/common_email.py


*** Keywords ***
Prepare Email
    [Documentation]    Preparation for email keywords
    IF    ${DEBUG_MODE}
        Set Log Level    INFO
    ELSE
        Set Log Level    NONE
    END
    ${email_secrets}=    Get Secret    testEmail${COUNTRY}
    Set Global Variable    ${EMAIL_USERNAME}    ${email_secrets}[username]
    Set Global Variable    ${EMAIL_PASSWORD}    ${email_secrets}[password]
    Set Log Level    INFO

Get Link From Email
    [Documentation]    Requests the first link in an email.
    ...
    ...    Link is sent to the customers email.
    ...
    ...    The recieved link is extracted from the recieved email.
    ...
    ...    Returns the extracted link.
    [Arguments]    ${email_subject}    ${email_recipient}    ${email_sender}    ${email_folder}
    ${encoded_subject}=    Decode String    ${email_subject}
    Prepare Email
    Open Mailbox
    ...    host=outlook.office365.com
    ...    user=${EMAIL_USERNAME}
    ...    password=${EMAIL_PASSWORD}
    ...    port=993
    ${email_index}=    Wait For Email
    ...    sender=${email_sender}
    ...    subject=${encoded_subject}
    ...    timeout=180
    ...    recipient=${email_recipient}
    ...    status=UNSEEN
    ...    folder=${email_folder}
    ${email_links}=    Get Links From Email    ${email_index}
    IF    ${DEBUG_MODE}    Log    ${email_links}
    Delete Email    ${email_index}
    ${reset_link_with_html_codes}=    Get From List    ${email_links}    0
    ${link}=    Decode Url    ${reset_link_with_html_codes}
    RETURN    ${link}

Get Emails
    [Documentation]    Requests emails by given arguments.
    ...
    ...    Link is sent to the customers email.
    ...
    ...    The recieved link is extracted from the recieved email.
    ...
    ...    Returns the extracted link.
    [Arguments]    ${email_subject}    ${email_recipient}    ${email_sender}    ${email_folder}
    ${encoded_subject}=    Decode String    ${email_subject}
    Prepare Email
    IF    ${DEBUG_MODE}
        Set Log Level    INFO
    ELSE
        Set Log Level    NONE
    END
    Authorize Imap
    ...    account=${EMAIL_USERNAME}
    ...    password=${EMAIL_PASSWORD}
    ...    imap_server=outlook.office365.com
    ...    imap_port=993
    Set Log Level    INFO
    @{new_emails}=    Wait For Message
    ...    criterion=TO "${email_recipient}" FROM "${email_sender}" UNSEEN SUBJECT "${encoded_subject}"
    ...    timeout=30
    ...    interval=10
    IF    ${DEBUG_MODE}
        FOR    ${email}    IN    @{new_emails}
            Log    ${email}
            Log    ${email}[Subject]
            Log    ${email}[From]
            Log    ${email}[Date]
            Log    ${email}[Delivered-To]
            Log    ${email}[Received]
            Log    ${email}[Has-Attachments]
            Log    ${email}[Body]
            Log    ${email}[Authentication-Results]
            Log    ${email}[Message-ID]
            Log    ${email}[MIME-Version]
        END
    END

    ${length}=    Get Length    @{new_emails}
    IF    ${length} > 0    RETURN    @{new_emails}

    @{emails}=    List Messages
    ...    criterion=TO "${email_recipient}" FROM "${email_sender}" UNSEEN SUBJECT "${encoded_subject}"
    ...    source_folder=${email_folder}
    IF    ${DEBUG_MODE}
        FOR    ${email}    IN    @{emails}
            Log    ${email}
            Log    ${email}[Subject]
            Log    ${email}[From]
            Log    ${email}[Date]
            Log    ${email}[Delivered-To]
            Log    ${email}[Received]
            Log    ${email}[Has-Attachments]
            Log    ${email}[Body]
            Log    ${email}[Authentication-Results]
            Log    ${email}[Message-ID]
            Log    ${email}[MIME-Version]
        END
    END
    RETURN    @{emails}
