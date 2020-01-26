public class CryptoHandler {
    
    public KeyManagement keyManager;
    
    public CryptoHandler(){
        keyManager = new KeyManagement();
    }
    
    public CryptoHandler(KeyManagement keyManager){
        this.keyManager = keyManager;
    }

    public void doEncrypt(Secure_Note__c[] noteRecords){
       	Blob key = keyManager.createAndGetKeyForCurrentUser();
        for(Secure_Note__c nt: noteRecords){
            nt.Body__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(nt.body__c)));
        }
    }
    
    public String doDecrypt(Id secureNoteId){
        Blob key = keyManager.getKeyForCurrentUser();
        Secure_Note__c noteRecord = [Select Body__c from Secure_Note__c where Id=:secureNoteId];
        Blob encryptedData = EncodingUtil.base64Decode(noteRecord.Body__c);
		return Crypto.decryptWithManagedIV('AES128', key, encryptedData).toString();
        
    }
}