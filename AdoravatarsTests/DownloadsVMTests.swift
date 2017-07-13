//
//  DownloadsVMTests.swift
//  Adoravatars
//
//  Created by Eugene on 29.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxTest
import RxSwift

@testable import Adoravatars


class DownloadsVMTests: XCTestCase {
    
    var subscription: Disposable!
    var scheduler: TestScheduler!

    let manager = AvatarsManagerStubbed()
    var vm:DownloadsVMType!
    
    override func setUp() {
        super.setUp()
        vm = DownloadsVM(api: manager)
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    func testAvatarDownloadTasksSet()
    {
        
        let expected = [AvatarsManagerStubbed.defaultTask]
        
        let observer = scheduler.createObserver(Array<AvatarDownloadTaskType>.self)
        
        subscription = vm.AvatarDownloadTasks.drive(observer)
        
        let result = observer.events
            .map{$0.value}
            .flatMap{ event -> [AvatarDownloadTaskType]? in
        
                if case .next(let taskEvents) = event {
                    return taskEvents
                }
                return nil
            }.last
        guard let res = result as? [AvatarDownloadTaskMock] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(expected, res)
    }
}
