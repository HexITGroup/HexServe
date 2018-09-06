module settings;
import asdf;

ServerSettings deserializeFile(string fileName) {
	import std.file;
	if (!exists(fileName)) throw new Exception("No configuration file found in /var/hexconf.json!");
	return readText(fileName).deserialize!ServerSettings;
}

struct ServerSettings {
	ushort port;
	string[] urlBindings;
	Redirect[string] redirects;
}

struct Redirect {
	string[] origins;
}
