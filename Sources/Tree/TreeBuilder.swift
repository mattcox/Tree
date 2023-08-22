//
//  TreeBuilder.swift
//  Tree
//
//  Created by Matt Cox on 15/08/2023.
//  Copyright © 2023 Matt Cox. All rights reserved.
//

import Foundation

/// A typealias for ``Node``, used to provide a more friendly interface for
/// ``TreeBuilder``
///
public typealias Root = Node

/// A typealias for ``Node``, used to provide a more friendly interface for
/// ``TreeBuilder``
///
public typealias Branch = Node

extension Node {
/// Initialize the tree structure starting at this node using a ``TreeBuilder``.
///
/// The provided closure will be called to build the tree declaratively.
///
/// - Parameters:
///   - element: The element to store on this node.
///   - contents: A closure used to build a tree declaratively.
///
	public convenience init(_ element: Element, @TreeBuilder<Element> _ contents: () -> [Node<Element>]) {
		self.init(element)
		for child in contents() {
			self.append(child)
		}
	}
}

/// A custom parameter attribute that constructs trees from closures.
///
@resultBuilder
public enum TreeBuilder<Element: Identifiable> {
	public static func buildBlock() -> [Node<Element>] {
		[]
	}
}

extension TreeBuilder {
	public static func buildPartialBlock(first: Element) -> [Node<Element>] {
		[Node(first)]
	}

	public static func buildPartialBlock(accumulated: [Node<Element>], next: Element) -> [Node<Element>] {
		accumulated + [Node(next)]
	}

	public static func buildPartialBlock(first: Node<Element>) -> [Node<Element>] {
		[first]
	}
	
	public static func buildPartialBlock(accumulated: [Node<Element>], next: Node<Element>) -> [Node<Element>] {
		accumulated + [next]
	}
	
	public static func buildPartialBlock(first: [Node<Element>]) -> [Node<Element>] {
		first
	}

	public static func buildPartialBlock(accumulated: [Node<Element>], next: [Node<Element>]) -> [Node<Element>] {
		accumulated + next
	}
}

extension TreeBuilder {
	public static func buildOptional(_ component: [Node<Element>]?) -> [Node<Element>] {
		component ?? []
	}
}

extension TreeBuilder {
	public static func buildEither(first component: [Node<Element>]) -> [Node<Element>] {
		component
	}
	
	public static func buildEither(second component: [Node<Element>]) -> [Node<Element>] {
		component
	}
}

extension TreeBuilder {
	public static func buildArray(_ components: [[Node<Element>]]) -> [Node<Element>] {
		components.flatMap {
			$0
		}
	}
}
