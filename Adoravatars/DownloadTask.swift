//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift


enum DownloadTaskEvent {

    case progress(Float)
    case done(UIImage)
}


class DownloadTask{
    
    let taskID:Int
    let avatar:Avatar
    
    let eventSubj = PublishSubject<DownloadTaskEvent>()
        
    init(taskID:Int, avatar:Avatar) {
        self.taskID = taskID
        self.avatar = avatar
    }
}
