# ``Tree``

A hierarchical tree structure constructed of interconnected nodes.

## Overview

A tree is a hierarchical data structure constructed of interconnected nodes.

Unlike a biological tree which grows vertically from a root at it's base and
leaves at its top, the tree is conceptually upside down with a root at the top,
and leaves at the bottom.

![An example of a basic tree hierarchy](tree.png)

## Topics

### Structure
- ``Node``
- ``Node/children``
- ``Node/element``
- ``Node/leaves``
- ``Node/parent``
- ``Node/root``

### Building
- ``TreeBuilder``
- ``Branch``
- ``Root``

### Editing
- ``Node/append(child:)-3dbmb``
- ``Node/append(child:)-5lg6n``
- ``Node/insert(child:atIndex:)-4pov2``
- ``Node/insert(child:atIndex:)-5en4l``
- ``Node/prune()``
- ``Node/prune(childAtIndex:)``
- ``Node/prune(childIdentifiedBy:)``
- ``Node/remove()``
- ``Node/remove(childAtIndex:)``
- ``Node/remove(childIdentifiedBy:)``

### Lookup
- ``Node/contains(element:)``
- ``Node/node(forElement:)``
- ``Node/node(identifiedBy:)``

### Properties
- ``Node/isLeaf``
- ``Node/isRoot``

### Iteration
- ``Node/breadthFirst``
- ``Node/depthFirst``
