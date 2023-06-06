@e2e_flow @auto_hold_fund
Feature: Chargeback Reconciliation
    This tests are designed in case the merchant's balance is sufficient

    Note: The reconcile between charge and chargeback are tested when chargeback is created.

    @precondition
    Scenario: A card charge is created and can't be used for chargeback (T4 Status = FAILED/REFUNDED - Need to confirm again this case with Ricky)
        Given A "Card Chage" was created

    @critical
    @dev @live
    @automated
    Scenario: Create a chargeback failed when charge can't be used for chargeback
        Given The "Create batch chargeback" request was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"
        And A list of chargebacks with "remark" is "NOT_FOUND" should be showned correctly

    @precondition
    Scenario: A card charge is created
        Given A "Card Chage" was created

    @critical
    @dev @live
    @automated
    Scenario: Create a chargeback is created successfully
        Given The "Create batch chargeback" request for the card charge above was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"
        And A list of chargebacks with "remark" is "FOUND" should be showned correctly

    @critical
    @dev @live
    @automated
    Scenario: Can't create a DUPLICATED chargeback
        Given The "Create batch chargeback" request for the card charge above was created
        When the request is processed
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"
        And A list of chargebacks with "remark" is "NOT_FOUND" should be showned correctly

    @precondition
    Scenario: A card charge is created with currency = IDR
        Given A "Card Chage" was created

    @critical
    @dev @live
    @automated
    Scenario: Create a chargeback failed with currency PHP/USD when charge currency is IDR
        Given The "Create batch chargeback" request for the card charge above was created
        When the value of "requestBody.chargebacks[0].currency" is string("USD/PHP")
        Then the response status should be "200 - OK"
        And A "deduction_status" should be "HELD"
        And A list of chargebacks with "remark" is "NOT_FOUND" should be showned correctly

    @critical
    @dev @live
    @automated
    Scenario: Create a chargeback FAIELD with chargeback info not in card's history
        Given The "Create batch chargeback" request was created
        When the value of "requestBody.chargebacks[0].approval_code" is not existing
        And the value of "requestBody.chargebacks[0].merchant_reference_code" is not existing
        And the request is processed
        Then the response status should be "200 - OK"
        And A list of chargebacks with "remark" is "NOT_FOUND" should be showned correctly

