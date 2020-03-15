@isTest
public class TestCryptoHandler {
	
    @isTest
    public static void testCrypto(){
        Secure_Note__c nt = new Secure_Note__c(Name='New Note',Body__c='Hello, World');
        insert nt;
        nt = [Select Body__c from Secure_Note__c where Id=:nt.Id];
        System.assertNotEquals(null,nt.Body__c);
    }
    
    @isTest
    public static void testDecrypt(){
        Secure_Note__c nt = new Secure_Note__c(Name='New Note',Body__c='Hello, World');
        insert nt;
        String decryptedValue = DecryptionController.decrypt(nt.Id);
        system.assertEquals('Hello, World', decryptedValue);
        // delete [Select Id from Secret__c];
        Secret__c sec = [Select Id from Secret__c];
        sec.Key__c='corruptedvalue';
        update sec;
        boolean hasException = false;
        try{
            decryptedValue = DecryptionController.decrypt(nt.Id);
        }catch(AuraHandledException ex){
            hasException = true;
        }
        system.assert(hasException);
    }

		public void testPreventOwnerChange(){
        Secure_Note__c nt = new Secure_Note__c(Name='New Note',Body__c='Hello, World');
        insert nt;
				boolean dmlfailed = false;
				try{
					nt.OwnerId=[Select Id from User where Profile.Name='System Administrator' and IsActive=true limit 1].Id;	
					update nt;
				}catch(DMLException ex){
					dmlfailed = true;
				}
				system.assert(dmlfailed);
		}
}
