//
//  AvatarsManagerStubbed.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//


import RxSwift

@testable import Adoravatars

class AvatarsManagerStubbed: AvatarsProvider {
    
    
    let baseURL = AvatarsManagerStubbed.defaultBaseURL
    let cache = AvatarsManagerStubbed.defaultCache
    let sessionConfig = AvatarsManagerStubbed.defaultSessionConfig
    
    let downloadTasks:Observable<[DownloadTaskType]> = Observable.just([AvatarsManagerStubbed.defaultTask])
    
    static let defaultTask = DownloadTaskMock()
    
    static let defaultDownloadEvents:[DownloadTaskEvent] = DownloadTaskMock.defaultProgress.map{DownloadTaskEvent.progress($0)} + [.done(DownloadTaskMock.defaultImage)]
    
    static let defaultEventsObservable = Observable.from(AvatarsManagerStubbed.defaultDownloadEvents)
    
    func downloadAvatarImage(_ avatar: Avatar) -> DownloadTaskType {
        
        return DownloadTaskMock()
    }
    
    
    func downloadAvatarImageWithError(_ avatar: Avatar) -> Observable<DownloadTaskEvent> {
        
        return Observable.error(DownloadError.failed)
    }
    
    func getAvatars() -> Observable<[Avatar]> {
       
        return Observable.just([DownloadTaskMock.defaultAvatar])
    }
}

extension AvatarsManagerStubbed {
 
    static let defaultBaseURL: URL = URL(string: "http://api.adorable.io/avatar")!
    
    static let defaultSessionConfig:URLSessionConfiguration = {
        let s = URLSessionConfiguration.default
        s.urlCache = AvatarsManagerStubbed.defaultCache
        return s
    }()
    
    static let defaultCache = URLCache(memoryCapacity: 100, diskCapacity: 100, diskPath: nil)


}
