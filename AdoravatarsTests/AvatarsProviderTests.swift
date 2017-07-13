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


class AvatarServiceTests: XCTestCase {
    
    typealias AMS = AvatarServiceStubbed
    
    var subscription: Disposable?
    var scheduler: TestScheduler!
    
    let manager = AMS()
    
    let avatar = DownloadTaskMock.defaultAvatar
    
    var sut:AvatarsGettable!

    
    override func setUp() {
        super.setUp()
        sut = AvatarService()
    }
}
