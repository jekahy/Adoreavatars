//
//  XCTestCaseExtensions.swift
//  Adoravatars
//
//  Created by Eugene on 29.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

extension XCTestCase {
    
    
    func performDriverVariableTest<E:Equatable>(expected:E, driverToTest:Driver<E?>, title:String="title")->Disposable
    {
        let promise = expectation(description: title)
        var result:E?
        let subscription = driverToTest.drive(onNext: { input in
            result = input
        }, onCompleted:{
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
        guard let res = result else {
            XCTFail()
            return subscription
        }
        XCTAssertEqual(expected, res)
        return subscription
    }
    
    
    func performDriverVariableTest<E:Equatable>(expected:E, driverToTest:Driver<E>, title:String="title")->Disposable
    {
        let promise = expectation(description: title)
        var result:E?
        let subscription = driverToTest.drive(onNext: { input in
            result = input
        }, onCompleted:{
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
        guard let res = result else {
            XCTFail()
            return subscription
        }
        XCTAssertEqual(expected, res)
        return subscription
    }


    func performDriverArrayTest<A:Equatable>(expected:[A], driverToTest:Driver<[A]>, title:String="title")->Disposable
    {
        let promise = expectation(description: title)
        var result:[A]?
        let subscription = driverToTest.drive(onNext: { input in
            result = input
        }, onCompleted:{
            promise.fulfill()
        })
        waitForExpectations(timeout: 0.1, handler: nil)
        guard let res = result else {
            XCTFail()
            return subscription
        }
        guard expected == res else {
            XCTFail()
            return subscription
        }
        
        return subscription
    }
}
