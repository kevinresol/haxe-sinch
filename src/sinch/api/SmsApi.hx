package sinch.api;

import tink.url.*;

using tink.CoreApi;

interface SmsApi {
	@:post('/sms/$number')
	@:consumes('application/json')
	public function send(number:String, body:{
		?from:Option<String>,
		message:String,
	}):{messageId:Int};
	
	@:get('/message/status/$messageId')
	@:consumes('application/json')
	public function check(messageId:String):{status:String};
}