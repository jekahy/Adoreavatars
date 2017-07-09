//
//  DownloadTaskTests.swift
//  Adoravatars
//
//  Created by Eugene on 29.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import Adoravatars


class DownloadTaskTests: XCTestCase {
    
    typealias RecordedDTaskEvent = Recorded<Event<DownloadTaskEvent>>
    
    var subscription: Disposable?
    var scheduler: TestScheduler!
    
    let manager = AvatarsManagerStubbed()
    
    let avatar = DownloadTaskMock.defaultAvatar

    var sut:DownloadTaskType!
    
    
    var defaultTestEvents:[RecordedDTaskEvent]  {
        var time = 0
        return AvatarsManagerStubbed.defaultDownloadEvents.map{ event ->RecordedDTaskEvent in
            time = time + 100
            return next(time, event)
        }
    }
    
    
    override func setUp() {
        super.setUp()
        sut = DownloadTask(avatar:avatar, eventsObservable:AvatarsManagerStubbed.defaultEventsObservable)
        scheduler = TestScheduler(initialClock: 0)
        
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        super.tearDown()
    }
    
    
//    MARK: Tests
    
    func testInitAvatar()
    {
        let expected = DownloadTaskMock.defaultAvatar
        XCTAssertEqual(expected, sut.avatar)
    }
    
    
//    func testInitEventsObservable()
//    {
//        let observer = scheduler.createObserver(DownloadTaskEvent.self)
//        subscription = sut.events.subscribe(observer)
//        
//        let expected:[RecordedDTaskEvent] = [next(0, .progress(0.5)), next(0, .done(AvatarsManagerStubbed.defaultImage)), completed(0)]
//        
//        scheduler.start()
//
//        XCTAssertEqual(observer.events, expected)
//    }
    
    
    func testUpdatedAtChanges()
    {
        
        var testEvents = defaultTestEvents
        testEvents.append(error(300, DownloadError.failed))

        var res = [Bool]()
        let observable = scheduler.createColdObservable(testEvents)
        
        sut = DownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())

        subscription = sut.updatedAt.scan(Date()) { previousDate, currentDate in
            res.append(previousDate != currentDate)
            return currentDate
        }.subscribe()

        scheduler.scheduleAt(350) { 
             XCTAssertEqual(res, [true, true, true, true])
        }
        scheduler.start()

        
    }
    
    func testStatusOnNextOnErrorChanges()
    {
        var testEvents = defaultTestEvents
        testEvents.append(error(300, DownloadError.failed))
        
        let observable = scheduler.createColdObservable(testEvents)
        let observer = scheduler.createObserver(DownloadTask.Status.self)
        
        sut = DownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())
        
        subscription = sut.status.subscribe(observer)
        
        scheduler.scheduleAt(350) { 
            XCTAssertEqual(observer.events, [next(0, .queued), next(100, .inProgress), next(200, .done), next(300, .failed)])
        }
        
        scheduler.start()
        
    }

    func testStatusOnComletedChanges()
    {
        let testEvents:[RecordedDTaskEvent] = [completed(100)]
        
        let observable = scheduler.createColdObservable(testEvents)
        let observer = scheduler.createObserver(DownloadTask.Status.self)
        
        sut = DownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())
        
        subscription = sut.status.subscribe(observer)
        
        scheduler.scheduleAt(150) {
            XCTAssertEqual(observer.events, [next(0, .queued), next(100, .done)])
        }
        
        scheduler.start()
    }
}

