//
//  Node.swift
//  Tree
//
//  Created by Matt Cox on 10/08/2023.
//  Copyright © 2023 Matt Cox. All rights reserved.
//

import Foundation

/// An identifiable node that when connected to other child nodes, forms a
/// hierarchical tree structure.
///
public final class Node<Element: Identifiable>: Identifiable {
	public var id: Element.ID {
		element.id
	}
	
/// The element or value associated with this node.
///
/// This value can be any type that conforms to `Identifiable`.
///
	public let element: Element

/// The parent node for this node.
///
	public private(set) weak var parent: Node<Element>?
	
/// The child nodes of this node.
///
	public private(set) var children: [Node<Element>]

/// Initialize a new root node for the provided element.
///
/// Any identifiable element can be stored on a node, however all nodes in a
/// tree must store the same element type.
///
/// - Parameters:
///   - element: The element to store in the node.
///
	public init(_ element: Element) {
		self.element = element
		self.parent = nil
		self.children = []
	}
}

extension Node {
/// Adds a node as a child of another node.
///
/// - Parameters:
///   - node: The node to add as a child of the parent node.
///   - parent: The parent node to append the child to.
///   - index: An optional index to insert the child node.
///
	private static func addChild(node: Node<Element>, to parent: Node<Element>, atIndex index: Int? = nil) {
		node.parent = parent
		if let index {
			let insertIndex = Swift.max(index, 0)
			if insertIndex >= parent.children.count {
				parent.children.append(node)
			}
			else {
				parent.children.insert(node, at: insertIndex)
			}
		}
		else {
			parent.children.append(node)
		}
	}

/// Inserts a node into the tree, as a new parent of the provided child
/// node. The inserted node will parented to the existing childs parent.
///
/// - Parameters:
///   - node: The node to insert into the tree.
///   - child: The existing child the new node will be a parent of.
///
	private static func insert(parent node: Node<Element>, into child: Node<Element>) {
		// Find the index of the child on it's parent.
		//
		let index = {
			if let parent = child.parent {
				return parent.children.firstIndex {
					$0.id == child.id
				}
			}
			return nil
		}()
		
		// Change the parent on the existing child from the old node, to the
		// new node. Also update the parent on this node to be the old parent.
		//
		node.parent = child.parent
		child.parent = node
		
		// Swap out the old child on the parent with the new node
		//
		if let index {
			node.parent?.children[index] = node
		}
	}

/// Inserts a node into the tree, as a child of the provided parent node.
/// All existing children of the parent node will be parented to this node.
///
/// - Parameters:
///   - node: The node to insert into the tree.
///   - parent: The existing parent the new node will be a child of.
///
	private static func insert(child node: Node<Element>, into parent: Node<Element>) {
		node.children.append(contentsOf: parent.children)
		for child in node.children {
			child.parent = node
		}
		
		node.parent = parent
		parent.children = [node]
	}
	
/// Removes a node from the tree. All child nodes will continue to be
/// parented to the removed node.
///
/// This converts this node into a root node, and an isolated tree.
///
/// - Parameters:
///   - node: The node to remove.
///
	private static func prune(node: Node<Element>) {
		node.parent?.children.removeAll {
			$0.id == node.id
		}
		node.parent = nil
	}
	
/// Extracts a node from the tree. All child nodes will be reparented to
/// the parent node.
///
/// This function returns an array of parent nodes. If the extracted node
/// has a parent, then this array will contain a single element. If it
/// does not, then the array will contain the orphaned child nodes.
///
/// - Parameters:
///   - node: The node to extract.
///
/// - Returns: The parent node, or orphaned children of this node.
///
	@discardableResult
	private static func extract(node: Node<Element>) -> [Node<Element>] {
		if let parent = node.parent {
			// Remove the node from the parent, and insert the nodes children
			// at the same position.
			//
			if let index = parent.children.firstIndex(of: node) {
				parent.children.remove(at: index)
				parent.children.insert(contentsOf: node.children, at: index)
			}
			else {
				parent.children.append(contentsOf: node.children)
			}
			
			// Update the parent of the children.
			//
			for child in node.children {
				child.parent = parent
			}
			
			// Isolate the removed node.
			//
			node.children = []
			node.parent = nil
			
			return [parent]
		}
		else {
			let children = node.children
			for child in children {
				child.parent = nil
			}
			node.children = []
			return children
		}
	}
}

extension Node {
/// A boolean indicating if this node is a `leaf`.
///
	public var isLeaf: Bool {
		self.children.isEmpty
	}

/// A boolean indicating if this node is a ``root``.
///
	public var isRoot: Bool {
		self.parent == nil
	}

/// The root node for the tree this node belongs to.
///
	public var root: Node<Element> {
		var current = self
		var parent = current.parent

		while let nextParent = parent {
			current = nextParent
			parent = current.parent
		}

		return current
	}

/// All leaf nodes that are ``children`` of this node.
///
	public var leaves: [Node<Element>] {
		self.filter {
			$0.isLeaf
		}
	}

/// Test if the provided element is contained within the sub-tree formed by
/// this node.
///
/// - Parameters:
///   - element: The element to test if it is contained within the sub-tree
///   formed by this node.
///
/// - Returns: A boolean indicating if the provided element is contained
/// within the sub-tree formed by this node.
///
	public func contains(element: Element) -> Bool {
		self.node(identifiedBy: element.id) != nil
	}

/// Returns the ``Node`` from sub-tree formed by this node that has the provided
/// identifier.
///
/// - Parameters:
///   - identifier: The identifier of the node to return.
///
/// - Returns: The node with the matching identifier, or nil if the node
/// cannot be found.
///
	public func node(identifiedBy identifier: Element.ID) -> Node<Element>? {
		self.first {
			$0.id == identifier
		}
	}
	
/// Returns the ``Node`` from sub-tree formed by this node that stores the
/// provided element.
///
/// - Parameters:
///   - element: The element contained within the node to return.
///
/// - Returns: The node storing the matching element, or nil if the node
/// cannot be found.
///
	public func node(forElement element: Element) -> Node<Element>? {
		node(identifiedBy: element.id)
	}
}

extension Node {
/// Append a new child element to this node.
///
/// A new ``Node`` will be created for this element, and will be returned.
///
/// - Parameters:
///   - element: The element to add as a child of this node.
///
/// - Returns: The node created to store the element.
///
	@discardableResult
	public func append(_ element: Element) -> Node<Element> {
		let node = Node<Element>(element)
		Node.addChild(node: node, to: self)
		return node
	}
	
/// Append a child node to this node.
///
/// This is useful for grafting one ``Tree`` to another, however care should
/// be taken to ensure the node being added or any of it's children don't
/// already exist in the tree.
///
/// - Parameters:
///   - node: The node to add as a child of this node.
///
	public func append(_ node: Node<Element>) {
		Node.addChild(node: node, to: self)
	}

/// Insert a new child element to this node at the specified index.
///
/// The newly created child ``Node`` will be returned.
///
/// - Parameters:
///   - element: The element to parent to this node.
///   - index: The index of the element.
///
/// - Returns: The node created to store the element.
///
	@discardableResult
	public func insert(_ element: Element, atIndex index: Int) -> Node<Element> {
		let node = Node<Element>(element)
		Node.addChild(node: node, to: self, atIndex: index)
		return node
	}
	
/// Insert a new child node to this node at the specified index.
///
/// This is useful for grafting one ``Tree`` to another, however care should
/// be taken to ensure the node being added or any of it's children don't
/// already exist in the tree.
///
/// - Parameters:
///   - node: The node to parent to this node.
///   - index: The index of the element.
///
	public func insert(_ node: Node<Element>, atIndex index: Int) {
		Node.addChild(node: node, to: self, atIndex: index)
	}

/// Removes this node and all of it's ``children`` from the parent node.
///
/// This creates a new independent ``Tree`` with this node at the ``root``
/// of the new tree.
///
	public func prune() {
		Node.prune(node: self)
	}

/// Removes a child node specified by index, and all of it's ``children``
/// from this node.
///
/// This creates a new independent ``Tree`` with the pruned child at the
/// ``root`` of the new tree.
///
/// - Parameters:
///   - index: The index of the child to prune.
///
/// - Returns: The node that was pruned.
///
	public func prune(childAtIndex index: Int) -> Node<Element> {
		let child = self.children[index]
		Node.prune(node: child)
		return child
	}

/// Removes a child node with the matching identifier, and all of it's
/// ``children`` from this node.
///
/// This creates a new independent ``Tree`` with the pruned child at the
/// ``root`` of the new tree.
///
/// - Parameters:
///   - identifier: The identifier of the child to prune.
///
/// - Returns: The node that was pruned.
///
	public func prune(childIdentifiedBy identifier: Node<Element>.ID) -> Node<Element>? {
		guard let child = self.children.first(
			where: {
				$0.id == identifier
			}
		)
		else {
			return nil
		}
		
		Node.prune(node: child)
		return child
	}

/// Removes this node and reparents all of it's ``children`` to the
/// ``parent`` node.
///
/// This extracts the node from the tree.
///
	public func remove() {
		Node.extract(node: self)
	}

/// Removes a child node with the specified index, and reparents all of it's
/// ``children`` to this node.
///
/// This extracts the node from the ``Tree``.
///
/// - Parameters:
///   - index: The index of the child to remove.
///
/// - Returns: The node that was removed.
///
	public func remove(childAtIndex index: Int) -> Node<Element>? {
		let child = self.children[index]
		Node.extract(node: child)
		return child
	}

/// Removes a child node with the matching identifier, and reparents all of
/// it's ``children`` to this node.
///
/// This extracts the node from the ``Tree``.
///
/// - Parameters:
///   - identifier: The identifier of the child to remove.
///
/// - Returns: The node that was removed.
///
	public func remove(childIdentifiedBy identifier: Node<Element>.ID) -> Node<Element>? {
		guard let child = self.children.first(
			where: {
				$0.id == identifier
			}
		)
		else {
			return nil
		}
		
		Node.extract(node: child)
		return child
	}
}

extension Node: Equatable {
	public static func == (lhs: Node<Element>, rhs: Node<Element>) -> Bool {
		lhs.id == rhs.id
	}
}
