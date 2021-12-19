*** Settings ***
Library  Test.py
 
*** Test Cases ***
test_library
    ${test}  test_method  3  5
    log to console  ${test}