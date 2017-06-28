//
//  AvatarsVMTests.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest

@testable import Adoravatars

class AvatarsVMTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    
    func testInitEmpty()
    {
        _ = AvatarsVM()
        

    }
    
    func testInitWithAvatarsManager()
    {
        let manager = AvatarsManager()
        let vm = AvatarsVM(api: manager)
        
        guard let manager2 = vm.api as? AvatarsManager else {
            XCTFail()
            return
        }
        XCTAssert(manager === manager2)
    }
    
    
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    
}
