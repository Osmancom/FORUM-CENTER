import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PARENT_ACCOUNT_FIELD from '@salesforce/schema/Account.Id';
import CHILD_ACCOUNTS_FIELD from '@salesforce/schema/Account.ChildAccounts';
import CHILD_ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import CHILD_ACCOUNT_BILLING_STREET_FIELD from '@salesforce/schema/Account.BillingStreet';
import CHILD_ACCOUNT_BILLING_CITY_FIELD from '@salesforce/schema/Account.BillingCity';
import CHILD_ACCOUNT_BILLING_STATE_FIELD from '@salesforce/schema/Account.BillingState';
import CHILD_ACCOUNT_BILLING_POSTAL_CODE_FIELD from '@salesforce/schema/Account.BillingPostalCode';
import CHILD_ACCOUNT_CONTACTS_FIELD from '@salesforce/schema/Account.Contacts';

export default class ChildAccountsWithContacts extends LightningElement {
    @api recordId;
    parentAccount;
    childAccounts;
    error;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [PARENT_ACCOUNT_FIELD, CHILD_ACCOUNTS_FIELD]
    })
    wiredParentAccount({ error, data }) {
        if (data) {
            this.parentAccount = data;
            this.childAccounts = getFieldValue(data, CHILD_ACCOUNTS_FIELD);
        } else if (error) {
            console.error(error);
            this.error = error;
        }
    }

    get childAccountsArray() {
        if (this.childAccounts) {
            return Object.values(this.childAccounts);
        }
        return [];
    }

    get hasContactsField() {
        return CHILD_ACCOUNT_CONTACTS_FIELD in this.childAccountsArray[0].fields;
    }
}
