public class AccountRelastionShipMapHelper {
    public static void beforeInsert(List<Accounts_Relationship_Map__c> armcList){
        List<Id> toAccountList = new List<Id>();
        List<Id> fromAccountList = new List<Id>();
        for (Accounts_Relationship_Map__c armObj : armcList){
            if (armObj.From_Account__c != null && armObj.Account__c != null && armObj.From_Account__c != armObj.Account__c){
                toAccountList.add(armObj.Account__c);
                fromAccountList.add(armObj.From_Account__c);
            }
        }
        if (!fromAccountList.isEmpty()){
              Map<id,List<Contact>> custMap = new Map<Id,List<Contact>>();
			  for(Account ac:[SELECT id,name,(SELECT LastName FROM Contacts) FROM Account WHERE id =:fromAccountList] ){
                	List<Contact> listCont = ac.Contacts;
                	custMap.put(ac.id, listCont);
            }
        	 List<Contact> toInsert = new List<Contact>(); 
        	 for (Integer i=0;i<fromAccountList.size();i++){
            		List<Contact> toUpdate = custMap.get(fromAccountList[i]);
            		id toacc = toAccountList[i];
            		for(Contact conObj : toUpdate){
                		Contact copiedContact = conObj.Clone(true,true,false,false);
                		copiedContact.Id = null;
                        copiedContact.Parent_Contact__c = conObj.Id;
                        copiedContact.AccountId = toacc;
                        toInsert.add(copiedContact);
            }
        }
        if(!toInsert.isEmpty()){
            Insert toInsert;
        }
        }
  	}
    public static void afterDelete(List<Accounts_Relationship_Map__c> armcList){
        Map<Id,Id> newMap = new Map<Id,Id>();
        for (Accounts_Relationship_Map__c armObj : armcList){
            if(armObj.Account__c != null){
                newMap.put(armObj.Account__c,armObj.From_Account__c);
            }
        
     	}
        if(!newMap.isEmpty()){
            Map<Id,Account> accMap = new Map<Id,Account>([Select Id, Name From Account Where id=:newMap.values()]);
            List<Contact> conList = new List<Contact>();
            if(!newMap.isEmpty()){
                List<Account> accList = [SELECT Id, (SELECT Clone_Account_Name__c,Parent_Contact__c From Contacts Where AccountId =:newMap.KeySet()) From Account Where Id =:newMap.keySet()];
                List<Contact> delContactList = new List<Contact>();
                for (Account accObj : accList){
                    for (Contact conObj : accObj.Contacts){
                        if (conObj.Parent_Contact__c != null && conObj.Clone_Account_Name__c == accMap.get(newMap.get(accObj.Id)).Name){
                            delContactList.add(conObj);
                        }
                    }
                }
                if(!delContactList.isEmpty()){
                    delete delContactList;}
            }
        }
        
   }
}