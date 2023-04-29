import { api, LightningElement, wire } from 'lwc';
import getChildAccount from '@salesforce/apex/GetAccAndConRecord.getChildAccounts';
import { NavigationMixin } from 'lightning/navigation';
export default class ChildAccountRecords extends NavigationMixin (LightningElement) {
    @api recordId;
    @wire(getChildAccount,{
        parentAccId:'$recordId'
    }) childAccounts;
    navigateToViewAccountPage(event) {
        // Navigate to the Account home page
        var recId=event.target.name;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                recordId: recId,
                objectApiName: 'Account',
                actionName: 'view'
            },
        });
    }
}
