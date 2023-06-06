Feature: Chargeback Reconciliation
    This is for Risk Automation to reconcile chargeback with Card Team

    Background: A card charge is created before each chargeback test
        Given A card charge is created before each chargeback test

    @critical
    @dev @live
    @automated
    Scenario: Create a batch chargeback successfully when card currency is same as bank_currency
        Given The "Create batch chargeback" request was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A list of chargebacks with "remark" is "FOUND" should be showned correctly

    @critical
    @dev @live
    @automated
    Scenario: Create a batch chargeback failed when the chargeback is duplicated
        Given A card charge and it's chargeback was created
        When the value of "requestBody.chargebacks[0].approval_code" is same as previous chargeback's
        When the value of "requestBody.chargebacks[0].merchant_reference_code" is same as previous chargeback's
        And the request is processed
        Then the response status should be "200 - OK"
        And A list of chargebacks with "remark" is "DUPLICATED" should be showned correctly

    @critical
    @dev @live
    @automated
    Scenario: Create a batch chargeback failed when the chargeback is not existing
        Given The "Create batch chargeback" request was created
        When the value of "requestBody.chargebacks[0].approval_code" is not existing
        And the value of "requestBody.chargebacks[0].merchant_reference_code" is not existing
        And the request is processed
        Then the response status should be "200 - OK"
        And A list of chargebacks with "remark" is "NOT_FOUND" should be showned correctly

