public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getChildAccounts(Id parentId) {
        List<Account> childAccounts = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                                       (SELECT Id, FirstName, LastName, Email FROM Contacts)
                                       FROM Account WHERE ParentId = :parentId];
        return childAccounts;
    }
}
