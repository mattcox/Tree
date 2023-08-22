//
//  NodeIterator.swift
//  Tree
//
//  Created by Matt Cox on 14/08/2023.
//  Copyright © 2023 Matt Cox. All rights reserved.
//

import Collections
import Foundation

/// An iterator for iterating over all nodes in a tree.
///
internal struct NodeIterator<T: Identifiable>: IteratorProtocol {
/// The method used for iteration.
///
	enum Method {
	/// Depth first iteration visits every node in the first branch of the
	/// tree, and then back traces to the next unvisited branch in the tree.
	/// Each branch is visited in turn until all nodes have been visited.
	///
		case depthFirst

	/// Breadth first iteration visits every node at each depth of the tree,
	/// before moving on to the nodes at the next depth level. It does this
	/// until all nodes in the tree have been visited.
	///
		case breadthFirst
	}

	private var nodesToVisit: Deque<Node<T>>
	private let method: Method
	
/// Initialize the iterator.
///
/// - Parameters:
///   - node: The node to iterate from.
///   - method: The method used to iterate; either depth first or breadth
///   first.
///
	init(_ node: Node<T>, method: Method) {
		self.nodesToVisit = Deque([node])
		self.method = method
	}
	
	mutating func next() -> Node<T>? {
		if nodesToVisit.isEmpty {
			return nil
		}
		
		if method == .depthFirst {
			let current = nodesToVisit.popFirst()
			if let children = current?.children, children.isEmpty == false {
				nodesToVisit.prepend(contentsOf: children)
			}
			return current
		}
		else {
			let current = nodesToVisit.popFirst()
			if let children = current?.children, children.isEmpty == false {
				nodesToVisit.append(contentsOf: children)
			}
			return current
		}
	}
}

extension Node: Sequence {
	public func makeIterator() -> AnyIterator<Node<Element>> {
		depthFirst
	}
}

extension Node {
/// An iterator that performs depth-first iteration of all nodes in the
/// tree.
///
	public var depthFirst: AnyIterator<Node<Element>> {
		AnyIterator(NodeIterator(self, method: .depthFirst))
	}
	
/// An iterator that performs breadth-first iteration of all nodes in the
/// tree.
///
	public var breadthFirst: AnyIterator<Node<Element>> {
		AnyIterator(NodeIterator(self, method: .breadthFirst))
	}
}
