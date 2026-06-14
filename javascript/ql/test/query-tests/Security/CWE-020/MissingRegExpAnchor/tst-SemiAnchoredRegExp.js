(function coreRegExp() {
	/^a|/;
	/^a|b/; // no dot, not flagged
	/a|^b/;
	/^a|^b/;
	/^a|b|c/; // no dot, not flagged
	/a|^b|c/;
	/a|b|^c/;
	/^a|^b|c/;

	/(^a)|b/;
	/^a|(b)/; // no dot, not flagged
	/^a|(^b)/;
	/^(a)|(b)/; // no dot, not flagged


	/a|b$/; // no dot, not flagged
	/a$|b/;
	/a$|b$/;
	/a|b|c$/; // no dot, not flagged
	/a|b$|c/;
	/a$|b|c/;
	/a|b$|c$/;

	/a|(b$)/;
	/(a)|b$/; // no dot, not flagged
	/(a$)|b$/;
	/(a)|(b)$/; // no dot, not flagged

	/^good.com|better.com/; // $ Alert
	/^good\.com|better\.com/; // $ Alert
	/^good\\.com|better\\.com/; // $ Alert
	/^good\\\.com|better\\\.com/; // $ Alert
	/^good\\\\.com|better\\\\.com/; // $ Alert

	/^foo|bar|baz$/; // no dot, not flagged
	/^foo|%/;
});

(function coreString() {
	new RegExp("^a|");
	new RegExp("^a|b"); // no dot, not flagged
	new RegExp("a|^b");
	new RegExp("^a|^b");
	new RegExp("^a|b|c"); // no dot, not flagged
	new RegExp("a|^b|c");
	new RegExp("a|b|^c");
	new RegExp("^a|^b|c");

	new RegExp("(^a)|b");
	new RegExp("^a|(b)"); // no dot, not flagged
	new RegExp("^a|(^b)");
	new RegExp("^(a)|(b)"); // no dot, not flagged


	new RegExp("a|b$"); // no dot, not flagged
	new RegExp("a$|b");
	new RegExp("a$|b$");
	new RegExp("a|b|c$"); // no dot, not flagged
	new RegExp("a|b$|c");
	new RegExp("a$|b|c");
	new RegExp("a|b$|c$");

	new RegExp("a|(b$)");
	new RegExp("(a)|b$"); // no dot, not flagged
	new RegExp("(a$)|b$");
	new RegExp("(a)|(b)$"); // no dot, not flagged

	new RegExp('^good.com|better.com'); // $ Alert
	new RegExp('^good\.com|better\.com'); // $ Alert
	new RegExp('^good\\.com|better\\.com'); // $ Alert
	new RegExp('^good\\\.com|better\\\.com'); // $ Alert
	new RegExp('^good\\\\.com|better\\\\.com'); // $ Alert
});

(function realWorld() {
	// real-world examples that have been anonymized a bit

	/*
	 * NOT OK: flagged (patterns containing dots are plausibly hostname-related)
	 */
	/(\.xxx)|(\.yyy)|(\.zzz)$/; // $ Alert
	/(^left|right|center)\sbottom$/; // not flagged at the moment due to interior anchors
	/\.xxx|\.yyy|\.zzz$/ig; // $ Alert
	/\.xxx|\.yyy|zzz$/; // $ Alert
	/^([A-Z]|xxx[XY]$)/; // not flagged at the moment due to interior anchors
	/^(xxx yyy zzz)|(xxx yyy)/i; // no dot, not flagged
	/^(xxx yyy zzz)|(xxx yyy)|(1st( xxx)? yyy)|xxx|1st/i; // no dot, not flagged
	/^(xxx:)|(yyy:)|(zzz:)/; // no dot, not flagged
	/^(xxx?:)|(yyy:zzz\/)/; // no dot, not flagged
	/^@media|@page/; // no dot, not flagged
	/^\s*(xxx?|yyy|zzz):|xxx:yyy\//; // no dot, not flagged
	/^click|mouse|touch/; // no dot, not flagged
	/^http:\/\/good\.com|http:\/\/better\.com/; // $ Alert
	/^https?:\/\/good\.com|https?:\/\/better\.com/; // $ Alert
	/^mouse|touch|click|contextmenu|drop|dragover|dragend/; // no dot, not flagged
	/^xxx:|yyy:/i; // no dot, not flagged
	/_xxx|_yyy|_zzz$/; // no dot, not flagged
	/em|%$/; // not flagged at the moment due to the anchor not being for letters

	/*
	 * MAYBE OK due to apparent complexity: not flagged
	 */
	/(?:^[#?]?|&)([^=&]+)(?:=([^&]*))?/g;
	/(^\s*|;\s*)\*.*;/m;
	/(^\s*|\[)(?:xxx|yyy_(?:xxx|yyy)|xxx|yyy(?:xxx|yyy)?|xxx|yyy)\b/m;
	/\s\S| \t|\t |\s$/;
	/\{[^}{]*\{|\}[^}{]*\}|\{[^}]*$/g;
	/^((\+|\-)\s*\d\d\d\d)|((\+|\-)\d\d\:?\d\d)/;
	/^(\/\/)|([a-z]+:(\/\/)?)/;
	/^[=?!#%@$]|!(?=[:}])/;
	/^[\[\]!:]|[<>]/;
	/^for\b|\b(?:xxx|yyy)\b/i;
	/^if\b|\b(?:xxx|yyy|zzz)\b/i;

	/*
	 * OK: not flagged
	 */
	/$^|only-match/g;
	/(#.+)|#$/;
	/(NaN| {2}|^$)/;
	/[^\n]*(?:\n|[^\n]$)/g;
	/^$|\/(?:xxx|yyy)zzz/i;
	/^(\/|(xxx|yyy|zzz)$)/;
	/^9$|27/;
	/^\+|\s*/g;
	/xxx_yyy=\w+|^$/;
	/^(?:mouse|contextmenu)|click/;
});

function replaceTest(x) {
	return x.replace(/^a|b/, ''); // OK - possibly replacing too much, but not obviously a problem
}
