# ``Tree/Node/remove()``

```swift
// Remove the node from it's parent, reparenting the child nodes.
A.remove()
```

![A tree with a removed node](nodeRemove.png)

> Warning: Care should be taken when using this function on a root node, as
it could result in orphaned child nodes.
