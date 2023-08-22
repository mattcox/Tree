//
//  TreeBuilderTests.swift
//  Tree
//
//  Created by Matt Cox on 20/08/2023.
//  Copyright © 2023 Matt Cox. All rights reserved.
//

import XCTest
@testable import Tree

/// A series of tests for the TreeBuilder type.
///
/// These tests work by building a tree using the tree builder, and then
/// validating the tree structure against what we expect. The expected tree
/// structure is stored on the node element, so generic tests can easily be
/// added.
///
final class TreeBuilderTests: XCTestCase {
/// Tests the tree builder for building a basic tree containing one child
/// element.
///
	func testBuildBlock() {
		let root = Root(Test("root", numberOfChildren: 1)) {
			Test("A", numberOfChildren: 0, parent: "root")
		}
		
		root.validate()
	}
	
/// Tests the tree builder for building a basic tree containing multiple child
/// element.
///
	func testBuildMultiple() {
		let root = Root(Test("root", numberOfChildren: 3)) {
			Test("A", numberOfChildren: 0, parent: "root")
			Test("B", numberOfChildren: 0, parent: "root")
			Test("C", numberOfChildren: 0, parent: "root")
		}
		
		root.validate()
	}
	
/// Tests the tree builder for building a tree containing a single branch with
/// child elements.
///
	func testBuildBranch() {
		let root = Root(Test("root", numberOfChildren: 1)) {
			Branch(Test("A", numberOfChildren: 2, parent: "root")) {
				Test("B", numberOfChildren: 0, parent: "A")
				Test("C", numberOfChildren: 0, parent: "A")
			}
		}
		
		root.validate()
	}
	
/// Tests the tree builder for building a tree containing mixed types; elements,
/// nodes and branches.
///
	func testBuildMixed() {
		let root = Root(Test("root", numberOfChildren: 4)) {
			Branch(Test("A", numberOfChildren: 2, parent: "root")) {
				Test("B", numberOfChildren: 0, parent: "A")
				Test("C", numberOfChildren: 0, parent: "A")
			}
			
			Test("D", numberOfChildren: 0, parent: "root")
			Test("E", numberOfChildren: 0, parent: "root")
			
			Node(Test("F", numberOfChildren: 0, parent: "root"))
		}
		
		root.validate()
	}
	
/// Tests the tree builder with a conditional if/else statement. Both the if and
/// else branch should produce a valid value, but only one should be added to
/// the tree depending on which branch of the conditional is used.
///
	func testBuildConditionalIfElse() {
		var conditional = true
		
		// Test if the conditional is true.
		//
		let trueRoot = Root(Test("root", numberOfChildren: 3)) {
			if conditional {
				Test("A", numberOfChildren: 0, parent: "root")
				Branch(Test("B", numberOfChildren: 1, parent: "root")) {
					Test("C", numberOfChildren: 0, parent: "B")
				}
				Node(Test("D", numberOfChildren: 0, parent: "root"))
			}
			else {
				Test("E", numberOfChildren: 0, parent: "root")
				Branch(Test("F", numberOfChildren: 1, parent: "root")) {
					Test("G", numberOfChildren: 0, parent: "F")
				}
				Node(Test("H", numberOfChildren: 0, parent: "root"))
			}
		}
		
		trueRoot.validate()
		
		XCTAssertEqual(trueRoot.children[0].id, "A")
		XCTAssertEqual(trueRoot.children[1].id, "B")
		XCTAssertEqual(trueRoot.children[2].id, "D")
		
		// Test if the conditional is false.
		//
		conditional = false
		
		let falseRoot = Root(Test("root", numberOfChildren: 3)) {
			if conditional {
				Test("A", numberOfChildren: 0, parent: "root")
				Branch(Test("B", numberOfChildren: 1, parent: "root")) {
					Test("C", numberOfChildren: 0, parent: "B")
				}
				Node(Test("D", numberOfChildren: 0, parent: "root"))
			}
			else {
				Test("E", numberOfChildren: 0, parent: "root")
				Branch(Test("F", numberOfChildren: 1, parent: "root")) {
					Test("G", numberOfChildren: 0, parent: "F")
				}
				Node(Test("H", numberOfChildren: 0, parent: "root"))
			}
		}
		
		falseRoot.validate()
		
		XCTAssertEqual(falseRoot.children[0].id, "E")
		XCTAssertEqual(falseRoot.children[1].id, "F")
		XCTAssertEqual(falseRoot.children[2].id, "H")
	}
	
/// Tests the tree builder for building an optional value. This can be used if
/// the else branch for a conditional is not present.
///
	func testBuildOptional() {
		let conditional = false
		
		let root = Root(Test("root", numberOfChildren: 0)) {
			if conditional {
				Test("A", numberOfChildren: 0, parent: "root")
				Branch(Test("B", numberOfChildren: 1, parent: "root")) {
					Test("C", numberOfChildren: 0, parent: "B")
				}
				Node(Test("D", numberOfChildren: 0, parent: "root"))
			}
		}
		
		root.validate()
	}
	
/// Tests the tree builder for building a tree with a loop.
///
	func testBuildLoop() {
		let root = Root(Test("root", numberOfChildren: 21)) {
			for i in 0..<10 {
				Branch(Test("branch_\(i)", numberOfChildren: 1, parent: "root")) {
					Node(Test("node_\(i)", numberOfChildren: 0, parent: "branch_\(i)"))
				}
				
				Test("element_\(i)", numberOfChildren: 0, parent: "root")
			}
			
			Test("child", numberOfChildren: 0, parent: "root")
		}
		
		root.validate()
	}
}
