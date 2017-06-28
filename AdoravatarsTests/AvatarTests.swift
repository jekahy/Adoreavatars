//
//  AvatarTests.swift
//  AvatarTests
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest

@testable import Adoravatars

class AvatarTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        
    }
    
    
    func testInitWithIdentifier()
    {
        let id = "test"
        let avatarSUT = Avatar(identifier:id)
        XCTAssert(id == avatarSUT.identifier)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

}
