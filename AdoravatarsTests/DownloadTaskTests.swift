//
//  AvatarDownloadTaskTests.swift
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


class AvatarDownloadTaskTests: XCTestCase {
    
    typealias RecordedDTaskEvent = Recorded<Event<AvatarDownloadTaskEvent>>
    
    var subscription: Disposable?
    var scheduler: TestScheduler!
    
    let manager = AvatarsManagerStubbed()
    
    let avatar = AvatarDownloadTaskMock.defaultAvatar

    var sut:AvatarDownloadTaskType!
    
    
    var defaultTestEvents:[RecordedDTaskEvent]  {
        let times = generateTimeFor(elementsNum:AvatarsManagerStubbed.defaultDownloadEvents.count)
        return zip(times, AvatarsManagerStubbed.defaultDownloadEvents).map{next($0,$1)}
    }
    
    
    override func setUp() {
        
        super.setUp()
        sut = AvatarDownloadTask(avatar:avatar, eventsObservable:AvatarsManagerStubbed.defaultEventsObservable)
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        
        subscription?.dispose()
        super.tearDown()
    }
    
    
//    MARK: Tests
    
    func testInitAvatar()
    {
        let expected = AvatarDownloadTaskMock.defaultAvatar
        XCTAssertEqual(expected, sut.avatar)
    }
    
    func testProgress()
    {
        let timeArr = generateTimeFor(elementsNum: AvatarDownloadTaskMock.defaultDownloadEvents.count)
        let expected = zip(timeArr, AvatarDownloadTaskMock.defaultProgress).map{next($0,$1)}

        let observable = scheduler.createColdObservable(defaultTestEvents)
        let observer = scheduler.createObserver(Double.self)
        
        sut = AvatarDownloadTask(avatar:avatar, eventsObservable:observable.asObservable())
        
        subscription = sut.progress.subscribe(observer)
        
        scheduler.scheduleAt(200) {
            let res = observer.events
            XCTAssertEqual(expected, res)
        }
        scheduler.start()
    }

    
    func testUpdatedAtChanges()
    {
        var testEvents = defaultTestEvents
        testEvents.append(error(300, DownloadError.failed))

        var res = [Bool]()
        let observable = scheduler.createColdObservable(testEvents)
        
        sut = AvatarDownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())

        subscription = sut.updatedAt.scan(Date()) { previousDate, currentDate in
            res.append(previousDate != currentDate)
            return currentDate
        }.subscribe()

        scheduler.scheduleAt(350) {
            let expected = [true, true, true, true, true, true]
             XCTAssertEqual(expected, res)
        }
        scheduler.start()
    }
    
    func testStatusOnNextOnErrorChanges()
    {
        var testEvents = defaultTestEvents
        testEvents.append(error(200, DownloadError.failed))
        
        let observable = scheduler.createColdObservable(testEvents)
        let observer = scheduler.createObserver(AvatarDownloadTask.Status.self)
        
        sut = AvatarDownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())
        
        subscription = sut.status.subscribe(observer)
        
        scheduler.scheduleAt(250) {
            let expected:[Recorded<Event<AvatarDownloadTask.Status>>] =  [next(0, .queued), next(0, .inProgress),next(50, .inProgress),next(100, .inProgress), next(150, .done), next(200, .failed)]
            XCTAssertEqual(expected, observer.events)
        }
        scheduler.start()
    }

    func testStatusOnComletedChanges()
    {
        let testEvents:[RecordedDTaskEvent] = [completed(100)]
        
        let observable = scheduler.createColdObservable(testEvents)
        let observer = scheduler.createObserver(AvatarDownloadTask.Status.self)
        
        sut = AvatarDownloadTask(avatar: avatar, eventsObservable: observable.asObservable().share())
        
        subscription = sut.status.subscribe(observer)
        
        scheduler.scheduleAt(150) {
            XCTAssertEqual(observer.events, [next(0, .queued), next(100, .done)])
        }
        
        scheduler.start()
    }
    
    
    func testImage()
    {
        let expected = AvatarDownloadTaskMock.defaultImage
        let observer = scheduler.createObserver(Optional<UIImage>.self)
        subscription = sut.image.subscribe(observer)
        
        scheduler.scheduleAt(150) {
            guard let res = observer.events.last?.value.element else{
                XCTFail()
                return
            }
            XCTAssertEqual(expected, res)
        }
        scheduler.start()
    }
    
//    MARK: Helpers
    
    func generateTimeFor(elementsNum:Int, step:Int = 50)->[Int]
    {
        var res = [Int]()
        for idx in 0...elementsNum{
            res.append(idx*step)
        }
        return res
    }
}

