//
//  DownloadTaskMock.swift
//  Adoravatars
//
//  Created by Eugene on 28.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

class DownloadTaskMock: DownloadTaskType {
    
    let avatar: Avatar
    let events: Observable<DownloadTaskEvent>
    let updatedAt: Date
    let status: DownloadTask.DownloadTaskStatus
    
    init(avatar:Avatar, events:Observable<DownloadTaskEvent>, updatedAt:Date, status:DownloadTask.DownloadTaskStatus) {
        self.avatar = avatar
        self.events = events
        self.updatedAt = updatedAt
        self.status = status
    }
}



