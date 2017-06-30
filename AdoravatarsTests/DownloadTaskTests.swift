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
    let avatar = Avatar(identifier: "vaider")
    
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
        sut = DownloadTask(avatar:avatar, eventsObservable:manager.defaultEventsObservable)
        scheduler = TestScheduler(initialClock: 0)
        
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        super.tearDown()
    }
    
    
//    MARK: Tests
    
    func testInitAvatar()
    {
        let expected = avatar
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

        var previousDate = sut.updatedAt

        let promise = expectation(description: #function)
        subscription = sut.events.subscribe(onNext: { _ in
            
            res.append(previousDate != self.sut.updatedAt)
            previousDate = self.sut.updatedAt
        }, onError:{ _ in
            res.append(previousDate != self.sut.updatedAt)
            promise.fulfill()
        })
        
        scheduler.start()

        waitForExpectations(timeout: 5, handler: nil)
        expect(res).to(equal([true, true, true]))
    }
    
    func testStatusOnNextOnErrorChanges()
    {
        var testEvents = defaultTestEvents
        testEvents.append(error(300, DownloadError.failed))
        
        var res:[DownloadTask.DownloadTaskStatus] = []
        let observable = scheduler.createColdObservable(testEvents)
        sut = DownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())
        
        let promise = expectation(description: #function)
        subscription = sut.events.subscribe(onNext: { _ in
            
            res.append(self.sut.status)
            
        }, onError:{ _ in
            res.append(self.sut.status)
            promise.fulfill()
        })
        
        scheduler.start()
        
        waitForExpectations(timeout: 3, handler: nil)
        expect(res).to(equal([.inProgress, .done, .failed]))
        
    }
    
    func testStatusOnComletedChanges()
    {
        let testEvents:[RecordedDTaskEvent] = [completed(100)]
        
        var res:[DownloadTask.DownloadTaskStatus] = []
        let observable = scheduler.createColdObservable(testEvents)
        sut = DownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())
        
        let promise = expectation(description: #function)
        subscription = sut.events.subscribe( onCompleted:{_ in
            res.append(self.sut.status)
            promise.fulfill()
        })
        
        scheduler.start()
        
        waitForExpectations(timeout: 1, handler: nil)
        expect(res).to(equal([.done]))
    }

}

