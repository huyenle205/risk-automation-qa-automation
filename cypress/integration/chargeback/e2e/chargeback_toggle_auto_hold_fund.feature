@e2e_flow @auto_hold_fund
Feature: Chargeback Toggle Auto Hold/ Non Auto Hold Fund E2E
    This tests are designed in case the merchant's balance is sufficient

    #Note: All test cases in a block as below are depends on each other.

    #******************* Toggle auto hold fund when skip_auto_hold_fund is set up at first *******************

    @precondition

    Scenario: A card charge is created and can be used for chargeback (T4 Status = PENDING/SUCCEEDED???)
        Given A "Card Chage" was created

    @critical
    @dev @live
    @automated
    Scenario: Create a chargeback with skip_auto_hold_fund = true successfully
        Given The "Create batch chargeback" request was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "NONE"
        And A list of chargebacks with "remark" is "FOUND" should be showned correctly

    @critical
    @dev @live
    @automated
    Scenario: Auto hold fund is toggled
        Given The "Toggle auto hold fund" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_YIELD
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "LOST" and "deduction_status" should be "PENDING_DEDUCTION"
        And The "actions" should be next "MERCHANT_YIELD" actions list
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to one of the actions ["DEDUCT_FROM_MERCHANT"]
        Given The "Create chargeback action" request was created with action is one of next "MERCHANT_YEILD" action
        When the request is processed
        Then the response status should be "200 - OK"
        And The "deduction_status" should be "DEDUCTED"
        And The "actions" should be an empty array

    #******************* Toggle non auto hold fund when auto_hold_fund is set up at first *******************

    @precondition
    Scenario: A card charge is created
        Given A "Card Chage" was created

    @critical
    @dev @live
    @automated
    Scenario: Create a chargeback with skip_auto_hold_fund = false successfully
        Given The "Create batch chargeback" request was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"
        And A list of chargebacks with "remark" is "FOUND" should be showned correctly

    @critical
    @dev @live
    @automated
    Scenario: Non auto hold fund is toggled
        Given The "Toggle non auto hold fund" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "NONE"

    @critical
    @dev @live
    @automated
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "NONE"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_YIELD
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "LOST" and "deduction_status" should be "PENDING_DEDUCTION"
        And The "actions" should be next "MERCHANT_YIELD" actions list
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to one of the actions ["DEDUCT_FROM_MERCHANT","COVERED_BY_XENDIT","DEDUCT_FROM_MERCHANT_PARTIAL"]
        Given The "Create chargeback action" request was created with action is one of next "MERCHANT_YEILD" action
        When the request is processed
        Then the response status should be "200 - OK"
        And The "deduction_status" should be "DEDUCTED" or "PARTIAL_DEDUCTED"
        And The "actions" should be an empty array
