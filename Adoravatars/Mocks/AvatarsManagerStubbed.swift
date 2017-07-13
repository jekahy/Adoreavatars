//
//  AvatarsManagerStubbed.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//


import RxSwift

@testable import Adoravatars

class AvatarsManagerStubbed: AvatarsGettable {
    
    
    let baseURL = AvatarsManagerStubbed.defaultBaseURL
    let cache = AvatarsManagerStubbed.defaultCache
    let sessionConfig = AvatarsManagerStubbed.defaultSessionConfig
    
    let AvatarDownloadTasks:Observable<[AvatarDownloadTaskType]> = Observable.just([AvatarsManagerStubbed.defaultTask])
    
    static let defaultTask = AvatarDownloadTaskMock()
    
    static let defaultDownloadEvents:[AvatarDownloadTaskEvent] = AvatarDownloadTaskMock.defaultProgress.map{AvatarDownloadTaskEvent.progress($0)} + [.done(AvatarDownloadTaskMock.defaultImage)]
    
    static let defaultEventsObservable = Observable.from(AvatarsManagerStubbed.defaultDownloadEvents)
    
    func downloadAvatarImage(_ avatar: Avatar) -> AvatarDownloadTaskType {
        
        return AvatarDownloadTaskMock()
    }
    
    
    func downloadAvatarImageWithError(_ avatar: Avatar) -> Observable<AvatarDownloadTaskEvent> {
        
        return Observable.error(DownloadError.failed)
    }
    
    func getAvatars() -> Observable<[Avatar]> {
       
        return Observable.just([AvatarDownloadTaskMock.defaultAvatar])
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
