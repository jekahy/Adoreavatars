//
//  AvatarsGettableTests.swift
//  Adoravatars
//
//  Created by Eugene on 11.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import Adoravatars


class AvatarsGettableTests: XCTestCase {
    
    typealias AMS = AvatarsManagerStubbed
    
    var subscription: Disposable?
    var scheduler: TestScheduler!
    
    let manager = AvatarsManagerStubbed()
    
    let avatar = AvatarDownloadTaskMock.defaultAvatar
    
    var sut:AvatarsGettable!

    
    override func setUp() {
        super.setUp()
        sut = AvatarsManager(baseURL: AMS.defaultBaseURL, sessionConfiguration: AMS.defaultSessionConfig, cache: AMS.defaultCache)
    }
    
    func testInitAllLetSet()
    {
        XCTAssertEqual(sut.baseURL, AMS.defaultBaseURL)
        XCTAssertEqual(sut.cache, AMS.defaultCache)
        XCTAssertEqual(sut.sessionConfig, AMS.defaultSessionConfig)
    }
    
    func testCacheSetInConfig()
    {
        XCTAssertTrue(sut.sessionConfig.urlCache===AMS.defaultCache)
    }
}
