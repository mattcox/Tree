//
//  XMLTreeTests.swift
//
//
//  Created by joshydotpoo on 3/10/24.
//

import Foundation
import XCTest
@testable import Tree

final class XMLTreeTests: XCTestCase {
    
    func testNilAttribute() {
        let root = Node(TestElement(name: "root"))
        root.append(child: Node(TestElement(name: "child")))
        let son = Node(TestElement(name: "child", nickName: "son"))
        root.append(child: son)
        son.append(child: Node(TestElement(name: "grandchil", nickName: "grandson")))

        let xmltree = XMLTree(root: root, using: \TestElement.id, assigning: ["nickname": \TestElement.nickName])
        xmltree.save()

    }
    
    struct TestElement: Identifiable {
        var id: String
        var nickName:String?
        
        init(name: String, nickName: String? = nil) {
            self.id = name
            self.nickName = nickName
        }
    }
}

