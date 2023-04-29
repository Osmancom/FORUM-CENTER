import { LightningElement,wire,api } from 'lwc';
import getChildContact from '@salesforce/apex/ParentAccountController.getContacts';
import {NavigationMixin} from 'lightning/navigation';
export default class ChildAccRelatedContact extends NavigationMixin(LightningElement) {

@api accId;


@wire (getChildContact, {
    childAccId:'$accId'

}) relatedContacts;

navigateToViewContactPage(event) {
        
    var recId = event.target.name;
    
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recId,
            objectApiName: 'Contact',
            actionName: 'view'
        },
    });
    }

}