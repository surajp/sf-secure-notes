import { LightningElement,track,wire,api } from 'lwc';
import decryptNote from '@salesforce/apex/DecryptionController.decrypt';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import SECURE_NOTE from '@salesforce/schema/Secure_Note__c';

export default class DecryptNote extends LightningElement {
	@track isDecrypted = false;
	@track decryptedNote = '';
	@api recordId;
	@api additionalFields='';
	@track _fields = ['Name','CreatedDate','LastModifiedDate'];
	@track _nonNullFields=[];
	@track customFieldsArray=[];
	@track objectName = SECURE_NOTE;

	/***
		concat static fields, user supplied fields and relationship fields that are not blank
 	 ***/
	get allFields(){
		let _allFields = this._fields;
		if(this.additionalFields.trim())
			_allFields = _allFields.concat(this.additionalFields.split(','));
		if(this._nonNullFields && this._nonNullFields.length>0)
			_allFields = _allFields.concat(this._nonNullFields);
		return _allFields;
	}

	/***
		get all subscriber added lookup fields
 	 ****/
	@wire(getObjectInfo,{objectApiName:SECURE_NOTE})
	getNoteObjectInfo({error,data}){
		if(!error && data){
			this.customFieldsArray = Object.values(data.fields).filter(field=>(field.apiName.endsWith('__c') && field.reference===true)).map(field=>SECURE_NOTE+field.apiName);
		}else if(error)
			this.dispatchEvent(new ShowToastEvent({title:'An error occurred',message:err.body.message,variant:'error'}));
	}

	/**
 	 * get all subscriber added lookup fields that are not null
 	 * **/
	@wire(getRecord,{recordId:'$recordId',fields:'$customFieldsArray'})
	getNoteRecord({error,data}){
		if(!error && data){
			console.log(Object.entries(data.fields));
			this._nonNullFields = Object.entries(data.fields).filter(entry=>entry[1].value).map(entry=>entry[0]);
		}else if(error)
			this.dispatchEvent(new ShowToastEvent({title:'An error occurred',message:err.body.message,variant:'error'}));
	}

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
