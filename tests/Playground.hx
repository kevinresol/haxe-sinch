package;

import tink.http.clients.*;
import sinch.Sms;
import tink.url.*;

class Playground {
	static function main() {
		var sms = new Sms('appkey', 'appsecret', new SecureNodeClient());
		
		sms.send('+85298765432', {message: 'Hello, Sinch!'}).handle(function(o) {
			trace(o);
			Sys.exit(0);
		});
	}
}