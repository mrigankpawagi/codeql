---
category: majorAnalysis
---
* Reduced false positives in the `js/regex/missing-regexp-anchor` query by filtering out `hasMisleadingAnchorPrecedence` results where the regular expression does not contain a literal dot character. Patterns matching simple strings, module names, or CLI arguments (which do not contain dots) are no longer flagged, as the query targets URL/hostname validation bypasses which inherently involve dotted domain names.
