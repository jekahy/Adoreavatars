//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

class DownloadTask:Hashable, Equatable {
    
    let taskID:Int
    let avatar:Avatar
    
    var state:DownloadState = .queued
    
    let progressSubj = BehaviorSubject<Double>(value:0)
    
    let completionSubj = BehaviorSubject<UIImage?>(value:nil)
    
    
    init(taskID:Int, avatar:Avatar) {
        self.taskID = taskID
        self.avatar = avatar
    }
    
    var hashValue: Int {
        return taskID
    }
    
    static func ==(lhs: DownloadTask, rhs: DownloadTask) -> Bool
    {
        return lhs.taskID == rhs.taskID
    }
    
}
