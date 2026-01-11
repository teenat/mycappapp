namespace anubhav.commons;
using { Currency } from '@sap/cds/common';


//Domain fixed values
type Gender: String(1) enum{
    male = 'M';
    female = 'F';
    undisclosed = 'U';
};

//When we put Amount in SAP, we always provide a reference field - CurrencyCode
//When we put Quantity in SAP, we always provide a - UoM 
//@ - annotation
type AmountT: Decimal(10,2) @(
    Semantics.amount.currecyCode : 'CURRENCY_code',
    sap.unit: 'CURRENCY_code'
);


//aspects - structure like a APPEND structure in ABAP
aspect Amount : {
    CURRENCY: Currency  @title : '{i18n>XLBL_CURR}';
    GROSS_AMOUNT: AmountT @title : '{i18n>XLBL_GROSS}';
    NET_AMOUNT: AmountT @title : '{i18n>XLBL_NET}';
    TAX_AMOUNT: AmountT @title : '{i18n>XLBL_TAX}';
}


//reusable types: which we can refer in all table
//like a data element in ABAP
type Guid: String(32);


//Adding regular expression - regex - https://www.w3schools.com/jsref/jsref_obj_regexp.asp
//Add phone number and email type with Validation
type PhoneNumber: String(30) @assert.format : '/^(?:\(\d{3}\)|\d{3})[-.\s]?\d{3}[-.\s]?\d{4}$/';
type EmailAddress: String(255); // @assert.format : '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';