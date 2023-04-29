public class OppTriggerHandler {
    public static void createContractForWonOpp(List<Opportunity> oppList,Map<Id,Opportunity> oldOppMap){
      List<Contract> newContracts = new List<Contract>();
    for (Opportunity opp : oppList) {
        if (opp.StageName == 'Closed Won' && opp.isWon != oldOppMap.get(opp.Id).isWon ) {//oldOppMap.get(opp.Id).StageName!='Closed Won'
            Contract newContract = new Contract();
            newContract.AccountId = opp.AccountId;
            newContract.StartDate = opp.CloseDate;
            newContract.Asset_Manager__c=opp.Asset_Manager__c;
            newContract.Leasing_Admin__c=opp.Leasing_Admin__c;
            newContract.Leasing_Analyst__c=opp.Leasing_Analyst__c;
            newContract.Space__c=opp.Space__c;
            newContract.Center__c=opp.Center__c;
            newContract.Status='Draft';
            newContract.Type__c=opp.Contract_Type__c;
                newContracts.add(newContract);
        }
    }
    insert newContracts;     
        
    }

        }