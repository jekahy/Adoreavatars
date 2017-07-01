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
    
//    MARK: Tests
    
    func testDownloadTasksSet()
    {
        
        let expected = [AvatarsManagerStubbed.defaultTask]
        
        let observer = scheduler.createObserver(Array<DownloadTaskType>.self)
        
        subscription = vm.downloadTasks.drive(observer)
        
        let result = observer.events
            .map{$0.value}
            .flatMap{ event -> [DownloadTaskType]? in
        
                if case .next(let taskEvents) = event {
                    return taskEvents
                }
                return nil
            }.last
        guard let res = result as? [DownloadTaskMock] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(expected, res)
    }
}
