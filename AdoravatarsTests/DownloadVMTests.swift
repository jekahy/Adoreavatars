//
//  DownloadVMTests.swift
//  Adoravatars
//
//  Created by Eugene on 30.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//


import XCTest
import RxTest
import RxSwift
import RxCocoa
import RxNimble
import Nimble
import RxSwiftExt

@testable import Adoravatars


class DownloadVMTests: XCTestCase {
    
    typealias RecordedE<T> = Recorded<Event<T>>

    var subscription: Disposable!
    var scheduler: TestScheduler!
    
    let manager = AvatarsManagerStubbed()
    var vm:DownloadVMType!
    
    
    var defaultTestEvents:[RecordedE<DownloadTaskEvent>]  {
        var time = 0
        return DownloadTaskMock.defaultDownloadEvents.map{ event ->RecordedE<DownloadTaskEvent> in
            time = time + 100
            return next(time, event)
        }
    }
    
    
    override func setUp() {
        super.setUp()
        vm = DownloadVM(DownloadTaskMock())
        scheduler = TestScheduler(initialClock: 0)
        
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        
        super.tearDown()
    }

//    MARK: Tests
    
    func testTitle()
    {
        let expected = DownloadTaskMock.defaultAvatar.identifier
        subscription = performDriverVariableTest(expected:expected , driverToTest: vm.title)
    }
    
    func testStatus()
    {
        let expected = DownloadTaskMock.defaultStatus.rawValue
        subscription = performDriverVariableTest(expected:expected , driverToTest: vm.status)
 
    }
    
    func testStatusOnErrorNothing()
    {
        let testEvents:[RecordedE<DownloadTask.Status>] = [next(0, .queued), next(100, .inProgress), error(200, DownloadError.failed) ]
        
        let observable = scheduler.createColdObservable(testEvents)
        let observer = scheduler.createObserver(String.self)
        
        
        let downloadTask = DownloadTaskMock(observable.asObservable())
    
        vm = DownloadVM(downloadTask)

        subscription = vm.status.drive(observer)
        scheduler.start()

        XCTAssertEqual(observer.events, [next(0, DownloadTask.Status.queued.rawValue), next(100, DownloadTask.Status.inProgress.rawValue), next(200, ""), completed(200)])
    }
    
    
    func testTimeStampStartsWithDateOnErrorNothing()
    {
        let testEvents:[RecordedE<Date>] = [next(0, DownloadTaskMock.defaultDate), error(100, DownloadError.failed) ]
        let observable = scheduler.createColdObservable(testEvents)

        let expectedDate = DownloadTaskMock.defaultDate.string
        let observer = scheduler.createObserver(String.self)

        let downloadTask = DownloadTaskMock(updatedAt:observable.asObservable())

        vm = DownloadVM(downloadTask)
        
        subscription = vm.timestamp.drive(observer)
        scheduler.start()
        
        XCTAssertEqual(observer.events, [next(0, expectedDate), next(100, ""), completed(100)])
    }
    
}
