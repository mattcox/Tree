# ``Tree/Node``

A ``Node`` is the primitive building block for a ``Tree``. A tree cannot exist
without at lease one node, however most trees have many nodes describing complex
parent child relationships.

Nodes have a ``Node/parent``, and they have ``Node/children``. A node without a
parent is a ``Node/root`` node, and there is only one per-tree. Nodes without
children are ``Node/leaves``.

![An example of a basic tree hierarchy, identifying root and leaf nodes](node.png)

Nodes are generic types that store any identifiable value. Nodes with duplicate
identifiers can exist in the tree, however for best results ensure each node
has a unique identifier.

> Warning: No checks are performed to ensure a valid tree structure, or
guarantee a non-cyclic hierarchy. It is the responsibility of the client to
ensure a node doesn't add it's own parent as a child, either directly or
indirectly.

## Example

In this example, a basic tree structure is created that contains strings.
`String` does not conform to `Identifiable` by default, but conformance is
implied. 

```swift
// Create a root node. This is identical to a standard node,
// but has no parent.
let root = Node("Root")

// Create two nodes as children of the root node.
let A = root.append("A")
let B = root.append("B")

// Create some leaf nodes as children of node A.
let C = A.append("C")
let D = A.append("D")
```

![The tree structure created by the example above](nodeExample.png)

Once the tree structure has been defined, its properties can be inspected and
operations can be performed on the tree structure.

```swift
print(root.isRoot)
// "true"

print(root.isLeaf)
// "false"

print(A.isRoot)
// "false"

print(A.isLeaf)
// "false"

print(C.isRoot)
// "false"

print(C.isLeaf)
// "true"

print(A.reduce("") {
    $0 + "\($1.element), "
})
// "C, D, "
```
