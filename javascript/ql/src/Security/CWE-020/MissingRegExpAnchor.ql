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

from DataFlow::Node nd, string msg
where
  (
    isUnanchoredHostnameRegExp(nd, msg)
    or
    isSemiAnchoredHostnameRegExp(nd, msg)
    or
    hasMisleadingAnchorPrecedence(nd, msg)
  ) and
  // Exclude patterns used with .test() where unanchored alternatives are simple words
  // (no dots), indicating intentional partial matching for role/type checks, not URL validation
  not exists(DataFlow::MethodCallNode testCall |
    testCall.getMethodName() = "test" and
    nd.(DataFlow::RegExpCreationNode).getARegExpObject().flowsTo(testCall.getReceiver()) and
    forall(RegExpTerm alt |
      alt = nd.(DataFlow::RegExpCreationNode).getRoot().(RegExpAlt).getAChild() and
      not alt.getAChild*() instanceof RegExpAnchor
    |
      not alt.getAChild*().(RegExpConstant).getValue().matches("%.%")
    )
  )
select nd, msg
