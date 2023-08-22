# ``Tree/Node/breadthFirst``

Breadth first iteration visits every node at each depth of the tree, before
moving on to the nodes at the next depth level. It does this until all nodes
in the tree have been visited.

```swift
for node in root.breadthFirst {
    print(node.id)
}
```

![A tree structure showing the sequence nodes are visited with breadth first iteration](nodeBreadthFirst.png)
