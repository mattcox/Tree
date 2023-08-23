# Tree

![Swift](https://img.shields.io/badge/Swift-orange.svg)
![Swift Package Manager](https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat)

Welcome to **Tree**, a Swift package implementing a hierarchical tree structure
constructed of interconnected nodes.

![An example of a basic tree hierarchy](./Resources/tree~dark.png#gh-dark-mode-only)
![An example of a basic tree hierarchy](./Resources/tree.png#gh-light-mode-only)

## Usage

Tree's store a value associated with each node. This can be any identifiable
type. The identifier is used for tracking the identity of a node within the
tree.

Building a tree is simple; you create a root node and add child nodes.

```swift
// Create a root node.
//
let root = Node("root")

// Create two nodes as children of the root node.
//
let A = root.append(child: "A")
let B = root.append(child" "B")

// Create some leaf nodes as children of node A.
//
let C = A.append(child: "C")
let D = A.append(child: "D")
```

Building a tree is even easier with the declarative tree builder.

```swift
let root = Root("root") {
    Branch("A") {
        "C"
        "D"
    }
    
    "B"
}
```

The tree can then be enumerated of inspected for properties.

```swift
print(root.isRoot)
// "true"

print(root.isLeaf)
// "false"

if let A = root.node(identifiedBy: "A") {
    print(A.reduce("") {
        $0 + "\($1.element), "
    })
    // "C, D, "
}
```

## Installation

Tree is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it within another Swift package, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    // . . .
    dependencies: [
        .package(url: "https://github.com/mattcox/Tree.git", branch: "main")
    ],
    // . . .
)
```

If you’d like to use Tree within an iOS, macOS, watchOS or tvOS app, then use Xcode’s `File > Add Packages...` menu command to add it to your project.

Import Tree wherever you’d like to use it:
```swift
import Tree
```
