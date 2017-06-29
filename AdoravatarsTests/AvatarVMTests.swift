//
//  AvatarVMTests.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxTest
import RxSwift

@testable import Adoravatars


class AvatarVMTests: XCTestCase {
    
    var subscription: Disposable!
    
    let manager = AvatarsManagerStubbed()
    var vm:AvatarVMType!
    
    override func setUp() {
        super.setUp()
        vm = AvatarVM(manager.defaultAvatar, api: manager)
    }
    
    override func tearDown() {
        
        subscription?.dispose()

        super.tearDown()
    }
    
//    MARK: Tests
    
    func testTitle()
    {
        let expected = "Adoreavatar"
        let avatar = Avatar(identifier: expected)
        vm = AvatarVM(avatar, api: manager)
        
        let promise = expectation(description: "title test")
        
        var result:String?
        subscription = vm.title.drive(onNext: { titleStr in
            result = titleStr
            
        }, onCompleted:{
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
        guard let res = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(expected, res)
    }
    
    func testImage()
    {
        let expected = manager.defaultImage
        
        let promise = expectation(description: "image test")
        
        var result:UIImage?
        subscription = vm.image.drive(onNext: { image in
            
            result = image
            
        }, onCompleted:{
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
        guard let res = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(expected, res)
    }
    
    
    func testLoading()
    {
        let expected = [true, true, false]
        
        let promise = expectation(description: "image test")
        
        var result = [Bool]()
        subscription = vm.loading.drive(onNext: { event in
            
            result.append(event)
            
        }, onCompleted:{
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
       
        XCTAssertEqual(expected, result)
    }
    
    
}
