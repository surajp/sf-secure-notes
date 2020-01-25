trigger NoteTrigger on cypto__Secure_Note__c (before insert) {
	new CryptoHandler().doEncrypt(Trigger.new);
}