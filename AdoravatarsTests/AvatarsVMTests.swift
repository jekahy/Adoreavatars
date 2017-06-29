//
//  AvatarsVMTests.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxTest
import RxSwift

@testable import Adoravatars


class AvatarsVMTests: XCTestCase {
    
    var subscription: Disposable!
    
    let manager = AvatarsManagerStubbed()
    var vm:AvatarsVMType!


    override func setUp() {
        
        super.setUp()
        vm = AvatarsVM(api: manager)
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        
        super.tearDown()
    }
    
//    MARK: Tests
    
    
    func testInitEmpty()
    {
        _ = AvatarsVM()
    }
    
    func testInitWithAvatarsManager()
    {
        let manager2 = vm.api
        XCTAssert(manager as AvatarsProvider  === manager2)
    }
    
    func testAvatars()
    {
        let promise = expectation(description: "avatars test")
        let expected = [manager.defaultAvatar]
        var result:[Avatar]?
        subscription = vm.avatars.drive(onNext: { avatars in
            result = avatars
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
        guard let res = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(expected, res)
    }
    
    
    func testTitle()
    {
        let promise = expectation(description: "title test")
        let expected = "Adoreavatars"
        var result:String?
        subscription = vm.title.drive(onNext: { titleStr in
            result = titleStr
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
        guard let res = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(expected, res)
    }
    
    func testDownloadsVM()
    {
        let expected = DownloadsVM(api: manager)
        let res = vm.downloadsVM as! DownloadsVM
        XCTAssertEqual(expected, res)
    }
    
    
}
