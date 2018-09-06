import std.stdio;
import vibe.http.fileserver;
import vibe.http.server;
import vibe.http.router;
import settings;

/**
	Enable exception throwing on major memory failures on Linux.
*/
void enableMemExceptions() {
	import etc.linux.memoryerror;
	static if (is(typeof(registerMemoryErrorHandler)))
		registerMemoryErrorHandler();
}

void main()
{
	version(linux) {
		enableMemExceptions();
	}

	try {
		ServerSettings settings = deserializeFile("/var/hexconf.json");

		
		// Create router
		auto router = new URLRouter;
		router.get("/", ((req, res){ res.redirect("/index.html"); }));

		// create routings for the redirects.
		foreach(k, r; settings.redirects) {
			foreach(rd; r.origins) {
				router.get(rd, ((req, res){ res.redirect(k); }));
			}
		}
		router.get("*", serveStaticFiles("/var/www/"));

		// Set up HTTP settings and start HTTP server.
		auto httpsettings = new HTTPServerSettings;
		httpsettings.port = settings.port;
		httpsettings.bindAddresses = settings.urlBindings;
		listenHTTP(httpsettings, router);
	} catch (Exception ex) {
		writeln(ex.message);
	}
}
