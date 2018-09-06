import std.stdio;
import vibe.http.fileserver;
import vibe.http.server;
import vibe.http.router;

void main()
{
	auto settings = new HTTPServerSettings;
	settings.port = 80;
	settings.bindAddresses = ["::1", "127.0.0.1"];

	auto router = new URLRouter;
	router.get("/", (scope HTTPServerRequest req, scope HTTPServerResponse res) => { res.redirect("/index.html"); });

	router.get("*", serverStaticFiles("/var/www/"));

	listenHTTP(settings, router);
}
