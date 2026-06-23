(function() {
    // GOOD: simple word alternation used with .test() for role checking
    // These are intentional partial matches, not URL validation
    var rolePattern = /^admin|user|guest/;
    if (rolePattern.test(role)) { /* ... */ }

    // BAD: hostname pattern with misleading anchor precedence
    var urlCheck = /^https?:\/\/good.com|https?:\/\/evil.com/; // $ Alert
    if (urlCheck.test(url)) { /* ... */ }
});
