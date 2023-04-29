public with sharing class GetAccAndConRecord {
    public static List<Account> getChildAccounts(String parentAccId) {
                             
        return [SELECT Id, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode FROM Account WHERE ParentId = :parentAccId with SECURITY_ENFORCED];
    }

    public static List<Contact> getRelatedContacts(String childAccId) {
        return [SELECT Id, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet FROM Contact WHERE AccountId = :childAccId with SECURITY_ENFORCED];
             
         
    }
}