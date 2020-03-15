public with sharing class SecureNotesValidator {

    public void doValidate(Secure_Note__c[] noteRecords) {
			if(Trigger.isExecuting){
				preventOwnerChange(noteRecords);
			}
    }

		private void preventOwnerChange(Secure_Note__c[] noteRecords){
			for(Secure_Note__c note: noteRecords){
				if(note.OwnerId != note.CreatedById){
					note.addError('You may not change the owner of a secure note');
				}
			}
		}
}
