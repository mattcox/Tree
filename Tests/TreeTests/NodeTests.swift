//
//  NodeTests.swift
//  Tree
//
//  Created by Matt Cox on 20/08/2023.
//  Copyright © 2023 Matt Cox. All rights reserved.
//

import XCTest
@testable import Tree

final class NodeTests: XCTestCase {
/// Tests the append element method, building a basic tree and then testing
/// the structure is as expected.
///
	func testAppendElement() {
		// Create the root node.
		//
		let root = Node(Test("root", numberOfChildren: 3, parent: nil))
		
		// Add the children of the root node.
		//
		root.append(Test("A", numberOfChildren: 0, parent: "root"))
		root.append(Test("B", numberOfChildren: 0, parent: "root"))
		
		let C = root.append(Test("C", numberOfChildren: 2, parent: "root"))
		
		// Add two children of the C node.
		//
		C.append(Test("D", numberOfChildren: 0, parent: "C"))
		C.append(Test("E", numberOfChildren: 0, parent: "C"))
		
		// Validate the structure.
		//
		root.validate()
	}
	
/// Tests the append node method, building a basic tree and then testing the
/// structure is as expected.
///
	func testAppendNode() {
		// Create the root node.
		//
		let root = Node(Test("root", numberOfChildren: 3, parent: nil))
		
		// Create three children that will be parented to the root node.
		//
		let A = Node(Test("A", numberOfChildren: 0, parent: "root"))
		let B = Node(Test("B", numberOfChildren: 0, parent: "root"))
		let C = Node(Test("C", numberOfChildren: 2, parent: "root"))
		
		// Create two children that will be parented to the C node.
		//
		let D = Node(Test("D", numberOfChildren: 0, parent: "C"))
		let E = Node(Test("E", numberOfChildren: 0, parent: "C"))
		
		// Build the structure.
		//
		root.append(A)
		root.append(B)
		root.append(C)
		
		C.append(D)
		C.append(E)
		
		// Validate the structure.
		//
		root.validate()
	}
	
/// Tests the children getter for the node.
///
	func testChildren() {
		// Create a basic tree structure containing some child nodes.
		//
		let root = Root(Test("root", numberOfChildren: 5)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Test("C", numberOfChildren: 0, parent: "root")
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
		}
		
		// Test the children to see they are in the order that was expected.
		//
		XCTAssertEqual(root.children.count, 5)
		XCTAssertEqual(root.children[0].id, "A")
		XCTAssertEqual(root.children[1].id, "B")
		XCTAssertEqual(root.children[2].id, "C")
		XCTAssertEqual(root.children[3].id, "D")
		XCTAssertEqual(root.children[4].id, "E")
	}
	
/// Tests the contains method for the node.
///
	func testContains() {
		// Create a basic tree structure containing a basic multi-level
		// structure.
		//
		let root = Root(Test("root", numberOfChildren: 5)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Branch(Test("C", numberOfChildren: 3, parent: "root")) {
				Test("F", numberOfChildren: 0, parent: "C")
				Test("G", numberOfChildren: 0, parent: "C")
				Branch(Test("H", numberOfChildren: 3, parent: "C")) {
					Test("I", numberOfChildren: 0, parent: "H")
					Test("J", numberOfChildren: 0, parent: "H")
					Test("K", numberOfChildren: 0, parent: "H")
				}
			}
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
		}
		
		// Try and find the root node from the root. It should be found, as this
		// is the root node.
		//
		XCTAssertTrue(root.contains(element: Test("root", numberOfChildren: 5)))
		
		// Try and find the D node from the root. It should be found, as it's a
		// child of the root node.
		//
		XCTAssertTrue(root.contains(element: Test("D", numberOfChildren: 0, parent: "root")))
		
		// Try and find the K node from the root. It should be found, as it's a
		// child of the root node.
		//
		XCTAssertTrue(root.contains(element: Test("K", numberOfChildren: 0, parent: "H")))
		
		// Try and find a node that doesn't exist.
		//
		XCTAssertFalse(root.contains(element: Test("NotHere", numberOfChildren: 0, parent: "Whatever")))
		
		// Get the H node by walking the tree, and then try and lookup the
		// A. It should not be found, as it's not a child of the H node.
		//
		let H: Node<Test>? = {
			guard let C = root.children.first(where: {
				$0.id == "C"
			})
			else {
				return nil
			}
			
			return C.children.first(where: {
				$0.id == "H"
			})
		}()
		
		XCTAssertNotNil(H)
		XCTAssertFalse((H?.contains(element: Test("A", numberOfChildren: 0, parent: "root"))) ?? true)
	}
	
/// Test inserting an element into the tree at a specific index.
///
	func testInsertElement() {
		// Create a basic tree structure.
		//
		let root = Root(Test("root", numberOfChildren: 3)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Test("C", numberOfChildren: 0, parent: "root")
		}
		
		// Attempt to insert an element before the A node. This should be index
		// 0.
		//
		root.insert(Test("BeforeA", numberOfChildren: 0, parent: "root"), atIndex: 0)
		XCTAssertEqual(root.children.count, 4)
		XCTAssertEqual(root.children[0].id, "BeforeA")
		XCTAssertEqual(root.children[1].id, "A")
		XCTAssertEqual(root.children[2].id, "B")
		XCTAssertEqual(root.children[3].id, "C")
		
		// Attempted to insert an element after the A node. This should now be
		// index 2.
		//
		root.insert(Test("AfterA", numberOfChildren: 0, parent: "root"), atIndex: 2)
		XCTAssertEqual(root.children.count, 5)
		XCTAssertEqual(root.children[0].id, "BeforeA")
		XCTAssertEqual(root.children[1].id, "A")
		XCTAssertEqual(root.children[2].id, "AfterA")
		XCTAssertEqual(root.children[3].id, "B")
		XCTAssertEqual(root.children[4].id, "C")
		
		// Attempt to insert an element at a negative index. It should be added
		// to the start of the list of children.
		//
		root.insert(Test("Start", numberOfChildren: 0, parent: "root"), atIndex: Int.min)
		XCTAssertEqual(root.children.count, 6)
		XCTAssertEqual(root.children[0].id, "Start")
		XCTAssertEqual(root.children[1].id, "BeforeA")
		XCTAssertEqual(root.children[2].id, "A")
		XCTAssertEqual(root.children[3].id, "AfterA")
		XCTAssertEqual(root.children[4].id, "B")
		XCTAssertEqual(root.children[5].id, "C")
		
		// Attempt to insert an element at a out of bounds index. It should be
		// added to the end of the list of children.
		//
		root.insert(Test("End", numberOfChildren: 0, parent: "root"), atIndex: Int.max)
		XCTAssertEqual(root.children.count, 7)
		XCTAssertEqual(root.children[0].id, "Start")
		XCTAssertEqual(root.children[1].id, "BeforeA")
		XCTAssertEqual(root.children[2].id, "A")
		XCTAssertEqual(root.children[3].id, "AfterA")
		XCTAssertEqual(root.children[4].id, "B")
		XCTAssertEqual(root.children[5].id, "C")
		XCTAssertEqual(root.children[6].id, "End")
	}
	
/// Test inserting an element into the tree at a specific index.
///
	func testInsertNode() {
		// Create a basic tree structure.
		//
		let root = Root(Test("root", numberOfChildren: 3)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Test("C", numberOfChildren: 0, parent: "root")
		}
		
		// Attempt to insert an element before the A node. This should be index
		// 0.
		//
		root.insert(Node(Test("BeforeA", numberOfChildren: 0, parent: "root")), atIndex: 0)
		XCTAssertEqual(root.children.count, 4)
		XCTAssertEqual(root.children[0].id, "BeforeA")
		XCTAssertEqual(root.children[1].id, "A")
		XCTAssertEqual(root.children[2].id, "B")
		XCTAssertEqual(root.children[3].id, "C")
		
		// Attempted to insert an element after the A node. This should now be
		// index 2.
		//
		root.insert(Node(Test("AfterA", numberOfChildren: 0, parent: "root")), atIndex: 2)
		XCTAssertEqual(root.children.count, 5)
		XCTAssertEqual(root.children[0].id, "BeforeA")
		XCTAssertEqual(root.children[1].id, "A")
		XCTAssertEqual(root.children[2].id, "AfterA")
		XCTAssertEqual(root.children[3].id, "B")
		XCTAssertEqual(root.children[4].id, "C")
		
		// Attempt to insert an element at a negative index. It should be added
		// to the start of the list of children.
		//
		root.insert(Node(Test("Start", numberOfChildren: 0, parent: "root")), atIndex: Int.min)
		XCTAssertEqual(root.children.count, 6)
		XCTAssertEqual(root.children[0].id, "Start")
		XCTAssertEqual(root.children[1].id, "BeforeA")
		XCTAssertEqual(root.children[2].id, "A")
		XCTAssertEqual(root.children[3].id, "AfterA")
		XCTAssertEqual(root.children[4].id, "B")
		XCTAssertEqual(root.children[5].id, "C")
		
		// Attempt to insert an element at a out of bounds index. It should be
		// added to the end of the list of children.
		//
		root.insert(Node(Test("End", numberOfChildren: 0, parent: "root")), atIndex: Int.max)
		XCTAssertEqual(root.children.count, 7)
		XCTAssertEqual(root.children[0].id, "Start")
		XCTAssertEqual(root.children[1].id, "BeforeA")
		XCTAssertEqual(root.children[2].id, "A")
		XCTAssertEqual(root.children[3].id, "AfterA")
		XCTAssertEqual(root.children[4].id, "B")
		XCTAssertEqual(root.children[5].id, "C")
		XCTAssertEqual(root.children[6].id, "End")
	}
	
/// Test the isLeaf getter on the node.
///
	func testIsLeaf() {
		let expectedLeaves: Set<String> = ["A", "B", "D", "E", "F", "G", "I", "J", "K"]
		
		// Create a basic tree structure containing a basic multi-level
		// structure.
		//
		let root = Root(Test("root", numberOfChildren: 5)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Branch(Test("C", numberOfChildren: 3, parent: "root")) {
				Test("F", numberOfChildren: 0, parent: "C")
				Test("G", numberOfChildren: 0, parent: "C")
				Branch(Test("H", numberOfChildren: 3, parent: "C")) {
					Test("I", numberOfChildren: 0, parent: "H")
					Test("J", numberOfChildren: 0, parent: "H")
					Test("K", numberOfChildren: 0, parent: "H")
				}
			}
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
		}
		
		// Enumerate over all the nodes and compare against the set of expected
		// leaves.
		//
		for node in root {
			if expectedLeaves.contains(node.id) {
				XCTAssertTrue(node.isLeaf)
			}
			else {
				XCTAssertFalse(node.isLeaf)
			}
		}
	}
	
/// Test the isLeaf getter on the node.
///
	func testIsRoot() {
		// Create a basic tree structure.
		//
		let root = Root(Test("root", numberOfChildren: 5)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Branch(Test("C", numberOfChildren: 3, parent: "root")) {
				Test("F", numberOfChildren: 0, parent: "C")
				Test("G", numberOfChildren: 0, parent: "C")
			}
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
		}
		
		// Enumerate over all the nodes and test if only the node labeled "root"
		// thinks it's a root.
		//
		for node in root {
			if node.id == "root" {
				XCTAssertTrue(node.isRoot)
			}
			else {
				XCTAssertFalse(node.isRoot)
			}
		}
	}
	
/// Test the leaves getter on the node.
///
	func testLeaves() {
		let expectedLeaves: Set<String> = ["A", "B", "D", "E", "F", "G", "I", "J", "K"]
		
		// Create a basic tree structure containing a basic multi-level
		// structure.
		//
		let root = Root(Test("root", numberOfChildren: 5)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Branch(Test("C", numberOfChildren: 3, parent: "root")) {
				Test("F", numberOfChildren: 0, parent: "C")
				Test("G", numberOfChildren: 0, parent: "C")
				Branch(Test("H", numberOfChildren: 3, parent: "C")) {
					Test("I", numberOfChildren: 0, parent: "H")
					Test("J", numberOfChildren: 0, parent: "H")
					Test("K", numberOfChildren: 0, parent: "H")
				}
			}
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
		}
		
		// Get the leaves and compare against the list of expected leaves.
		//
		let foundLeaves = root.leaves
		XCTAssertEqual(expectedLeaves.count, foundLeaves.count)
		
		for foundLeaf in foundLeaves {
			XCTAssertTrue(expectedLeaves.contains(foundLeaf.id))
		}
	}
	
/// Tests the node(element:) method for the node.
///
	func testNodeElement() {
		// Create a basic tree structure containing a basic multi-level
		// structure.
		//
		let root = Root(Test("root", numberOfChildren: 5)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Branch(Test("C", numberOfChildren: 3, parent: "root")) {
				Test("F", numberOfChildren: 0, parent: "C")
				Test("G", numberOfChildren: 0, parent: "C")
				Branch(Test("H", numberOfChildren: 3, parent: "C")) {
					Test("I", numberOfChildren: 0, parent: "H")
					Test("J", numberOfChildren: 0, parent: "H")
					Test("K", numberOfChildren: 0, parent: "H")
				}
			}
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
		}
		
		// Try and get the root node from the root. It should be found, as this
		// is the root node.
		//
		XCTAssertNotNil(root.node(forElement: Test("root", numberOfChildren: 5)))
		
		// Try and find the D node from the root. It should be found, as it's a
		// child of the root node.
		//
		XCTAssertNotNil(root.node(forElement: Test("D", numberOfChildren: 0, parent: "root")))
		
		// Try and find the K node from the root. It should be found, as it's a
		// child of the root node.
		//
		XCTAssertNotNil(root.node(forElement: Test("K", numberOfChildren: 0, parent: "H")))
		
		// Try and find a node that doesn't exist.
		//
		XCTAssertNil(root.node(forElement: Test("NotHere", numberOfChildren: 0, parent: "Whatever")))
		
		// Get the H node by walking the tree, and then try and lookup the
		// A. It should not be found, as it's not a child of the H node.
		//
		let H: Node<Test>? = {
			guard let C = root.children.first(where: {
				$0.id == "C"
			})
			else {
				return nil
			}
			
			return C.children.first(where: {
				$0.id == "H"
			})
		}()

		if let H {
			XCTAssertNil(H.node(forElement: Test("A", numberOfChildren: 0, parent: "root")))
		}
		else {
			XCTFail()
		}
	}
	
/// Tests the node(identifier:) method for the node.
///
	func testNodeIdentifier() {
		// Create a basic tree structure containing a basic multi-level
		// structure.
		//
		let root = Root(Test("root", numberOfChildren: 5)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Branch(Test("C", numberOfChildren: 3, parent: "root")) {
				Test("F", numberOfChildren: 0, parent: "C")
				Test("G", numberOfChildren: 0, parent: "C")
				Branch(Test("H", numberOfChildren: 3, parent: "C")) {
					Test("I", numberOfChildren: 0, parent: "H")
					Test("J", numberOfChildren: 0, parent: "H")
					Test("K", numberOfChildren: 0, parent: "H")
				}
			}
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
		}
		
		// Try and get the root node from the root. It should be found, as this
		// is the root node.
		//
		XCTAssertNotNil(root.node(identifiedBy: "root"))
		
		// Try and find the D node from the root. It should be found, as it's a
		// child of the root node.
		//
		XCTAssertNotNil(root.node(identifiedBy: "D"))
		
		// Try and find the K node from the root. It should be found, as it's a
		// child of the root node.
		//
		XCTAssertNotNil(root.node(identifiedBy: "K"))
		
		// Try and find a node that doesn't exist.
		//
		XCTAssertNil(root.node(identifiedBy: "NotHere"))
		
		// Get the H node by walking the tree, and then try and lookup the
		// A. It should not be found, as it's not a child of the H node.
		//
		let H: Node<Test>? = {
			guard let C = root.children.first(where: {
				$0.id == "C"
			})
			else {
				return nil
			}
			
			return C.children.first(where: {
				$0.id == "H"
			})
		}()

		if let H {
			XCTAssertNil(H.node(identifiedBy: "A"))
		}
		else {
			XCTFail()
		}
	}
	
/// Test the parent getter on the node.
///
	func testParent() {
		// Build a basic tree with some parenting information.
		//
		let root = Node(Test("root", numberOfChildren: 1, parent: nil))
		let A = Node(Test("A", numberOfChildren: 1, parent: "root"))
		let B = Node(Test("B", numberOfChildren: 1, parent: "A"))
		let C = Node(Test("C", numberOfChildren: 1, parent: "B"))
		
		root.append(A)
		A.append(B)
		B.append(C)
		
		// Test the parents.
		//
		XCTAssertEqual(C.parent?.id, C.element.parent)
		XCTAssertEqual(B.parent?.id, B.element.parent)
		XCTAssertEqual(A.parent?.id, A.element.parent)
		XCTAssertEqual(root.parent?.id, root.element.parent)
	}
	
// Test the prune method on the node.
//
	func testPrune() {
		// Build a basic tree with three levels of hierarchy.
		//
		let root = Node(Test("root", numberOfChildren: 2, parent: nil))
		
		let A = Node(Test("A", numberOfChildren: 2, parent: "root"))
		let B = Node(Test("B", numberOfChildren: 0, parent: "root"))
		
		let C = Node(Test("C", numberOfChildren: 0, parent: "A"))
		let D = Node(Test("D", numberOfChildren: 0, parent: "A"))
		
		root.append(A)
		root.append(B)
		
		A.append(C)
		A.append(D)
		
		// Prune the A node.
		//
		A.prune()
		
		// Check the root of A, C and D. It should be A.
		//
		XCTAssertEqual(A.root.id, A.id)
		XCTAssertEqual(C.root.id, A.id)
		XCTAssertEqual(D.root.id, A.id)
		
		// Check the number of children of root - it should be 1.
		//
		XCTAssertEqual(root.children.count, 1)
	}
	
// Test the prune(childIdentifiedBy:) method on the node.
//
	func testPruneChildIdentifiedBy() {
		// Build a basic tree with three levels of hierarchy.
		//
		let root = Root(Test("root", numberOfChildren: 2, parent: nil)) {
			Branch(Test("A", numberOfChildren: 2, parent: "root")) {
				Test("C", numberOfChildren: 0, parent: "A")
				Test("D", numberOfChildren: 0, parent: "A")
			}
			
			Test("B", numberOfChildren: 0, parent: "root")
		}
		
		// Prune the A node from the root.
		//
		guard let A = root.prune(childIdentifiedBy: "A") else {
			XCTFail()
			return
		}
		
		// Check the root of A and it's children. It should be A.
		//
		XCTAssertEqual(A.root.id, A.id)
		for child in A.children {
			XCTAssertEqual(child.root.id, A.id)
		}
		
		// Check the number of children of root - it should be 1.
		//
		XCTAssertEqual(root.children.count, 1)
	}
	
// Test the prune(childAtIndex:) method on the node.
//
	func testPruneChildAtIndex() {
		// Build a basic tree with three levels of hierarchy.
		//
		let root = Root(Test("root", numberOfChildren: 2, parent: nil)) {
			Branch(Test("A", numberOfChildren: 2, parent: "root")) {
				Test("C", numberOfChildren: 0, parent: "A")
				Test("D", numberOfChildren: 0, parent: "A")
			}
			
			Test("B", numberOfChildren: 0, parent: "root")
		}
		
		// Prune the A node from the root.
		//
		let pruned = root.prune(childAtIndex: 0)
		XCTAssertEqual(pruned.id, "A")
		
		// Check the root of A and it's children. It should be A.
		//
		XCTAssertEqual(pruned.root.id, pruned.id)
		for child in pruned.children {
			XCTAssertEqual(child.root.id, pruned.id)
		}
		
		// Check the number of children of root - it should be 1.
		//
		XCTAssertEqual(root.children.count, 1)
	}

// Test the remove method on the node.
//
	func testRemove() {
		// Build a basic tree with three levels of hierarchy.
		//
		let root = Node(Test("root", numberOfChildren: 2, parent: nil))
		
		let A = Node(Test("A", numberOfChildren: 2, parent: "root"))
		let B = Node(Test("B", numberOfChildren: 0, parent: "root"))
		
		let C = Node(Test("C", numberOfChildren: 0, parent: "A"))
		let D = Node(Test("D", numberOfChildren: 0, parent: "A"))
		
		root.append(A)
		root.append(B)
		
		A.append(C)
		A.append(D)
		
		// Remove the A node. This should make an independent tree for A, and
		// reparent A children to A's old parent, at the same position as A.
		//
		A.remove()
		
		// Confirm that A is an independent node without any children or without
		// a root node.
		//
		XCTAssertNil(A.parent)
		XCTAssertTrue(A.children.isEmpty)
		
		// Check the children of root - it should be C, D and B in that order.
		//
		XCTAssertEqual(root.children.count, 3)
		XCTAssertEqual(root.children[0].id, C.id)
		XCTAssertEqual(root.children[1].id, D.id)
		XCTAssertEqual(root.children[2].id, B.id)
		
		// Check the parent of nodes C and D, it should be the root.
		//
		XCTAssertEqual(C.parent?.id, root.id)
		XCTAssertEqual(D.parent?.id, root.id)
	}
	
// Test the remove(childIdentifiedBy:) method on the node.
//
	func testRemoveChildIdentifiedBy() {
		// Build a basic tree with three levels of hierarchy.
		//
		let root = Node(Test("root", numberOfChildren: 2, parent: nil))
		
		let A = Node(Test("A", numberOfChildren: 2, parent: "root"))
		let B = Node(Test("B", numberOfChildren: 0, parent: "root"))
		
		let C = Node(Test("C", numberOfChildren: 0, parent: "A"))
		let D = Node(Test("D", numberOfChildren: 0, parent: "A"))
		
		root.append(A)
		root.append(B)
		
		A.append(C)
		A.append(D)
		
		// Remove the A node, specifying it by identifier. This should make an
		// independent tree for A, and reparent A children to A's old parent,
		// at the same position as A.
		//
		_ = root.remove(childIdentifiedBy: A.id)
		
		// Confirm that A is an independent node without any children or without
		// a root node.
		//
		XCTAssertNil(A.parent)
		XCTAssertTrue(A.children.isEmpty)
		
		// Check the children of root - it should be C, D and B in that order.
		//
		XCTAssertEqual(root.children.count, 3)
		XCTAssertEqual(root.children[0].id, C.id)
		XCTAssertEqual(root.children[1].id, D.id)
		XCTAssertEqual(root.children[2].id, B.id)
		
		// Check the parent of nodes C and D, it should be the root.
		//
		XCTAssertEqual(C.parent?.id, root.id)
		XCTAssertEqual(D.parent?.id, root.id)
	}
	
// Test the remove(childAtIndex:) method on the node.
//
	func testRemoveChildAtIndex() {
		// Build a basic tree with three levels of hierarchy.
		//
		let root = Node(Test("root", numberOfChildren: 2, parent: nil))
		
		let A = Node(Test("A", numberOfChildren: 2, parent: "root"))
		let B = Node(Test("B", numberOfChildren: 0, parent: "root"))
		
		let C = Node(Test("C", numberOfChildren: 0, parent: "A"))
		let D = Node(Test("D", numberOfChildren: 0, parent: "A"))
		
		root.append(A)
		root.append(B)
		
		A.append(C)
		A.append(D)
		
		// Remove the A node, specifying it by index. This should make an
		// independent tree for A, and reparent A children to A's old parent,
		// at the same position as A.
		//
		let removedNode = root.remove(childAtIndex: 0)
		XCTAssertEqual(removedNode?.id, A.id)
		
		// Confirm that A is an independent node without any children or without
		// a root node.
		//
		XCTAssertNil(A.parent)
		XCTAssertTrue(A.children.isEmpty)
		
		// Check the children of root - it should be C, D and B in that order.
		//
		XCTAssertEqual(root.children.count, 3)
		XCTAssertEqual(root.children[0].id, C.id)
		XCTAssertEqual(root.children[1].id, D.id)
		XCTAssertEqual(root.children[2].id, B.id)
		
		// Check the parent of nodes C and D, it should be the root.
		//
		XCTAssertEqual(C.parent?.id, root.id)
		XCTAssertEqual(D.parent?.id, root.id)
	}
	
/// Test the root getter on the node.
///
	func testRoot() {
		// Build a basic tree with multiple levels of hierarchy.
		//
		let root = Node(Test("root", numberOfChildren: 3, parent: nil))
		
		let A = Node(Test("A", numberOfChildren: 2, parent: "root"))
		let B = Node(Test("B", numberOfChildren: 0, parent: "root"))
		let C = Node(Test("C", numberOfChildren: 0, parent: "root"))
		
		let D = Node(Test("D", numberOfChildren: 0, parent: "A"))
		let E = Node(Test("E", numberOfChildren: 1, parent: "A"))
		
		let F = Node(Test("F", numberOfChildren: 0, parent: "E"))
		
		root.append(A)
		root.append(B)
		root.append(C)
		
		A.append(D)
		A.append(E)
		
		E.append(F)
		
		// Given the F node, attempt to find the root of the tree.
		//
		XCTAssertEqual(F.root.id, root.id)
	}
}
