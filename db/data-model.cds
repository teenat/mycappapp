namespace anubhav.db;

using { cuid, Currency } from '@sap/cds/common';
using { anubhav.commons } from './commons';

context master
{

    entity businesspartner
    {
        key NODE_KEY : commons.Guid @title : '{i18n>XLBL_BPKEY}';
        BP_ROLE : String(2);
        EMAIL_ADDRESS : String(105);
        PHONE_NUMBER : String(32);
        FAX_NUMBER : String(32);
        WEB_ADDRESS : String(44);
        //the actual column name in DB CURRENT_PK
        ADDRESS_GUID : Association to one address @title : '{i18n>XLBL_ADDRKEY}';
        BP_ID : String(32) @title : '{i18n>XLBL_BPID}';
        COMPANY_NAME : String(250) @title : '{i18n>XLBL_COMPANY}';
    }

    entity ravi{
        key teja: commons.Guid;
        hobby: String(32);
        city: String(40);
    }

    entity address
    {
        key NODE_KEY : commons.Guid  @title : '{i18n>XLBL_ADDRKEY}';
        CITY : String(44);
        POSTAL_CODE : String(8);
        STREET : String(44);
        BUILDING : String(128);
        COUNTRY : String(44)  @title : '{i18n>XLBL_COUNTRY}';
        ADDRESS_TYPE : String(44);
        VAL_START_DATE : Date;
        VAL_END_DATE : Date;
        LATITUDE : Decimal;
        LONGITUDE : Decimal;
        //not mandatory
        businesspartner : Association to one businesspartner on businesspartner.ADDRESS_GUID = $self;
    }

    entity product{
        key NODE_KEY: commons.Guid  @title : '{i18n>XLBL_PRODKEY}';
        PRODUCT_ID: String(28)  @title : '{i18n>XLBL_PRODID}';
        TYPE_CODE: String(2);
        CATEGORY: String(32)  @title : '{i18n>XLBL_PRODCAT}';
        DESCRIPTION: localized String(255)  @title : '{i18n>XLBL_PRODDESC}';
        SUPPLIER_GUID: Association to businesspartner  @title : '{i18n>XLBL_BPKEY}';
        TAX_TARIF_CODE: Integer;
        MEASURE_UNIT: String(2);
        WEIGHT_MEASURE: Decimal(5,2);
        WEIGHT_UNIT: String(2);
        CURRENCY_CODE: String(4);
        PRICE: Decimal(15,2);
        WIDTH: Decimal(15,2);
        DEPTH: Decimal(15,2);
        HEIGHT: Decimal(15,2);
        DIM_UNIT: String(2);
    }

    entity employees : cuid
    {
        nameFirst : String(40);
        nameMiddle : String(40);
        nameLast : String(40);
        nameInitials : String(40);
        sex : commons.Gender;
        language : String(1);
        phoneNumber : commons.PhoneNumber;
        email : commons.EmailAddress;
        loginName: String(32);
        currency : Currency;
        salaryAmount : commons.AmountT;
        accountNumber : String(16);
        bankId : String(40);
        bankName : String(64);
    }
}

context transaction {
    
    entity purchaseorder: commons.Amount, cuid{
        //key NODE_KEY: commons.Guid;
        PO_ID: String(40)  @title : '{i18n>XLBL_POID}';
        PARTNER_GUID: Association to one master.businesspartner  @title : '{i18n>XLBL_BPKEY}';
        LIFECYCLE_STATUS: String(1)  @title : '{i18n>LIFESTATUS}';
        OVERALL_STATUS: String(1) @title : '{i18n>OVERALLSTATUS}';
        Items: Composition of many poitems on Items.PARENT_KEY = $self;
    };

    entity poitems : commons.Amount, cuid {
        //key NODE_KEY: commons.Guid;
        PARENT_KEY : Association to one purchaseorder  @title : '{i18n>XCOL_POKEY}';
        PO_ITEM_POS: Integer  @title : '{i18n>ITEMPOS}';
        PRODUCT_GUID: Association to one master.product  @title : '{i18n>XLBL_PRODKEY}';
    }

}