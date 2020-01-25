public class CryptoHandler {

    public void doEncrypt(Secure_Note__c[] noteRecords){
        Secret__c[] secrets = [Select key__c from Secret__c where Name=:UserInfo.getUserId() limit 1];
        if(secrets.size()==0){
            secrets.add(new Secret__c(Name=UserInfo.getUserId(),Key__c=EncodingUtil.base64Encode(Crypto.generateAesKey(128))));
            insert secrets;
        }
        Blob key = EncodingUtil.base64Decode(secrets[0].key__c);
        for(Secure_Note__c nt: noteRecords){
            nt.Body__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(nt.body__c)));
        }
    }
    
    public String doDecrypt(Id secureNoteId){
        Secret__c[] secrets = [Select key__c from Secret__c where Name=:UserInfo.getUserId() limit 1];
        Blob key = EncodingUtil.base64Decode(secrets[0].key__c);
        Secure_Note__c noteRecord = [Select Body__c from Secure_Note__c where Id=:secureNoteId];
        Blob encryptedData = EncodingUtil.base64Decode(noteRecord.Body__c);
		return Crypto.decryptWithManagedIV('AES128', key, encryptedData).toString();
        
    }
}