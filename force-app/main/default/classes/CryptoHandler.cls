/**
 * @description Main class for encyption and decryption
 * @author Suraj
 * @date Feb, 2020
 *
 */
public class CryptoHandler {
    
    public KeyManagement keyManager;
    
    public CryptoHandler(){
        keyManager = new KeyManagement();
    }
    
    public CryptoHandler(KeyManagement keyManager){
        this.keyManager = keyManager;
    }

    /***
     * @description performs encryption of Secure_Note__c using user's private key.
     * @param Secure_Note__c[] noteRecords - List of secure_note__c records to be encrypted
     */
    public void doEncrypt(Secure_Note__c[] noteRecords){
       	Blob key = keyManager.createAndGetKeyForCurrentUser();
        for(Secure_Note__c nt: noteRecords){
            nt.Body__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(nt.body__c)));
        }
    }

    
    /**
     * @description decrypt a single secure_note__c record, using the owner's private key
     * @param id of the secure_note__c record to be decrypted.
     */
    public String doDecrypt(Id secureNoteId){
        Secure_Note__c noteRecord = [Select Body__c from Secure_Note__c where Id=:secureNoteId];
        Blob key = keyManager.getKeyForCurrentUser();
        Blob encryptedData = EncodingUtil.base64Decode(noteRecord.Body__c);
				return Crypto.decryptWithManagedIV('AES128', key, encryptedData).toString();
    }
}
