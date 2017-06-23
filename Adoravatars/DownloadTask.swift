//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift


enum DownloadTaskEvent {

    case progress(Double)
    case done(UIImage)
}


class DownloadTask{
    
    let taskID:Int
    let avatar:Avatar
    private (set) var updatedAt:Date!
    
    let eventSubj = PublishSubject<DownloadTaskEvent>()
    
    private let disposeBag = DisposeBag()
        
    init(taskID:Int, avatar:Avatar) {
        self.taskID = taskID
        self.avatar = avatar
        updatedAt = Date()
        eventSubj.asObservable().subscribe { [weak self] event in
            self?.updatedAt = Date()
        }.disposed(by: disposeBag)
    }
}
