# ``Tree/Node/node(identifiedBy:)``

This function has `O(n)` performance over the size of the tree. It works by
visiting each node, and comparing the identifiers.

This function will search only the sub-tree formed from the current node and it's
children. To scan the entire tree for a specific element, call the function on
the ``Tree/Node/root`` node.

```swift
// Get the root node.
let root = node.root

// Search the sub-tree for the identifier and return it if it exists.
let foundNode = root.node(identifiedBy: someIdentifier)
```

> Important: If two or more elements within the tree have the same identifier,
then first node with a matching identifier will be returned.
