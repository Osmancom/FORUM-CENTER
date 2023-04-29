import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import CONTACT_NAME_FIELD from '@salesforce/schema/Contact.Name';
import CONTACT_MAILING_STREET_FIELD from '@salesforce/schema/Contact.MailingStreet';
import CONTACT_MAILING_CITY_FIELD from '@salesforce/schema/Contact.MailingCity';
import CONTACT_MAILING_STATE_FIELD from '@salesforce/schema/Contact.MailingState';
import CONTACT_MAILING_COUNTRY_FIELD from '@salesforce/schema/Contact.MailingCountry';
import CONTACT_MAILING_POSTALCODE_FIELD from '@salesforce/schema/Contact.MailingPostalCode';

const FIELDS = [
    'Account.Name',
    'Account.BillingStreet',
    'Account.BillingCity',
    'Account.BillingState',
    'Account.BillingCountry',
    'Account.BillingPostalCode'
];

export default class ExampleLWC extends LightningElement {
    @api recordId;
    account;
    contacts;
    error;
    wiredAccountResult;
    wiredContactsResult;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount(result) {
        this.wiredAccountResult = result;
        if (result.data) {
            this.account = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.account = undefined;
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: [CONTACT_NAME_FIELD, CONTACT_MAILING_STREET_FIELD, CONTACT_MAILING_CITY_FIELD, CONTACT_MAILING_STATE_FIELD, CONTACT_MAILING_COUNTRY_FIELD, CONTACT_MAILING_POSTALCODE_FIELD] })
    wiredContacts(result) {
        this.wiredContactsResult = result;
        if (result.data) {
            const contacts = [];
            result.data.fields.Name.value.forEach((contactName, index) => {
                contacts.push({
                    Id: result.data.id,
                    Name: contactName,
                    MailingStreet: getFieldValue(result.data, CONTACT_MAILING_STREET_FIELD.fieldApiName)[index],
                    MailingCity: getFieldValue(result.data, CONTACT_MAILING_CITY_FIELD.fieldApiName)[index],
                    MailingState: getFieldValue(result.data, CONTACT_MAILING_STATE_FIELD.fieldApiName)[index],
                    MailingCountry: getFieldValue(result.data, CONTACT_MAILING_COUNTRY_FIELD.fieldApiName)[index],
                    MailingPostalCode: getFieldValue(result.data, CONTACT_MAILING_POSTALCODE_FIELD.fieldApiName)[index]
                });
            });
            this.contacts = contacts;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.contacts = undefined;
        }
    }

    handleAccountClick(event) {
        const recordId = this.account.Id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    handleContactClick(event) {
        const recordId = event.currentTarget.dataset.recordId;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
}