# ``Tree/Node/root``

A root node is a node without a parent node. One root always exists for each
tree, and is the root ancestor of all ``Node/children``.

![A tree structure highlighting the root node](nodeRoot.png)

This function works by walking the tree from the current node to the
``Node/parent`` node until the root node is found. When performing iteration of
nodes that requires access to the root node, it can be beneficial to cache the
root node to prevent continuous and costly lookup.
