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
import RxNimble
import Nimble

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
        return manager.defaultDownloadEvents.map{ event ->RecordedDTaskEvent in
            time = time + 100
            return next(time, event)
        }
    }
    
    
    override func setUp() {
        super.setUp()
        sut = DownloadTaskMock()
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
    
    
    func testInitEventsObservable()
    {
        let res = sut.events
        expect(res)==manager.defaultDownloadEvents.first
    }
    
    
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
            expect(res).to(equal([true, true, true, true]))
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

