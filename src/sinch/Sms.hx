package sinch;

import sinch.api.*;
import tink.http.Client;
import tink.http.Response;
import tink.http.Request;
import tink.http.Header;
import tink.web.proxy.Remote;
import tink.url.Host;
import haxe.crypto.Base64;
import haxe.io.Bytes;

using tink.io.Source;
using tink.CoreApi;

private typedef Impl = Remote<SmsApi>;

@:forward
abstract Sms(Impl) {
	public inline function new(appKey, appSecret, client:Client) {
		client = new AuthedClient(appKey, appSecret, client);
		var endpoint = new RemoteEndpoint(new Host('messagingapi.sinch.com', 443)).sub({path: ['v1']});
		this = new Impl(client, endpoint);
	}
}

class AuthedClient extends AppendHeaderClient {
	public function new(appKey, appSecret, client) {
		var auth = Base64.encode(Bytes.ofString(appKey + ':' + appSecret)).toString();
		super(AUTHORIZATION, 'Basic $auth', client);
	}
}

class AppendHeaderClient implements ClientObject {
	var field:HeaderField;
	var client:Client;
	
	public function new(name, value, client) {
		this.field = new HeaderField(name, value);
		this.client = client;
	}
		
	public function request(req:OutgoingRequest):Promise<IncomingResponse> {
		trace(req.header.url.path);
		return req.body.all()
			.next(function(chunk) {
				return client.request(new OutgoingRequest(req.header.concat([
					field,
					new HeaderField(CONTENT_LENGTH, Std.string(chunk.length)),
				]), req.body));
			});
	}
}