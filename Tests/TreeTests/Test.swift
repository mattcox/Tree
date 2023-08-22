//
//  Test.swift
//  Tree
//
//  Created by Matt Cox on 21/08/2023.
//  Copyright © 2023 Matt Cox. All rights reserved.
//

import XCTest
@testable import Tree

/// A node test element.
///
/// This stores the number of children, and the parent ID, so that it can be
/// validated against the actual tree structure for unit testing.
///
struct Test: Identifiable {
/// The identifier for this node.
///
	var id: String
	
/// The expected number of children for this node.
///
	var numberOfChildren: Int
	
/// The id of the parent node.
///
	var parent: String?
	
/// Initialize the Test element.
///
/// - Parameters:
///   - id: The identifier for this node.
///   - numberOfChildren: The expected number of children for the node
///   containing this element.
///   - parent: The parent node for the node containing this element.
///
	init(_ id: String, numberOfChildren: Int, parent: String? = nil) {
		self.id = id
		self.parent = parent
		self.numberOfChildren = numberOfChildren
	}
	
/// Validates the node structure, ensuring it matches the expected
/// structure on the node element.
///
/// This function will be called recursively, so is not suitable for
/// testing very deep trees.
///
/// - Parameters:
///   - node: The node to validate.
///
	static func validate(node: Node<Test>) {
		XCTAssertEqual(node.id, node.element.id)
		XCTAssertEqual(node.parent?.id, node.element.parent)
		XCTAssertEqual(node.children.count, node.element.numberOfChildren)
		
		for child in node.children {
			Test.validate(node: child)
		}
	}
}

extension Node where Element == Test {
	func validate() {
		Test.validate(node: self)
	}
}
