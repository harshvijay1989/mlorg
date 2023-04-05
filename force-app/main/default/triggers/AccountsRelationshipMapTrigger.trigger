trigger AccountsRelationshipMapTrigger on Accounts_Relationship_Map__c (before insert, after delete) {
    if (trigger.isBefore && trigger.isInsert){
        AccountRelastionShipMapHelper.beforeInsert(trigger.new);
    }else if(trigger.isAfter && trigger.isDelete){
        System.debug('Hello');
        AccountRelastionShipMapHelper.afterDelete(trigger.old);
    }
}