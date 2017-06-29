//
//  AvatarsManagerStubbed.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

@testable import Adoravatars

import RxSwift

class AvatarsManagerStubbed: AvatarsProvider {
    
    lazy var downloadTasks: Observable<[DownloadTaskType]> = Observable.just([self.defaultTask])
    
    lazy var defaultTask:DownloadTaskType = DownloadTask(avatar: self.defaultAvatar, eventsObservable: self.defaultEventsObservable)
    
    let defaultAvatar = Avatar(identifier: "default")
    lazy var defaultEventsObservable:Observable<DownloadTaskEvent> = Observable.from(self.defaultDownloadEvents)
    let defaultUpdateDate = Date()
    let defaultStatus = DownloadTask.DownloadTaskStatus.done
    let defaultImage = UIImage(named: "test_icon")!
    lazy var defaultDownloadEvents:[DownloadTaskEvent] = [.progress(0.5), .done(self.defaultImage)]
    
    func downloadAvatarImage(_ avatar: Avatar) -> Observable<DownloadTaskEvent> {
        
        return Observable<DownloadTaskEvent>.create({ observer -> Disposable in
            
            for e in self.defaultDownloadEvents{
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
        
        return Observable.just([defaultAvatar])
    }
}
