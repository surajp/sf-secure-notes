public class KeyManagement {
    
    private boolean isContextValid(){
        AuthSession[] sessions = [Select Id from AuthSession where UsersId=:UserInfo.getUserId() and SessionType='SubstituteUser'];
        return sessions.size()==0;
    }
	
    public Blob createAndGetKeyForCurrentUser(){
        if(!isContextValid()){
            throw new InsecureContextException('There is someone else logged in as the current user');
        }
        Secret__c[] secrets = [Select key__c from Secret__c where Name=:UserInfo.getUserId() limit 1];
        if(secrets.size()==0){
            secrets.add(new Secret__c(Name=UserInfo.getUserId(),Key__c=EncodingUtil.base64Encode(Crypto.generateAesKey(128))));
            insert secrets;
        }
        return EncodingUtil.base64Decode(secrets[0].key__c);
    }
    
    public Blob getKeyForCurrentUser(){
        if(!isContextValid()){
            throw new InsecureContextException('There is someone else logged in as the current user');
        }
        Secret__c[] secrets = [Select key__c from Secret__c where Name=:UserInfo.getUserId() limit 1];
        return EncodingUtil.base64Decode(secrets[0].key__c);
    }
}