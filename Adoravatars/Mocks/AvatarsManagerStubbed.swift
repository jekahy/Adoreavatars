//
//  AvatarServiceStubbed.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//


import RxSwift

@testable import Adoravatars

class AvatarServiceStubbed: AvatarsGettable {
    
    
    func downloadAvatarImage(_ avatar:Avatar, api:APIDownloadable)->DownloadTaskType
    {
        return DownloadTaskMock()
    }
    
    func downloadAvatarImageWithError(_ avatar: Avatar) -> Observable<DownloadTaskEvent> {
        
        return Observable.error(DownloadError.failed)
    }
    
    func getAvatars() -> Observable<[Avatar]> {
       
        return Observable.just([DownloadTaskMock.defaultAvatar])
    }
}


