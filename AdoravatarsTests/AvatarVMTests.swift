//
//  AvatarVMTests.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import Adoravatars


class AvatarVMTests: XCTestCase {
    
    var subscription: Disposable!
    var scheduler: TestScheduler!

    let service = AvatarServiceStubbed()
    let api = APIServiceStubbed()
    var vm:AvatarVMType!
    
    override func setUp() {
        super.setUp()
        vm = AvatarVM(DownloadTaskMock.defaultAvatar, service: service, api: api)
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        
        subscription?.dispose()

        super.tearDown()
    }
    
    // MARK: Tests
    
    func testTitle()
    {
        let expected = "Adoreavatar"
        let avatar = Avatar(identifier: expected)
        vm = AvatarVM(avatar, service: service, api: api)
        
        subscription = performDriverVariableTest(expected: expected, driverToTest: vm.title, title: #function)
    }
    
    func testImage()
    {
        let expectedData = UIImagePNGRepresentation(DownloadTaskMock.defaultImage)

        let observer = scheduler.createObserver((Optional<UIImage>).self)
        
        subscription = vm.image.drive(observer)
        
        let resImg = observer.events.first?.value.element!
        let resData = UIImagePNGRepresentation(resImg!)
        
        XCTAssertEqual(expectedData, resData)
    }
    
    
    func testLoading()
    {
        let expected = [true, false]
        
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
