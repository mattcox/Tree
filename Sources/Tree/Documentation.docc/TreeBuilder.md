# ``Tree/TreeBuilder``

You typically use ``TreeBuilder`` as a parameter attribute for child
node-producing closure parameters, allowing those closures to provide multiple
sub nodes.

```swift
func createNode<T: Identifiable>(_ element: T, @TreeBuilder<T> _ contents: () -> [Node<T>]) -> Node<T> {
    let node = Node(element)
    for child in contents() {
        node.append(child)
    }
    return node
}
```

The ``Node/init(_:_:)`` initializer on the ``Node`` can be used to building a
tree with a tree builder. For example, to use this to build a simple structure
containing a root node, a branch, and three leaf nodes.

```swift
let root = Node("Root") {
    // Tree builders can contain other tree builders to create branches.
    Node("A") {
        "C"
        "D"
    }
    
    // Leaf nodes can be declared directly as a value.
    "B"
}
```

![The tree structure created by the example above](treeBuilderExample.png)

The ``Root`` and ``Branch`` types are aliases for ``Node``, but provide a more
user friendly interface for the tree builder.

```swift
let root = Root("Root") {
    Branch("A") {
        "C"
        "D"
    }
    
    "B"
}
```
