using { anubhav.db.master, anubhav.db.transaction } from '../db/data-model';
using { anubhav.myviews } from '../db/CDSViews';


service CatalogService @(path: 'CatalogService', requires: 'authenticated-user') {

    ///Entityset which offers all the GET, PUT, POST, DELETE 
    //@readonly
    // @Capabilities: {
    //     Updatable: false,
    //     Deletable: false
    // }
    entity EmployeeSet 
        @(restrict :[
            { grant: ['READ'], to : 'Display', where: 'bankName = $user.BankName' },
            { grant: ['WRITE'], to : 'Edit' }
        ])
     as projection on master.employees;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet 
        @(restrict :[
            { grant: ['READ'], to : 'Display', where: 'COUNTRY = $user.Country' }
        ])
    as projection on master.address;
    entity POs @(
        odata.draft.enabled: true,
        Common.DefaultValuesFunction: 'getOrderDefault'
    ) as projection on transaction.purchaseorder{
        *,
        case OVERALL_STATUS
          when 'A' then 'Approved'
          when 'D' then 'Delivered'
          when 'X' then 'Rejected'
          when 'N' then 'New'
          else 'Pending'
                 end as OverallStatusText: String(10),
       case OVERALL_STATUS
          when 'A' then 3
          when 'D' then 3
          when 'X' then 1
          when 'N' then 2
          else 2
                 end as IconColor: Integer
    }
    actions{
        action boost() returns POs;
        action setDelivered() returns POs;
    };
    entity POItems as projection on transaction.poitems;
    
    //Expose the cds entity 
    entity ProductSet as projection on myviews.CDSViews.ProductView;
    //a non instance bound function --- if you want multiple => array of
    function getMostExpensiveOrder() returns  POs;
    function getOrderDefault() returns POs;
}
