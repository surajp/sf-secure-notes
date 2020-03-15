trigger NoteTrigger on Secure_Note__c (before insert,after insert,before update,after update) {

	if(Trigger.isBefore){
		new CryptoHandler().doEncrypt(Trigger.new);
	}else if(Trigger.isAfter){
		new SecureNotesValidator().doValidate(Trigger.new);
	}
}
