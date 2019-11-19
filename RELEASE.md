RELEASE_TYPE: patch

Fix a deprecation warning with some type constraints on variables (e.g. using
`map(string)` instead of `"map"`).

This should improve error reporting if you've passed a variable that doesn't match
the type contraints.