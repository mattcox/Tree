//
//  XMLTree.swift
//  Tree
//
//  Created by joshydotpoo on 3/8/2024.
//

import Foundation

public struct XMLTree<Element:Identifiable> {
    
    private(set) var data:Data?
    
    let property:KeyPath<Element, String>
    let attributes:[String: KeyPath<Element, String>]
    
    /// XMLTree converts the tree into an XML file.
    /// - Parameters:
    ///   - root: root node of the tree
    ///   - property: string property of generic Element used as the tag name
    ///   - attributes: dictionary of string property pairs, where the string is the attribute name and the property is used for attribute value.
    init(root:Node<Element>,
         using property:KeyPath<Element, String>,
         assigning attributes:[String: KeyPath<Element, String>] = [:])
    {
        self.property = property
        self.attributes = attributes
        
        let document = XMLDocument()
        document.addChild(toXML(node: root))
        self.data = document.xmlData
    }
    
    
    /// Recursive function that iterates through all the child nodes and assigns attribute values
    /// - Parameter node: parent node element
    /// - Returns: XMLElement of the parent element with all children XMLElements appended.
    private func toXML(node:Node<Element>) -> XMLElement {
        let branchElement = XMLElement(name: node.element[keyPath: property])
        for (attributeName, attributeValue) in attributes {
            let attributeNode:XMLNode = XMLNode.attribute(
                withName: attributeName,
                stringValue: node.element[keyPath: attributeValue]
            ) as! XMLNode
            branchElement.addAttribute(attributeNode)
        }
        
        for childNode in node.children {
            branchElement.addChild(toXML(node: childNode))
        }
        
        return branchElement
    }
    
    
    /// For testing purposes only, saves data to test.xml in document directory.
    public func save() {
        do {
            var url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            url.appendPathComponent("test.xml")
            print(url.relativePath)
            FileManager.default.createFile(atPath: url.relativePath, contents: self.data)
        } catch {
            print(error.localizedDescription)
        }
    }
}
