import std.stdio;
import vibe.http.fileserver;
import vibe.http.server;
import vibe.http.router;
import settings;

/**
	Enable exception throwing on major errors on Linux.
*/
void enableExceptions() {
	import etc.linux.memoryerror;
	static if (is(typeof(registerMemoryErrorHandler)))
		registerMemoryErrorHandler();
}

void main()
{
	version(linux) {
		enableExceptions();
	}

	auto settings = new HTTPServerSettings;
	settings.port = 80;
	settings.bindAddresses = ["::1", "127.0.0.1"];

	auto router = new URLRouter;
	router.get("/", ((req, res){ res.redirect("/index.html"); }));

	router.get("*", serveStaticFiles("/var/www/"));

	listenHTTP(settings, router);
}
