@e2e_flow @auto_hold_fund
Feature: Chargeback Auto Hold Fund E2E
    This tests are designed in case the merchant's balance is sufficient

    Note: The reconcile between charge and chargeback are tested when chargeback is created.

    #******************* START FLOW OF MERCHANT YIELD - MERCHANT always LOSE *******************

    @precondition

    Scenario: A card charge is created and can be used for chargeback (T4 Status = PENDING/SUCCEEDED???)
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

    #******************* START FLOW OF CHARGEBACK_CANCELLED *******************

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
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to CHARGEBACK_CANCELLED
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "CANCELLED" and "deduction_status" should be "RELEASED"
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "RELEASED"

    @critical
    @dev @live
    @automated
    Scenario: Create a chargeback with skip_auto_hold_fund = false successfully
        Given The "Create batch chargeback" request was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"
        And A list of chargebacks with "remark" is "NOT_FOUND" should be showned correctly

    #******************* START FLOW OF DEFAULT_EVIDENCE_SENT_TO_BANK -> MERCHANT_LOST_CHARGEBACK *******************
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
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to DEFAULT_EVIDENCE_SENT_TO_BANK
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "EVIDENCE_SENT" and "deduction_status" should be "NONE"
        And The "actions" should be next "DEFAULT_EVIDENCE_SENT_TO_BANK" actions list
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_LOST_CHARGEBACK as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_LOST_CHARGEBACK"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "LOST" and "deduction_status" should be "PENDING_DEDUCTION"
        And The "lost_decision" should be "BANK_DECISION"
        And The "actions" should be ["DEDUCT_FROM_MERCHANT","COVERED_BY_XENDIT","DEDUCT_FROM_MERCHANT_PARTIAL"]

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to one of the actions["DEDUCT_FROM_MERCHANT"]
        Given The "Create chargeback action" request was created with action is one of next "MERCHANT_YEILD" action
        When the request is processed
        Then the response status should be "200 - OK"
        And The "deduction_status" should be "DEDUCTED"
        And The "actions" should be an empty array

    #******************* START FLOW OF DEFAULT_EVIDENCE_SENT_TO_BANK -> MERCHANT_WON_CHARGEBACK *******************
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
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to DEFAULT_EVIDENCE_SENT_TO_BANK
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "EVIDENCE_SENT" and "deduction_status" should be "NONE"
        And The "actions" should be next "DEFAULT_EVIDENCE_SENT_TO_BANK" actions list
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_LOST_CHARGEBACK as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_WON_CHARGEBACK"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "WON" and "deduction_status" should be "RELEASED"
        And The "actions" should be an empty array

    #******************* START FLOW OF DEFAULT_EVIDENCE_SENT_TO_BANK -> MERCHANT_WON_CHARGEBACK *******************
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
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to DEFAULT_EVIDENCE_SENT_TO_BANK
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "EVIDENCE_SENT" and "deduction_status" should be "NONE"
        And The "actions" should be next "DEFAULT_EVIDENCE_SENT_TO_BANK" actions list
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_LOST_CHARGEBACK as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_WON_CHARGEBACK"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "WON" and "deduction_status" should be "RELEASED"
        And The "actions" should be an empty array

    #******************* START FLOW OF DEFAULT_EVIDENCE_SENT_TO_BANK -> MERCHANT_LOST_WITH_ARBITRATION -> MERCHANT_SENT_ARBITRATION_EVIDENCE -> ARBITRATION_EVIDENCE_SENT_TO_BANK -> MERCHANT_WON_ARBITRATION*******************
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
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to DEFAULT_EVIDENCE_SENT_TO_BANK
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "EVIDENCE_SENT" and "deduction_status" should be "HELD"
        And The "actions" should be next "DEFAULT_EVIDENCE_SENT_TO_BANK" actions list
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_LOST_WITH_ARBITRATION as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_LOST_WITH_ARBITRATION"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "NONE" and "deduction_status" should be "HELD"
        And The arbitration_status should be "BANK_RAISED"
        And The "actions" should be ["MERCHANT_SENT_ARBITRATION_EVIDENCE","MERCHANT_REJECTED_ARBITRATION"]

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_SENT_ARBITRATION_EVIDENCE as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_SENT_ARBITRATION_EVIDENCE"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "EVIDENCE_RECEIVED" and "deduction_status" should be "HELD"
        And The arbitration_status should be "MERCHANT_ACCEPTED"
        And The "actions" should be ["ARBITRATION_EVIDENCE_SENT_TO_BANK"]

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to ARBITRATION_EVIDENCE_SENT_TO_BANK as next step
        Given The "Create chargeback action" request was created with action "ARBITRATION_EVIDENCE_SENT_TO_BANK"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "EVIDENCE_SENT" and "deduction_status" should be "HELD"
        And The arbitration_status should be "MERCHANT_ACCEPTED"
        And The "actions" should be ["MERCHANT_WON_ARBITRATION","MERCHANT_LOST_ARBITRATION"]

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_WON_ARBITRATION as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_WON_ARBITRATION"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "WON" and "deduction_status" should be "RELEASED"
        And The "actions" should be an empty array

    #******************* START FLOW OF DEFAULT_EVIDENCE_SENT_TO_BANK -> MERCHANT_LOST_WITH_ARBITRATION -> MERCHANT_REJECTED_ARBITRATION*******************
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
    Scenario: Get a chargeback via it's id and receive the correct data
        Given The "Get batch chargeback" request for previous chargeback was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to DEFAULT_EVIDENCE_SENT_TO_BANK
        Given The "Create chargeback action" request for previous chargeback was created with action is "MERCHANT_YIELD"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "EVIDENCE_SENT" and "deduction_status" should be "HELD"
        And The "actions" should be next "DEFAULT_EVIDENCE_SENT_TO_BANK" actions list
        And Other chargeback infomation should be received correctly

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_LOST_WITH_ARBITRATION as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_LOST_WITH_ARBITRATION"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "NONE" and "deduction_status" should be "HELD"
        And The arbitration_status should be "BANK_RAISED"
        And The "actions" should be ["MERCHANT_SENT_ARBITRATION_EVIDENCE","MERCHANT_REJECTED_ARBITRATION"]

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to MERCHANT_REJECTED_ARBITRATION as next step
        Given The "Create chargeback action" request was created with action "MERCHANT_REJECTED_ARBITRATION"
        When the request is processed
        Then the response status should be "200 - OK"
        And The chargeback "status" should be "LOST" and "deduction_status" should be "PENDING_DEDUCTION"
        And The "actions" should be ["DEDUCT_FROM_MERCHANT","COVERED_BY_XENDIT","DEDUCT_FROM_MERCHANT_PARTIAL"]

    @critical
    @dev @live
    @automated
    Scenario: lost_reason is updated to one the actions ["DEDUCT_FROM_MERCHANT"]
        Given The "Create chargeback action" request was created with action is one of next "MERCHANT_YEILD" action
        When the request is processed
        Then the response status should be "200 - OK"
        And The "deduction_status" should be "DEDUCTED"
        And The "actions" should be an empty array

    @critical
    @dev @live
    @automated
    Scenario: Able to delete a chargeback
        Given The "Delete batch chargeback" request was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A list of chargebacks with "remark" is "FOUND" should be showned correctly

    @critical
    @dev @live
    @automated
    Scenario: No chargeback found after it was being deleted
        Given The "Get list of chargebacks" request was created
        When the request is processed
        Then the response status should be "200 - OK"
        And An error message for "CHARGEBACK_NOT_FOUND" should be received