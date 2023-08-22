# ``Tree/Node/leaves``

Child leaf nodes may be direct or distant descendents.

A leaf node is a node that has no child nodes.

![A tree structure highlighting the leaf nodes](nodeLeaves.png)

This function has `O(n)` performance over the size of the tree. It works by
visiting each node, and collecting the nodes that are considered leaves.
