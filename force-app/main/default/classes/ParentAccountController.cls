public with sharing class ParentAccountController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getChildAccounts(Id parentId) {
        return [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE ParentId = :parentId with SECURITY_ENFORCED];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accountId) {
        return [SELECT Id, Name, MailingStreet, MailingCity, MailingState, MailingPostalCode FROM Contact WHERE AccountId = :accountId with SECURITY_ENFORCED];
    }
}