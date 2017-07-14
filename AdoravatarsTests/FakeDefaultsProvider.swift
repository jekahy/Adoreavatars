//
//  FakeDefaultsProvider.swift
//  Adoravatars
//
//  Created by Eugene on 14.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

@testable import Adoravatars

typealias FDP = FakeDefaultsProvider

class FakeDefaultsProvider {
    
    static let defaultBaseURL: URL = URL(string: "http://api.adorable.io/avatar")!
    
    static let defaultSessionConfig:URLSessionConfiguration = {
        let s = URLSessionConfiguration.default
        s.urlCache = defaultCache
        return s
    }()
    
    static let defaultCache = URLCache(memoryCapacity: 100, diskCapacity: 100, diskPath: nil)
    
    static let defaultTask = DownloadTaskMock()
    
    static let defaultDownloadEvents:[DownloadTaskEvent] = defaultProgress.map{DownloadTaskEvent.progress($0)} + [.done(defaultData)]
    
    static let defaultEventsObservable = Observable.from(defaultDownloadEvents)
    
    
    static let defaultDate = Date(timeIntervalSince1970: 10000)
    static let defaultImage = UIImage(data: defaultData)!
    static let defaultData = try! Data(contentsOf: URL(fileURLWithPath: imgPath))
    static let defaultAvatar = Avatar(identifier: "Dart")
    static let defaultStatus = DownloadTask.Status.done
    static let defaultProgress = [0,0.5,1]
    
    private static let imgPath = Bundle.main.path(forResource: "test_icon", ofType: "png")!

}
