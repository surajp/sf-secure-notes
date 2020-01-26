public class DecryptionController {
	
    @AuraEnabled
    public static String decrypt(Id recordId){
        try{
        	return new CryptoHandler().doDecrypt(recordId);
        }
        catch(InsecureContextException ex){
            throw new AuraHandledException(ex.getMessage());
        }
        catch(Exception ex){
            throw new AuraHandledException('Decryption failed due to corrupt data/metadata');
        }
    }
}