//
//  NodeIteratorTests.swift
//  Tree
//
//  Created by Matt Cox on 20/08/2023.
//  Copyright © 2023 Matt Cox. All rights reserved.
//

import XCTest
@testable import Tree

final class NodeIteratorTests: XCTestCase {
/// A standard tree for testing iteration.
///
	var iterationTree: Root<Test> {
		Root(Test("root", numberOfChildren: 5)) {
			Test("0", numberOfChildren: 0, parent: "root")
			Test("1", numberOfChildren: 0, parent: "root")
			
			Branch(Test("2", numberOfChildren: 3, parent: "root")) {
				Test("2.0", numberOfChildren: 0, parent: "2")
				Test("2.1", numberOfChildren: 0, parent: "2")
				Branch(Test("2.2", numberOfChildren: 1, parent: "2")) {
					Test("2.2.0", numberOfChildren: 0, parent: "2.2")
				}
			}
			
			Test("3", numberOfChildren: 0, parent: "root")
			
			Branch(Test("4", numberOfChildren: 2, parent: "root")) {
				Branch(Test("4.0", numberOfChildren: 1, parent: "4")) {
					Test("4.0.0", numberOfChildren: 0, parent: "4.0")
				}
				Test("4.1", numberOfChildren: 0, parent: "4")
			}
		}
	}

/// Test node iteration.
///
/// This uses depth first iteration.
///
/// This is performed by simply defining a tree of moderate complexity, and
/// then iterating over it, ensuring all nodes are returned in the expected
/// order.
///
	func testIteration() {
		// Build a tree using the tree builder.
		//
		let root = iterationTree
		
		// Store a list of node identifiers in the order they're expected.
		//
		let expectedIdentifiers: [String] = ["root", "0", "1", "2", "2.0", "2.1", "2.2", "2.2.0", "3", "4", "4.0", "4.0.0", "4.1"]
	
		// Iterate over the nodes in the tree and collect them.
		//
		let foundIdentifiers = root.map { $0.id }
		
		// Compare the two arrays.
		//
		XCTAssertEqual(expectedIdentifiers, foundIdentifiers)
	}
	
/// Test depth first node iteration.
///
/// This is performed by simply defining a tree of moderate complexity, and
/// then iterating over it, ensuring all nodes are returned in the expected
/// order.
///
	func testDepthFirstIteration() {
		// Build a tree using the tree builder.
		//
		let root = iterationTree
		
		// Store a list of node identifiers in the order they're expected.
		//
		let expectedIdentifiers: [String] = ["root", "0", "1", "2", "2.0", "2.1", "2.2", "2.2.0", "3", "4", "4.0", "4.0.0", "4.1"]
	
		// Iterate over the nodes in the tree and collect them.
		//
		let foundIdentifiers = root.depthFirst.map { $0.id }
		
		// Compare the two arrays.
		//
		XCTAssertEqual(expectedIdentifiers, foundIdentifiers)
	}
	
/// Test breadth first node iteration.
///
/// This is performed by simply defining a tree of moderate complexity, and
/// then iterating over it, ensuring all nodes are returned in the expected
/// order.
///
	func testBreadthFirstIteration() {
		// Build a tree using the tree builder.
		//
		let root = iterationTree
		
		// Store a list of node identifiers in the order they're expected.
		//
		let expectedIdentifiers: [String] = ["root", "0", "1", "2", "3", "4", "2.0", "2.1", "2.2", "4.0", "4.1", "2.2.0", "4.0.0"]
	
		// Iterate over the nodes in the tree and collect them.
		//
		let foundIdentifiers = root.breadthFirst.map { $0.id }
		
		// Compare the two arrays.
		//
		XCTAssertEqual(expectedIdentifiers, foundIdentifiers)
	}
}
