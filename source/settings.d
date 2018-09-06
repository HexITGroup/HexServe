module settings;
import asdf;

public ServerSettings deserializeFile(string fileName) {
	import std.file;
	return readText(fileName).deserialize!ServerSettings;
}

struct ServerSettings {
	Redirect[string] redirects;
	string[] urlBindings;
}

struct Redirect {
	string[] origins;
}
