# ``Tree/Node/depthFirst``

Depth first iteration visits every node in the first branch of the tree, and
then back traces to the next unvisited branch in the tree. Each branch is
visited in turn until all nodes have been visited.

```swift
for node in root.depthFirst {
    print(node.id)
}
```

![A tree structure showing the sequence nodes are visited with depth first iteration](nodeDepthFirst.png)

> Note: Depth first iteration is the default iteration method when iterating the
tree as a sequence.
