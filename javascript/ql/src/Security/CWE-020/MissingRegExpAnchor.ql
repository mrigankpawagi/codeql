/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @id js/regex/missing-regexp-anchor
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

private import javascript
private import semmle.javascript.security.regexp.HostnameRegexp as HostnameRegexp
private import codeql.regex.MissingRegExpAnchor as MissingRegExpAnchor
private import semmle.javascript.security.regexp.RegExpTreeView::RegExpTreeView as TreeImpl

private module Impl implements
  MissingRegExpAnchor::MissingRegExpAnchorSig<TreeImpl, HostnameRegexp::Impl>
{
  predicate isUsedAsReplace(RegExpPatternSource pattern) {
    // is used for capture or replace
    exists(DataFlow::MethodCallNode mcn, string name | name = mcn.getMethodName() |
      name = "exec" and
      mcn = pattern.getARegExpObject().getAMethodCall() and
      exists(mcn.getAPropertyRead())
      or
      exists(DataFlow::Node arg |
        arg = mcn.getArgument(0) and
        (
          pattern.getARegExpObject().flowsTo(arg) or
          pattern.getAParse() = arg
        )
      |
        name = "replace"
        or
        name = ["match", "matchAll"] and exists(mcn.getAPropertyRead())
      )
    )
  }

  string getEndAnchorText() { result = "$" }
}

import MissingRegExpAnchor::Make<TreeImpl, HostnameRegexp::Impl, Impl>

/**
 * Holds if `src` is a pattern that plausibly matches a hostname or URL,
 * as indicated by the presence of a dot character in the pattern (either an
 * escaped literal dot `\.` or an unescaped dot `.` used as a wildcard).
 *
 * Hostname patterns inherently contain dots (e.g., `example\.com` or `example.com`),
 * whereas patterns matching simple strings, module names, or CLI arguments
 * typically do not contain dots.
 */
private predicate looksLikeHostnamePattern(RegExpPatternSource src) {
  exists(RegExpTerm term |
    term = src.getRegExpTerm().getAChild*() and
    (
      term.(RegExpConstant).getValue() = "."
      or
      term instanceof RegExpDot
    )
  )
}

from DataFlow::Node nd, string msg
where
  isUnanchoredHostnameRegExp(nd, msg)
  or
  isSemiAnchoredHostnameRegExp(nd, msg)
  or
  hasMisleadingAnchorPrecedence(nd, msg) and looksLikeHostnamePattern(nd)
// isLineAnchoredHostnameRegExp is not used here, as it is not relevant to JS.
select nd, msg
