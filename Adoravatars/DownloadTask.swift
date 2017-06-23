//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

class DownloadTask{
    
    let taskID:Int
    let avatar:Avatar
    
    private (set) var state:DownloadState = .queued
    
    let progressSubj = BehaviorSubject<Double>(value:0)
    
    let completionSubj = BehaviorSubject<UIImage?>(value:nil)
    
    private let disposeBag = DisposeBag()
    
    init(taskID:Int, avatar:Avatar) {
        self.taskID = taskID
        self.avatar = avatar
        
        progressSubj.asObservable().subscribe(onNext: {[unowned self] _ in
            self.state = .inProgress
        }, onError: { [unowned self] _ in
            self.state = .failed
        }, onCompleted: { [unowned self] in
            self.state = .done
        }).disposed(by: disposeBag)
    }
}
