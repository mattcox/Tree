# ``Tree/Node/contains(element:)``

This function will test only the sub-tree formed from the current node and it's
children. To scan the entire tree for a specific element, call the function on
the ``Tree/Node/root`` node.

```swift
// Get the root node.
let root = node.root

// Test if the node is in the tree.
let isNodeFound = root.contains(element: someElement)
```

This function has `O(n)` performance over the size of the tree. It works by
visiting each node, and comparing the identifiers.

> Important: A matching element is found using the identifier associated with
the element. If two or more elements have the same identifier, then first
element with a matching identifier will be returned.
