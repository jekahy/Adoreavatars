//
//  AvatarsVMTests.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxSwift

@testable import Adoravatars

class AvatarsVMTests: XCTestCase {
    
    var subscription: Disposable!
    
    let service = AvatarServiceStubbed()
    var vm:AvatarsVMType!


    override func setUp() {
        
        super.setUp()
        vm = AvatarsVM(service:service)
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    
    func testInitEmpty()
    {
        _ = AvatarsVM()
    }
    
    func testInitWithAvatarsManager()
    {
        let service2 = vm.service
        XCTAssert(service as AvatarsGettable  === service2)
    }
    
    func testAvatars()
    {
        let expected = [FDP.defaultAvatar]
        subscription = performDriverArrayTest(expected: expected, driverToTest: vm.avatars, title: #function)
    }
    
    
    func testTitle()
    {
        let expected = "Adoreavatars"
        subscription = performDriverVariableTest(expected: expected, driverToTest: vm.title, title:#function)
    }
    
//    func testDownloadsVM()
//    {
//        let expected = DownloadsVM(api: APIService)
//        let res = vm.downloadsVM as! DownloadsVM
//        XCTAssertEqual(expected, res)
//    }
//    
//    
    
    
}


