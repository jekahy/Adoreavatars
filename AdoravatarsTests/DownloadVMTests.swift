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

@testable import Adoravatars

class DownloadVMTests: XCTestCase {
    
    typealias RecordedE<T> = Recorded<Event<T>>
    typealias DTM = DownloadTaskMock
    
    var subscription: Disposable!
    var scheduler: TestScheduler!
    
    let manager = AvatarServiceStubbed()
    var vm:DownloadVMType!
    
    override func setUp() {
        super.setUp()
        vm = DownloadVM(DTM())
        scheduler = TestScheduler(initialClock: 0)
        
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        
        super.tearDown()
    }

    // MARK: Tests
    
    func testTitle()
    {
        let expected = DTM.defaultAvatar.identifier
        subscription = performDriverVariableTest(expected:expected , driverToTest: vm.title)
    }
    
    func testStatus()
    {
        let expected = DTM.defaultStatus.rawValue
        subscription = performDriverVariableTest(expected:expected , driverToTest: vm.status)
 
    }
    
    func testStatusOnErrorNothing()
    {
        let testEvents:[RecordedE<DownloadTask.Status>] = [next(0, .queued), next(100, .inProgress), error(200, DownloadError.failed) ]
        
        let observable = scheduler.createColdObservable(testEvents)
        let observer = scheduler.createObserver(String.self)
        
        
        let AvatarDownloadTask = DTM(observable.asObservable())
    
        vm = DownloadVM(AvatarDownloadTask)

        subscription = vm.status.drive(observer)
        scheduler.start()

        XCTAssertEqual(observer.events, [next(0, DownloadTask.Status.queued.rawValue), next(100, DownloadTask.Status.inProgress.rawValue), next(200, ""), completed(200)])
    }
    
    
    func testTimeStampStartsWithDateOnErrorNothing()
    {
        let testEvents:[RecordedE<Date>] = [next(0, DTM.defaultDate), error(100, DownloadError.failed) ]
        let observable = scheduler.createColdObservable(testEvents)

        let expectedDate = DTM.defaultDate.string
        let observer = scheduler.createObserver(String.self)

        let AvatarDownloadTask = DTM(updatedAt:observable.asObservable())

        vm = DownloadVM(AvatarDownloadTask)
        
        subscription = vm.timestamp.drive(observer)
        scheduler.start()
        
        XCTAssertEqual(observer.events, [next(0, expectedDate), next(100, ""), completed(100)])
    }
    
}
