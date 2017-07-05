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
    
    let downloadTasks:Observable<[DownloadTaskType]> = Observable.just([AvatarsManagerStubbed.defaultTask])
    
    static let defaultTask = DownloadTaskMock()
    static let defaultAvatar = Avatar(identifier: "default")
    static let defaultImage = UIImage(named: "test_icon")!
    
    static let defaultDownloadEvents:[DownloadTaskEvent] = [.progress(0.5), .done(AvatarsManagerStubbed.defaultImage)]
    
    static let defaultEventsObservable = Observable.from(AvatarsManagerStubbed.defaultDownloadEvents)
    
    func downloadAvatarImage(_ avatar: Avatar) -> Observable<DownloadTaskEvent> {
        
        return Observable<DownloadTaskEvent>.create({ observer -> Disposable in
            
            for e in AvatarsManagerStubbed.defaultDownloadEvents{
                observer.onNext(e)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    
    func downloadAvatarImageWithError(_ avatar: Avatar) -> Observable<DownloadTaskEvent> {
        
        return Observable.error(DownloadError.failed)
    }
    
    func getAvatars() -> Observable<[Avatar]> {
       
        return Observable.just([AvatarsManagerStubbed.defaultAvatar])
    }
}
