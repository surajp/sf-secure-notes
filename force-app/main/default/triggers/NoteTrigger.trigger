trigger NoteTrigger on Secure_Note__c (before insert) {
	new CryptoHandler().doEncrypt(Trigger.new);
}
