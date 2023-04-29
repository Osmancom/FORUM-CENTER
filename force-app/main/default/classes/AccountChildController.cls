public with sharing class AccountChildController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getChildAccounts(Id accountId) {
        return [SELECT Id, Name, AccountNumber FROM Account WHERE ParentId = :accountId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getChildContacts(Id accountId) {
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :accountId];
    }

}
