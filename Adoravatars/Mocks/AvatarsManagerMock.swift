//
//  AvatarsManagerMock.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

class AvatarsManagerMock: AvatarsProvider {
    
    lazy var downloadTasks: Observable<[DownloadTaskType]> = Observable.just([self.defaultTask])
    
    lazy var defaultTask:DownloadTaskType = DownloadTaskMock(avatar: self.defaultAvatar, events: self.defaultEvents, updatedAt: self.defaultUpdateDate, status: self.defaultStatus)
    
    
    let defaultAvatar = Avatar(identifier: "default")
    let defaultEvents = Observable.just(DownloadTaskEvent.finish)
    let defaultUpdateDate = Date()
    let defaultStatus = DownloadTask.DownloadTaskStatus.done
    
    
    func downloadAvatarImage(_ avatar: Avatar) -> Observable<DownloadTaskEvent> {
        
        return Observable.just(DownloadTaskEvent.done(UIImage(named: "test_icon")!))
    }
    
    func getAvatars() -> Observable<[Avatar]> {
        
        return Observable.just([defaultAvatar])
    }
}
