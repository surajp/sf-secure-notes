import { LightningElement,track,api } from 'lwc';
import decryptNote from '@salesforce/apex/DecryptionController.decrypt';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class DecryptNote extends LightningElement {
	@track isDecrypted = false;
	@track decryptedNote = '';
	@api recordId;

	decrypt(){
		decryptNote({recordId:this.recordId})
			.then(note=>{
				this.decryptedNote=note;
				this.isDecrypted = true;
			})
			.catch(err=>{
				this.decryptedNote='';
				this.isDecrypted=false;
				this.dispatchEvent(new ShowToastEvent({title:'Decryption Failed',message:err.body.message,variant:'error'}));
			});
	}
}
